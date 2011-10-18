# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osgDB

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
    "/Users/maurizio/work/t11/git/osg/lib/libosgDB.3.1.0.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgDB.78.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgDB.dylib"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgDB.3.1.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgDB.78.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgDB.dylib"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
        -id "libosgDB.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libOpenThreads.12.dylib" "libOpenThreads.12.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosg.78.dylib" "libosg.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libosgUtil.78.dylib" "libosgUtil.78.dylib"
        "${file}")
      IF(CMAKE_INSTALL_DO_STRIP)
        EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "${file}")
      ENDIF(CMAKE_INSTALL_DO_STRIP)
    ENDIF()
  ENDFOREACH()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/osgDB" TYPE FILE FILES
    "/Users/maurizio/work/t11/git/osg/include/osgDB/DataTypes"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/StreamOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/Serializer"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/ObjectWrapper"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/InputStream"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/OutputStream"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/Archive"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/AuthenticationMap"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/Callbacks"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/ConvertUTF"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/DatabasePager"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/DatabaseRevisions"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/DotOsgWrapper"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/DynamicLibrary"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/Export"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/ExternalFileWriter"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/FileCache"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/FileNameUtils"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/FileUtils"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/fstream"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/ImageOptions"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/ImagePager"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/ImageProcessor"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/Input"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/Output"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/Options"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/ParameterOutput"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/PluginQuery"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/ReaderWriter"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/ReadFile"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/Registry"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/SharedStateManager"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/Version"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/WriteFile"
    "/Users/maurizio/work/t11/git/osg/include/osgDB/XmlParser"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")

