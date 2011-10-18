# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osgSim

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
    "/Users/maurizio/work/t11/git/osg/lib/libosgSim.3.1.0.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgSim.78.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgSim.dylib"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgSim.3.1.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgSim.78.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgSim.dylib"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
        -id "libosgSim.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libOpenThreads.12.dylib" "libOpenThreads.12.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosg.78.dylib" "libosg.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgDB.78.dylib" "libosgDB.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgText.78.dylib" "libosgText.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgUtil.78.dylib" "libosgUtil.78.dylib"
        "${file}")
      IF(CMAKE_INSTALL_DO_STRIP)
        EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "${file}")
      ENDIF(CMAKE_INSTALL_DO_STRIP)
    ENDIF()
  ENDFOREACH()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/osgSim" TYPE FILE FILES
    "/Users/maurizio/work/t11/git/osg/include/osgSim/BlinkSequence"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/ColorRange"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/DOFTransform"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/ElevationSlice"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/HeightAboveTerrain"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/Export"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/GeographicLocation"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/Impostor"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/ImpostorSprite"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/InsertImpostorsVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/LightPoint"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/LightPointNode"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/LightPointSystem"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/LineOfSight"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/MultiSwitch"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/OverlayNode"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/ObjectRecordData"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/ScalarBar"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/ScalarsToColors"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/Sector"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/ShapeAttribute"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/SphereSegment"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/Version"
    "/Users/maurizio/work/t11/git/osg/include/osgSim/VisibilityGroup"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")

