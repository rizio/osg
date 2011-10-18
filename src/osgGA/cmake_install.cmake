# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osgGA

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
    "/Users/maurizio/work/t11/git/osg/lib/libosgGA.3.1.0.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgGA.78.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgGA.dylib"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgGA.3.1.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgGA.78.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgGA.dylib"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
        -id "libosgGA.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libOpenThreads.12.dylib" "libOpenThreads.12.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosg.78.dylib" "libosg.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgDB.78.dylib" "libosgDB.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgUtil.78.dylib" "libosgUtil.78.dylib"
        "${file}")
      IF(CMAKE_INSTALL_DO_STRIP)
        EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "${file}")
      ENDIF(CMAKE_INSTALL_DO_STRIP)
    ENDIF()
  ENDFOREACH()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/osgGA" TYPE FILE FILES
    "/Users/maurizio/work/t11/git/osg/include/osgGA/AnimationPathManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/DriveManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/EventQueue"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/EventVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/Export"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/FirstPersonManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/FlightManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/GUIActionAdapter"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/GUIEventAdapter"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/GUIEventHandler"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/KeySwitchMatrixManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/CameraManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/MultiTouchTrackballManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/NodeTrackerManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/OrbitManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/StandardManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/SphericalManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/StateSetManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/TerrainManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/TrackballManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/UFOManipulator"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/Version"
    "/Users/maurizio/work/t11/git/osg/include/osgGA/CameraViewSwitchManipulator"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")

