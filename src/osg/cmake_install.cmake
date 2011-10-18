# Install script for directory: /Users/maurizio/work/t11/git/osg/src/osg

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
    "/Users/maurizio/work/t11/git/osg/lib/libosg.3.1.0.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosg.78.dylib"
    "/Users/maurizio/work/t11/git/osg/lib/libosg.dylib"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosg.3.1.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosg.78.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libosg.dylib"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      EXECUTE_PROCESS(COMMAND "/usr/bin/install_name_tool"
        -id "libosg.78.dylib"
        -change "/Users/maurizio/work/t11/git/osg/lib/libOpenThreads.12.dylib" "libOpenThreads.12.dylib"
        "${file}")
      IF(CMAKE_INSTALL_DO_STRIP)
        EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "${file}")
      ENDIF(CMAKE_INSTALL_DO_STRIP)
    ENDIF()
  ENDFOREACH()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/osg" TYPE FILE FILES
    "/Users/maurizio/work/t11/git/osg/include/osg/AlphaFunc"
    "/Users/maurizio/work/t11/git/osg/include/osg/AnimationPath"
    "/Users/maurizio/work/t11/git/osg/include/osg/ApplicationUsage"
    "/Users/maurizio/work/t11/git/osg/include/osg/ArgumentParser"
    "/Users/maurizio/work/t11/git/osg/include/osg/Array"
    "/Users/maurizio/work/t11/git/osg/include/osg/ArrayDispatchers"
    "/Users/maurizio/work/t11/git/osg/include/osg/AudioStream"
    "/Users/maurizio/work/t11/git/osg/include/osg/AutoTransform"
    "/Users/maurizio/work/t11/git/osg/include/osg/Billboard"
    "/Users/maurizio/work/t11/git/osg/include/osg/BlendColor"
    "/Users/maurizio/work/t11/git/osg/include/osg/BlendEquation"
    "/Users/maurizio/work/t11/git/osg/include/osg/BlendFunc"
    "/Users/maurizio/work/t11/git/osg/include/osg/BoundingBox"
    "/Users/maurizio/work/t11/git/osg/include/osg/BoundingSphere"
    "/Users/maurizio/work/t11/git/osg/include/osg/BoundsChecking"
    "/Users/maurizio/work/t11/git/osg/include/osg/buffered_value"
    "/Users/maurizio/work/t11/git/osg/include/osg/BufferIndexBinding"
    "/Users/maurizio/work/t11/git/osg/include/osg/BufferObject"
    "/Users/maurizio/work/t11/git/osg/include/osg/Camera"
    "/Users/maurizio/work/t11/git/osg/include/osg/CameraNode"
    "/Users/maurizio/work/t11/git/osg/include/osg/CameraView"
    "/Users/maurizio/work/t11/git/osg/include/osg/ClampColor"
    "/Users/maurizio/work/t11/git/osg/include/osg/ClearNode"
    "/Users/maurizio/work/t11/git/osg/include/osg/ClipNode"
    "/Users/maurizio/work/t11/git/osg/include/osg/ClipPlane"
    "/Users/maurizio/work/t11/git/osg/include/osg/ClusterCullingCallback"
    "/Users/maurizio/work/t11/git/osg/include/osg/CollectOccludersVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osg/ColorMask"
    "/Users/maurizio/work/t11/git/osg/include/osg/ColorMatrix"
    "/Users/maurizio/work/t11/git/osg/include/osg/ComputeBoundsVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osg/ConvexPlanarOccluder"
    "/Users/maurizio/work/t11/git/osg/include/osg/ConvexPlanarPolygon"
    "/Users/maurizio/work/t11/git/osg/include/osg/CoordinateSystemNode"
    "/Users/maurizio/work/t11/git/osg/include/osg/CopyOp"
    "/Users/maurizio/work/t11/git/osg/include/osg/CullFace"
    "/Users/maurizio/work/t11/git/osg/include/osg/CullingSet"
    "/Users/maurizio/work/t11/git/osg/include/osg/CullSettings"
    "/Users/maurizio/work/t11/git/osg/include/osg/CullStack"
    "/Users/maurizio/work/t11/git/osg/include/osg/DeleteHandler"
    "/Users/maurizio/work/t11/git/osg/include/osg/Depth"
    "/Users/maurizio/work/t11/git/osg/include/osg/DisplaySettings"
    "/Users/maurizio/work/t11/git/osg/include/osg/Drawable"
    "/Users/maurizio/work/t11/git/osg/include/osg/DrawPixels"
    "/Users/maurizio/work/t11/git/osg/include/osg/Endian"
    "/Users/maurizio/work/t11/git/osg/include/osg/Export"
    "/Users/maurizio/work/t11/git/osg/include/osg/fast_back_stack"
    "/Users/maurizio/work/t11/git/osg/include/osg/Fog"
    "/Users/maurizio/work/t11/git/osg/include/osg/FragmentProgram"
    "/Users/maurizio/work/t11/git/osg/include/osg/FrameBufferObject"
    "/Users/maurizio/work/t11/git/osg/include/osg/FrameStamp"
    "/Users/maurizio/work/t11/git/osg/include/osg/FrontFace"
    "/Users/maurizio/work/t11/git/osg/include/osg/Geode"
    "/Users/maurizio/work/t11/git/osg/include/osg/Geometry"
    "/Users/maurizio/work/t11/git/osg/include/osg/GL"
    "/Users/maurizio/work/t11/git/osg/include/osg/GL2Extensions"
    "/Users/maurizio/work/t11/git/osg/include/osg/GLExtensions"
    "/Users/maurizio/work/t11/git/osg/include/osg/GLBeginEndAdapter"
    "/Users/maurizio/work/t11/git/osg/include/osg/GLObjects"
    "/Users/maurizio/work/t11/git/osg/include/osg/GLU"
    "/Users/maurizio/work/t11/git/osg/include/osg/GraphicsCostEstimator"
    "/Users/maurizio/work/t11/git/osg/include/osg/GraphicsContext"
    "/Users/maurizio/work/t11/git/osg/include/osg/GraphicsThread"
    "/Users/maurizio/work/t11/git/osg/include/osg/Group"
    "/Users/maurizio/work/t11/git/osg/include/osg/Hint"
    "/Users/maurizio/work/t11/git/osg/include/osg/Image"
    "/Users/maurizio/work/t11/git/osg/include/osg/ImageSequence"
    "/Users/maurizio/work/t11/git/osg/include/osg/ImageStream"
    "/Users/maurizio/work/t11/git/osg/include/osg/ImageUtils"
    "/Users/maurizio/work/t11/git/osg/include/osg/io_utils"
    "/Users/maurizio/work/t11/git/osg/include/osg/KdTree"
    "/Users/maurizio/work/t11/git/osg/include/osg/Light"
    "/Users/maurizio/work/t11/git/osg/include/osg/LightModel"
    "/Users/maurizio/work/t11/git/osg/include/osg/LightSource"
    "/Users/maurizio/work/t11/git/osg/include/osg/LineSegment"
    "/Users/maurizio/work/t11/git/osg/include/osg/LineStipple"
    "/Users/maurizio/work/t11/git/osg/include/osg/LineWidth"
    "/Users/maurizio/work/t11/git/osg/include/osg/LOD"
    "/Users/maurizio/work/t11/git/osg/include/osg/LogicOp"
    "/Users/maurizio/work/t11/git/osg/include/osg/Material"
    "/Users/maurizio/work/t11/git/osg/include/osg/Math"
    "/Users/maurizio/work/t11/git/osg/include/osg/Matrix"
    "/Users/maurizio/work/t11/git/osg/include/osg/Matrixd"
    "/Users/maurizio/work/t11/git/osg/include/osg/Matrixf"
    "/Users/maurizio/work/t11/git/osg/include/osg/MatrixTransform"
    "/Users/maurizio/work/t11/git/osg/include/osg/MixinVector"
    "/Users/maurizio/work/t11/git/osg/include/osg/Multisample"
    "/Users/maurizio/work/t11/git/osg/include/osg/Node"
    "/Users/maurizio/work/t11/git/osg/include/osg/NodeCallback"
    "/Users/maurizio/work/t11/git/osg/include/osg/NodeTrackerCallback"
    "/Users/maurizio/work/t11/git/osg/include/osg/NodeVisitor"
    "/Users/maurizio/work/t11/git/osg/include/osg/Notify"
    "/Users/maurizio/work/t11/git/osg/include/osg/Object"
    "/Users/maurizio/work/t11/git/osg/include/osg/observer_ptr"
    "/Users/maurizio/work/t11/git/osg/include/osg/Observer"
    "/Users/maurizio/work/t11/git/osg/include/osg/ObserverNodePath"
    "/Users/maurizio/work/t11/git/osg/include/osg/OccluderNode"
    "/Users/maurizio/work/t11/git/osg/include/osg/OcclusionQueryNode"
    "/Users/maurizio/work/t11/git/osg/include/osg/OperationThread"
    "/Users/maurizio/work/t11/git/osg/include/osg/PagedLOD"
    "/Users/maurizio/work/t11/git/osg/include/osg/Plane"
    "/Users/maurizio/work/t11/git/osg/include/osg/Point"
    "/Users/maurizio/work/t11/git/osg/include/osg/PointSprite"
    "/Users/maurizio/work/t11/git/osg/include/osg/PolygonMode"
    "/Users/maurizio/work/t11/git/osg/include/osg/PolygonOffset"
    "/Users/maurizio/work/t11/git/osg/include/osg/PolygonStipple"
    "/Users/maurizio/work/t11/git/osg/include/osg/Polytope"
    "/Users/maurizio/work/t11/git/osg/include/osg/PositionAttitudeTransform"
    "/Users/maurizio/work/t11/git/osg/include/osg/PrimitiveSet"
    "/Users/maurizio/work/t11/git/osg/include/osg/Program"
    "/Users/maurizio/work/t11/git/osg/include/osg/Projection"
    "/Users/maurizio/work/t11/git/osg/include/osg/ProxyNode"
    "/Users/maurizio/work/t11/git/osg/include/osg/Quat"
    "/Users/maurizio/work/t11/git/osg/include/osg/Referenced"
    "/Users/maurizio/work/t11/git/osg/include/osg/ref_ptr"
    "/Users/maurizio/work/t11/git/osg/include/osg/RenderInfo"
    "/Users/maurizio/work/t11/git/osg/include/osg/Scissor"
    "/Users/maurizio/work/t11/git/osg/include/osg/Sequence"
    "/Users/maurizio/work/t11/git/osg/include/osg/ShadeModel"
    "/Users/maurizio/work/t11/git/osg/include/osg/Shader"
    "/Users/maurizio/work/t11/git/osg/include/osg/ShaderAttribute"
    "/Users/maurizio/work/t11/git/osg/include/osg/ShaderComposer"
    "/Users/maurizio/work/t11/git/osg/include/osg/ShadowVolumeOccluder"
    "/Users/maurizio/work/t11/git/osg/include/osg/Shape"
    "/Users/maurizio/work/t11/git/osg/include/osg/ShapeDrawable"
    "/Users/maurizio/work/t11/git/osg/include/osg/State"
    "/Users/maurizio/work/t11/git/osg/include/osg/StateAttribute"
    "/Users/maurizio/work/t11/git/osg/include/osg/StateAttributeCallback"
    "/Users/maurizio/work/t11/git/osg/include/osg/StateSet"
    "/Users/maurizio/work/t11/git/osg/include/osg/Stats"
    "/Users/maurizio/work/t11/git/osg/include/osg/Stencil"
    "/Users/maurizio/work/t11/git/osg/include/osg/StencilTwoSided"
    "/Users/maurizio/work/t11/git/osg/include/osg/Switch"
    "/Users/maurizio/work/t11/git/osg/include/osg/TemplatePrimitiveFunctor"
    "/Users/maurizio/work/t11/git/osg/include/osg/TexEnv"
    "/Users/maurizio/work/t11/git/osg/include/osg/TexEnvCombine"
    "/Users/maurizio/work/t11/git/osg/include/osg/TexEnvFilter"
    "/Users/maurizio/work/t11/git/osg/include/osg/TexGen"
    "/Users/maurizio/work/t11/git/osg/include/osg/TexGenNode"
    "/Users/maurizio/work/t11/git/osg/include/osg/TexMat"
    "/Users/maurizio/work/t11/git/osg/include/osg/Texture"
    "/Users/maurizio/work/t11/git/osg/include/osg/Texture1D"
    "/Users/maurizio/work/t11/git/osg/include/osg/Texture2D"
    "/Users/maurizio/work/t11/git/osg/include/osg/Texture2DMultisample"
    "/Users/maurizio/work/t11/git/osg/include/osg/Texture2DArray"
    "/Users/maurizio/work/t11/git/osg/include/osg/Texture3D"
    "/Users/maurizio/work/t11/git/osg/include/osg/TextureCubeMap"
    "/Users/maurizio/work/t11/git/osg/include/osg/TextureRectangle"
    "/Users/maurizio/work/t11/git/osg/include/osg/Timer"
    "/Users/maurizio/work/t11/git/osg/include/osg/TransferFunction"
    "/Users/maurizio/work/t11/git/osg/include/osg/Transform"
    "/Users/maurizio/work/t11/git/osg/include/osg/TriangleFunctor"
    "/Users/maurizio/work/t11/git/osg/include/osg/TriangleIndexFunctor"
    "/Users/maurizio/work/t11/git/osg/include/osg/Uniform"
    "/Users/maurizio/work/t11/git/osg/include/osg/UserDataContainer"
    "/Users/maurizio/work/t11/git/osg/include/osg/ValueObject"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec2"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec2b"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec2d"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec2f"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec2s"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec3"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec3b"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec3d"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec3f"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec3s"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec4"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec4b"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec4d"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec4f"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec4s"
    "/Users/maurizio/work/t11/git/osg/include/osg/Vec4ub"
    "/Users/maurizio/work/t11/git/osg/include/osg/Version"
    "/Users/maurizio/work/t11/git/osg/include/osg/VertexProgram"
    "/Users/maurizio/work/t11/git/osg/include/osg/View"
    "/Users/maurizio/work/t11/git/osg/include/osg/Viewport"
    "/Users/maurizio/work/t11/git/osg/include/osg/Config"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "libopenscenegraph-dev")

