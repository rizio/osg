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

#include <stdio.h>
#include <stdlib.h>

#include <osg/DeleteHandler>
#include <osg/io_utils>

#include <osgDB/Registry>
#include <osgDB/ReadFile>
#include <osgGA/TrackballManipulator>

#include <osgViewer/Viewer>
#include <osgViewer/Renderer>
#include <osgViewer/CompositeViewer>

#include <sstream>
#include <string.h>

using namespace osgViewer;


Viewer::Viewer()
{
    _viewerBase = this;

    constructorInit();
}

Viewer::Viewer(osg::ArgumentParser& arguments)
{
    _viewerBase = this;

    constructorInit();

    // Add help for command-line options read here
    arguments.getApplicationUsage()->addCommandLineOption("--SingleThreaded","Select SingleThreaded threading model for viewer.");
    arguments.getApplicationUsage()->addCommandLineOption("--CullDrawThreadPerContext","Select CullDrawThreadPerContext threading model for viewer.");
    arguments.getApplicationUsage()->addCommandLineOption("--DrawThreadPerContext","Select DrawThreadPerContext threading model for viewer.");
    arguments.getApplicationUsage()->addCommandLineOption("--CullThreadPerCameraDrawThreadPerContext","Select CullThreadPerCameraDrawThreadPerContext threading model for viewer.");
    arguments.getApplicationUsage()->addCommandLineOption("--clear-color <color>","Set the background color of the viewer in the form \"r,g,b[,a]\".");
    arguments.getApplicationUsage()->addCommandLineOption("--screen <num>","Set the screen to use when multiple screens are present.");
    arguments.getApplicationUsage()->addCommandLineOption("--window <x y w h>","Set the position (x,y) and size (w,h) of the viewer window.");

    arguments.getApplicationUsage()->addCommandLineOption("--run-on-demand","Set the run methods frame rate management to only rendering frames when required.");
    arguments.getApplicationUsage()->addCommandLineOption("--run-continuous","Set the run methods frame rate management to rendering frames continuously.");
    arguments.getApplicationUsage()->addCommandLineOption("--run-max-frame-rate","Set the run methods maximum permissable frame rate, 0.0 is default and switching off frame rate capping.");
    arguments.getApplicationUsage()->addCommandLineOption("--enable-object-cache","Enable caching of objects, images, etc.");

    // FIXME: Uncomment these lines when the options have been documented properly
    //arguments.getApplicationUsage()->addCommandLineOption("--3d-sd","");
    //arguments.getApplicationUsage()->addCommandLineOption("--panoramic-sd","");
    //arguments.getApplicationUsage()->addCommandLineOption("--radius","");
    //arguments.getApplicationUsage()->addCommandLineOption("--collar","");
    //arguments.getApplicationUsage()->addCommandLineOption("--im","");

    if (arguments.read("--ico"))
    {
        setIncrementalCompileOperation(new osgUtil::IncrementalCompileOperation());
    }

    std::string filename;
    bool readConfig = false;
    while (arguments.read("-c",filename))
    {
        readConfig = readConfiguration(filename) || readConfig;
    }

    // Enable caching?
    while (arguments.read("--enable-object-cache"))
    {
        if (osgDB::Registry::instance()->getOptions()==0) osgDB::Registry::instance()->setOptions(new osgDB::Options());
        osgDB::Registry::instance()->getOptions()->setObjectCacheHint(osgDB::Options::CACHE_ALL);
    }

    while (arguments.read("--SingleThreaded")) setThreadingModel(SingleThreaded);
    while (arguments.read("--CullDrawThreadPerContext")) setThreadingModel(CullDrawThreadPerContext);
    while (arguments.read("--DrawThreadPerContext")) setThreadingModel(DrawThreadPerContext);
    while (arguments.read("--CullThreadPerCameraDrawThreadPerContext")) setThreadingModel(CullThreadPerCameraDrawThreadPerContext);

    osg::DisplaySettings::instance()->readCommandLine(arguments);
    osgDB::readCommandLine(arguments);

    std::string colorStr;
    while (arguments.read("--clear-color",colorStr))
    {
        float r, g, b;
        float a = 1.0f;
        int cnt = sscanf( colorStr.c_str(), "%f,%f,%f,%f", &r, &g, &b, &a );
        if( cnt==3 || cnt==4 )
        {
            getCamera()->setClearColor( osg::Vec4(r,g,b,a) );
        }
        else
        {
            OSG_WARN<<"Invalid clear color \""<<colorStr<<"\""<<std::endl;
        }
    }


    while(arguments.read("--run-on-demand")) { setRunFrameScheme(ON_DEMAND); }
    while(arguments.read("--run-continuous")) { setRunFrameScheme(CONTINUOUS); }

    double runMaxFrameRate;
    while(arguments.read("--run-max-frame-rate", runMaxFrameRate)) { setRunMaxFrameRate(runMaxFrameRate); }


    int screenNum = -1;
    while (arguments.read("--screen",screenNum)) {}

    int x = -1, y = -1, width = -1, height = -1;
    while (arguments.read("--window",x,y,width,height)) {}

    bool ss3d = false;
    bool wowvx20 = false;
    bool wowvx42 = false;
    if ((wowvx20=arguments.read("--wowvx-20")) || (wowvx42=arguments.read("--wowvx-42")) || arguments.read("--wowvx"))
    {
        int wow_content=0x02, wow_factor=0x40, wow_offset=0x80;
        float wow_Zd, wow_vz, wow_M, wow_C;
        if (wowvx20){
            wow_Zd = 0.459813f;
            wow_vz = 6.180772f;
            wow_M = -1586.34f;
            wow_C = 127.5f;
        }
        else if (wowvx42){
            wow_Zd = 0.467481f;
            wow_vz = 7.655192f;
            wow_M = -1960.37f;
            wow_C = 127.5f;
        }

        while (arguments.read("--wow-content",wow_content)) {}
        while (arguments.read("--wow-factor",wow_factor)) {}
        while (arguments.read("--wow-offset",wow_offset)) {}
        while (arguments.read("--wow-zd",wow_Zd)) {}
        while (arguments.read("--wow-vz",wow_vz)) {}
        while (arguments.read("--wow-M",wow_M)) {}
        while (arguments.read("--wow-C",wow_C)) {}

        if (screenNum<0) screenNum = 0;

        setUpViewForWoWVxDisplay( screenNum, wow_content, wow_factor, wow_offset, wow_Zd, wow_vz, wow_M, wow_C );
    }
    else if ((ss3d=arguments.read("--3d-sd")) || arguments.read("--panoramic-sd"))
    {
        double radius = 1.0;
        while (arguments.read("--radius",radius)) {}

        double collar = 0.45;
        while (arguments.read("--collar",collar)) {}

        std::string intensityMapFilename;
        while (arguments.read("--im",intensityMapFilename)) {}

        osg::ref_ptr<osg::Image> intensityMap = intensityMapFilename.empty() ? 0 : osgDB::readImageFile(intensityMapFilename);

        if (screenNum<0) screenNum = 0;

        if (ss3d)
        {
            setThreadingModel(SingleThreaded);
            setUpViewFor3DSphericalDisplay(radius, collar, screenNum, intensityMap.get());
        }
        else
        {
            setThreadingModel(SingleThreaded);
            setUpViewForPanoramicSphericalDisplay(radius, collar, screenNum, intensityMap.get());
        }
    }
    else if (width>0 && height>0)
    {
        if (screenNum>=0) setUpViewInWindow(x, y, width, height, screenNum);
        else setUpViewInWindow(x,y,width,height);

    }
    else if (screenNum>=0)
    {
        setUpViewOnSingleScreen(screenNum);
    }

}

Viewer::Viewer(const osgViewer::Viewer& viewer, const osg::CopyOp& copyop):
    View(viewer,copyop)
{
    _viewerBase = this;
}

void Viewer::constructorInit()
{
    _eventVisitor = new osgGA::EventVisitor;
    _eventVisitor->setActionAdapter(this);
    _eventVisitor->setFrameStamp(_frameStamp.get());

    _updateVisitor = new osgUtil::UpdateVisitor;
    _updateVisitor->setFrameStamp(_frameStamp.get());

    setViewerStats(new osg::Stats("Viewer"));
}

Viewer::~Viewer()
{
    //OSG_NOTICE<<"Viewer::~Viewer()"<<std::endl;

    Threads threads;
    getAllThreads(threads);

    OSG_INFO<<"Viewer::~Viewer():: start destructor getThreads = "<<threads.size()<<std::endl;

    stopThreading();

    if (_scene.valid() && _scene->getDatabasePager())
    {
        _scene->getDatabasePager()->cancel();
        _scene->setDatabasePager(0);
    }

    Contexts contexts;
    getContexts(contexts);

    // clear out all the previously assigned operations
    for(Contexts::iterator citr = contexts.begin();
        citr != contexts.end();
        ++citr)
    {
        (*citr)->close();
    }

    //OSG_NOTICE<<"finish Viewer::~Viewer()"<<std::endl;

    getAllThreads(threads);

    OSG_INFO<<"Viewer::~Viewer() end destructor getThreads = "<<threads.size()<<std::endl;
}

void Viewer::take(View& rhs)
{
    osgViewer::View::take(rhs);

#if 1
    osgViewer::Viewer* rhs_viewer = dynamic_cast<osgViewer::Viewer*>(&rhs);
    if (rhs_viewer)
    {
        // variables left to take.
        _done = rhs_viewer->_done;
        _keyEventSetsDone = rhs_viewer->_keyEventSetsDone;
        _quitEventSetsDone = rhs_viewer->_quitEventSetsDone;
        _threadingModel = rhs_viewer->_threadingModel;
        _threadsRunning = rhs_viewer->_threadsRunning;
        _endBarrierPosition = rhs_viewer->_endBarrierPosition;
        _startRenderingBarrier = rhs_viewer->_startRenderingBarrier;
        _endRenderingDispatchBarrier = rhs_viewer->_endRenderingDispatchBarrier;
        _endDynamicDrawBlock = rhs_viewer->_endDynamicDrawBlock;
        _cameraWithFocus = rhs_viewer->_cameraWithFocus;
        _eventVisitor = rhs_viewer->_eventVisitor;
        _updateOperations = rhs_viewer->_updateOperations;
        _updateVisitor = rhs_viewer->_updateVisitor;
        _realizeOperation = rhs_viewer->_realizeOperation;
        _currentContext = rhs_viewer->_currentContext;


        // objects to clear
        rhs_viewer->_done = true;
        rhs_viewer->_startRenderingBarrier = 0;
        rhs_viewer->_endRenderingDispatchBarrier = 0;
        rhs_viewer->_endDynamicDrawBlock = 0;
        rhs_viewer->_cameraWithFocus = 0;
        rhs_viewer->_eventVisitor = 0;
        rhs_viewer->_updateOperations = 0;
        rhs_viewer->_updateVisitor = 0;
        rhs_viewer->_realizeOperation = 0;
        rhs_viewer->_currentContext = 0;
    }
#endif
}

bool Viewer::readConfiguration(const std::string& filename)
{
    OSG_INFO<<"Viewer::readConfiguration("<<filename<<")"<<std::endl;

    osg::ref_ptr<osg::Object> object = osgDB::readObjectFile(filename);
    if (!object)
    {
        //OSG_NOTICE<<"Error: Unable to load configuration file \""<<filename<<"\""<<std::endl;
        return false;
    }

    CompositeViewer* compositeViewer = dynamic_cast<CompositeViewer*>(object.get());
    if (compositeViewer)
    {
        OSG_NOTICE<<"Error: Config file \""<<filename<<"\" containing CompositeViewer cannot be loaded by Viewer."<<std::endl;
        return false;
    }

    View* view = dynamic_cast<osgViewer::View*>(object.get());
    if (view)
    {
        take(*view);

        return true;
    }
    else
    {
        OSG_NOTICE<<"Error: Config file \""<<filename<<"\" does not contain a valid Viewer configuration."<<std::endl;
        return false;
    }
}

bool Viewer::isRealized() const
{
    Contexts contexts;
    const_cast<Viewer*>(this)->getContexts(contexts);

    unsigned int numRealizedWindows = 0;

    // clear out all the previously assigned operations
    for(Contexts::iterator citr = contexts.begin();
        citr != contexts.end();
        ++citr)
    {
        if ((*citr)->isRealized()) ++numRealizedWindows;
    }

    return numRealizedWindows > 0;
}

bool Viewer::checkNeedToDoFrame()
{
    if (_requestRedraw) return true;
    if (_requestContinousUpdate) return true;


    // If the database pager is going to update the scene the render flag is
    // set so that the updates show up
    if(getDatabasePager()->requiresUpdateSceneGraph() || getDatabasePager()->getRequestsInProgress()) return true;

    // if there update callbacks then we need to do frame.
    if (_camera->getUpdateCallback()) return true;
    if (getSceneData()!=0 && getSceneData()->getNumChildrenRequiringUpdateTraversal()>0) return true;

    // now do a eventTraversal to see if any events might require a new frame.
    eventTraversal();

    // now check if any of the event handles have prompted a redraw.
    if (_requestRedraw) return true;
    if (_requestContinousUpdate) return true;

    return false;
}

int Viewer::run()
{
    if (!getCameraManipulator() && getCamera()->getAllowEventFocus())
    {
        setCameraManipulator(new osgGA::TrackballManipulator());
    }

    setReleaseContextAtEndOfFrameHint(false);

    return ViewerBase::run();
}

void Viewer::setStartTick(osg::Timer_t tick)
{
    View::setStartTick(tick);

    Contexts contexts;
    getContexts(contexts,false);

    getEventQueue()->setStartTick(_startTick);
    for(Contexts::iterator citr = contexts.begin();
        citr != contexts.end();
        ++citr)
    {
        osgViewer::GraphicsWindow* gw = dynamic_cast<osgViewer::GraphicsWindow*>(*citr);
        if (gw)
        {
            gw->getEventQueue()->setStartTick(_startTick);
        }
    }
}

void Viewer::setReferenceTime(double time)
{
    osg::Timer_t tick = osg::Timer::instance()->tick();
    double currentTime = osg::Timer::instance()->delta_s(_startTick, tick);
    double delta_ticks = (time-currentTime)*(osg::Timer::instance()->getSecondsPerTick());
    if (delta_ticks>=0) tick += osg::Timer_t(delta_ticks);
    else tick -= osg::Timer_t(-delta_ticks);

    // assign the new start tick
    setStartTick(tick);
}


void Viewer::setSceneData(osg::Node* node)
{
    setReferenceTime(0.0);

    View::setSceneData(node);
}

GraphicsWindowEmbedded* Viewer::setUpViewerAsEmbeddedInWindow(int x, int y, int width, int height)
{
    setThreadingModel(SingleThreaded);
    osgViewer::GraphicsWindowEmbedded* gw = new osgViewer::GraphicsWindowEmbedded(x,y,width,height);
    getCamera()->setViewport(new osg::Viewport(0,0,width,height));
    getCamera()->setProjectionMatrixAsPerspective(30.0f, static_cast<double>(width)/static_cast<double>(height), 1.0f, 10000.0f);
    getCamera()->setGraphicsContext(gw);
    return gw;
}

void Viewer::realize()
{
    //OSG_INFO<<"Viewer::realize()"<<std::endl;

    setCameraWithFocus(0);

    Contexts contexts;
    getContexts(contexts);

    if (contexts.empty())
    {
        OSG_INFO<<"Viewer::realize() - No valid contexts found, setting up view across all screens."<<std::endl;

        // no windows are already set up so set up a default view

        const char* ptr = 0;
        if ((ptr = getenv("OSG_CONFIG_FILE")) != 0)
        {
            readConfiguration(ptr);
        }
        else
        {
            int screenNum = -1;
            if ((ptr = getenv("OSG_SCREEN")) != 0)
            {
                if (strlen(ptr)!=0) screenNum = atoi(ptr);
                else screenNum = -1;
            }

            int x = -1, y = -1, width = -1, height = -1;
            if ((ptr = getenv("OSG_WINDOW")) != 0)
            {
                std::istringstream iss(ptr);
                iss >> x >> y >> width >> height;
            }

            if (width>0 && height>0)
            {
                if (screenNum>=0) setUpViewInWindow(x, y, width, height, screenNum);
                else setUpViewInWindow(x,y,width,height);
            }
            else if (screenNum>=0)
            {
                setUpViewOnSingleScreen(screenNum);
            }
            else
            {
                setUpViewAcrossAllScreens();
            }
        }

        getContexts(contexts);
    }

    if (contexts.empty())
    {
        OSG_NOTICE<<"Viewer::realize() - failed to set up any windows"<<std::endl;
        _done = true;
        return;
    }

    unsigned int maxTexturePoolSize = osg::DisplaySettings::instance()->getMaxTexturePoolSize();
    if (_camera->getDisplaySettings()) maxTexturePoolSize = std::max(maxTexturePoolSize, _camera->getDisplaySettings()->getMaxTexturePoolSize());
    if (_displaySettings.valid()) maxTexturePoolSize = std::max(maxTexturePoolSize, _displaySettings->getMaxTexturePoolSize());

    unsigned int maxBufferObjectPoolSize = osg::DisplaySettings::instance()->getMaxBufferObjectPoolSize();
    if (_displaySettings.valid()) maxBufferObjectPoolSize = std::max(maxBufferObjectPoolSize, _displaySettings->getMaxBufferObjectPoolSize());
    if (_camera->getDisplaySettings()) maxBufferObjectPoolSize = std::max(maxBufferObjectPoolSize, _camera->getDisplaySettings()->getMaxBufferObjectPoolSize());

    for(Contexts::iterator citr = contexts.begin();
        citr != contexts.end();
        ++citr)
    {
        osg::GraphicsContext* gc = *citr;

        // set the pool sizes, 0 the default will result in no GL object pools.
        gc->getState()->setMaxTexturePoolSize(maxTexturePoolSize);
        gc->getState()->setMaxBufferObjectPoolSize(maxBufferObjectPoolSize);

        gc->realize();

        if (_realizeOperation.valid() && gc->valid())
        {
            gc->makeCurrent();

            (*_realizeOperation)(gc);

            gc->releaseContext();
        }
    }

    // attach contexts to _incrementalCompileOperation if attached.
    if (_incrementalCompileOperation) _incrementalCompileOperation->assignContexts(contexts);

    bool grabFocus = true;
    if (grabFocus)
    {
        for(Contexts::iterator citr = contexts.begin();
            citr != contexts.end();
            ++citr)
        {
            osgViewer::GraphicsWindow* gw = dynamic_cast<osgViewer::GraphicsWindow*>(*citr);
            if (gw)
            {
                gw->grabFocusIfPointerInWindow();
            }
        }
    }

    // initialize the global timer to be relative to the current time.
    osg::Timer::instance()->setStartTick();

    // pass on the start tick to all the associated event queues
    setStartTick(osg::Timer::instance()->getStartTick());

    setUpThreading();

    if (osg::DisplaySettings::instance()->getCompileContextsHint())
    {
        int numProcessors = OpenThreads::GetNumberOfProcessors();
        int processNum = 0;

        for(unsigned int i=0; i<= osg::GraphicsContext::getMaxContextID(); ++i)
        {
            osg::GraphicsContext* gc = osg::GraphicsContext::getOrCreateCompileContext(i);

            if (gc)
            {
                gc->createGraphicsThread();
                gc->getGraphicsThread()->setProcessorAffinity(processNum % numProcessors);
                gc->getGraphicsThread()->startThread();

                ++processNum;
            }
        }
    }

}



void Viewer::advance(double simulationTime)
{
    if (_done) return;

    double prevousReferenceTime = _frameStamp->getReferenceTime();
    int previousFrameNumber = _frameStamp->getFrameNumber();

    _frameStamp->setFrameNumber(_frameStamp->getFrameNumber()+1);

    _frameStamp->setReferenceTime( osg::Timer::instance()->delta_s(_startTick, osg::Timer::instance()->tick()) );

    if (simulationTime==USE_REFERENCE_TIME)
    {
        _frameStamp->setSimulationTime(_frameStamp->getReferenceTime());
    }
    else
    {
        _frameStamp->setSimulationTime(simulationTime);
    }

    if (getViewerStats() && getViewerStats()->collectStats("frame_rate"))
    {
        // update previous frame stats
        double deltaFrameTime = _frameStamp->getReferenceTime() - prevousReferenceTime;
        getViewerStats()->setAttribute(previousFrameNumber, "Frame duration", deltaFrameTime);
        getViewerStats()->setAttribute(previousFrameNumber, "Frame rate", 1.0/deltaFrameTime);

        // update current frames stats
        getViewerStats()->setAttribute(_frameStamp->getFrameNumber(), "Reference time", _frameStamp->getReferenceTime());
    }

    if (osg::Referenced::getDeleteHandler())
    {
        osg::Referenced::getDeleteHandler()->flush();
        osg::Referenced::getDeleteHandler()->setFrameNumber(_frameStamp->getFrameNumber());
    }

}

void Viewer::eventTraversal()
{
    if (_done) return;

    double beginEventTraversal = osg::Timer::instance()->delta_s(_startTick, osg::Timer::instance()->tick());

    // OSG_NOTICE<<"Viewer::frameEventTraversal()."<<std::endl;

    // need to copy events from the GraphicsWindow's into local EventQueue;
    osgGA::EventQueue::Events events;

    Contexts contexts;
    getContexts(contexts);

    osgGA::GUIEventAdapter* eventState = getEventQueue()->getCurrentEventState();
    osg::Matrix masterCameraVPW = getCamera()->getViewMatrix() * getCamera()->getProjectionMatrix();
    if (getCamera()->getViewport())
    {
        osg::Viewport* viewport = getCamera()->getViewport();
        masterCameraVPW *= viewport->computeWindowMatrix();
        eventState->setInputRange( viewport->x(), viewport->y(), viewport->x() + viewport->width(), viewport->y() + viewport->height());
    }
    else
    {
        eventState->setInputRange(-1.0, -1.0, 1.0, 1.0);
    }


    for(Contexts::iterator citr = contexts.begin();
        citr != contexts.end();
        ++citr)
    {
        osgViewer::GraphicsWindow* gw = dynamic_cast<osgViewer::GraphicsWindow*>(*citr);
        if (gw)
        {
            gw->checkEvents();

            osgGA::EventQueue::Events gw_events;
            gw->getEventQueue()->takeEvents(gw_events);

            osgGA::EventQueue::Events::iterator itr;
            for(itr = gw_events.begin();
                itr != gw_events.end();
                ++itr)
            {
                osgGA::GUIEventAdapter* event = itr->get();

                bool pointerEvent = false;

                float x = event->getX();
                float y = event->getY();

                bool invert_y = event->getMouseYOrientation()==osgGA::GUIEventAdapter::Y_INCREASING_DOWNWARDS;
                if (invert_y && gw->getTraits()) y = gw->getTraits()->height - y;

                switch(event->getEventType())
                {
                    case(osgGA::GUIEventAdapter::PUSH):
                    case(osgGA::GUIEventAdapter::RELEASE):
                    case(osgGA::GUIEventAdapter::DOUBLECLICK):
                    case(osgGA::GUIEventAdapter::DRAG):
                    case(osgGA::GUIEventAdapter::MOVE):
                    {
                        pointerEvent = true;

                        if (event->getEventType()!=osgGA::GUIEventAdapter::DRAG || !getCameraWithFocus())
                        {
                            osg::GraphicsContext::Cameras& cameras = gw->getCameras();
                            for(osg::GraphicsContext::Cameras::iterator citr = cameras.begin();
                                citr != cameras.end();
                                ++citr)
                            {
                                osg::Camera* camera = *citr;
                                if (camera->getView()==this &&
                                    camera->getAllowEventFocus() &&
                                    camera->getRenderTargetImplementation()==osg::Camera::FRAME_BUFFER)
                                {
                                    osg::Viewport* viewport = camera ? camera->getViewport() : 0;
                                    if (viewport &&
                                        x >= viewport->x() && y >= viewport->y() &&
                                        x <= (viewport->x()+viewport->width()) && y <= (viewport->y()+viewport->height()) )
                                    {
                                        // OSG_NOTICE<<"setCamera with focus "<<camera->getName()<<" x="<<x<<" y="<<y<<std::endl;
                                        setCameraWithFocus(camera);
                                    }
                                }
                            }
                        }

                        break;
                    }
                    default:
                        break;
                }

                if (pointerEvent)
                {
                    if (getCameraWithFocus())
                    {
                        if (getCameraWithFocus()!=getCamera())
                        {
                            osg::Viewport* viewport = getCameraWithFocus()->getViewport();
                            osg::Matrix localCameraVPW = getCameraWithFocus()->getViewMatrix() * getCameraWithFocus()->getProjectionMatrix();
                            if (viewport) localCameraVPW *= viewport->computeWindowMatrix();

                            osg::Matrix matrix( osg::Matrix::inverse(localCameraVPW) * masterCameraVPW );

                            osg::Vec3d new_coord = osg::Vec3d(x,y,0.0) * matrix;

                            x = new_coord.x();
                            y = new_coord.y();
                        }

                        // OSG_NOTICE<<"pointer event new_coord.x()="<<new_coord.x()<<" new_coord.y()="<<new_coord.y()<<std::endl;

                        event->setInputRange(eventState->getXmin(), eventState->getYmin(), eventState->getXmax(), eventState->getYmax());
                        event->setX(x);
                        event->setY(y);
                        event->setMouseYOrientation(osgGA::GUIEventAdapter::Y_INCREASING_UPWARDS);

                    }
                    else
                    {
                        x = eventState->getXmin() + (x/double(gw->getTraits()->width))*(eventState->getXmax() - eventState->getXmin());
                        y = eventState->getYmin() + (y/double(gw->getTraits()->height))*(eventState->getYmax() - eventState->getYmin());
                        // OSG_NOTICE<<"new x = "<<x<<" new y = "<<y<<std::endl;

                        event->setInputRange(eventState->getXmin(), eventState->getYmin(), eventState->getXmax(), eventState->getYmax());
                        event->setX(x);
                        event->setY(y);
                        event->setMouseYOrientation(osgGA::GUIEventAdapter::Y_INCREASING_UPWARDS);
                    }

                    // pass along the new pointer events details to the eventState of the viewer
                    eventState->setX(x);
                    eventState->setY(y);
                    eventState->setButtonMask(event->getButtonMask());
                    eventState->setMouseYOrientation(osgGA::GUIEventAdapter::Y_INCREASING_UPWARDS);

                }
                else
                {
                    event->setInputRange(eventState->getXmin(), eventState->getYmin(), eventState->getXmax(), eventState->getYmax());
                    event->setX(eventState->getX());
                    event->setY(eventState->getY());
                    event->setButtonMask(eventState->getButtonMask());
                    event->setMouseYOrientation(eventState->getMouseYOrientation());
                }
                //OSG_NOTICE<<"   mouse x = "<<event->getX()<<" y="<<event->getY()<<std::endl;
                // OSG_NOTICE<<"   mouse Xmin = "<<event->getXmin()<<" Ymin="<<event->getYmin()<<" xMax="<<event->getXmax()<<" Ymax="<<event->getYmax()<<std::endl;
            }

            for(itr = gw_events.begin();
                itr != gw_events.end();
                ++itr)
            {
                osgGA::GUIEventAdapter* event = itr->get();
                switch(event->getEventType())
                {
                    case(osgGA::GUIEventAdapter::CLOSE_WINDOW):
                    {
                        bool wasThreading = areThreadsRunning();
                        if (wasThreading) stopThreading();

                        gw->close();
                        _currentContext = NULL;

                        if (wasThreading) startThreading();

                        break;
                    }
                    default:
                        break;
                }
            }

            events.insert(events.end(), gw_events.begin(), gw_events.end());

        }
    }


    // OSG_NOTICE<<"mouseEventState Xmin = "<<eventState->getXmin()<<" Ymin="<<eventState->getYmin()<<" xMax="<<eventState->getXmax()<<" Ymax="<<eventState->getYmax()<<std::endl;


    _eventQueue->frame( getFrameStamp()->getReferenceTime() );
    _eventQueue->takeEvents(events);


#if 0
    // OSG_NOTICE<<"Events "<<events.size()<<std::endl;
    for(osgGA::EventQueue::Events::iterator itr = events.begin();
        itr != events.end();
        ++itr)
    {
        osgGA::GUIEventAdapter* event = itr->get();
        switch(event->getEventType())
        {
            case(osgGA::GUIEventAdapter::PUSH):
                OSG_NOTICE<<"  PUSH "<<event->getButton()<<" x="<<event->getX()<<" y="<<event->getY()<<std::endl;
                break;
            case(osgGA::GUIEventAdapter::RELEASE):
                OSG_NOTICE<<"  RELEASE "<<event->getButton()<<" x="<<event->getX()<<" y="<<event->getY()<<std::endl;
                break;
            case(osgGA::GUIEventAdapter::DRAG):
                OSG_NOTICE<<"  DRAG "<<event->getButtonMask()<<" x="<<event->getX()<<" y="<<event->getY()<<std::endl;
                break;
            case(osgGA::GUIEventAdapter::MOVE):
                OSG_NOTICE<<"  MOVE "<<event->getButtonMask()<<" x="<<event->getX()<<" y="<<event->getY()<<std::endl;
                break;
            case(osgGA::GUIEventAdapter::SCROLL):
                OSG_NOTICE<<"  SCROLL "<<event->getScrollingMotion()<<std::endl;
                break;
            case(osgGA::GUIEventAdapter::KEYDOWN):
                OSG_NOTICE<<"  KEYDOWN '"<<(char)event->getKey()<<"'"<<std::endl;
                break;
            case(osgGA::GUIEventAdapter::KEYUP):
                OSG_NOTICE<<"  KEYUP '"<<(char)event->getKey()<<"'"<<std::endl;
                break;
            case(osgGA::GUIEventAdapter::RESIZE):
                OSG_NOTICE<<"  RESIZE "<<event->getWindowX()<<"/"<<event->getWindowY()<<" x "<<event->getWindowWidth()<<"/"<<event->getWindowHeight() << std::endl;
                break;
            case(osgGA::GUIEventAdapter::QUIT_APPLICATION):
                OSG_NOTICE<<"  QUIT_APPLICATION " << std::endl;
                break;
            case(osgGA::GUIEventAdapter::FRAME):
                // OSG_NOTICE<<"  FRAME "<<std::endl;
                break;
            default:
                // OSG_NOTICE<<"  Event not handled"<<std::endl;
                break;
        }
    }
#endif

    // OSG_NOTICE<<"Events "<<events.size()<<std::endl;

    if ((_keyEventSetsDone!=0) || _quitEventSetsDone)
    {
        for(osgGA::EventQueue::Events::iterator itr = events.begin();
            itr != events.end();
            ++itr)
        {
            osgGA::GUIEventAdapter* event = itr->get();
            switch(event->getEventType())
            {
                case(osgGA::GUIEventAdapter::KEYUP):
                    if (_keyEventSetsDone && event->getKey()==_keyEventSetsDone) _done = true;
                    break;

                case(osgGA::GUIEventAdapter::QUIT_APPLICATION):
                    if (_quitEventSetsDone) _done = true;
                    break;

                default:
                    break;
            }
        }
    }

    if (_done) return;

    if (_eventVisitor.valid() && getSceneData())
    {
        _eventVisitor->setFrameStamp(getFrameStamp());
        _eventVisitor->setTraversalNumber(getFrameStamp()->getFrameNumber());

        for(osgGA::EventQueue::Events::iterator itr = events.begin();
            itr != events.end();
            ++itr)
        {
            osgGA::GUIEventAdapter* event = itr->get();

            _eventVisitor->reset();
            _eventVisitor->addEvent( event );

            getSceneData()->accept(*_eventVisitor);

            // Do EventTraversal for slaves with their own subgraph
            for(unsigned int i=0; i<getNumSlaves(); ++i)
            {
                osg::View::Slave& slave = getSlave(i);
                osg::Camera* camera = slave._camera.get();
                if(camera && !slave._useMastersSceneData)
                {
                    camera->accept(*_eventVisitor);
                }
            }


            // call any camera event callbacks, but only traverse that callback, don't traverse its subgraph
            // leave that to the scene update traversal.
            osg::NodeVisitor::TraversalMode tm = _eventVisitor->getTraversalMode();
            _eventVisitor->setTraversalMode(osg::NodeVisitor::TRAVERSE_NONE);

            if (_camera.valid() && _camera->getEventCallback()) _camera->accept(*_eventVisitor);

            for(unsigned int i=0; i<getNumSlaves(); ++i)
            {
                osg::View::Slave& slave = getSlave(i);
                osg::Camera* camera = slave._camera.get();
                if (camera && slave._useMastersSceneData && camera->getEventCallback())
                {
                    camera->accept(*_eventVisitor);
                }
            }

            _eventVisitor->setTraversalMode(tm);

        }
    }


    for(osgGA::EventQueue::Events::iterator itr = events.begin();
        itr != events.end();
        ++itr)
    {
        osgGA::GUIEventAdapter* event = itr->get();

        for(EventHandlers::iterator hitr = _eventHandlers.begin();
            hitr != _eventHandlers.end();
            ++hitr)
        {
            (*hitr)->handleWithCheckAgainstIgnoreHandledEventsMask( *event, *this, 0, 0);
        }

    }

    for(osgGA::EventQueue::Events::iterator itr = events.begin();
        itr != events.end();
        ++itr)
    {
        osgGA::GUIEventAdapter* event = itr->get();
        if (_cameraManipulator.valid())
        {
            _cameraManipulator->handleWithCheckAgainstIgnoreHandledEventsMask( *event, *this);
        }
    }

    if (getViewerStats() && getViewerStats()->collectStats("event"))
    {
        double endEventTraversal = osg::Timer::instance()->delta_s(_startTick, osg::Timer::instance()->tick());

        // update current frames stats
        getViewerStats()->setAttribute(_frameStamp->getFrameNumber(), "Event traversal begin time", beginEventTraversal);
        getViewerStats()->setAttribute(_frameStamp->getFrameNumber(), "Event traversal end time", endEventTraversal);
        getViewerStats()->setAttribute(_frameStamp->getFrameNumber(), "Event traversal time taken", endEventTraversal-beginEventTraversal);
    }

}

void Viewer::updateTraversal()
{
    if (_done) return;

    double beginUpdateTraversal = osg::Timer::instance()->delta_s(_startTick, osg::Timer::instance()->tick());

    _updateVisitor->reset();
    _updateVisitor->setFrameStamp(getFrameStamp());
    _updateVisitor->setTraversalNumber(getFrameStamp()->getFrameNumber());

    _scene->updateSceneGraph(*_updateVisitor);

    // if we have a shared state manager prune any unused entries
    if (osgDB::Registry::instance()->getSharedStateManager())
        osgDB::Registry::instance()->getSharedStateManager()->prune();

    // update the Registry object cache.
    osgDB::Registry::instance()->updateTimeStampOfObjectsInCacheWithExternalReferences(*getFrameStamp());
    osgDB::Registry::instance()->removeExpiredObjectsInCache(*getFrameStamp());


    if (_updateOperations.valid())
    {
        _updateOperations->runOperations(this);
    }

    if (_incrementalCompileOperation.valid())
    {
        // merge subgraphs that have been compiled by the incremental compiler operation.
        _incrementalCompileOperation->mergeCompiledSubgraphs();
    }

    {
        // Do UpdateTraversal for slaves with their own subgraph
        for(unsigned int i=0; i<getNumSlaves(); ++i)
        {
            osg::View::Slave& slave = getSlave(i);
            osg::Camera* camera = slave._camera.get();
            if(camera && !slave._useMastersSceneData)
            {
                camera->accept(*_updateVisitor);
            }
        }
    }

    {
        // call any camera update callbacks, but only traverse that callback, don't traverse its subgraph
        // leave that to the scene update traversal.
        osg::NodeVisitor::TraversalMode tm = _updateVisitor->getTraversalMode();
        _updateVisitor->setTraversalMode(osg::NodeVisitor::TRAVERSE_NONE);

        if (_camera.valid() && _camera->getUpdateCallback()) _camera->accept(*_updateVisitor);

        for(unsigned int i=0; i<getNumSlaves(); ++i)
        {
            osg::View::Slave& slave = getSlave(i);
            osg::Camera* camera = slave._camera.get();
            if (camera && slave._useMastersSceneData && camera->getUpdateCallback())
            {
                camera->accept(*_updateVisitor);
            }
        }

        _updateVisitor->setTraversalMode(tm);
    }

    if (_cameraManipulator.valid())
    {
        setFusionDistance( getCameraManipulator()->getFusionDistanceMode(),
                            getCameraManipulator()->getFusionDistanceValue() );

        _camera->setViewMatrix(_cameraManipulator->getInverseMatrix());
    }

    updateSlaves();

    if (getViewerStats() && getViewerStats()->collectStats("update"))
    {
        double endUpdateTraversal = osg::Timer::instance()->delta_s(_startTick, osg::Timer::instance()->tick());

        // update current frames stats
        getViewerStats()->setAttribute(_frameStamp->getFrameNumber(), "Update traversal begin time", beginUpdateTraversal);
        getViewerStats()->setAttribute(_frameStamp->getFrameNumber(), "Update traversal end time", endUpdateTraversal);
        getViewerStats()->setAttribute(_frameStamp->getFrameNumber(), "Update traversal time taken", endUpdateTraversal-beginUpdateTraversal);
    }
}

void Viewer::getScenes(Scenes& scenes, bool onlyValid)
{
    scenes.clear();
    scenes.push_back(_scene.get());
}

void Viewer::getViews(Views& views, bool onlyValid)
{
    views.clear();
    views.push_back(this);
}

void Viewer::getAllThreads(Threads& threads, bool onlyActive)
{
    threads.clear();

    OperationThreads operationThreads;
    getOperationThreads(operationThreads);

    for(OperationThreads::iterator itr = operationThreads.begin();
        itr != operationThreads.end();
        ++itr)
    {
        threads.push_back(*itr);
    }


    if (_scene.valid())
    {
        osgDB::DatabasePager* dp = _scene->getDatabasePager();
        if (dp)
        {
            for(unsigned int i=0; i<dp->getNumDatabaseThreads(); ++i)
            {
                osgDB::DatabasePager::DatabaseThread* dt = dp->getDatabaseThread(i);
                if (!onlyActive || dt->isRunning())
                {
                    threads.push_back(dt);
                }
            }
        }
    }
}


void Viewer::getOperationThreads(OperationThreads& threads, bool onlyActive)
{
    threads.clear();

    Contexts contexts;
    getContexts(contexts);
    for(Contexts::iterator gcitr = contexts.begin();
        gcitr != contexts.end();
        ++gcitr)
    {
        osg::GraphicsContext* gc = *gcitr;
        if (gc->getGraphicsThread() &&
            (!onlyActive || gc->getGraphicsThread()->isRunning()) )
        {
            threads.push_back(gc->getGraphicsThread());
        }
    }

    Cameras cameras;
    getCameras(cameras);
    for(Cameras::iterator citr = cameras.begin();
        citr != cameras.end();
        ++citr)
    {
        osg::Camera* camera = *citr;
        if (camera->getCameraThread() &&
            (!onlyActive || camera->getCameraThread()->isRunning()) )
        {
            threads.push_back(camera->getCameraThread());
        }
    }

}

void Viewer::getContexts(Contexts& contexts, bool onlyValid)
{
    typedef std::set<osg::GraphicsContext*> ContextSet;
    ContextSet contextSet;

    contexts.clear();

    if (_camera.valid() &&
        _camera->getGraphicsContext() &&
        (_camera->getGraphicsContext()->valid() || !onlyValid))
    {
        contextSet.insert(_camera->getGraphicsContext());
        contexts.push_back(_camera->getGraphicsContext());
    }

    for(unsigned int i=0; i<getNumSlaves(); ++i)
    {
        Slave& slave = getSlave(i);
        osg::GraphicsContext* sgc = slave._camera.valid() ? slave._camera->getGraphicsContext() : 0;
        if (sgc && (sgc->valid() || !onlyValid))
        {
            if (contextSet.count(sgc)==0)
            {
                contextSet.insert(sgc);
                contexts.push_back(sgc);
            }
        }
    }
}

void Viewer::getCameras(Cameras& cameras, bool onlyActive)
{
    cameras.clear();

    if (_camera.valid() &&
        (!onlyActive || (_camera->getGraphicsContext() && _camera->getGraphicsContext()->valid())) ) cameras.push_back(_camera.get());

    for(Slaves::iterator itr = _slaves.begin();
        itr != _slaves.end();
        ++itr)
    {
        if (itr->_camera.valid() &&
            (!onlyActive || (itr->_camera->getGraphicsContext() && itr->_camera->getGraphicsContext()->valid())) ) cameras.push_back(itr->_camera.get());
    }
}


double Viewer::elapsedTime()
{
    return osg::Timer::instance()->delta_s(_startTick, osg::Timer::instance()->tick());
}


void Viewer::getUsage(osg::ApplicationUsage& usage) const
{
    if (_cameraManipulator.valid())
    {
        _cameraManipulator->getUsage(usage);
    }

    for(EventHandlers::const_iterator hitr = _eventHandlers.begin();
        hitr != _eventHandlers.end();
        ++hitr)
    {
        (*hitr)->getUsage(usage);
    }
}

