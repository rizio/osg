# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osgAnimation

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
    "/Users/maurizio/work/t11/git/osg/lib/libosgAnimation.3.1.0.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgAnimation.78.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgAnimation.dylib"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgAnimation.3.1.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgAnimation.78.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgAnimation.dylib"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
        -id "libosgAnimation.78.dylib"
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
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/osgAnimation" TYPE FILE FILES
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Action"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/ActionAnimation"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/ActionBlendIn"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/ActionBlendOut"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/ActionCallback"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/ActionStripAnimation"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/ActionVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Animation"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/AnimationManagerBase"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/AnimationUpdateCallback"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/BasicAnimationManager"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Bone"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/BoneMapVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Channel"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/CubicBezier"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/EaseMotion"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Export"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/FrameAction"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Interpolator"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Keyframe"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/LinkVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/MorphGeometry"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/RigGeometry"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/RigTransform"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/RigTransformHardware"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/RigTransformSoftware"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Sampler"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Skeleton"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/StackedMatrixElement"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/StackedQuaternionElement"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/StackedRotateAxisElement"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/StackedScaleElement"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/StackedTransformElement"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/StackedTranslateElement"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/StackedTransform"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/StatsVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/StatsHandler"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Target"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Timeline"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/TimelineAnimationManager"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/UpdateBone"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/UpdateMaterial"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/UpdateMatrixTransform"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/Vec3Packed"
    "/Users/maurizio/work/t11/git/osg/include/osgAnimation/VertexInfluence"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")

