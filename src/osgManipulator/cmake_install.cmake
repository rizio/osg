# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osgManipulator

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
    "/Users/maurizio/work/t11/git/osg/lib/libosgManipulator.3.1.0.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgManipulator.78.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgManipulator.dylib"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgManipulator.3.1.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgManipulator.78.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgManipulator.dylib"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
        -id "libosgManipulator.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libOpenThreads.12.dylib" "libOpenThreads.12.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosg.78.dylib" "libosg.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgDB.78.dylib" "libosgDB.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgGA.78.dylib" "libosgGA.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgText.78.dylib" "libosgText.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgUtil.78.dylib" "libosgUtil.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgViewer.78.dylib" "libosgViewer.78.dylib"
        "${file}")
      IF(CMAKE_INSTALL_DO_STRIP)
        EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "${file}")
      ENDIF(CMAKE_INSTALL_DO_STRIP)
    ENDIF()
  ENDFOREACH()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/osgManipulator" TYPE FILE FILES
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/AntiSquish"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Command"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/CommandManager"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Constraint"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Dragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Export"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Projector"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/RotateCylinderDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/RotateSphereDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Scale1DDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Scale2DDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/ScaleAxisDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Selection"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/TabBoxDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/TabBoxTrackballDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/TabPlaneDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/TabPlaneTrackballDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/TrackballDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Translate1DDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Translate2DDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/TranslateAxisDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/TranslatePlaneDragger"
    "/Users/maurizio/work/t11/git/osg/include/osgManipulator/Version"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")

