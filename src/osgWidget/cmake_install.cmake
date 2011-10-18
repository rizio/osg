# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osgWidget

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
    "/Users/maurizio/work/t11/git/osg/lib/libosgWidget.3.1.0.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgWidget.78.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgWidget.dylib"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgWidget.3.1.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgWidget.78.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgWidget.dylib"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
        -id "libosgWidget.78.dylib"
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
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/osgWidget" TYPE FILE FILES
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Export"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Box"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Browser"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/PdfReader"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/VncClient"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Canvas"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/EventInterface"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Frame"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Input"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Label"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Lua"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Python"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/ScriptEngine"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/StyleInterface"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/StyleManager"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Table"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Types"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/UIObjectParent"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Util"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Version"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/ViewerEventHandlers"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Widget"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/Window"
    "/Users/maurizio/work/t11/git/osg/include/osgWidget/WindowManager"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")

