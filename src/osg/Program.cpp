/* -*-c++-*- OpenSceneGraph - Copyright (C) 1998-2006 Robert Osfield 
 * Copyright (C) 2003-2005 3Dlabs Inc. Ltd.
 * Copyright (C) 2004-2005 Nathan Cournia
 * Copyright (C) 2008 Zebra Imaging
 * Copyright (C) 2010 VIRES Simulationstechnologie GmbH
 *
 * This application is open source and may be redistributed and/or modified   
 * freely and without restriction, both in commercial and non commercial
 * applications, as long as this copyright notice is maintained.
 * 
 * This application is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
*/

/* file:        src/osg/Program.cpp
 * author:      Mike Weiblen 2008-01-19
 *              Holger Helmich 2010-10-21
*/

#include <list>

#include <osg/Notify>
#include <osg/State>
#include <osg/Timer>
#include <osg/buffered_value>
#include <osg/ref_ptr>
#include <osg/Program>
#include <osg/Shader>
#include <osg/GL2Extensions>

#include <OpenThreads/ScopedLock>
#include <OpenThreads/Mutex>

using namespace osg;

///////////////////////////////////////////////////////////////////////////
// static cache of glPrograms flagged for deletion, which will actually
// be deleted in the correct GL context.

typedef std::list<GLuint> GlProgramHandleList;
typedef osg::buffered_object<GlProgramHandleList> DeletedGlProgramCache;

static OpenThreads::Mutex    s_mutex_deletedGlProgramCache;
static DeletedGlProgramCache s_deletedGlProgramCache;

void Program::deleteGlProgram(unsigned int contextID, GLuint program)
{
    if( program )
    {
        OpenThreads::ScopedLock<OpenThreads::Mutex> lock(s_mutex_deletedGlProgramCache);

        // add glProgram to the cache for the appropriate context.
        s_deletedGlProgramCache[contextID].push_back(program);
    }
}

void Program::flushDeletedGlPrograms(unsigned int contextID,double /*currentTime*/, double& availableTime)
{
    // if no time available don't try to flush objects.
    if (availableTime<=0.0) return;

    OpenThreads::ScopedLock<OpenThreads::Mutex> lock(s_mutex_deletedGlProgramCache);
    const GL2Extensions* extensions = GL2Extensions::Get(contextID,true);
    if( ! extensions->isGlslSupported() ) return;

    const osg::Timer& timer = *osg::Timer::instance();
    osg::Timer_t start_tick = timer.tick();
    double elapsedTime = 0.0;

    {

        GlProgramHandleList& pList = s_deletedGlProgramCache[contextID];
        for(GlProgramHandleList::iterator titr=pList.begin();
            titr!=pList.end() && elapsedTime<availableTime;
            )
        {
            extensions->glDeleteProgram( *titr );
            titr = pList.erase( titr );
            elapsedTime = timer.delta_s(start_tick,timer.tick());
        }
    }

    availableTime -= elapsedTime;
}

void Program::discardDeletedGlPrograms(unsigned int contextID)
{
    OpenThreads::ScopedLock<OpenThreads::Mutex> lock(s_mutex_deletedGlProgramCache);
    GlProgramHandleList& pList = s_deletedGlProgramCache[contextID];
    pList.clear();
}


///////////////////////////////////////////////////////////////////////////
// osg::Program
///////////////////////////////////////////////////////////////////////////

Program::Program() :
    _geometryVerticesOut(1), _geometryInputType(GL_TRIANGLES),
    _geometryOutputType(GL_TRIANGLE_STRIP),
    _patchVertices(3)
{
}


Program::Program(const Program& rhs, const osg::CopyOp& copyop):
    osg::StateAttribute(rhs, copyop)
{
    for( unsigned int shaderIndex=0; shaderIndex < rhs.getNumShaders(); ++shaderIndex )
    {
        addShader( new osg::Shader( *rhs.getShader( shaderIndex ), copyop ) );
    }

    const osg::Program::AttribBindingList &abl = rhs.getAttribBindingList();
    for( osg::Program::AttribBindingList::const_iterator attribute = abl.begin(); attribute != abl.end(); ++attribute )
    {
        addBindAttribLocation( attribute->first, attribute->second );
    }

    const osg::Program::FragDataBindingList &fdl = rhs.getFragDataBindingList();
    for( osg::Program::FragDataBindingList::const_iterator fragdata = fdl.begin(); fragdata != fdl.end(); ++fragdata )
    {
        addBindFragDataLocation( fragdata->first, fragdata->second );
    }

    _geometryVerticesOut = rhs._geometryVerticesOut;
    _geometryInputType = rhs._geometryInputType;
    _geometryOutputType = rhs._geometryOutputType;

    _patchVertices = rhs._patchVertices;
}


Program::~Program()
{
    // inform any attached Shaders that we're going away
    for( unsigned int i=0; i < _shaderList.size(); ++i )
    {
        _shaderList[i]->removeProgramRef( this );
    }
}


int Program::compare(const osg::StateAttribute& sa) const
{
    // check the types are equal and then create the rhs variable
    // used by the COMPARE_StateAttribute_Parameter macros below.
    COMPARE_StateAttribute_Types(Program,sa)
    
    if( _shaderList.size() < rhs._shaderList.size() ) return -1;
    if( rhs._shaderList.size() < _shaderList.size() ) return 1;

    if( getName() < rhs.getName() ) return -1;
    if( rhs.getName() < getName() ) return 1;

    if( _geometryVerticesOut < rhs._geometryVerticesOut ) return -1;
    if( rhs._geometryVerticesOut < _geometryVerticesOut ) return 1;

    if( _geometryInputType < rhs._geometryInputType ) return -1;
    if( rhs._geometryInputType < _geometryInputType ) return 1;

    if( _geometryOutputType < rhs._geometryOutputType ) return -1;
    if( rhs._geometryOutputType < _geometryOutputType ) return 1;

    if( _patchVertices < rhs._patchVertices ) return -1;
    if( rhs._patchVertices < _patchVertices ) return 1;

    ShaderList::const_iterator litr=_shaderList.begin();
    ShaderList::const_iterator ritr=rhs._shaderList.begin();
    for(;
        litr!=_shaderList.end();
        ++litr,++ritr)
    {
        int result = (*litr)->compare(*(*ritr));
        if (result!=0) return result;
    }

    return 0; // passed all the above comparison macros, must be equal.
}


void Program::compileGLObjects( osg::State& state ) const
{
    if( isFixedFunction() ) return;

    const unsigned int contextID = state.getContextID();

    for( unsigned int i=0; i < _shaderList.size(); ++i )
    {
        _shaderList[i]->compileShader( state );
    }

    getPCP( contextID )->linkProgram(state);
}

void Program::setThreadSafeRefUnref(bool threadSafe)
{
    StateAttribute::setThreadSafeRefUnref(threadSafe);

    for( unsigned int i=0; i < _shaderList.size(); ++i )
    {
        if (_shaderList[i].valid()) _shaderList[i]->setThreadSafeRefUnref(threadSafe);
    }
}

void Program::dirtyProgram()
{
    // mark our PCPs as needing relink
    for( unsigned int cxt=0; cxt < _pcpList.size(); ++cxt )
    {
        if( _pcpList[cxt].valid() ) _pcpList[cxt]->requestLink();
    }
}


void Program::resizeGLObjectBuffers(unsigned int maxSize)
{
    for( unsigned int i=0; i < _shaderList.size(); ++i )
    {
        if (_shaderList[i].valid()) _shaderList[i]->resizeGLObjectBuffers(maxSize);
    }

    _pcpList.resize(maxSize);
}

void Program::releaseGLObjects(osg::State* state) const
{
    for( unsigned int i=0; i < _shaderList.size(); ++i )
    {
        if (_shaderList[i].valid()) _shaderList[i]->releaseGLObjects(state);
    }

    if (!state) _pcpList.setAllElementsTo(0);
    else
    {
        unsigned int contextID = state->getContextID();
        _pcpList[contextID] = 0;
    }   
}


bool Program::addShader( Shader* shader )
{
    if( !shader ) return false;

    // Shader can only be added once to a Program
    for( unsigned int i=0; i < _shaderList.size(); ++i )
    {
        if( shader == _shaderList[i].get() ) return false;
    }

    // Add shader to PCPs
    for( unsigned int cxt=0; cxt < _pcpList.size(); ++cxt )
    {
        if( _pcpList[cxt].valid() ) _pcpList[cxt]->addShaderToAttach( shader );
    }

    shader->addProgramRef( this );
    _shaderList.push_back( shader );
    dirtyProgram();
    return true;
}


bool Program::removeShader( Shader* shader )
{
    if( !shader ) return false;

    // Shader must exist to be removed.
    for( ShaderList::iterator itr = _shaderList.begin();
         itr != _shaderList.end();
         ++itr)
    {
        if( shader == itr->get() )
        {
            // Remove shader from PCPs
            for( unsigned int cxt=0; cxt < _pcpList.size(); ++cxt )
            {
                if( _pcpList[cxt].valid() ) _pcpList[cxt]->addShaderToDetach( shader );
            }

            shader->removeProgramRef( this );
            _shaderList.erase(itr);

            dirtyProgram();
            return true;
        }
    }

    return false;
}


void Program::setParameter( GLenum pname, GLint value )
{
    switch( pname )
    {
        case GL_GEOMETRY_VERTICES_OUT_EXT:
            _geometryVerticesOut = value;
            dirtyProgram();
            break;
        case GL_GEOMETRY_INPUT_TYPE_EXT:
            _geometryInputType = value;
            dirtyProgram();    // needed?
            break;
        case GL_GEOMETRY_OUTPUT_TYPE_EXT:
            _geometryOutputType = value;
            //dirtyProgram();    // needed?
            break;
        case GL_PATCH_VERTICES:
            _patchVertices = value;
            dirtyProgram();
            break;
        default:
            OSG_WARN << "setParameter invalid param " << pname << std::endl;
            break;
    }
}

void Program::setParameterfv( GLenum pname, const GLfloat* value )
{
    switch( pname )
    {
      // todo tessellation default level
        case GL_PATCH_DEFAULT_INNER_LEVEL:
            break;
        case GL_PATCH_DEFAULT_OUTER_LEVEL:
            break;
        default:
            OSG_WARN << "setParameter invalid param " << pname << std::endl;
            break;
    }
}

const GLfloat* Program::getParameterfv( GLenum pname ) const
{
    switch( pname )
    {
      ;
      // todo tessellation default level
      //        case GL_PATCH_DEFAULT_INNER_LEVEL: return _patchDefaultInnerLevel;
      //        case GL_PATCH_DEFAULT_OUTER_LEVEL: return _patchDefaultOuterLevel;

    }
    OSG_WARN << "getParameter invalid param " << pname << std::endl;
    return 0;
}

GLint Program::getParameter( GLenum pname ) const
{
    switch( pname )
    {
        case GL_GEOMETRY_VERTICES_OUT_EXT: return _geometryVerticesOut;
        case GL_GEOMETRY_INPUT_TYPE_EXT:   return _geometryInputType;
        case GL_GEOMETRY_OUTPUT_TYPE_EXT:  return _geometryOutputType;
        case GL_PATCH_VERTICES:            return _patchVertices; 
    }
    OSG_WARN << "getParameter invalid param " << pname << std::endl;
    return 0;
}


void Program::addBindAttribLocation( const std::string& name, GLuint index )
{
    _attribBindingList[name] = index;
    dirtyProgram();
}

void Program::removeBindAttribLocation( const std::string& name )
{
    _attribBindingList.erase(name);
    dirtyProgram();
}

void Program::addBindFragDataLocation( const std::string& name, GLuint index )
{
    _fragDataBindingList[name] = index;
    dirtyProgram();
}

void Program::removeBindFragDataLocation( const std::string& name )
{
    _fragDataBindingList.erase(name);
    dirtyProgram();
}

void Program::addBindUniformBlock(const std::string& name, GLuint index)
{
    _uniformBlockBindingList[name] = index;
    dirtyProgram(); // XXX
}

void Program::removeBindUniformBlock(const std::string& name)
{
    _uniformBlockBindingList.erase(name);
    dirtyProgram(); // XXX
}




void Program::apply( osg::State& state ) const
{
    const unsigned int contextID = state.getContextID();
    const GL2Extensions* extensions = GL2Extensions::Get(contextID,true);
    if( ! extensions->isGlslSupported() ) return;

    if( isFixedFunction() )
    {
        extensions->glUseProgram( 0 );
        state.setLastAppliedProgramObject(0);
        return;
    }

    PerContextProgram* pcp = getPCP( contextID );
    if( pcp->needsLink() ) compileGLObjects( state );
    if( pcp->isLinked() )
    {
        // for shader debugging: to minimize performance impact,
        // optionally validate based on notify level.
        // TODO: enable this using notify level, or perhaps its own getenv()?
        if( osg::isNotifyEnabled(osg::INFO) )
            pcp->validateProgram();

        pcp->useProgram();
        state.setLastAppliedProgramObject(pcp);
    }
    else
    {
        // program not usable, fallback to fixed function.
        extensions->glUseProgram( 0 );
        state.setLastAppliedProgramObject(0);
    }
}


Program::PerContextProgram* Program::getPCP(unsigned int contextID) const
{
    if( ! _pcpList[contextID].valid() )
    {
        _pcpList[contextID] = new PerContextProgram( this, contextID );

        // attach all PCSs to this new PCP
        for( unsigned int i=0; i < _shaderList.size(); ++i )
        {
            _pcpList[contextID]->addShaderToAttach( _shaderList[i].get() );
        }
    }

    return _pcpList[contextID].get();
}


bool Program::isFixedFunction() const
{
    // A Program object having no attached Shaders is a special case:
    // it indicates that programmable shading is to be disabled,
    // and thus use GL 1.x "fixed functionality" rendering.
    return _shaderList.empty();
}


bool Program::getGlProgramInfoLog(unsigned int contextID, std::string& log) const
{
    return getPCP( contextID )->getInfoLog( log );
}

const Program::ActiveUniformMap& Program::getActiveUniforms(unsigned int contextID) const
{
    return getPCP( contextID )->getActiveUniforms();
}

const Program::ActiveVarInfoMap& Program::getActiveAttribs(unsigned int contextID) const
{
    return getPCP( contextID )->getActiveAttribs();
}

///////////////////////////////////////////////////////////////////////////
// osg::Program::PerContextProgram
// PCP is an OSG abstraction of the per-context glProgram
///////////////////////////////////////////////////////////////////////////

Program::PerContextProgram::PerContextProgram(const Program* program, unsigned int contextID ) :
        osg::Referenced(),
        _contextID( contextID )
{
    _program = program;
    _extensions = GL2Extensions::Get( _contextID, true );
    _glProgramHandle = _extensions->glCreateProgram();
    requestLink();
}

Program::PerContextProgram::~PerContextProgram()
{
    Program::deleteGlProgram( _contextID, _glProgramHandle );
}


void Program::PerContextProgram::requestLink()
{
    _needsLink = true;
    _isLinked = false;
}


void Program::PerContextProgram::linkProgram(osg::State& state)
{
    if( ! _needsLink ) return;
    _needsLink = false;

    OSG_INFO << "Linking osg::Program \"" << _program->getName() << "\""
             << " id=" << _glProgramHandle
             << " contextID=" << _contextID
             <<  std::endl;

    if (_extensions->isGeometryShader4Supported())
    {
        _extensions->glProgramParameteri( _glProgramHandle, GL_GEOMETRY_VERTICES_OUT_EXT, _program->_geometryVerticesOut );
        _extensions->glProgramParameteri( _glProgramHandle, GL_GEOMETRY_INPUT_TYPE_EXT, _program->_geometryInputType );
        _extensions->glProgramParameteri( _glProgramHandle, GL_GEOMETRY_OUTPUT_TYPE_EXT, _program->_geometryOutputType );
    }

    if (_extensions->areTessellationShadersSupported() )
    {
        _extensions->glPatchParameteri( GL_PATCH_VERTICES, _program->_patchVertices );
        // todo: add default tessellation level
    }

    // Detach removed shaders
    for( unsigned int i=0; i < _shadersToDetach.size(); ++i )
    {
        _shadersToDetach[i]->detachShader( _contextID, _glProgramHandle );
    }
    _shadersToDetach.clear();

    // Attach new shaders
    for( unsigned int i=0; i < _shadersToAttach.size(); ++i )
    {
        _shadersToAttach[i]->attachShader( _contextID, _glProgramHandle );
    }
    _shadersToAttach.clear();

    _uniformInfoMap.clear();
    _attribInfoMap.clear();
    _lastAppliedUniformList.clear();

    // set any explicit vertex attribute bindings
    const AttribBindingList& programBindlist = _program->getAttribBindingList();
    for( AttribBindingList::const_iterator itr = programBindlist.begin();
        itr != programBindlist.end(); ++itr )
    {
        OSG_INFO<<"Program's vertex attrib binding "<<itr->second<<", "<<itr->first<<std::endl;
        _extensions->glBindAttribLocation( _glProgramHandle, itr->second, reinterpret_cast<const GLchar*>(itr->first.c_str()) );
    }

    // set any explicit vertex attribute bindings that are set up via osg::State, such as the vertex arrays
    //  that have been aliase to vertex attrib arrays
    if (state.getUseVertexAttributeAliasing())
    {
        const AttribBindingList& stateBindlist = state.getAttributeBindingList();
        for( AttribBindingList::const_iterator itr = stateBindlist.begin();
            itr != stateBindlist.end(); ++itr )
        {
            OSG_INFO<<"State's vertex attrib binding "<<itr->second<<", "<<itr->first<<std::endl;
            _extensions->glBindAttribLocation( _glProgramHandle, itr->second, reinterpret_cast<const GLchar*>(itr->first.c_str()) );
        }
    }

    // set any explicit frag data bindings
    const FragDataBindingList& fdbindlist = _program->getFragDataBindingList();
    for( FragDataBindingList::const_iterator itr = fdbindlist.begin();
        itr != fdbindlist.end(); ++itr )
    {
        _extensions->glBindFragDataLocation( _glProgramHandle, itr->second, reinterpret_cast<const GLchar*>(itr->first.c_str()) );
    }

    // link the glProgram
    GLint linked = GL_FALSE;
    _extensions->glLinkProgram( _glProgramHandle );
    _extensions->glGetProgramiv( _glProgramHandle, GL_LINK_STATUS, &linked );
    _isLinked = (linked == GL_TRUE);
    if( ! _isLinked )
    {
        OSG_WARN << "glLinkProgram \""<< _program->getName() << "\" FAILED" << std::endl;

        std::string infoLog;
        if( getInfoLog(infoLog) )
        {
            OSG_WARN << "Program \""<< _program->getName() << "\" " 
                                      "infolog:\n" << infoLog << std::endl;
        }
        
        return;
    }
    else
    {
        std::string infoLog;
        if( getInfoLog(infoLog) )
        {
            OSG_INFO << "Program \""<< _program->getName() << "\" "<<
                                      "link succeded, infolog:\n" << infoLog << std::endl;
        }
    }

    if (_extensions->isUniformBufferObjectSupported())
    {
        GLuint activeUniformBlocks = 0;
        GLsizei maxBlockNameLen = 0;
        _extensions->glGetProgramiv(_glProgramHandle, GL_ACTIVE_UNIFORM_BLOCKS,
                                    reinterpret_cast<GLint*>(&activeUniformBlocks));
        _extensions->glGetProgramiv(_glProgramHandle,
                                    GL_ACTIVE_UNIFORM_MAX_LENGTH,
                                    &maxBlockNameLen);
        if (maxBlockNameLen > 0)
        {
            std::vector<GLchar> blockName(maxBlockNameLen);
            for (GLuint i = 0; i < activeUniformBlocks; ++i)
            {
                GLsizei len = 0;
                GLint blockSize = 0;
                _extensions->glGetActiveUniformBlockName(_glProgramHandle, i,
                                                         maxBlockNameLen, &len,
                                                         &blockName[0]);
                _extensions->glGetActiveUniformBlockiv(_glProgramHandle, i,
                                                       GL_UNIFORM_BLOCK_DATA_SIZE,
                                                       &blockSize);
                _uniformBlockMap
                    .insert(UniformBlockMap::value_type(&blockName[0],
                                                        UniformBlockInfo(i, blockSize)));
            }
        }
        // Bind any uniform blocks
        const UniformBlockBindingList& bindingList = _program->getUniformBlockBindingList();
        for (UniformBlockMap::iterator itr = _uniformBlockMap.begin(),
                 end = _uniformBlockMap.end();
             itr != end;
            ++itr)
        {
            const std::string& blockName = itr->first;
            UniformBlockBindingList::const_iterator bitr = bindingList.find(blockName);
            if (bitr != bindingList.end())
            {
                _extensions->glUniformBlockBinding(_glProgramHandle, itr->second._index,
                                                   bitr->second);
                OSG_INFO << "uniform block " << blockName << ": " << itr->second._index
                         << " binding: " << bitr->second << "\n";
            }
            else
            {
                OSG_WARN << "uniform block " << blockName << " has no binding.\n";
            }

        }

    }

    // build _uniformInfoMap
    GLint numUniforms = 0;
    GLsizei maxLen = 0;
    _extensions->glGetProgramiv( _glProgramHandle, GL_ACTIVE_UNIFORMS, &numUniforms );
    _extensions->glGetProgramiv( _glProgramHandle, GL_ACTIVE_UNIFORM_MAX_LENGTH, &maxLen );
    if( (numUniforms > 0) && (maxLen > 1) )
    {
        GLint size = 0;
        GLenum type = 0;
        GLchar* name = new GLchar[maxLen];

        for( GLint i = 0; i < numUniforms; ++i )
        {
            _extensions->glGetActiveUniform( _glProgramHandle,
                    i, maxLen, 0, &size, &type, name );

            GLint loc = _extensions->glGetUniformLocation( _glProgramHandle, name );
            
            if( loc != -1 )
            {
                _uniformInfoMap[Uniform::getNameID(reinterpret_cast<const char*>(name))] = ActiveVarInfo(loc,type,size);

                OSG_INFO << "\tUniform \"" << name << "\""
                    << " loc="<< loc
                    << " size="<< size
                    << " type=" << Uniform::getTypename((Uniform::Type)type)
                    << std::endl;
            }
        }
        delete [] name;
    }

    // build _attribInfoMap
    GLint numAttrib = 0;
    _extensions->glGetProgramiv( _glProgramHandle, GL_ACTIVE_ATTRIBUTES, &numAttrib );
    _extensions->glGetProgramiv( _glProgramHandle, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &maxLen );
    if( (numAttrib > 0) && (maxLen > 1) )
    {
        GLint size = 0;
        GLenum type = 0;
        GLchar* name = new GLchar[maxLen];

        for( GLint i = 0; i < numAttrib; ++i )
        {
            _extensions->glGetActiveAttrib( _glProgramHandle,
                    i, maxLen, 0, &size, &type, name );

            GLint loc = _extensions->glGetAttribLocation( _glProgramHandle, name );
            
            if( loc != -1 )
            {
                _attribInfoMap[reinterpret_cast<char*>(name)] = ActiveVarInfo(loc,type,size);

                OSG_INFO << "\tAttrib \"" << name << "\""
                         << " loc=" << loc
                         << " size=" << size
                         << std::endl;
            }
        }
        delete [] name;
    }
    OSG_INFO << std::endl;
}

bool Program::PerContextProgram::validateProgram()
{
    GLint validated = GL_FALSE;
    _extensions->glValidateProgram( _glProgramHandle );
    _extensions->glGetProgramiv( _glProgramHandle, GL_VALIDATE_STATUS, &validated );
    if( validated == GL_TRUE)
        return true;

    OSG_WARN << "glValidateProgram FAILED \"" << _program->getName() << "\""
             << " id=" << _glProgramHandle
             << " contextID=" << _contextID
             <<  std::endl;

    std::string infoLog;
    if( getInfoLog(infoLog) )
        OSG_WARN << "infolog:\n" << infoLog << std::endl;

    OSG_WARN << std::endl;
    
    return false;
}

bool Program::PerContextProgram::getInfoLog( std::string& infoLog ) const
{
    return _extensions->getProgramInfoLog( _glProgramHandle, infoLog );
}

void Program::PerContextProgram::useProgram() const
{
    _extensions->glUseProgram( _glProgramHandle  );
}
