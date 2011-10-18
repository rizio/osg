# Install script for directory: /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads

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

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenthreads")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/Users/maurizio/work/t11/git/osg/lib/libOpenThreads.2.6.0.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libOpenThreads.12.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libOpenThreads.dylib"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libOpenThreads.2.6.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libOpenThreads.12.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libOpenThreads.dylib"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
        -id "libOpenThreads.12.dylib"
        "${file}")
      IF(CMAKE_INSTALL_DO_STRIP)
        EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "${file}")
      ENDIF(CMAKE_INSTALL_DO_STRIP)
    ENDIF()
  ENDFOREACH()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenthreads")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenthreads-dev")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/OpenThreads" TYPE FILE FILES
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/Atomic"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/Barrier"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/Block"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/Condition"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/Exports"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/Mutex"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/ReadWriteMutex"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/ReentrantMutex"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/ScopedLock"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/Thread"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/Version"
    "/Users/maurizio/work/t11/git/osg/include/OpenThreads/Config"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenthreads-dev")

