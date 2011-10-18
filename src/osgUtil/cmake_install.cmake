# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osgUtil

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/usr/local")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "Release")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/Users/maurizio/work/t11/git/osg/lib/libosgUtil.3.1.0.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgUtil.78.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgUtil.dylib"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgUtil.3.1.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgUtil.78.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgUtil.dylib"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
        -id "libosgUtil.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libOpenThreads.12.dylib" "libOpenThreads.12.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosg.78.dylib" "libosg.78.dylib"
        "${file}")
      IF(CMAKE_INSTALL_DO_STRIP)
        EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "${file}")
      ENDIF(CMAKE_INSTALL_DO_STRIP)
    ENDIF()
  ENDFOREACH()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/osgUtil" TYPE FILE FILES
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/ConvertVec"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/CubeMapGenerator"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/CullVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/DelaunayTriangulator"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/DisplayRequirementsVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/DrawElementTypeSimplifier"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/EdgeCollector"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/Export"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/GLObjectsVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/HalfWayMapGenerator"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/HighlightMapGenerator"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/IntersectionVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/IntersectVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/IncrementalCompileOperation"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/LineSegmentIntersector"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/MeshOptimizers"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/OperationArrayFunctor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/Optimizer"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/PlaneIntersector"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/PolytopeIntersector"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/PositionalStateContainer"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/PrintVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/ReflectionMapGenerator"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/RenderBin"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/RenderLeaf"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/RenderStage"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/ReversePrimitiveFunctor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/SceneView"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/SceneGraphBuilder"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/ShaderGen"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/Simplifier"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/SmoothingVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/StateGraph"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/Statistics"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/TangentSpaceGenerator"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/Tessellator"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/TransformAttributeFunctor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/TransformCallback"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/TriStripVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/UpdateVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgUtil/Version"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")

