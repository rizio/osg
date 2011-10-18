# Install script for directory: /Users/maurizio/work/t11/git/osg/src

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

IF(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/OpenThreads/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osg/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgDB/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgUtil/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgGA/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgText/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgViewer/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgAnimation/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgFX/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgManipulator/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgParticle/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgPresentation/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgShadow/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgSim/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgTerrain/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWidget/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgVolume/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/deprecated-dotosg/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgPlugins/cmake_install.cmake")

ENDIF(NOT CMAKE_INSTALL_LOCAL_ONLY)

