# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osgPlugins/p3d

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
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/osgPlugins-3.1.0" TYPE MODULE FILES "/Users/maurizio/work/t11/git/osg/lib/osgPlugins-3.1.0/osgdb_p3d.so")
  IF(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/osgPlugins-3.1.0/osgdb_p3d.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/osgPlugins-3.1.0/osgdb_p3d.so")
    EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
      -change "/Users/maurizio/work/t11/git/osg/lib/libOpenThreads.12.dylib" "libOpenThreads.12.dylib"
      -change "/Users/maurizio/work/t11/git/osg/lib/libosg.78.dylib" "libosg.78.dylib"
      -change "/Users/maurizio/work/t11/git/osg/lib/libosgDB.78.dylib" "libosgDB.78.dylib"
      -change "/Users/maurizio/work/t11/git/osg/lib/libosgFX.78.dylib" "libosgFX.78.dylib"
      -change "/Users/maurizio/work/t11/git/osg/lib/libosgGA.78.dylib" "libosgGA.78.dylib"
      -change "/Users/maurizio/work/t11/git/osg/lib/libosgManipulator.78.dylib" "libosgManipulator.78.dylib"
      -change "/Users/maurizio/work/t11/git/osg/lib/libosgPresentation.78.dylib" "libosgPresentation.78.dylib"
      -change "/Users/maurizio/work/t11/git/osg/lib/libosgText.78.dylib" "libosgText.78.dylib"
      -change "/Users/maurizio/work/t11/git/osg/lib/libosgUtil.78.dylib" "libosgUtil.78.dylib"
      -change "/Users/maurizio/work/t11/git/osg/lib/libosgViewer.78.dylib" "libosgViewer.78.dylib"
      -change "/Users/maurizio/work/t11/git/osg/lib/libosgVolume.78.dylib" "libosgVolume.78.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/osgPlugins-3.1.0/osgdb_p3d.so")
    IF(CMAKE_INSTALL_DO_STRIP)
      EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/osgPlugins-3.1.0/osgdb_p3d.so")
    ENDIF(CMAKE_INSTALL_DO_STRIP)
  ENDIF()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph")

