/* -*-c++-*- OpenSceneGraph - Copyright (C) 1998-2006 Robert Osfield 
 *
 * This library is open source and may be redistributed and/or modified under  
 * the terms of the OpenSceneGraph Public License (OSGPL) version 0.0 or 
 * (at your option) any later version.  The full license is in LICENSE file
 * included with this distribution, and on the openscenegraph.org website.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 * OpenSceneGraph Public License for more details.
*/

#include <osgDB/DatabasePager>
#include <osgDB/WriteFile>
#include <osgDB/FileNameUtils>
#include <osgDB/FileUtils>
#include <osgDB/Registry>

#include <osg/Geode>
#include <osg/Timer>
#include <osg/Texture>
#include <osg/Notify>
#include <osg/ProxyNode>
#include <osg/ApplicationUsage>

#include <OpenThreads/ScopedLock>

#include <algorithm>
#include <functional>
#include <set>
#include <iterator>

#include <stdlib.h>
#include <string.h>

#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

using namespace osgDB;
using namespace OpenThreads;

static osg::ApplicationUsageProxy DatabasePager_e0(osg::ApplicationUsage::ENVIRONMENTAL_VARIABLE,"OSG_DO_PRE_COMPILE <ON/OFF>","Switch on or off the pre compile of OpenGL object database pager.");
static osg::ApplicationUsageProxy DatabasePager_e1(osg::ApplicationUsage::ENVIRONMENTAL_VARIABLE,"OSG_MINIMUM_COMPILE_TIME_PER_FRAME <float>","minimum compile time alloted to compiling OpenGL objects per frame in database pager.");
static osg::ApplicationUsageProxy DatabasePager_e2(osg::ApplicationUsage::ENVIRONMENTAL_VARIABLE,"OSG_MAXIMUM_OBJECTS_TO_COMPILE_PER_FRAME <int>","maximum number of OpenGL objects to compile per frame in database pager.");
static osg::ApplicationUsageProxy DatabasePager_e3(osg::ApplicationUsage::ENVIRONMENTAL_VARIABLE,"OSG_DATABASE_PAGER_DRAWABLE <mode>","Set the drawable policy for setting of loaded drawable to specified type.  mode can be one of DoNotModify, DisplayList, VBO or VertexArrays>.");
static osg::ApplicationUsageProxy DatabasePager_e4(osg::ApplicationUsage::ENVIRONMENTAL_VARIABLE,"OSG_DATABASE_PAGER_PRIORITY <mode>", "Set the thread priority to DEFAULT, MIN, LOW, NOMINAL, HIGH or MAX.");
static osg::ApplicationUsageProxy DatabasePager_e7(osg::ApplicationUsage::ENVIRONMENTAL_VARIABLE,"OSG_EXPIRY_DELAY <float> ","Set the length of time a PagedLOD child is kept in memory, without being used, before its tagged as expired, and ear marked to deletion.");
static osg::ApplicationUsageProxy DatabasePager_e8(osg::ApplicationUsage::ENVIRONMENTAL_VARIABLE,"OSG_EXPIRY_FRAMES <int> ","Set number of frames a PagedLOD child is kept in memory, without being used, before its tagged as expired, and ear marked to deletion.");
static osg::ApplicationUsageProxy DatabasePager_e9(osg::ApplicationUsage::ENVIRONMENTAL_VARIABLE,"OSG_RELEASE_DELAY <float> ","Set the length of time a PagedLOD child's OpenGL objects are kept in memory, without being used, before be released (setting to OFF disables this feature.)");
static osg::ApplicationUsageProxy DatabasePager_e10(osg::ApplicationUsage::ENVIRONMENTAL_VARIABLE,"OSG_RELEASE_FRAMES <int> ","Set number of frames a PagedLOD child's OpenGL objects are kept in memory, without being used, before be released.");
static osg::ApplicationUsageProxy DatabasePager_e11(osg::ApplicationUsage::ENVIRONMENTAL_VARIABLE,"OSG_MAX_PAGEDLOD <num>","Set the target maximum number of PagedLOD to maintain.");

// Convert function objects that take pointer args into functions that a
// reference to an osg::ref_ptr. This is quite useful for doing STL
// operations on lists of ref_ptr. This code assumes that a function
// with an argument const Foo* should be composed into a function of
// argument type ref_ptr<Foo>&, not ref_ptr<const Foo>&. Some support
// for that should be added to make this more general.

namespace
{
template <typename U>
struct PointerTraits
{
    typedef class NullType {} PointeeType;
};

template <typename U>
struct PointerTraits<U*>
{
    typedef U PointeeType;
};

template <typename U>
struct PointerTraits<const U*>
{
    typedef U PointeeType;
};

template <typename FuncObj>
class RefPtrAdapter
    : public std::unary_function<const osg::ref_ptr<typename PointerTraits<typename FuncObj::argument_type>::PointeeType>,
                                 typename FuncObj::result_type>
{
public:
    typedef typename PointerTraits<typename FuncObj::argument_type>::PointeeType PointeeType;
    typedef osg::ref_ptr<PointeeType> RefPtrType;
    explicit RefPtrAdapter(const FuncObj& funcObj) : _func(funcObj) {}
    typename FuncObj::result_type operator()(const RefPtrType& refPtr) const
    {
        return _func(refPtr.get());
    }
protected:
        FuncObj _func;
};

template <typename FuncObj>
RefPtrAdapter<FuncObj> refPtrAdapt(const FuncObj& func)
{
    return RefPtrAdapter<FuncObj>(func);
}
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  CountPagedLODList
//
struct DatabasePager::DatabasePagerCompileCompletedCallback : public osgUtil::IncrementalCompileOperation::CompileCompletedCallback
{
    DatabasePagerCompileCompletedCallback(osgDB::DatabasePager* pager, osgDB::DatabasePager::DatabaseRequest* databaseRequest):
        _pager(pager),
        _databaseRequest(databaseRequest) {}

    virtual bool compileCompleted(osgUtil::IncrementalCompileOperation::CompileSet* compileSet)
    {
        _pager->compileCompleted(_databaseRequest.get());
        return true;
    }

    osgDB::DatabasePager*                               _pager;
    osg::ref_ptr<osgDB::DatabasePager::DatabaseRequest> _databaseRequest;
};


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  CountPagedLODList
//
class DatabasePager::CountPagedLODsVisitor : public osg::NodeVisitor
{
public:
    CountPagedLODsVisitor():
        osg::NodeVisitor(osg::NodeVisitor::TRAVERSE_ALL_CHILDREN),
        _numPagedLODs(0)
    {
    }

    META_NodeVisitor("osgDB","CountPagedLODsVisitor")

    virtual void apply(osg::PagedLOD& plod)
    {
        ++_numPagedLODs;
        _pagedLODs.insert(&plod);
        traverse(plod);
    }

    bool removeExpiredChildrenAndCountPagedLODs(osg::PagedLOD* plod, double expiryTime, int expiryFrame, osg::NodeList& removedChildren)
    {
        size_t sizeBefore = removedChildren.size();
        plod->removeExpiredChildren(expiryTime, expiryFrame, removedChildren);
        for(size_t i = sizeBefore; i<removedChildren.size(); ++i)
        {
            removedChildren[i]->accept(*this);
        }

        for(PagedLODset::iterator itr = _pagedLODs.begin();
            itr != _pagedLODs.end();
            ++itr)
        {
            removedChildren.push_back(*itr);
        }

        return sizeBefore!=removedChildren.size();
    }


    typedef std::set<osg::PagedLOD*> PagedLODset;
    PagedLODset         _pagedLODs;
    int                 _numPagedLODs;
};


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  SetBasedPagedLODList
//
class SetBasedPagedLODList : public DatabasePager::PagedLODList
{
public:

    typedef std::set< osg::observer_ptr<osg::PagedLOD> > PagedLODs;
    PagedLODs _pagedLODs;


    virtual PagedLODList* clone() { return new SetBasedPagedLODList(); }
    virtual void clear() { _pagedLODs.clear(); }
    virtual unsigned int size() { return _pagedLODs.size(); }
    virtual void moveInactivePagedLODTo(PagedLODList& inactivePagedLODList, const osg::FrameStamp& frameStamp)
    {
        for(PagedLODs::iterator itr = _pagedLODs.begin();
            itr != _pagedLODs.end();
            )
        {
            osg::ref_ptr<osg::PagedLOD> plod;
            if (itr->lock(plod))
            {
                int delta = frameStamp.getFrameNumber() - plod->getFrameNumberOfLastTraversal();
                if (delta>1)
                {
#if 0
                    if (_releaseDelay!=DBL_MAX)
                    {
                        plod->releaseGLObjects();
                    }
#endif
                    inactivePagedLODList.insertPagedLOD(*itr);

                    PagedLODs::iterator pitr = itr;
                    ++itr;
                    _pagedLODs.erase(pitr);
                }
                else
                {
                    ++itr;
                }
            }
            else
            {
                OSG_INFO<<"DatabasePager::removeExpiredSubgraphs(), removing PagedLOD from _activePagedLODLists"<<std::endl;
                PagedLODs::iterator pitr = itr;
                ++itr;
                _pagedLODs.erase(pitr);
            }
        }
    }

    virtual void moveActivePagedLODTo(PagedLODList& activePagedLODList, const osg::FrameStamp& frameStamp)
    {
        for(PagedLODs::iterator itr = _pagedLODs.begin();
            itr != _pagedLODs.end();
            )
        {
            osg::ref_ptr<osg::PagedLOD> plod;
            if (itr->lock(plod))
            {
                int delta = frameStamp.getFrameNumber() - plod->getFrameNumberOfLastTraversal();
                if (delta>1)
                {
                    ++itr;
                }
                else
                {
                    activePagedLODList.insertPagedLOD(*itr);

                    PagedLODs::iterator pitr = itr;
                    ++itr;
                    _pagedLODs.erase(pitr);
                }
            }
            else
            {
                OSG_INFO<<"DatabasePager::removeExpiredSubgraphs(), removing PagedLOD from _inactivePagedLODLists"<<std::endl;
                PagedLODs::iterator pitr = itr;
                ++itr;
                _pagedLODs.erase(pitr);
            }
        }
    }

    virtual void removeExpiredChildren(int& numberChildrenToRemove, double expiryTime, int expiryFrame, osg::NodeList& childrenRemoved)
    {
        DatabasePager::CountPagedLODsVisitor countPagedLODsVisitor;

        for(PagedLODs::iterator itr = _pagedLODs.begin();
            itr!=_pagedLODs.end() && numberChildrenToRemove > countPagedLODsVisitor._numPagedLODs;
            )
        {
            osg::ref_ptr<osg::PagedLOD> plod;
            if (itr->lock(plod) && countPagedLODsVisitor._pagedLODs.count(plod.get())==0)
            {
                countPagedLODsVisitor.removeExpiredChildrenAndCountPagedLODs(plod.get(), expiryTime, expiryFrame, childrenRemoved);

                // advance the iterator to the next element
                ++itr;
            }
            else
            {
                PagedLODs::iterator pitr = itr;
                ++itr;
                _pagedLODs.erase(pitr);
                OSG_INFO<<"DatabasePager::removeExpiredSubgraphs() _inactivePagedLOD has been invalidated, but ignored"<<std::endl;
            }
        }
        numberChildrenToRemove -= countPagedLODsVisitor._numPagedLODs;
    }

    virtual void removeNodes(osg::NodeList& nodesToRemove)
    {
        for(osg::NodeList::iterator itr = nodesToRemove.begin();
            itr != nodesToRemove.end();
            ++itr)
        {
            osg::PagedLOD* plod = dynamic_cast<osg::PagedLOD*>(itr->get());
            osg::observer_ptr<osg::PagedLOD> obs_ptr(plod);
            PagedLODs::iterator plod_itr = _pagedLODs.find(obs_ptr);
            if (plod_itr != _pagedLODs.end())
            {
                OSG_INFO<<"Removing node from PagedLOD list"<<std::endl;
                _pagedLODs.erase(plod_itr);
            }
        }
    }

    virtual void insertPagedLOD(const osg::observer_ptr<osg::PagedLOD>& plod)
    {
        if (_pagedLODs.count(plod)!=0)
        {
            OSG_NOTICE<<"Warning: SetBasedPagedLODList::insertPagedLOD("<<plod.get()<<") already inserted"<<std::endl;
            // abort();
            return;
        }

        // OSG_NOTICE<<"OK: SetBasedPagedLODList::insertPagedLOD("<<plod<<") inserting"<<std::endl;

        _pagedLODs.insert(plod);
    }

    virtual bool containsPagedLOD(const osg::observer_ptr<osg::PagedLOD>& plod) const
    {
        return (_pagedLODs.count(plod)!=0);
    }

};


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  FindCompileableGLObjectsVisitor
//
class DatabasePager::FindCompileableGLObjectsVisitor : public osg::NodeVisitor
{
public:
    FindCompileableGLObjectsVisitor(DatabasePager::DataToCompile* dataToCompile,
                               bool changeAutoUnRef, bool valueAutoUnRef,
                               bool changeAnisotropy, float valueAnisotropy,
                               DatabasePager::DrawablePolicy drawablePolicy,
                               const DatabasePager* pager):
            osg::NodeVisitor(osg::NodeVisitor::TRAVERSE_ALL_CHILDREN),
            _dataToCompile(dataToCompile),
            _changeAutoUnRef(changeAutoUnRef), _valueAutoUnRef(valueAutoUnRef),
            _changeAnisotropy(changeAnisotropy), _valueAnisotropy(valueAnisotropy),
            _drawablePolicy(drawablePolicy), _pager(pager)
    {
        if (osgDB::Registry::instance()->getBuildKdTreesHint()==osgDB::Options::BUILD_KDTREES &&
            osgDB::Registry::instance()->getKdTreeBuilder())
        {
            _kdTreeBuilder = osgDB::Registry::instance()->getKdTreeBuilder()->clone();
        }
    }

    META_NodeVisitor("osgDB","FindCompileableGLObjectsVisitor")

    virtual void apply(osg::Node& node)
    {
        apply(node.getStateSet());

        traverse(node);
    }

    virtual void apply(osg::Geode& geode)
    {
        apply(geode.getStateSet());

        for(unsigned int i=0;i<geode.getNumDrawables();++i)
        {
            apply(geode.getDrawable(i));
        }

        traverse(geode);

        if (_kdTreeBuilder.valid())
        {
            geode.accept(*_kdTreeBuilder);
        }
    }

    inline void apply(osg::StateSet* stateset)
    {
        if (stateset)
        {
            // search for the existance of any texture object
            // attributes
            // if texture object attributes exist and need to be
            // compiled, add the state to the list for later
            // compilation.
            for(unsigned int i=0;i<stateset->getTextureAttributeList().size();++i)
            {
                osg::Texture* texture = dynamic_cast<osg::Texture*>(stateset->getTextureAttribute(i,osg::StateAttribute::TEXTURE));
                // Has this texture already been encountered?
                if (texture && !_textureSet.count(texture))
                {
                    _textureSet.insert(texture);
                    if (_changeAutoUnRef) texture->setUnRefImageDataAfterApply(_valueAutoUnRef);
                    if ((_changeAnisotropy
                         && texture->getMaxAnisotropy() != _valueAnisotropy))
                    {
                        if (_changeAnisotropy)
                            texture->setMaxAnisotropy(_valueAnisotropy);
                    }

                    if (!_pager->isCompiled(texture))
                    {
                        _dataToCompile->_textures.insert(texture);

                        if (osg::getNotifyLevel() >= osg::DEBUG_INFO)
                        {
                            OSG_INFO <<"Found compilable texture " << texture << " ";
                            osg::Image* image = texture->getImage(0);
                            if (image) OSG_INFO << image->getFileName();
                            OSG_INFO << std:: endl;
                        }
                        break;
                    }
                }
            }

        }
    }

    inline void apply(osg::Drawable* drawable)
    {
        if (_drawableSet.count(drawable))
            return;

        _drawableSet.insert(drawable);

        apply(drawable->getStateSet());

        switch(_drawablePolicy)
        {
        case DatabasePager::DO_NOT_MODIFY_DRAWABLE_SETTINGS: 
             // do nothing, leave settings as they came in from loaded database.
             // OSG_NOTICE<<"DO_NOT_MODIFY_DRAWABLE_SETTINGS"<<std::endl;
             break;
        case DatabasePager::USE_DISPLAY_LISTS: 
             drawable->setUseDisplayList(true);
             drawable->setUseVertexBufferObjects(false);
             break;
        case DatabasePager::USE_VERTEX_BUFFER_OBJECTS:
             drawable->setUseDisplayList(true);
             drawable->setUseVertexBufferObjects(true);
             // OSG_NOTICE<<"USE_VERTEX_BUFFER_OBJECTS"<<std::endl;
             break;
        case DatabasePager::USE_VERTEX_ARRAYS:
             drawable->setUseDisplayList(false);
             drawable->setUseVertexBufferObjects(false);
             // OSG_NOTICE<<"USE_VERTEX_ARRAYS"<<std::endl;
             break;
        }
        // Don't compile if already compiled. This can happen if the
        // subgraph is shared with already-loaded nodes.
        //
        // XXX This "compiles" VBOs too, but compilation doesn't do
        // anything for VBOs, does it?
        if (_dataToCompile && (drawable->getUseVertexBufferObjects() || drawable->getUseDisplayList()) && !_pager->isCompiled(drawable))
        {
            _dataToCompile->_drawables.insert(drawable);
        }
    }
    
    DatabasePager::DataToCompile*           _dataToCompile;
    bool                                    _changeAutoUnRef;
    bool                                    _valueAutoUnRef;
    bool                                    _changeAnisotropy;
    float                                   _valueAnisotropy;
    DatabasePager::DrawablePolicy           _drawablePolicy;
    const DatabasePager*                    _pager;
    std::set<osg::ref_ptr<osg::Texture> >   _textureSet;
    std::set<osg::ref_ptr<osg::Drawable> >  _drawableSet;
    osg::ref_ptr<osg::KdTreeBuilder>        _kdTreeBuilder;
    
protected:

    FindCompileableGLObjectsVisitor& operator = (const FindCompileableGLObjectsVisitor&) { return *this; }
};


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  SortFileRequestFunctor
//
struct DatabasePager::SortFileRequestFunctor
{
    bool operator() (const osg::ref_ptr<DatabasePager::DatabaseRequest>& lhs,const osg::ref_ptr<DatabasePager::DatabaseRequest>& rhs) const
    {
        if (lhs->_timestampLastRequest>rhs->_timestampLastRequest) return true;
        else if (lhs->_timestampLastRequest<rhs->_timestampLastRequest) return false;
        else return (lhs->_priorityLastRequest>rhs->_priorityLastRequest);
    }
};



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DatabaseRequest
//
void DatabasePager::DatabaseRequest::invalidate()
{
    OSG_INFO<<"   DatabasePager::DatabaseRequest::invalidate()."<<std::endl;
    _valid = false;
    _groupForAddingLoadedSubgraph = 0;
    _loadedModel = 0;
    _dataToCompileMap.clear();
    _requestQueue = 0;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  RequestQueue
//
DatabasePager::RequestQueue::RequestQueue(DatabasePager* pager):
    _pager(pager),
    _size(0),
    _frameNumberLastPruned(-1)
{
}

DatabasePager::RequestQueue::~RequestQueue()
{
    OSG_INFO<<"DatabasePager::RequestQueue::~RequestQueue() Destructing queue."<<std::endl;
    for(RequestList::iterator itr = _requestList.begin();
        itr != _requestList.end();
        ++itr)
    {
        (*itr)->invalidate();
    }
}

bool DatabasePager::RequestQueue::pruneOldRequestsAndCheckIfEmpty()
{
    OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_requestMutex);

    if (_frameNumberLastPruned != _pager->_frameNumber)
    {
        for(RequestQueue::RequestList::iterator citr = _requestList.begin();
            citr != _requestList.end();
            )
        {
            if ((*citr)->isRequestCurrent(_pager->_frameNumber))
            {
                ++citr;
            }
            else
            {
                (*citr)->invalidate();

                OSG_INFO<<"DatabasePager::RequestQueue::pruneOldRequestsAndCheckIfEmpty(): Pruning "<<(*citr)<<std::endl;
                citr = _requestList.erase(citr);
                --_size;
            }
        }

        if (_requestList.size()!=_size)
        {
            OSG_NOTICE<<"DatabasePager::pruneOldRequestsAndCheckIfEmpty(): Error, _size = "<<_size<<"  _requestList.size()="<<_requestList.size()<<std::endl;
        }

        _frameNumberLastPruned = _pager->_frameNumber;

        updateBlock();
    }

    return _requestList.empty();
}


void DatabasePager::RequestQueue::clear()
{
    OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_requestMutex);

    for(RequestList::iterator citr = _requestList.begin();
        citr != _requestList.end();
        ++citr)
    {
        (*citr)->invalidate();
    }

    _requestList.clear();

    _size  = 0;

    if (_requestList.size()!=_size)
    {
        OSG_NOTICE<<"DatabasePager::clear(): Error, _size = "<<_size<<"  _requestList.size()="<<_requestList.size()<<std::endl;
    }

    _frameNumberLastPruned = _pager->_frameNumber;

    updateBlock();
}


void DatabasePager::RequestQueue::add(DatabasePager::DatabaseRequest* databaseRequest)
{
    OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_requestMutex);

    addNoLock(databaseRequest);
}

void DatabasePager::RequestQueue::addNoLock(DatabasePager::DatabaseRequest* databaseRequest)
{
    _requestList.push_back(databaseRequest);
    ++_size;
    databaseRequest->_requestQueue = this;

    if (_requestList.size()!=_size)
    {
        OSG_NOTICE<<"DatabasePager::add(): Error, _size = "<<_size<<"  _requestList.size()="<<_requestList.size()<<std::endl;
    }

    updateBlock();
}

void DatabasePager::RequestQueue::swap(RequestList& requestList)
{
    OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_requestMutex);
    _requestList.swap(requestList);
    _size = _requestList.size();
}

void DatabasePager::RequestQueue::takeFirst(osg::ref_ptr<DatabaseRequest>& databaseRequest)
{
    OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_requestMutex);

    if (!_requestList.empty())
    {
        DatabasePager::SortFileRequestFunctor highPriority;

        RequestQueue::RequestList::iterator selected_itr = _requestList.end();

        for(RequestQueue::RequestList::iterator citr = _requestList.begin();
            citr != _requestList.end();
            )
        {
            if ((*citr)->isRequestCurrent(_pager->_frameNumber))
            {
                if (selected_itr==_requestList.end() || highPriority(*citr, *selected_itr))
                {
                    selected_itr = citr;
                }

                ++citr;
            }
            else
            {
                (*citr)->invalidate();
                
                OSG_INFO<<"DatabasePager::RequestQueue::takeFirst(): Pruning "<<(*citr)<<std::endl;
                citr = _requestList.erase(citr);
                --_size;
            }

        }

        _frameNumberLastPruned = _pager->_frameNumber;

        if (selected_itr != _requestList.end())
        {
            databaseRequest = *selected_itr;
            databaseRequest->_requestQueue = 0;
            _requestList.erase(selected_itr);
            --_size;
            OSG_INFO<<" DatabasePager::RequestQueue::takeFirst() Found DatabaseRequest size()="<<_requestList.size()<<std::endl;
        }
        else
        {
            OSG_INFO<<" DatabasePager::RequestQueue::takeFirst() No suitable DatabaseRequest found size()="<<_requestList.size()<<std::endl;
        }

        if (_requestList.size()!=_size)
        {
            OSG_NOTICE<<"DatabasePager::takeFirst(): Error, _size = "<<_size<<"  _requestList.size()="<<_requestList.size()<<std::endl;
        }

        updateBlock();
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  ReadQueue
//
DatabasePager::ReadQueue::ReadQueue(DatabasePager* pager, const std::string& name):
    RequestQueue(pager),
    _name(name)
{
    _block = new osg::RefBlock;
}

void DatabasePager::ReadQueue::updateBlock()
{
    _block->set((!empty() || !_childrenToDeleteList.empty()) &&
                !_pager->_databasePagerThreadPaused);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DatabaseThread
//
DatabasePager::DatabaseThread::DatabaseThread(DatabasePager* pager, Mode mode, const std::string& name):
    _done(false),
    _active(false),
    _pager(pager),
    _mode(mode),
    _name(name),
    _tickSinceStartOfIteration(0)
{
}

DatabasePager::DatabaseThread::DatabaseThread(const DatabaseThread& dt, DatabasePager* pager):
    _done(false),
    _active(false),
    _pager(pager),
    _mode(dt._mode),
    _name(dt._name),
    _tickSinceStartOfIteration(0)
{
}

DatabasePager::DatabaseThread::~DatabaseThread()
{
    cancel();
}

int DatabasePager::DatabaseThread::cancel()
{
    int result = 0;

    if( isRunning() )
    {
    
        _done = true;
        
        switch(_mode)
        {
            case(HANDLE_ALL_REQUESTS):
                _pager->_fileRequestQueue->release();
                break;
            case(HANDLE_NON_HTTP):
                _pager->_fileRequestQueue->release();
                break;
            case(HANDLE_ONLY_HTTP):
                _pager->_httpRequestQueue->release();
                break;
        }

        // release the frameBlock and _databasePagerThreadBlock in case its holding up thread cancellation.
        // _databasePagerThreadBlock->release();

        // then wait for the the thread to stop running.
        while(isRunning())
        {
            // commenting out debug info as it was cashing crash on exit, presumable
            // due to OSG_NOTICE or std::cout destructing earlier than this destructor.
            // OSG_INFO<<"Waiting for DatabasePager to cancel"<<std::endl;
            OpenThreads::Thread::YieldCurrentThread();
        }
        
        // _startThreadCalled = false;
    }
    //std::cout<<"DatabasePager::~DatabasePager() stopped running"<<std::endl;
    return result;

}

double DatabasePager::DatabaseThread::getTimeSinceStartOfIteration() const
{
    return osg::Timer::instance()->delta_s(_tickSinceStartOfIteration, osg::Timer::instance()->tick());
}

void DatabasePager::DatabaseThread::run()
{
    OSG_INFO<<_name<<": DatabasePager::DatabaseThread::run"<<std::endl;
    
#if 1
    // need to set the texture object manager to be able to reuse textures
    osg::Texture::setMinimumNumberOfTextureObjectsToRetainInCache(100);
    
    // need to set the display list manager to be able to reuse display lists
    osg::Drawable::setMinimumNumberOfDisplayListsToRetainInCache(100);
#else
    // need to set the texture object manager to be able to reuse textures
    osg::Texture::setMinimumNumberOfTextureObjectsToRetainInCache(0);
    
    // need to set the display list manager to be able to reuse display lists
    osg::Drawable::setMinimumNumberOfDisplayListsToRetainInCache(0);
#endif

    bool firstTime = true;
    
    osg::ref_ptr<DatabasePager::ReadQueue> read_queue;
    osg::ref_ptr<DatabasePager::ReadQueue> out_queue;
    
    switch(_mode)
    {
        case(HANDLE_ALL_REQUESTS):
            read_queue = _pager->_fileRequestQueue;
            break;
        case(HANDLE_NON_HTTP):
            read_queue = _pager->_fileRequestQueue;
            out_queue = _pager->_httpRequestQueue;
            break;
        case(HANDLE_ONLY_HTTP):
            read_queue = _pager->_httpRequestQueue;
            break;
    }


    do
    {
        _active = false;

        _tickSinceStartOfIteration = osg::Timer::instance()->tick();

        read_queue->block();

        _tickSinceStartOfIteration = osg::Timer::instance()->tick();

        _active = true;

        OSG_INFO<<_name<<": _pager->size()= "<<read_queue->size()<<" to delete = "<<read_queue->_childrenToDeleteList.size()<<std::endl;


        //
        // delete any children if required.
        //
        if (_pager->_deleteRemovedSubgraphsInDatabaseThread && !(read_queue->_childrenToDeleteList.empty()))
        {
            ObjectList deleteList;

            {
                OpenThreads::ScopedLock<OpenThreads::Mutex> lock(read_queue->_childrenToDeleteListMutex);
                deleteList.swap(read_queue->_childrenToDeleteList);
                read_queue->updateBlock();
            }
        }

        //
        // load any subgraphs that are required.
        //
        osg::ref_ptr<DatabaseRequest> databaseRequest;
        read_queue->takeFirst(databaseRequest);

        bool readFromFileCache = false;

        osg::ref_ptr<FileCache> fileCache = osgDB::Registry::instance()->getFileCache();
        osg::ref_ptr<FileLocationCallback> fileLocationCallback = osgDB::Registry::instance()->getFileLocationCallback();

        if (databaseRequest.valid())
        {
            if (databaseRequest->_loadOptions.valid())
            {
                if (databaseRequest->_loadOptions->getFileCache()) fileCache = databaseRequest->_loadOptions->getFileCache();
                if (databaseRequest->_loadOptions->getFileLocationCallback()) fileLocationCallback = databaseRequest->_loadOptions->getFileLocationCallback();
            }

            // disable the FileCache if the fileLocationCallback tells us that it isn't required for this request.
            if (fileLocationCallback.valid() && !fileLocationCallback->useFileCache()) fileCache = 0;


            // check if databaseRequest is still relevant
            if ((_pager->_frameNumber-databaseRequest->_frameNumberLastRequest)<=1)
            {

                // now check to see if this request is appropriate for this thread
                switch(_mode)
                {
                    case(HANDLE_ALL_REQUESTS):
                    {
                        // do nothing as this thread can handle the load
                        if (fileCache.valid() && fileCache->isFileAppropriateForFileCache(databaseRequest->_fileName))
                        {
                            if (fileCache->existsInCache(databaseRequest->_fileName))
                            {
                                readFromFileCache = true;
                            }
                        }
                        break;
                    }
                    case(HANDLE_NON_HTTP):
                    {
                        // check the cache first
                        bool isHighLatencyFileRequest = false;

                        if (fileLocationCallback.valid())
                        {
                            isHighLatencyFileRequest = fileLocationCallback->fileLocation(databaseRequest->_fileName, databaseRequest->_loadOptions.get()) == FileLocationCallback::REMOTE_FILE;
                        }
                        else  if (fileCache.valid() && fileCache->isFileAppropriateForFileCache(databaseRequest->_fileName))
                        {
                            isHighLatencyFileRequest = true;
                        }

                        if (isHighLatencyFileRequest)
                        {
                            if (fileCache.valid() && fileCache->existsInCache(databaseRequest->_fileName))
                            {
                                readFromFileCache = true;
                            }
                            else
                            {
                                OSG_INFO<<_name<<": Passing http requests over "<<databaseRequest->_fileName<<std::endl;
                                out_queue->add(databaseRequest.get());
                                databaseRequest = 0;
                            }
                        }
                        break;
                    }
                    case(HANDLE_ONLY_HTTP):
                    {
                        // accept all requests, as we'll assume only high latency requests will have got here.
                        break;
                    }
                }
            }
            else
            {                
                databaseRequest = 0;
            }
        }
        
        
        if (databaseRequest.valid())
        {
                       
            // load the data, note safe to write to the databaseRequest since once 
            // it is created this thread is the only one to write to the _loadedModel pointer.
            //OSG_NOTICE<<"In DatabasePager thread readNodeFile("<<databaseRequest->_fileName<<")"<<std::endl;
            //osg::Timer_t before = osg::Timer::instance()->tick();


            // assume that readNode is thread safe...
            ReaderWriter::ReadResult rr = readFromFileCache ?
                        fileCache->readNode(databaseRequest->_fileName, databaseRequest->_loadOptions.get(), false) :
                        Registry::instance()->readNode(databaseRequest->_fileName, databaseRequest->_loadOptions.get(), false);

            if (rr.validNode()) databaseRequest->_loadedModel = rr.getNode();
            if (rr.error()) OSG_WARN<<"Error in reading file "<<databaseRequest->_fileName<<" : "<<rr.message() << std::endl;
            if (rr.notEnoughMemory()) OSG_INFO<<"Not enought memory to load file "<<databaseRequest->_fileName << std::endl;

            if (databaseRequest->_loadedModel.valid() &&
                fileCache.valid() &&
                fileCache->isFileAppropriateForFileCache(databaseRequest->_fileName) &&
                !readFromFileCache)
            {
                fileCache->writeNode(*(databaseRequest->_loadedModel), databaseRequest->_fileName, databaseRequest->_loadOptions.get());
            }

            if ((_pager->_frameNumber-databaseRequest->_frameNumberLastRequest)>1)
            {
                OSG_INFO<<_name<<": Warning DatabaseRquest no longer required."<<std::endl;
                databaseRequest->_loadedModel = 0;
            }

            // take a refNodePath to ensure that none of the nodes go out of scope while we are using them.
            osg::RefNodePath refNodePath;
            if (!databaseRequest->_observerNodePath.getRefNodePath(refNodePath))
            {
                OSG_INFO<<_name<<": Warning node in parental chain has been deleted, discarding load."<<std::endl;
                databaseRequest->_loadedModel = 0;
            }


            //OSG_NOTICE<<"     node read in "<<osg::Timer::instance()->delta_m(before,osg::Timer::instance()->tick())<<" ms"<<std::endl;

            bool loadedObjectsNeedToBeCompiled = false;

            if (databaseRequest->_loadedModel.valid())
            {
                databaseRequest->_loadedModel->getBound();

                osg::NodePath nodePath;

                for(osg::RefNodePath::iterator rnp_itr = refNodePath.begin();
                    rnp_itr != refNodePath.end();
                    ++rnp_itr)
                {
                    nodePath.push_back(rnp_itr->get());
                }

                // force a compute of the loaded model's bounding volume, so that when the subgraph
                // merged with the main scene graph and large computeBound() isn't incurred.
                ActiveGraphicsContexts::iterator itr = _pager->_activeGraphicsContexts.begin();

                DataToCompile* dtc = 0;
                if (itr != _pager->_activeGraphicsContexts.end())
                {
                    dtc = &(databaseRequest->_dataToCompileMap[*itr]);
                    ++itr;
                }

                // find all the compileable rendering objects
                DatabasePager::FindCompileableGLObjectsVisitor frov(dtc, 
                                                     _pager->_changeAutoUnRef, _pager->_valueAutoUnRef,
                                                     _pager->_changeAnisotropy, _pager->_valueAnisotropy,
                                                     _pager->_drawablePolicy, 
                                                     _pager);

                // push the soon to be parent on the nodepath of the NodeVisitor so that 
                // during traversal one can test for where it'll be in the overall scene graph                
                for(osg::NodePath::iterator nitr = nodePath.begin();
                    nitr != nodePath.end();
                    ++nitr)
                {
                    frov.pushOntoNodePath(*nitr);
                }

                databaseRequest->_loadedModel->accept(frov);

                if (_pager->_doPreCompile && !dtc->empty())
                {
                    if (_pager->_incrementalCompileOperation.valid())
                    {
                        OSG_NOTICE<<"Using IncrementalCompileOperation"<<std::endl;

                        osgUtil::IncrementalCompileOperation::CompileSet* compileSet = new osgUtil::IncrementalCompileOperation::CompileSet(databaseRequest->_loadedModel.get());
                        compileSet->_compileCompletedCallback = new DatabasePagerCompileCompletedCallback(_pager, databaseRequest.get());

                        _pager->_incrementalCompileOperation->add(compileSet);
 
                        loadedObjectsNeedToBeCompiled = true;
                    }
                    else if (!_pager->_activeGraphicsContexts.empty())
                    {
                        // copy the objects from the compile list to the other graphics context list.
                        for(;
                            itr != _pager->_activeGraphicsContexts.end();
                            ++itr)
                        {
                            databaseRequest->_dataToCompileMap[*itr] = *dtc;
                        }
                    }
                }

                // move the databaseRequest from the front of the fileRequest to the end of
                // dataToCompile or dataToMerge lists.
                if (loadedObjectsNeedToBeCompiled)
                {
                    if (!_pager->_incrementalCompileOperation)
                    {
                        _pager->_dataToCompileList->add(databaseRequest.get());
                    }
                }
                else
                {
                    _pager->_dataToMergeList->add(databaseRequest.get());
                }
            }

            // Prepare and prune the to-be-compiled list here in
            // the pager thread rather than in the draw or
            // graphics context thread(s).
            if (loadedObjectsNeedToBeCompiled)
            {
                loadedObjectsNeedToBeCompiled = ! _pager->_dataToCompileList->pruneOldRequestsAndCheckIfEmpty();
            }

            if (loadedObjectsNeedToBeCompiled && !_pager->_activeGraphicsContexts.empty())
            {
                for(ActiveGraphicsContexts::iterator itr = _pager->_activeGraphicsContexts.begin();
                    itr != _pager->_activeGraphicsContexts.end();
                    ++itr)
                {
                    osg::GraphicsContext* gc = osg::GraphicsContext::getCompileContext(*itr);
                    if (gc)
                    {   
                        osg::GraphicsThread* gt = gc->getGraphicsThread();
                        if (gt)
                        {
                            gt->add(new DatabasePager::CompileOperation(_pager));
                        }
                        else
                        {
                            gc->makeCurrent();

                            _pager->compileAllGLObjects(*(gc->getState()));

                            gc->releaseContext();
                        }
                    }
                }

                // OSG_NOTICE<<"Done compiling in paging thread"<<std::endl;
            }
        }
        else
        {
            OpenThreads::Thread::YieldCurrentThread();
        }
        
        
        // go to sleep till our the next time our thread gets scheduled.

        if (firstTime)
        {
            // do a yield to get round a peculiar thread hang when testCancel() is called 
            // in certain circumstances - of which there is no particular pattern.
            YieldCurrentThread();
            firstTime = false;
        }

    } while (!testCancel() && !_done);
}


DatabasePager::DatabasePager()
{
    //OSG_INFO<<"Constructing DatabasePager()"<<std::endl;
    
    _startThreadCalled = false;

    _done = false;
    _acceptNewRequests = true;
    _databasePagerThreadPaused = false;
    
    _numFramesActive = 0;
    _frameNumber = 0;
    

#if __APPLE__
    // OSX really doesn't like compiling display lists, and performs poorly when they are used,
    // so apply this hack to make up for its short comings.
    _drawablePolicy = USE_VERTEX_ARRAYS;
#else
    _drawablePolicy = DO_NOT_MODIFY_DRAWABLE_SETTINGS;
#endif    
    
    const char* str = getenv("OSG_DATABASE_PAGER_GEOMETRY");
    if (!str) str = getenv("OSG_DATABASE_PAGER_DRAWABLE");
    if (str)
    {
        if (strcmp(str,"DoNotModify")==0)
        {
            _drawablePolicy = DO_NOT_MODIFY_DRAWABLE_SETTINGS;
        }
        else if (strcmp(str,"DisplayList")==0 || strcmp(str,"DL")==0)
        {
            _drawablePolicy = USE_DISPLAY_LISTS;
        }
        else if (strcmp(str,"VBO")==0)
        {
            _drawablePolicy = USE_VERTEX_BUFFER_OBJECTS;
        }
        else if (strcmp(str,"VertexArrays")==0 || strcmp(str,"VA")==0 )
        {
            _drawablePolicy = USE_VERTEX_ARRAYS;
        } 
    }

    _changeAutoUnRef = true;
    _valueAutoUnRef = false;
 
    _changeAnisotropy = false;
    _valueAnisotropy = 1.0f;

    const char* ptr=0;

    _deleteRemovedSubgraphsInDatabaseThread = true;
    if( (ptr = getenv("OSG_DELETE_IN_DATABASE_THREAD")) != 0)
    {
        _deleteRemovedSubgraphsInDatabaseThread = strcmp(ptr,"yes")==0 || strcmp(ptr,"YES")==0 ||
                        strcmp(ptr,"on")==0 || strcmp(ptr,"ON")==0;

    }

    _targetMaximumNumberOfPageLOD = 300;
    if( (ptr = getenv("OSG_MAX_PAGEDLOD")) != 0)
    {
        _targetMaximumNumberOfPageLOD = atoi(ptr);
        OSG_NOTICE<<"_targetMaximumNumberOfPageLOD = "<<_targetMaximumNumberOfPageLOD<<std::endl;
    }


    _doPreCompile = false;
    if( (ptr = getenv("OSG_DO_PRE_COMPILE")) != 0)
    {
        _doPreCompile = strcmp(ptr,"yes")==0 || strcmp(ptr,"YES")==0 ||
                        strcmp(ptr,"on")==0 || strcmp(ptr,"ON")==0;
    }

    _targetFrameRate = 100.0;
    _minimumTimeAvailableForGLCompileAndDeletePerFrame = 0.001; // 1ms.
    _maximumNumOfObjectsToCompilePerFrame = 4;
    if( (ptr = getenv("OSG_MINIMUM_COMPILE_TIME_PER_FRAME")) != 0)
    {
        _minimumTimeAvailableForGLCompileAndDeletePerFrame = osg::asciiToDouble(ptr);
    }

    if( (ptr = getenv("OSG_MAXIMUM_OBJECTS_TO_COMPILE_PER_FRAME")) != 0)
    {
        _maximumNumOfObjectsToCompilePerFrame = atoi(ptr);
    }

    // initialize the stats variables
    resetStats();

    // make sure a SharedStateManager exists.
    //osgDB::Registry::instance()->getOrCreateSharedStateManager();
    
    //if (osgDB::Registry::instance()->getSharedStateManager())
        //osgDB::Registry::instance()->setUseObjectCacheHint(true);
        
    _fileRequestQueue = new ReadQueue(this,"fileRequestQueue");
    _httpRequestQueue = new ReadQueue(this,"httpRequestQueue");
    
    _dataToCompileList = new RequestQueue(this);
    _dataToMergeList = new RequestQueue(this);
    
    setUpThreads(
        osg::DisplaySettings::instance()->getNumOfDatabaseThreadsHint(),
        osg::DisplaySettings::instance()->getNumOfHttpDatabaseThreadsHint());

    str = getenv("OSG_DATABASE_PAGER_PRIORITY");
    if (str)
    {
        if (strcmp(str,"DEFAULT")==0)
        {
            setSchedulePriority(OpenThreads::Thread::THREAD_PRIORITY_DEFAULT);
        }
        else if (strcmp(str,"MIN")==0)
        {
            setSchedulePriority(OpenThreads::Thread::THREAD_PRIORITY_MIN);
        }
        else if (strcmp(str,"LOW")==0)
        {
            setSchedulePriority(OpenThreads::Thread::THREAD_PRIORITY_LOW);
        }
        else if (strcmp(str,"NOMINAL")==0)
        {
            setSchedulePriority(OpenThreads::Thread::THREAD_PRIORITY_NOMINAL);
        }
        else if (strcmp(str,"HIGH")==0)
        {
            setSchedulePriority(OpenThreads::Thread::THREAD_PRIORITY_HIGH);
        }
        else if (strcmp(str,"MAX")==0)
        {
            setSchedulePriority(OpenThreads::Thread::THREAD_PRIORITY_MAX);
        }
    }

    _activePagedLODList = new SetBasedPagedLODList;
    _inactivePagedLODList = new SetBasedPagedLODList;
}

DatabasePager::DatabasePager(const DatabasePager& rhs)
{
    //OSG_INFO<<"Constructing DatabasePager(const DatabasePager& )"<<std::endl;
    
    _startThreadCalled = false;

    _done = false;
    _acceptNewRequests = true;
    _databasePagerThreadPaused = false;
    
    _numFramesActive = 0;
    _frameNumber = 0;

    _drawablePolicy = rhs._drawablePolicy;

    _changeAutoUnRef = rhs._changeAutoUnRef;
    _valueAutoUnRef = rhs._valueAutoUnRef;
    _changeAnisotropy = rhs._changeAnisotropy;
    _valueAnisotropy = rhs._valueAnisotropy;


    _deleteRemovedSubgraphsInDatabaseThread = rhs._deleteRemovedSubgraphsInDatabaseThread;

    
    _targetMaximumNumberOfPageLOD = rhs._targetMaximumNumberOfPageLOD;

    _doPreCompile = rhs._doPreCompile;
    _targetFrameRate = rhs._targetFrameRate;
    _minimumTimeAvailableForGLCompileAndDeletePerFrame = rhs._minimumTimeAvailableForGLCompileAndDeletePerFrame;
    _maximumNumOfObjectsToCompilePerFrame = rhs._maximumNumOfObjectsToCompilePerFrame;

    _fileRequestQueue = new ReadQueue(this,"fileRequestQueue");
    _httpRequestQueue = new ReadQueue(this,"httpRequestQueue");
    
    _dataToCompileList = new RequestQueue(this);
    _dataToMergeList = new RequestQueue(this);

    for(DatabaseThreadList::const_iterator dt_itr = rhs._databaseThreads.begin();
        dt_itr != rhs._databaseThreads.end();
        ++dt_itr)
    {
        _databaseThreads.push_back(new DatabaseThread(**dt_itr,this));
    }

    _activePagedLODList = rhs._activePagedLODList->clone();
    _inactivePagedLODList = rhs._inactivePagedLODList->clone();

    // initialize the stats variables
    resetStats();
}


void DatabasePager::setIncrementalCompileOperation(osgUtil::IncrementalCompileOperation* ico)
{
    _incrementalCompileOperation = ico;
}

DatabasePager::~DatabasePager()
{
    cancel();
}

osg::ref_ptr<DatabasePager>& DatabasePager::prototype()
{
    static osg::ref_ptr<DatabasePager> s_DatabasePager = new DatabasePager;
    return s_DatabasePager;
}

DatabasePager* DatabasePager::create()
{
    return DatabasePager::prototype().valid() ? 
           DatabasePager::prototype()->clone() :
           new DatabasePager; 
}

void DatabasePager::setUpThreads(unsigned int totalNumThreads, unsigned int numHttpThreads)
{
    _databaseThreads.clear();
    
    unsigned int numGeneralThreads = numHttpThreads < totalNumThreads ?
        totalNumThreads - numHttpThreads :
        1;
    
    if (numHttpThreads==0)
    {
        for(unsigned int i=0; i<numGeneralThreads; ++i)
        {
            addDatabaseThread(DatabaseThread::HANDLE_ALL_REQUESTS,"HANDLE_ALL_REQUESTS");
        }
    }
    else
    {
        for(unsigned int i=0; i<numGeneralThreads; ++i)
        {
            addDatabaseThread(DatabaseThread::HANDLE_NON_HTTP, "HANDLE_NON_HTTP");
        }

        for(unsigned int i=0; i<numHttpThreads; ++i)
        {
            addDatabaseThread(DatabaseThread::HANDLE_ONLY_HTTP, "HANDLE_ONLY_HTTP");
        }
    }    
}

unsigned int DatabasePager::addDatabaseThread(DatabaseThread::Mode mode, const std::string& name)
{
    OSG_INFO<<"DatabasePager::addDatabaseThread() "<<name<<std::endl;

    unsigned int pos = _databaseThreads.size();
    
    DatabaseThread* thread = new DatabaseThread(this, mode,name);
    _databaseThreads.push_back(thread);
    
    if (_startThreadCalled)
    {
        OSG_INFO<<"DatabasePager::startThread()"<<std::endl;
        thread->startThread();
    }
    
    return pos;
}

int DatabasePager::setSchedulePriority(OpenThreads::Thread::ThreadPriority priority)
{
    int result = 0;
    for(DatabaseThreadList::iterator dt_itr = _databaseThreads.begin();
        dt_itr != _databaseThreads.end();
        ++dt_itr)
    {
        result = (*dt_itr)->setSchedulePriority(priority);
    }
    return result;
}

bool DatabasePager::isRunning() const
{
    for(DatabaseThreadList::const_iterator dt_itr = _databaseThreads.begin();
        dt_itr != _databaseThreads.end();
        ++dt_itr)
    {
        if ((*dt_itr)->isRunning()) return true;
    }
    
    return false;
}

int DatabasePager::cancel()
{
    int result = 0;

    for(DatabaseThreadList::iterator dt_itr = _databaseThreads.begin();
        dt_itr != _databaseThreads.end();
        ++dt_itr)
    {
        (*dt_itr)->setDone(true);
    }

    // release the frameBlock and _databasePagerThreadBlock in case its holding up thread cancellation.
    _fileRequestQueue->release();
    _httpRequestQueue->release();

    for(DatabaseThreadList::iterator dt_itr = _databaseThreads.begin();
        dt_itr != _databaseThreads.end();
        ++dt_itr)
    {
        (*dt_itr)->cancel();
    }

    _done = true;
    _startThreadCalled = false;

    //std::cout<<"DatabasePager::~DatabasePager() stopped running"<<std::endl;
    return result;
}

void DatabasePager::clear()
{
    _fileRequestQueue->clear();
    _httpRequestQueue->clear();

    _dataToCompileList->clear();
    _dataToMergeList->clear();

    // note, no need to use a mutex as the list is only accessed from the update thread.
    _activePagedLODList->clear();
    _inactivePagedLODList->clear();

    // ??
    // _activeGraphicsContexts
}

void DatabasePager::resetStats()
{
    // initialize the stats variables
    _minimumTimeToMergeTile = DBL_MAX;
    _maximumTimeToMergeTile = -DBL_MAX;
    _totalTimeToMergeTiles = 0.0;
    _numTilesMerges = 0;
}

bool DatabasePager::getRequestsInProgress() const
{
    if (getFileRequestListSize()>0) return true;

    if (getDataToCompileListSize()>0) 
    {
        return true;
    }

    if (getDataToMergeListSize()>0) return true;

    for(DatabaseThreadList::const_iterator itr = _databaseThreads.begin();
        itr != _databaseThreads.end();
        ++itr)
    {
        if ((*itr)->getActive()) return true;
    }
    return false;
}


void DatabasePager::requestNodeFile(const std::string& fileName,osg::Group* group,
                                    float priority, const osg::FrameStamp* framestamp,
                                    osg::ref_ptr<osg::Referenced>& databaseRequestRef,
                                    const osg::Referenced* options)
{
    osgDB::Options* loadOptions = dynamic_cast<osgDB::Options*>(const_cast<osg::Referenced*>(options));
    if (!loadOptions)
    {
       loadOptions = Registry::instance()->getOptions();

        // OSG_NOTICE<<"Using options from Registry "<<std::endl;
    }
    else
    {
        // OSG_NOTICE<<"options from requestNodeFile "<<std::endl;
    }


    if (!_acceptNewRequests) return;
    

    double timestamp = framestamp?framestamp->getReferenceTime():0.0;
    int frameNumber = framestamp?framestamp->getFrameNumber():_frameNumber;

// #define WITH_REQUESTNODEFILE_TIMING
#ifdef WITH_REQUESTNODEFILE_TIMING
    osg::Timer_t start_tick = osg::Timer::instance()->tick();
    static int previousFrame = -1;
    static double totalTime = 0.0;
    
    if (previousFrame!=frameNumber)
    {
        OSG_NOTICE<<"requestNodeFiles for "<<previousFrame<<" time = "<<totalTime<<std::endl;

        previousFrame = frameNumber;
        totalTime = 0.0;
    }
#endif
    
    // search to see if filename already exist in the file loaded list.
    bool foundEntry = false;

    if (databaseRequestRef.valid())
    {
        DatabaseRequest* databaseRequest = dynamic_cast<DatabaseRequest*>(databaseRequestRef.get());
        if (databaseRequest && !(databaseRequest->valid()))
        {
            OSG_INFO<<"DatabaseRequest has been previously invalidated whilst still attached to scene graph."<<std::endl;
            databaseRequest = 0;
        }

        if (databaseRequest)
        {
            OSG_INFO<<"DatabasePager::requestNodeFile("<<fileName<<") updating already assigned."<<std::endl;

            RequestQueue* requestQueue = databaseRequest->_requestQueue;
            if (requestQueue)
            {
                OpenThreads::ScopedLock<OpenThreads::Mutex> lock(requestQueue->_requestMutex);

                databaseRequest->_valid = true;
                databaseRequest->_frameNumberLastRequest = frameNumber;
                databaseRequest->_timestampLastRequest = timestamp;
                databaseRequest->_priorityLastRequest = priority;
                ++(databaseRequest->_numOfRequests);
            }
            else
            {
                databaseRequest->_valid = true;
                databaseRequest->_frameNumberLastRequest = frameNumber;
                databaseRequest->_timestampLastRequest = timestamp;
                databaseRequest->_priorityLastRequest = priority;
                ++(databaseRequest->_numOfRequests);
            }
            
            foundEntry = true;

            if (databaseRequestRef->referenceCount()==1)
            {
                OSG_INFO<<"DatabasePager::requestNodeFile("<<fileName<<") orphaned, resubmitting."<<std::endl;

                databaseRequest->_valid = true;
                databaseRequest->_frameNumberFirstRequest = frameNumber;
                databaseRequest->_timestampFirstRequest = timestamp;
                databaseRequest->_priorityFirstRequest = priority;
                databaseRequest->_frameNumberLastRequest = frameNumber;
                databaseRequest->_timestampLastRequest = timestamp;
                databaseRequest->_priorityLastRequest = priority;
                databaseRequest->_observerNodePath.setNodePathTo(group);
                databaseRequest->_groupForAddingLoadedSubgraph = group;
                databaseRequest->_loadOptions = loadOptions;
                databaseRequest->_requestQueue = _fileRequestQueue.get();

                _fileRequestQueue->add(databaseRequest);
            }
            
        }
    }

    if (!foundEntry)
    {
        OSG_INFO<<"In DatabasePager::requestNodeFile("<<fileName<<")"<<std::endl;
        
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_fileRequestQueue->_requestMutex);
        
        if (!databaseRequestRef.valid() || databaseRequestRef->referenceCount()==1)
        {
            osg::ref_ptr<DatabaseRequest> databaseRequest = new DatabaseRequest;

            databaseRequestRef = databaseRequest.get();

            databaseRequest->_valid = true;
            databaseRequest->_fileName = fileName;
            databaseRequest->_frameNumberFirstRequest = frameNumber;
            databaseRequest->_timestampFirstRequest = timestamp;
            databaseRequest->_priorityFirstRequest = priority;
            databaseRequest->_frameNumberLastRequest = frameNumber;
            databaseRequest->_timestampLastRequest = timestamp;
            databaseRequest->_priorityLastRequest = priority;
            databaseRequest->_observerNodePath.setNodePathTo(group);
            databaseRequest->_groupForAddingLoadedSubgraph = group;
            databaseRequest->_loadOptions = loadOptions;
            databaseRequest->_requestQueue = _fileRequestQueue.get();

            _fileRequestQueue->addNoLock(databaseRequest.get());
        }
        
    }
    
    if (!_startThreadCalled)
    {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_run_mutex);
        
        if (!_startThreadCalled)
        {
            _startThreadCalled = true;
            _done = false;
            OSG_INFO<<"DatabasePager::startThread()"<<std::endl;
            
            if (_databaseThreads.empty()) 
            {
                setUpThreads(
                    osg::DisplaySettings::instance()->getNumOfDatabaseThreadsHint(),
                    osg::DisplaySettings::instance()->getNumOfHttpDatabaseThreadsHint());
            }

            for(DatabaseThreadList::const_iterator dt_itr = _databaseThreads.begin();
                dt_itr != _databaseThreads.end();
                ++dt_itr)
            {
                (*dt_itr)->startThread();
            }
        }
    }

#ifdef WITH_REQUESTNODEFILE_TIMING
    totalTime += osg::Timer::instance()->delta_m(start_tick, osg::Timer::instance()->tick());
#endif
}

void DatabasePager::signalBeginFrame(const osg::FrameStamp* framestamp)
{
    if (framestamp)
    {
        //OSG_INFO << "signalBeginFrame "<<framestamp->getFrameNumber()<<">>>>>>>>>>>>>>>>"<<std::endl;
        _frameNumber = framestamp->getFrameNumber();
        
    } //else OSG_INFO << "signalBeginFrame >>>>>>>>>>>>>>>>"<<std::endl;
}

void DatabasePager::signalEndFrame()
{
    //OSG_INFO << "signalEndFrame <<<<<<<<<<<<<<<<<<<< "<<std::endl;
}

void DatabasePager::setDatabasePagerThreadPause(bool pause)
{
    if (_databasePagerThreadPaused == pause) return;
    
    _databasePagerThreadPaused = pause;
    _fileRequestQueue->updateBlock();
    _httpRequestQueue->updateBlock();
}


bool DatabasePager::requiresUpdateSceneGraph() const
{
    return !(_dataToMergeList->empty());
}

void DatabasePager::updateSceneGraph(const osg::FrameStamp& frameStamp)
{

#define UPDATE_TIMING 0
#if UPDATE_TIMING
    osg::ElapsedTime timer;
    double timeFor_removeExpiredSubgraphs, timeFor_addLoadedDataToSceneGraph;
#endif

    {
        removeExpiredSubgraphs(frameStamp);

#if UPDATE_TIMING
        timeFor_removeExpiredSubgraphs = timer.elapsedTime_m();
#endif

        addLoadedDataToSceneGraph(frameStamp);

#if UPDATE_TIMING
        timeFor_addLoadedDataToSceneGraph = timer.elapsedTime_m() - timeFor_removeExpiredSubgraphs;
#endif

    }

#if UPDATE_TIMING
    double elapsedTime = timer.elapsedTime_m();
    if (elapsedTime>0.4)
    {
        OSG_NOTICE<<"DatabasePager::updateSceneGraph() total time = "<<elapsedTime<<"ms"<<std::endl;
        OSG_NOTICE<<"   timeFor_removeExpiredSubgraphs    = "<<timeFor_removeExpiredSubgraphs<<"ms"<<std::endl;
        OSG_NOTICE<<"   timeFor_addLoadedDataToSceneGraph = "<<timeFor_addLoadedDataToSceneGraph<<"ms"<<std::endl;
        OSG_NOTICE<<"   _activePagedLODList.size()        = "<<_activePagedLODList->size()<<std::endl;
        OSG_NOTICE<<"   _inactivePagedLODList.size()      = "<<_inactivePagedLODList->size()<<std::endl;
        OSG_NOTICE<<"   total                             = "<<_activePagedLODList->size() + _inactivePagedLODList->size()<<std::endl;
    }
#endif
}


void DatabasePager::addLoadedDataToSceneGraph(const osg::FrameStamp &frameStamp)
{
    double timeStamp = frameStamp.getReferenceTime();
    int frameNumber = frameStamp.getFrameNumber();

    osg::Timer_t before = osg::Timer::instance()->tick(), mid, last;

    RequestQueue::RequestList localFileLoadedList;

    // get the data for the _dataToCompileList, leaving it empty via a std::vector<>.swap.
    _dataToMergeList->swap(localFileLoadedList);
        
    mid = osg::Timer::instance()->tick();

    // add the loaded data into the scene graph.
    for(RequestQueue::RequestList::iterator itr=localFileLoadedList.begin();
        itr!=localFileLoadedList.end();
        ++itr)
    {
        DatabaseRequest* databaseRequest = itr->get();

        osg::RefNodePath refNodePath;
        if (databaseRequest->_observerNodePath.getRefNodePath(refNodePath))
        {
            // OSG_NOTICE<<"Merging "<<_frameNumber-(*itr)->_frameNumberLastRequest<<std::endl;
            osg::Group* group = databaseRequest->_groupForAddingLoadedSubgraph;

            if (osgDB::Registry::instance()->getSharedStateManager())
                osgDB::Registry::instance()->getSharedStateManager()->share(databaseRequest->_loadedModel.get());

            osg::PagedLOD* plod = dynamic_cast<osg::PagedLOD*>(group);
            if (plod)
            {
                plod->setTimeStamp(plod->getNumChildren(), timeStamp);
                plod->setFrameNumber(plod->getNumChildren(), frameNumber);
                plod->getDatabaseRequest(plod->getNumChildren()) = 0;
            }
            else
            {
                osg::ProxyNode* proxyNode = dynamic_cast<osg::ProxyNode*>(group);
                if (proxyNode)
                {
                    proxyNode->getDatabaseRequest(proxyNode->getNumChildren()) = 0;
                } 
            }

            group->addChild(databaseRequest->_loadedModel.get());

            // Check if parent plod was already registered if not start visitor from parent
            if( plod && 
                !_activePagedLODList->containsPagedLOD( plod ) &&
                !_inactivePagedLODList->containsPagedLOD( plod ) )
            {
                registerPagedLODs(plod, frameNumber);
            } 
            else 
            {
                registerPagedLODs(databaseRequest->_loadedModel.get(), frameNumber);
            }

            // OSG_NOTICE<<"merged subgraph"<<databaseRequest->_fileName<<" after "<<databaseRequest->_numOfRequests<<" requests and time="<<(timeStamp-databaseRequest->_timestampFirstRequest)*1000.0<<std::endl;

            double timeToMerge = timeStamp-databaseRequest->_timestampFirstRequest;

            if (timeToMerge<_minimumTimeToMergeTile) _minimumTimeToMergeTile = timeToMerge;
            if (timeToMerge>_maximumTimeToMergeTile) _maximumTimeToMergeTile = timeToMerge;

            _totalTimeToMergeTiles += timeToMerge;
            ++_numTilesMerges;
        }
        else
        {
            OSG_INFO<<"DatabasePager::addLoadedDataToSceneGraph() node in parental chain deleted, discarding subgaph."<<std::endl;
        }

        // reset the loadedModel pointer
        databaseRequest->_loadedModel = 0;

        // OSG_NOTICE<<"curr = "<<timeToMerge<<" min "<<getMinimumTimeToMergeTile()*1000.0<<" max = "<<getMaximumTimeToMergeTile()*1000.0<<" average = "<<getAverageTimToMergeTiles()*1000.0<<std::endl;
    }

    last = osg::Timer::instance()->tick();

    if (!localFileLoadedList.empty())
    {
        OSG_INFO<<"Done DatabasePager::addLoadedDataToSceneGraph"<<
            osg::Timer::instance()->delta_m(before,mid)<<"ms,\t"<<
            osg::Timer::instance()->delta_m(mid,last)<<"ms"<<
            "  objects"<<localFileLoadedList.size()<<std::endl<<std::endl;
    }

}



void DatabasePager::removeExpiredSubgraphs(const osg::FrameStamp& frameStamp)
{

    static double s_total_iter_stage_a = 0.0;
    static double s_total_time_stage_a = 0.0;
    static double s_total_max_stage_a = 0.0;
    
    static double s_total_iter_stage_b = 0.0;
    static double s_total_time_stage_b = 0.0;
    static double s_total_max_stage_b = 0.0;

    static double s_total_iter_stage_c = 0.0;
    static double s_total_time_stage_c = 0.0;
    static double s_total_max_stage_c = 0.0;

    osg::Timer_t startTick = osg::Timer::instance()->tick();

    _activePagedLODList->moveInactivePagedLODTo(*_inactivePagedLODList, frameStamp);

    _inactivePagedLODList->moveActivePagedLODTo(*_activePagedLODList, frameStamp);

    int inactivePLOD = _inactivePagedLODList->size();
    unsigned int numPagedLODs = _activePagedLODList->size() + inactivePLOD;

    
    osg::Timer_t end_a_Tick = osg::Timer::instance()->tick();
    double time_a = osg::Timer::instance()->delta_m(startTick,end_a_Tick);

    s_total_iter_stage_a += 1.0;
    s_total_time_stage_a += time_a;
    if (s_total_max_stage_a<time_a) s_total_max_stage_a = time_a;
    

    if (numPagedLODs <= _targetMaximumNumberOfPageLOD)
    {
        // nothing to do
        return;
    }
    
    int numToPrune = numPagedLODs - _targetMaximumNumberOfPageLOD;
    if (numToPrune > inactivePLOD)
    {
        numToPrune = inactivePLOD;
    }


    osg::NodeList childrenRemoved;
    childrenRemoved.reserve(numToPrune);
    
    double expiryTime = frameStamp.getReferenceTime() - 0.1;
    int expiryFrame = frameStamp.getFrameNumber() - 1;

    if (numToPrune>0) _inactivePagedLODList->removeExpiredChildren(numToPrune, expiryTime, expiryFrame, childrenRemoved);
    if (numToPrune>0) _activePagedLODList->removeExpiredChildren(numToPrune, expiryTime, expiryFrame, childrenRemoved);

    osg::Timer_t end_b_Tick = osg::Timer::instance()->tick();
    double time_b = osg::Timer::instance()->delta_m(end_a_Tick,end_b_Tick);

    s_total_iter_stage_b += 1.0;
    s_total_time_stage_b += time_b;
    if (s_total_max_stage_b<time_b) s_total_max_stage_b = time_b;

    //OSG_NOTICE<<"numToPrune "<<numToPrune<< " countPagedLODsVisitor._numPagedLODsMarked="<<countPagedLODsVisitor._numPagedLODsMarked<< " childrenRemoved.size()="<<childrenRemoved.size()<<std::endl;

    if (!childrenRemoved.empty())
    { 
        bool updateBlock = false;

        // remove any entries in the active/inactivePagedLODLists.
        _activePagedLODList->removeNodes(childrenRemoved);
        _inactivePagedLODList->removeNodes(childrenRemoved);

        // pass the objects across to the database pager delete list
        if (_deleteRemovedSubgraphsInDatabaseThread)
        {
            OpenThreads::ScopedLock<OpenThreads::Mutex> lock(_fileRequestQueue->_childrenToDeleteListMutex);
            for (osg::NodeList::iterator critr = childrenRemoved.begin();
                 critr!=childrenRemoved.end();
                 ++critr)
            {
                _fileRequestQueue->_childrenToDeleteList.push_back(critr->get());
            }

            updateBlock = true;
        }

        childrenRemoved.clear();

        if (updateBlock)
        {
            _fileRequestQueue->updateBlock();
        }
    }
    
    osg::Timer_t end_c_Tick = osg::Timer::instance()->tick();
    double time_c = osg::Timer::instance()->delta_m(end_b_Tick,end_c_Tick);

    s_total_iter_stage_c += 1.0;
    s_total_time_stage_c += time_c;
    if (s_total_max_stage_c<time_c) s_total_max_stage_c = time_c;

    OSG_INFO<<"active="<<_activePagedLODList->size()<<" inactive="<<_inactivePagedLODList->size()<<" overall = "<<osg::Timer::instance()->delta_m(startTick,end_c_Tick)<<
                              " A="<<time_a<<" avg="<<s_total_time_stage_a/s_total_iter_stage_a<<" max = "<<s_total_max_stage_a<<
                              " B="<<time_b<<" avg="<<s_total_time_stage_b/s_total_iter_stage_b<<" max = "<<s_total_max_stage_b<<
                              " C="<<time_c<<" avg="<<s_total_time_stage_c/s_total_iter_stage_c<<" max = "<<s_total_max_stage_c<<std::endl;
}

class DatabasePager::FindPagedLODsVisitor : public osg::NodeVisitor
{
public:

    FindPagedLODsVisitor(DatabasePager::PagedLODList& pagedLODList, int frameNumber):
        osg::NodeVisitor(osg::NodeVisitor::TRAVERSE_ALL_CHILDREN),
        _activePagedLODList(pagedLODList),
        _frameNumber(frameNumber)
    {
    }

    META_NodeVisitor("osgDB","FindPagedLODsVisitor")

    virtual void apply(osg::PagedLOD& plod)
    {
        plod.setFrameNumberOfLastTraversal(_frameNumber);

        osg::observer_ptr<osg::PagedLOD> obs_ptr(&plod);
        _activePagedLODList.insertPagedLOD(obs_ptr);

        traverse(plod);
    }

    DatabasePager::PagedLODList& _activePagedLODList;
    int _frameNumber;

protected:

    FindPagedLODsVisitor& operator = (const FindPagedLODsVisitor&) { return *this; }
};


void DatabasePager::registerPagedLODs(osg::Node* subgraph, int frameNumber)
{
    if (!subgraph) return;

    FindPagedLODsVisitor fplv(*_activePagedLODList, frameNumber);
    subgraph->accept(fplv);
}

bool DatabasePager::requiresCompileGLObjects() const
{
    return !_dataToCompileList->empty();
}

void DatabasePager::setCompileGLObjectsForContextID(unsigned int contextID, bool on)
{
    if (on)
    {
        _activeGraphicsContexts.insert(contextID);
    }
    else
    {
        _activeGraphicsContexts.erase(contextID);
    }
}

bool DatabasePager::getCompileGLObjectsForContextID(unsigned int contextID)
{
    return _activeGraphicsContexts.count(contextID)!=0;
}


DatabasePager::CompileOperation::CompileOperation(osgDB::DatabasePager* databasePager):
    osg::GraphicsOperation("DatabasePager::CompileOperation",false),
    _databasePager(databasePager)
{
}

void DatabasePager::CompileOperation::operator () (osg::GraphicsContext* context)
{
    // OSG_NOTICE<<"Background thread compiling"<<std::endl;

    if (_databasePager.valid()) _databasePager->compileAllGLObjects(*(context->getState()), true);
    
}

bool DatabasePager::requiresExternalCompileGLObjects(unsigned int contextID) const
{
    if (_activeGraphicsContexts.count(contextID)==0) return false;

    return osg::GraphicsContext::getCompileContext(contextID)==0;
}

void DatabasePager::compileCompleted(DatabaseRequest* databaseRequest)
{
    OSG_NOTICE<<"DatabasePager::compileCompleted("<<databaseRequest<<")"<<std::endl;
    _dataToMergeList->add(databaseRequest);
}

void DatabasePager::compileAllGLObjects(osg::State& state, bool doFlush)
{
    double availableTime = DBL_MAX;
    compileGLObjects(state, availableTime, doFlush);
}

void DatabasePager::compileGLObjects(osg::State& state, double& availableTime, bool doFlush)
{
    // OSG_NOTICE<<"DatabasePager::compileGLObjects "<<_frameNumber<<std::endl;

    bool compileAll = (availableTime==DBL_MAX);

    SharedStateManager *sharedManager
        = Registry::instance()->getSharedStateManager();
    osg::RenderInfo renderInfo;
    renderInfo.setState(&state);

    if (availableTime>0.0)
    {

        const osg::Timer& timer = *osg::Timer::instance();
        osg::Timer_t start_tick = timer.tick();
        double elapsedTime = 0.0;
        double estimatedTextureDuration = 0.0001;
        double estimatedDrawableDuration = 0.0001;

        osg::ref_ptr<DatabaseRequest> databaseRequest;
        _dataToCompileList->takeFirst(databaseRequest);

        unsigned int numObjectsCompiled = 0;

        // while there are valid databaseRequest's in the to compile list and there is
        // sufficient time left compile each databaseRequest's stateset and drawables.
        while (databaseRequest.valid() && databaseRequest->valid() && (compileAll || (elapsedTime<availableTime && numObjectsCompiled<_maximumNumOfObjectsToCompilePerFrame)) )
        {
            DataToCompileMap& dcm = databaseRequest->_dataToCompileMap;
            DataToCompile& dtc = dcm[state.getContextID()];
            if (!dtc._textures.empty() && (elapsedTime+estimatedTextureDuration)<availableTime && numObjectsCompiled<_maximumNumOfObjectsToCompilePerFrame)
            {

                #if !defined(OSG_GLES1_AVAILABLE) && !defined(OSG_GLES2_AVAILABLE)  && !defined(OSG_GL3_AVAILABLE)
                    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_PRIORITY, 1.0);
                #endif

                //OSG_INFO<<"Compiling textures"<<std::endl;

                // we have Textures to compile
                typedef osgUtil::CompileData::Textures Textures;
                Textures& textures = dtc._textures;
                Textures::iterator itr=textures.begin();
                unsigned int objTemp = numObjectsCompiled;
                for(;
                    itr!=textures.end() && (compileAll || ((elapsedTime+estimatedTextureDuration)<availableTime && numObjectsCompiled<_maximumNumOfObjectsToCompilePerFrame));
                    ++itr)
                {
                    OSG_INFO<<"    Compiling texture "<<(*itr).get()<<std::endl;
                    if (isCompiled(itr->get(), state.getContextID())
                        || (sharedManager && sharedManager->isShared(itr->get())))
                    {
                        elapsedTime = timer.delta_s(start_tick,timer.tick());
                        continue;
                    }
                    double startCompileTime = timer.delta_s(start_tick,timer.tick());

                    (*itr)->apply(state);

                    #if !defined(OSG_GLES1_AVAILABLE) && !defined(OSG_GLES2_AVAILABLE) && !defined(OSG_GL3_AVAILABLE)
                        GLint p;
                        glGetTexParameteriv(GL_TEXTURE_2D, GL_TEXTURE_RESIDENT, &p);
                    #endif

                    elapsedTime = timer.delta_s(start_tick,timer.tick());

                    // estimate the duration of the compile based on current compile duration.
                    estimatedTextureDuration = (elapsedTime-startCompileTime);

                    ++numObjectsCompiled;
                }
                if (osg::getNotifyLevel() >= osg::DEBUG_INFO
                    && numObjectsCompiled > objTemp)
                    OSG_NOTICE<< _frameNumber << " compiled "
                                                << numObjectsCompiled - objTemp
                                                << " StateSets" << std::endl;
                // remove the compiled statesets from the list.
                textures.erase(textures.begin(),itr);
            }

            if (!dtc._drawables.empty() && (compileAll || ((elapsedTime+estimatedDrawableDuration)<availableTime && numObjectsCompiled<_maximumNumOfObjectsToCompilePerFrame)))
            {
                // we have Drawable's to compile
                //OSG_INFO<<"Compiling drawables"<<std::endl;
                typedef osgUtil::CompileData::Drawables Drawables;
                Drawables& dwlist = dtc._drawables;
                Drawables::iterator itr = dwlist.begin();
                unsigned int objTemp = numObjectsCompiled;
                for(;
                    itr!=dwlist.end() && (compileAll || ((elapsedTime+estimatedDrawableDuration)<availableTime && numObjectsCompiled<_maximumNumOfObjectsToCompilePerFrame));
                    ++itr)
                {
                    //OSG_INFO<<"    Compiling drawable "<<(*itr).get()<<std::endl;
                    if (isCompiled(itr->get(), state.getContextID()))
                    {
                        elapsedTime = timer.delta_s(start_tick,timer.tick());
                        continue;
                    }
                    double startCompileTime = timer.delta_s(start_tick,timer.tick());
                    (*itr)->compileGLObjects(renderInfo);
                    elapsedTime = timer.delta_s(start_tick,timer.tick());

                    // estimate the duration of the compile based on current compile duration.
                    estimatedDrawableDuration = (elapsedTime-startCompileTime);

                    ++numObjectsCompiled;

                }
                if (osg::getNotifyLevel() >= osg::DEBUG_INFO
                    && numObjectsCompiled > objTemp)
                {
                    OSG_INFO<< _frameNumber << " compiled "
                            << numObjectsCompiled - objTemp
                            << " Drawables" << std::endl;
                }
                // remove the compiled drawables from the list.
                dwlist.erase(dwlist.begin(),itr);
            }

            //OSG_INFO<<"Checking if compiled"<<std::endl;

            // now check the to compile entries for all active graphics contexts
            // to make sure that all have been compiled. They won't be
            // if we ran out of time or if another thread is still
            // compiling for its graphics context.
            bool allCompiled = true;
            for(DataToCompileMap::iterator itr=dcm.begin();
                itr!=dcm.end() && allCompiled;
                ++itr)
            {
                if (!(itr->second.empty())) allCompiled=false;
            }

            if (numObjectsCompiled > 0)
               OSG_NOTICE<< "Framenumber "<<_frameNumber << ": compiled " << numObjectsCompiled << " objects" << std::endl;
            
            if (allCompiled)
            {
                if (doFlush)
                {
                    glFlush();
                }

                // we've compiled all of the current databaseRequest so we can now pop it off the
                // to compile list and place it on the merge list.
                OSG_INFO<<"All compiled"<<std::endl;

                _dataToMergeList->add(databaseRequest.get());

                databaseRequest = 0;
                _dataToCompileList->takeFirst(databaseRequest);
            }
            else
            {
                OSG_INFO<<"Not all compiled"<<std::endl;
                _dataToCompileList->add(databaseRequest.get());
                databaseRequest = 0;
            }

            elapsedTime = timer.delta_s(start_tick,timer.tick());
        }

        availableTime -= elapsedTime;

        //OSG_NOTICE<<"elapsedTime="<<elapsedTime<<"\ttime remaining ="<<availableTime<<"\tnumObjectsCompiled = "<<numObjectsCompiled<<std::endl;
        //OSG_NOTICE<<"estimatedTextureDuration="<<estimatedTextureDuration;
        //OSG_NOTICE<<"\testimatedDrawableDuration="<<estimatedDrawableDuration<<std::endl;
    }
    else
    {
        availableTime = 0.0f;
    }
}

