# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers

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
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/osg/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/osgAnimation/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/osgFX/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/osgManipulator/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/osgParticle/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/osgSim/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/osgShadow/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/osgTerrain/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/osgText/cmake_install.cmake")
  INCLUDE("/Users/maurizio/work/t11/git/osg/src/osgWrappers/serializers/osgVolume/cmake_install.cmake")

ENDIF(NOT CMAKE_INSTALL_LOCAL_ONLY)

