# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osgParticle

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
    "/Users/maurizio/work/t11/git/osg/lib/libosgParticle.3.1.0.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgParticle.78.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosgParticle.dylib"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgParticle.3.1.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgParticle.78.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosgParticle.dylib"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
        -id "libosgParticle.78.dylib"
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
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/osgParticle" TYPE FILE FILES
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/AccelOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/AngularAccelOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/BoxPlacer"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/CenteredPlacer"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ConnectedParticleSystem"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ConstantRateCounter"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/Counter"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/Emitter"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ExplosionDebrisEffect"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ExplosionEffect"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/Export"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/FireEffect"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/FluidFrictionOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/FluidProgram"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ForceOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/Interpolator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/LinearInterpolator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ModularEmitter"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ModularProgram"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/MultiSegmentPlacer"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/Operator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/Particle"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ParticleEffect"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ParticleProcessor"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ParticleSystem"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ParticleSystemUpdater"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/Placer"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/PointPlacer"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/PrecipitationEffect"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/Program"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/RadialShooter"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/RandomRateCounter"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/range"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/SectorPlacer"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/SegmentPlacer"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/Shooter"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/SmokeEffect"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/SmokeTrailEffect"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/VariableRateCounter"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/Version"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/CompositePlacer"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/AngularDampingOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/DampingOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/ExplosionOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/OrbitOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/DomainOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/BounceOperator"
    "/Users/maurizio/work/t11/git/osg/include/osgParticle/SinkOperator"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")

