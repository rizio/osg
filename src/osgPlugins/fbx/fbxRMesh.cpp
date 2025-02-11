#include <cassert>
#include <sstream>

#include <osg/BlendFunc>
#include <osg/Geode>
#include <osg/Image>
#include <osg/MatrixTransform>
#include <osg/TexMat>
#include <osg/TexGen>
#include <osg/TexEnvCombine>

#include <osgUtil/TriStripVisitor>
#include <osgUtil/Tessellator>

#include <osgDB/ReadFile>

#include <osgAnimation/RigGeometry>
#include <osgAnimation/MorphGeometry>
#include <osgAnimation/BasicAnimationManager>

#if defined(_MSC_VER)
#pragma warning( disable : 4505 )
#endif
#include <fbxsdk.h>

#include "fbxReader.h"

enum GeometryType
{
    GEOMETRY_STATIC,
    GEOMETRY_RIG,
    GEOMETRY_MORPH
};

osg::Vec3d convertVec3(const KFbxVector4& v)
{
    return osg::Vec3d(
        v[0],
        v[1],
        v[2]);
}

template <typename T>
bool layerElementValid(const KFbxLayerElementTemplate<T>* pLayerElement)
{
    if (!pLayerElement)
        return false;

    switch (pLayerElement->GetMappingMode())
    {
    case KFbxLayerElement::eBY_CONTROL_POINT:
    case KFbxLayerElement::eBY_POLYGON_VERTEX:
    case KFbxLayerElement::eBY_POLYGON:
        break;
    default:
        return false;
    }

    switch (pLayerElement->GetReferenceMode())
    {
    case KFbxLayerElement::eDIRECT:
    case KFbxLayerElement::eINDEX_TO_DIRECT:
        return true;
    }

    return false;
}

template <typename T>
int getVertexIndex(const KFbxLayerElementTemplate<T>* pLayerElement,
    const KFbxMesh* fbxMesh,
    int nPolygon, int nPolyVertex, int nMeshVertex)
{
    int index = 0;

    switch (pLayerElement->GetMappingMode())
    {
    case KFbxLayerElement::eBY_CONTROL_POINT:
        index = fbxMesh->GetPolygonVertex(nPolygon, nPolyVertex);
        break;
    case KFbxLayerElement::eBY_POLYGON_VERTEX:
        index = nMeshVertex;
        break;
    case KFbxLayerElement::eBY_POLYGON:
        index = nPolygon;
        break;
    }

    if (pLayerElement->GetReferenceMode() == KFbxLayerElement::eDIRECT)
    {
        return index;
    }

    return pLayerElement->GetIndexArray().GetAt(index);
}

template <typename T>
int getPolygonIndex(const KFbxLayerElementTemplate<T>* pLayerElement, int nPolygon)
{
    if (pLayerElement &&
        pLayerElement->GetMappingMode() == KFbxLayerElement::eBY_POLYGON)
    {
        switch (pLayerElement->GetReferenceMode())
        {
        case KFbxLayerElement::eDIRECT:
            return nPolygon;
        case KFbxLayerElement::eINDEX_TO_DIRECT:
            return pLayerElement->GetIndexArray().GetAt(nPolygon);
        }
    }

    return 0;
}

template <typename FbxT>
FbxT getElement(const KFbxLayerElementTemplate<FbxT>* pLayerElement,
    const KFbxMesh* fbxMesh,
    int nPolygon, int nPolyVertex, int nMeshVertex)
{
    return pLayerElement->GetDirectArray().GetAt(getVertexIndex(
        pLayerElement, fbxMesh, nPolygon, nPolyVertex, nMeshVertex));
}

typedef std::map<unsigned, osg::ref_ptr<osg::Geometry> > GeometryMap;

osg::Array* createVec2Array(bool doublePrecision)
{
    if  (doublePrecision) return new osg::Vec2dArray;
    else return new osg::Vec2Array;
}
osg::Array* createVec3Array(bool doublePrecision)
{
    if  (doublePrecision) return new osg::Vec3dArray;
    else return new osg::Vec3Array;
}
osg::Array* createVec4Array(bool doublePrecision)
{
    if  (doublePrecision) return new osg::Vec4dArray;
    else return new osg::Vec4Array;
}

osg::Geometry* getGeometry(osg::Geode* pGeode, GeometryMap& geometryMap,
    std::vector<StateSetContent>& stateSetList,
    GeometryType gt, 
    unsigned int mti, 
    bool bNormal, 
    bool useDiffuseMap,
    bool useOpacityMap,
    bool useEmissiveMap,
    // more here...
    bool bColor, 
    const osgDB::Options& options,
    bool lightmapTextures)
{
    GeometryMap::iterator it = geometryMap.find(mti);

    if (it != geometryMap.end())
    {
        return it->second.get();
    }

    osg::ref_ptr<osg::Geometry> pGeometry;
    if (gt == GEOMETRY_MORPH)
    {
        pGeometry = new osgAnimation::MorphGeometry;
    }
    else
    {
        pGeometry = new osg::Geometry;
    }

    osgDB::Options::PrecisionHint precision = options.getPrecisionHint();

    pGeometry->setVertexData(osg::Geometry::ArrayData(createVec3Array((precision & osgDB::Options::DOUBLE_PRECISION_VERTEX) != 0), osg::Geometry::BIND_PER_VERTEX));
    if (bNormal) pGeometry->setNormalData(osg::Geometry::ArrayData(createVec3Array((precision & osgDB::Options::DOUBLE_PRECISION_NORMAL) != 0), osg::Geometry::BIND_PER_VERTEX));

    // create as much textures coordinates as needed...
    if (useDiffuseMap)
        pGeometry->setTexCoordData(StateSetContent::DIFFUSE_TEXTURE_UNIT, osg::Geometry::ArrayData(createVec2Array((precision & osgDB::Options::DOUBLE_PRECISION_TEX_COORD) != 0), osg::Geometry::BIND_PER_VERTEX));
    if (useOpacityMap)
        pGeometry->setTexCoordData(StateSetContent::OPACITY_TEXTURE_UNIT, osg::Geometry::ArrayData(createVec2Array((precision & osgDB::Options::DOUBLE_PRECISION_TEX_COORD) != 0), osg::Geometry::BIND_PER_VERTEX));
    if (useEmissiveMap)
        pGeometry->setTexCoordData(StateSetContent::EMISSIVE_TEXTURE_UNIT, osg::Geometry::ArrayData(createVec2Array((precision & osgDB::Options::DOUBLE_PRECISION_TEX_COORD) != 0), osg::Geometry::BIND_PER_VERTEX));
    // create more textures coordinates here...

    if (bColor) pGeometry->setColorData(osg::Geometry::ArrayData(createVec4Array((precision & osgDB::Options::DOUBLE_PRECISION_COLOR) != 0), osg::Geometry::BIND_PER_VERTEX));

    if (mti < stateSetList.size())
    {
        osg::StateSet* stateSet = pGeometry->getOrCreateStateSet();

        bool transparent = false;
        const StateSetContent& ssc = stateSetList[mti];

        // set material...
        if (osg::Material* pMaterial = ssc.material.get())
        {
            stateSet->setAttributeAndModes(pMaterial);
            transparent = pMaterial->getDiffuse(osg::Material::FRONT).w() < 1.0f;
        }

        // diffuse texture map...
        if (ssc.diffuseTexture)
        {
            stateSet->setTextureAttributeAndModes(StateSetContent::DIFFUSE_TEXTURE_UNIT, ssc.diffuseTexture.get());

            if (ssc.diffuseScaleU != 1.0 || ssc.diffuseScaleV != 1.0)
            {
                // set UV scaling...
                osg::ref_ptr<osg::TexMat> texmat = new osg::TexMat();
                osg::Matrix uvScaling;
                uvScaling.makeScale(osg::Vec3(ssc.diffuseScaleU, ssc.diffuseScaleV, 1.0));
                texmat->setMatrix(uvScaling);
                stateSet->setTextureAttributeAndModes(StateSetContent::DIFFUSE_TEXTURE_UNIT, texmat.get(), osg::StateAttribute::ON);
            }

            if (lightmapTextures)
            {
                double factor = ssc.diffuseFactor;
                osg::ref_ptr<osg::TexEnvCombine> texenv = new osg::TexEnvCombine();    
                texenv->setCombine_RGB(osg::TexEnvCombine::INTERPOLATE);
                texenv->setSource0_RGB(osg::TexEnvCombine::TEXTURE);
                texenv->setSource1_RGB(osg::TexEnvCombine::PREVIOUS);
                texenv->setSource2_RGB(osg::TexEnvCombine::CONSTANT);
                texenv->setConstantColor(osg::Vec4(factor, factor, factor, factor));
                stateSet->setTextureAttributeAndModes(StateSetContent::DIFFUSE_TEXTURE_UNIT, texenv.get(), osg::StateAttribute::ON);
            }

            // setup transparency
            if (!transparent && ssc.diffuseTexture->getImage())
                transparent = ssc.diffuseTexture->getImage()->isImageTranslucent();
        }

        // opacity texture map...
        if (ssc.opacityTexture)
        {
            stateSet->setTextureAttributeAndModes(StateSetContent::OPACITY_TEXTURE_UNIT, ssc.opacityTexture.get());

            if (ssc.opacityScaleU != 1.0 || ssc.opacityScaleV != 1.0)
            {
                // set UV scaling...
                osg::ref_ptr<osg::TexMat> texmat = new osg::TexMat();
                osg::Matrix uvScaling;
                uvScaling.makeScale(osg::Vec3(ssc.opacityScaleU, ssc.opacityScaleV, 1.0));
                texmat->setMatrix(uvScaling);
                stateSet->setTextureAttributeAndModes(StateSetContent::OPACITY_TEXTURE_UNIT, texmat.get(), osg::StateAttribute::ON);
            }

            // setup combiner for factor...
            //In practice factor will always be zero, hence the RGB of the
            //opacity map will be ignored. The alpha will modulate the previous alpha.
            double factor = ssc.opacityFactor;
            osg::ref_ptr<osg::TexEnvCombine> texenv = new osg::TexEnvCombine();    
            texenv->setCombine_RGB(osg::TexEnvCombine::INTERPOLATE);
            texenv->setSource0_RGB(osg::TexEnvCombine::TEXTURE);
            texenv->setSource1_RGB(osg::TexEnvCombine::PREVIOUS);
            texenv->setSource2_RGB(osg::TexEnvCombine::CONSTANT);
            texenv->setConstantColor(osg::Vec4(factor, factor, factor, factor));
            stateSet->setTextureAttributeAndModes(StateSetContent::OPACITY_TEXTURE_UNIT, texenv.get(), osg::StateAttribute::ON);

            // setup transparency...
            if (!transparent && ssc.opacityTexture->getImage())
                transparent = ssc.opacityTexture->getImage()->isImageTranslucent();
        }

        // reflection texture map...
        if (ssc.reflectionTexture)
        {
            stateSet->setTextureAttributeAndModes(StateSetContent::REFLECTION_TEXTURE_UNIT, ssc.reflectionTexture.get());

            // setup spherical map...
            osg::ref_ptr<osg::TexGen> texgen = new osg::TexGen();
            texgen->setMode(osg::TexGen::SPHERE_MAP);
            stateSet->setTextureAttributeAndModes(StateSetContent::REFLECTION_TEXTURE_UNIT, texgen.get(), osg::StateAttribute::ON);

            // setup combiner for factor...
            double factor = ssc.reflectionFactor;
            osg::ref_ptr<osg::TexEnvCombine> texenv = new osg::TexEnvCombine();    
            texenv->setCombine_RGB(osg::TexEnvCombine::INTERPOLATE);
            texenv->setSource0_RGB(osg::TexEnvCombine::TEXTURE);
            texenv->setSource1_RGB(osg::TexEnvCombine::PREVIOUS);
            texenv->setSource2_RGB(osg::TexEnvCombine::CONSTANT);
            texenv->setConstantColor(osg::Vec4(factor, factor, factor, factor));
            stateSet->setTextureAttributeAndModes(StateSetContent::REFLECTION_TEXTURE_UNIT, texenv.get(), osg::StateAttribute::ON);
        }

        // emissive texture map
        if (ssc.emissiveTexture)
        {
            if (ssc.emissiveScaleU != 1.0 || ssc.emissiveScaleV != 1.0)
            {
                // set UV scaling...
                osg::ref_ptr<osg::TexMat> texmat = new osg::TexMat();
                osg::Matrix uvScaling;
                uvScaling.makeScale(osg::Vec3(ssc.emissiveScaleU, ssc.emissiveScaleV, 1.0));
                texmat->setMatrix(uvScaling);
                stateSet->setTextureAttributeAndModes(StateSetContent::EMISSIVE_TEXTURE_UNIT, texmat.get(), osg::StateAttribute::ON);
            }

            stateSet->setTextureAttributeAndModes(StateSetContent::EMISSIVE_TEXTURE_UNIT, ssc.emissiveTexture.get());
        }

        // add more texture maps here...

        if (transparent)
        {
            stateSet->setRenderingHint(osg::StateSet::TRANSPARENT_BIN);
            stateSet->setAttributeAndModes(new osg::BlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA));
        }
    }

    geometryMap.insert(std::pair<unsigned, osg::ref_ptr<osg::Geometry> >(mti, pGeometry));
    pGeode->addDrawable(pGeometry.get());

    return pGeometry.get();
}

osgAnimation::VertexInfluence& getVertexInfluence(
    osgAnimation::VertexInfluenceMap& vim, const std::string& name)
{
    osgAnimation::VertexInfluenceMap::iterator it = vim.lower_bound(name);
    if (it == vim.end() || name != it->first)
    {
        it = vim.insert(it, osgAnimation::VertexInfluenceMap::value_type(
            name, osgAnimation::VertexInfluence()));
        it->second.setName(name);
    }
    return it->second;
}

void addChannel(
    osgAnimation::Channel* pChannel,
    osg::ref_ptr<osgAnimation::AnimationManagerBase>& pAnimManager,
    const char* pTakeName)
{
    if (!pChannel)
    {
        return;
    }

    if (!pAnimManager) pAnimManager = new osgAnimation::BasicAnimationManager;

    osgAnimation::Animation* pAnimation = 0;
    const osgAnimation::AnimationList& anims = pAnimManager->getAnimationList();
    for (size_t i = 0; i < anims.size(); ++i)
    {
        if (anims[i]->getName() == pTakeName)
        {
            pAnimation = anims[i].get();
        }
    }

    if (!pAnimation)
    {
        pAnimation = new osgAnimation::Animation;
        pAnimation->setName(pTakeName);
        pAnimManager->registerAnimation(pAnimation);
    }

    pAnimation->addChannel(pChannel);
}

void readAnimation(KFbxNode* pNode, KFbxScene& fbxScene, const std::string& targetName,
    osg::ref_ptr<osgAnimation::AnimationManagerBase>& pAnimationManager,
    KFbxMesh* pMesh, int nShape)
{
    for (int i = 0; i < fbxScene.GetSrcObjectCount(FBX_TYPE(KFbxAnimStack)); ++i)
    {
        KFbxAnimStack* pAnimStack = KFbxCast<KFbxAnimStack>(fbxScene.GetSrcObject(FBX_TYPE(KFbxAnimStack), i));

        int nbAnimLayers = pAnimStack->GetMemberCount(FBX_TYPE(KFbxAnimLayer));

        const char* pTakeName = pAnimStack->GetName();

        if (!pTakeName || !*pTakeName)
            continue;

        for (int j = 0; j < nbAnimLayers; j++)
        {
            KFbxAnimLayer* pAnimLayer = pAnimStack->GetMember(FBX_TYPE(KFbxAnimLayer), j);

            KFbxAnimCurve* pCurve = pMesh->GetShapeChannel(nShape, pAnimLayer);
            if (!pCurve)
            {
                continue;
            }

            int nKeys = pCurve->KeyGetCount();
            if (!nKeys)
            {
                continue;
            }

            osgAnimation::FloatLinearChannel* pChannel = new osgAnimation::FloatLinearChannel;
            std::vector<osgAnimation::TemplateKeyframe<float> >& keyFrameCntr = *pChannel->getOrCreateSampler()->getOrCreateKeyframeContainer();

            for (int k = 0; k < nKeys; ++k)
            {
                KFbxAnimCurveKey key = pCurve->KeyGet(k);
                double fTime = key.GetTime().GetSecondDouble();
                float fValue = static_cast<float>(key.GetValue() * 0.01);
                keyFrameCntr.push_back(osgAnimation::FloatKeyframe(fTime,fValue));
            }

            pChannel->setTargetName(targetName);
            std::stringstream ss;
            ss << nShape;
            pChannel->setName(ss.str());
            addChannel(pChannel, pAnimationManager, pTakeName);
        }
    }

    {
    }
}

void addBindMatrix(
    BindMatrixMap& boneBindMatrices,
    KFbxNode* pBone,
    const osg::Matrix& bindMatrix,
    osgAnimation::RigGeometry* pRigGeometry)
{
    boneBindMatrices.insert(BindMatrixMap::value_type(
        BindMatrixMap::key_type(pBone, pRigGeometry), bindMatrix));
}

void addVec2ArrayElement(osg::Array& a, const KFbxVector2& v)
{
    if (a.getType() == osg::Array::Vec2dArrayType)
    {
        static_cast<osg::Vec2dArray&>(a).push_back(osg::Vec2d(v[0], v[1]));
    }
    else
    {
        static_cast<osg::Vec2Array&>(a).push_back(osg::Vec2(
            static_cast<float>(v[0]),
            static_cast<float>(v[1])));
    }
}

void addVec3ArrayElement(osg::Array& a, const KFbxVector4& v)
{
    if (a.getType() == osg::Array::Vec3dArrayType)
    {
        static_cast<osg::Vec3dArray&>(a).push_back(osg::Vec3d(v[0], v[1], v[2]));
    }
    else
    {
        static_cast<osg::Vec3Array&>(a).push_back(osg::Vec3(
            static_cast<float>(v[0]),
            static_cast<float>(v[1]),
            static_cast<float>(v[2])));
    }
}

void addColorArrayElement(osg::Array& a, const KFbxColor& c)
{
    if (a.getType() == osg::Array::Vec4dArrayType)
    {
        static_cast<osg::Vec4dArray&>(a).push_back(osg::Vec4d(c.mRed, c.mGreen, c.mBlue, c.mAlpha));
    }
    else
    {
        static_cast<osg::Vec4Array&>(a).push_back(osg::Vec4(
            static_cast<float>(c.mRed),
            static_cast<float>(c.mGreen),
            static_cast<float>(c.mBlue),
            static_cast<float>(c.mAlpha)));
    }
}

// scans StateSetList looking for the (first) channel name for the specified map type...
std::string getUVChannelForTextureMap(std::vector<StateSetContent>& stateSetList, const char* pName)
{
    // will return the first occurrence in the state set list...
    // TODO: what if more than one channel for the same map type?
    for (unsigned int i = 0; i < stateSetList.size(); i++)
    {
        if (0 == strcmp(pName, KFbxSurfaceMaterial::sDiffuse))
            return stateSetList[i].diffuseChannel;
        if (0 == strcmp(pName, KFbxSurfaceMaterial::sTransparentColor))
            return stateSetList[i].opacityChannel;
        if (0 == strcmp(pName, KFbxSurfaceMaterial::sReflection))
            return stateSetList[i].reflectionChannel;
        if (0 == strcmp(pName, KFbxSurfaceMaterial::sEmissive))
            return stateSetList[i].emissiveChannel;
        // more here...
    }

    return "";
}

// scans mesh layers looking for the UV element corresponding to the specified channel name...
const KFbxLayerElementUV* getUVElementForChannel(std::string uvChannelName,
    KFbxLayerElement::ELayerElementType elementType, KFbxMesh* pFbxMesh)
{
    // scan layers for specified UV channel...
    for (int cLayerIndex = 0; cLayerIndex < pFbxMesh->GetLayerCount(); cLayerIndex++)
    {
        const KFbxLayer* pFbxLayer = pFbxMesh->GetLayer(cLayerIndex);
        if (!pFbxLayer)
            continue;

        if (const KFbxLayerElementUV* uv = pFbxLayer->GetUVs())
        {
            if (0 == uvChannelName.compare(uv->GetName()))
                return uv;
        }
    }

    for (int cLayerIndex = 0; cLayerIndex < pFbxMesh->GetLayerCount(); cLayerIndex++)
    {
        const KFbxLayer* pFbxLayer = pFbxMesh->GetLayer(cLayerIndex);
        if (!pFbxLayer)
            continue;

        if (const KFbxLayerElementUV* uv = pFbxLayer->GetUVs(elementType))
        {
            return uv;
        }
    }    

    return 0;
}

typedef std::pair<osg::Geometry*, int> GIPair;
typedef std::multimap<int, GIPair> FbxToOsgVertexMap;
typedef std::map<GIPair, int> OsgToFbxNormalMap;

void readMeshTriangle(const KFbxMesh * fbxMesh, int i /*polygonIndex*/,
                      int posInPoly0, int posInPoly1, int posInPoly2,
                      int meshVertex0, int meshVertex1, int meshVertex2,
                      FbxToOsgVertexMap& fbxToOsgVertMap,
                      OsgToFbxNormalMap& osgToFbxNormMap,
                      const KFbxVector4* pFbxVertices,
                      const KFbxLayerElementNormal* pFbxNormals,
                      const KFbxLayerElementUV* pFbxUVs_diffuse,
                      const KFbxLayerElementUV* pFbxUVs_opacity,
                      const KFbxLayerElementUV* pFbxUVs_emissive,
                      const KFbxLayerElementVertexColor* pFbxColors,
                      osg::Geometry* pGeometry,
                      osg::Array* pVertices,
                      osg::Array* pNormals,
                      osg::Array* pTexCoords_diffuse,
                      osg::Array* pTexCoords_opacity,
                      osg::Array* pTexCoords_emissive,
                      osg::Array* pColors)
{
    int v0 = fbxMesh->GetPolygonVertex(i, posInPoly0),
        v1 = fbxMesh->GetPolygonVertex(i, posInPoly1),
        v2 = fbxMesh->GetPolygonVertex(i, posInPoly2);

    fbxToOsgVertMap.insert(FbxToOsgVertexMap::value_type(v0, GIPair(pGeometry, pVertices->getNumElements())));
    fbxToOsgVertMap.insert(FbxToOsgVertexMap::value_type(v1, GIPair(pGeometry, pVertices->getNumElements() + 1)));
    fbxToOsgVertMap.insert(FbxToOsgVertexMap::value_type(v2, GIPair(pGeometry, pVertices->getNumElements() + 2)));

    addVec3ArrayElement(*pVertices, pFbxVertices[v0]);
    addVec3ArrayElement(*pVertices, pFbxVertices[v1]);
    addVec3ArrayElement(*pVertices, pFbxVertices[v2]);

    if (pNormals)
    {
        int n0 = getVertexIndex(pFbxNormals, fbxMesh, i, posInPoly0, meshVertex0);
        int n1 = getVertexIndex(pFbxNormals, fbxMesh, i, posInPoly1, meshVertex1);
        int n2 = getVertexIndex(pFbxNormals, fbxMesh, i, posInPoly2, meshVertex2);

        osgToFbxNormMap.insert(OsgToFbxNormalMap::value_type(GIPair(pGeometry, pNormals->getNumElements()), n0));
        osgToFbxNormMap.insert(OsgToFbxNormalMap::value_type(GIPair(pGeometry, pNormals->getNumElements() + 1), n1));
        osgToFbxNormMap.insert(OsgToFbxNormalMap::value_type(GIPair(pGeometry, pNormals->getNumElements() + 2), n2));

        addVec3ArrayElement(*pNormals, pFbxNormals->GetDirectArray().GetAt(n0));
        addVec3ArrayElement(*pNormals, pFbxNormals->GetDirectArray().GetAt(n1));
        addVec3ArrayElement(*pNormals, pFbxNormals->GetDirectArray().GetAt(n2));
    }

    // add texture maps data (avoid duplicates)...
    if (pTexCoords_diffuse)
    {
        addVec2ArrayElement(*pTexCoords_diffuse, getElement(pFbxUVs_diffuse, fbxMesh, i, posInPoly0, meshVertex0));
        addVec2ArrayElement(*pTexCoords_diffuse, getElement(pFbxUVs_diffuse, fbxMesh, i, posInPoly1, meshVertex1));
        addVec2ArrayElement(*pTexCoords_diffuse, getElement(pFbxUVs_diffuse, fbxMesh, i, posInPoly2, meshVertex2));
    }
    if (pTexCoords_opacity && (pTexCoords_opacity != pTexCoords_diffuse))
    {
        addVec2ArrayElement(*pTexCoords_opacity, getElement(pFbxUVs_opacity, fbxMesh, i, posInPoly0, meshVertex0));
        addVec2ArrayElement(*pTexCoords_opacity, getElement(pFbxUVs_opacity, fbxMesh, i, posInPoly1, meshVertex1));
        addVec2ArrayElement(*pTexCoords_opacity, getElement(pFbxUVs_opacity, fbxMesh, i, posInPoly2, meshVertex2));
    }

    // Only spherical reflection maps are supported (so do not add coordinates for the reflection map)

    if (pTexCoords_emissive && (pTexCoords_emissive != pTexCoords_opacity) && (pTexCoords_emissive != pTexCoords_diffuse))
    {
        addVec2ArrayElement(*pTexCoords_emissive, getElement(pFbxUVs_emissive, fbxMesh, i, posInPoly0, meshVertex0));
        addVec2ArrayElement(*pTexCoords_emissive, getElement(pFbxUVs_emissive, fbxMesh, i, posInPoly1, meshVertex1));
        addVec2ArrayElement(*pTexCoords_emissive, getElement(pFbxUVs_emissive, fbxMesh, i, posInPoly2, meshVertex2));
    }
    // add more texture maps here...

    if (pColors)
    {
        addColorArrayElement(*pColors, getElement(pFbxColors, fbxMesh, i, posInPoly0, meshVertex0));
        addColorArrayElement(*pColors, getElement(pFbxColors, fbxMesh, i, posInPoly1, meshVertex1));
        addColorArrayElement(*pColors, getElement(pFbxColors, fbxMesh, i, posInPoly2, meshVertex2));
    }
}

/// Says if a quad should be split using vertices 02 (or else 13)
bool quadSplit02(const KFbxMesh * fbxMesh, int i /*polygonIndex*/,
                 int posInPoly0, int posInPoly1, int posInPoly2, int posInPoly3,
                 const KFbxVector4* pFbxVertices)
{
    // Algorithm may be a bit dumb. If you got a faster one, feel free to change.
    // Here we test each of the 4 triangles and see if there is one in the opposite direction.
    //        Triangles: 012, 023, 013, 123
    // For this, we do a cross product to get normals. We say here the first triangle is the reference, and do a dot product to see the direction.
    //        Normals: na (= (p1-p0)^(p2-p1)), nb, na, nd
    //        Dot products: rb (na.nb), rc, rd
    // Results:
    //        if r*>0 => convex (02 and 13 are ok, so choose 02)
    //        if rb only <0, or r*<0 => concave, split on 13
    //        if rc only <0, or rd<0 => concave, split on 02
    //        else unhandled (crossed polygon?) => choose 02
    //    In short:
    //        if rb only <0, or r*<0 => return false
    //        else return true

    int v0 = fbxMesh->GetPolygonVertex(i, posInPoly0);
    int v1 = fbxMesh->GetPolygonVertex(i, posInPoly1);
    int v2 = fbxMesh->GetPolygonVertex(i, posInPoly2);
    int v3 = fbxMesh->GetPolygonVertex(i, posInPoly3);

    osg::Vec3d p0(pFbxVertices[v0][0], pFbxVertices[v0][1], pFbxVertices[v0][2]);
    osg::Vec3d p1(pFbxVertices[v1][0], pFbxVertices[v1][1], pFbxVertices[v1][2]);
    osg::Vec3d p2(pFbxVertices[v2][0], pFbxVertices[v2][1], pFbxVertices[v2][2]);
    osg::Vec3d p3(pFbxVertices[v3][0], pFbxVertices[v3][1], pFbxVertices[v3][2]);

    osg::Vec3d na((p1 - p0) ^ (p2 - p1));
    osg::Vec3d nb((p2 - p0) ^ (p3 - p2));

    double rb(na * nb);
    if (rb >= 0) return true;        // Split at 02

    osg::Vec3d nc((p1 - p0) ^ (p3 - p1));
    osg::Vec3d nd((p2 - p1) ^ (p3 - p2));
    double rc(na * nc);
    double rd(na * nd);
    return (rc >= 0 || rd >= 0);
}

struct PolygonRef
{
    PolygonRef(osg::Geometry* pGeometry, int numPoly, int nVertex)
        : pGeometry(pGeometry), numPoly(numPoly), nVertex(nVertex)
    {}
    osg::Geometry* pGeometry;
    int numPoly;
    int nVertex;
};
typedef std::vector<PolygonRef> PolygonRefList;

osgDB::ReaderWriter::ReadResult OsgFbxReader::readMesh(
    KFbxNode* pNode,
    KFbxMesh* fbxMesh,
    std::vector<StateSetContent>& stateSetList,
    const char* szName)
{
    GeometryMap geometryMap;

    osg::Geode* pGeode = new osg::Geode;
    pGeode->setName(szName);

    const KFbxLayerElementNormal* pFbxNormals = 0;
    const KFbxLayerElementVertexColor* pFbxColors = 0;
    const KFbxLayerElementMaterial* pFbxMaterials = 0;

    const KFbxVector4* pFbxVertices = fbxMesh->GetControlPoints();

    // scan layers for Normals, Colors and Materials elements (this will get the first available elements)...
    for (int cLayerIndex = 0; cLayerIndex < fbxMesh->GetLayerCount(); cLayerIndex++)
    {
        const KFbxLayer* pFbxLayer = fbxMesh->GetLayer(cLayerIndex);
        if (!pFbxLayer)
            continue;

        // get normals, colors and materials...
        if (!pFbxNormals)
            pFbxNormals = pFbxLayer->GetNormals();
        if (!pFbxColors)
            pFbxColors = pFbxLayer->GetVertexColors();
        if (!pFbxMaterials)
            pFbxMaterials = pFbxLayer->GetMaterials();
    }

    // look for UV elements (diffuse, opacity, reflection, emissive, ...) and get their channels names...
    std::string diffuseChannel = getUVChannelForTextureMap(stateSetList, KFbxSurfaceMaterial::sDiffuse);
    std::string opacityChannel = getUVChannelForTextureMap(stateSetList, KFbxSurfaceMaterial::sTransparentColor);
    std::string emissiveChannel = getUVChannelForTextureMap(stateSetList, KFbxSurfaceMaterial::sEmissive);
    // look for more UV elements here...

    // UV elements...
    const KFbxLayerElementUV* pFbxUVs_diffuse = getUVElementForChannel(diffuseChannel, KFbxLayerElement::eDIFFUSE_TEXTURES, fbxMesh);
    const KFbxLayerElementUV* pFbxUVs_opacity = getUVElementForChannel(opacityChannel, KFbxLayerElement::eTRANSPARENT_TEXTURES, fbxMesh);
    const KFbxLayerElementUV* pFbxUVs_emissive = getUVElementForChannel(emissiveChannel, KFbxLayerElement::eEMISSIVE_TEXTURES, fbxMesh);
    // more UV elements here...

    // check elements validity...
    if (!layerElementValid(pFbxNormals)) pFbxNormals = 0;
    if (!layerElementValid(pFbxColors)) pFbxColors = 0;

    if (!layerElementValid(pFbxUVs_diffuse)) pFbxUVs_diffuse = 0;
    if (!layerElementValid(pFbxUVs_opacity)) pFbxUVs_opacity = 0;
    if (!layerElementValid(pFbxUVs_emissive)) pFbxUVs_emissive = 0;
    // more here...

    int nPolys = fbxMesh->GetPolygonCount();

    int nDeformerCount = fbxMesh->GetDeformerCount(KFbxDeformer::eSKIN);
    int nMorphShapeCount = 0;

    GeometryType geomType = GEOMETRY_STATIC;

    //determine the type of geometry
    if (nDeformerCount)
    {
        geomType = GEOMETRY_RIG;
    }
    else if (nMorphShapeCount = fbxMesh->GetShapeCount())
    {
        geomType = GEOMETRY_MORPH;
    }

    FbxToOsgVertexMap fbxToOsgVertMap;
    OsgToFbxNormalMap osgToFbxNormMap;

    // First add only triangles and quads (easy to split into triangles without
    // more processing)
    // This is the reason we store polygons references:

    PolygonRefList polygonRefList;

    for (int i = 0, nVertex = 0; i < nPolys; ++i)
    {
        int lPolygonSize = fbxMesh->GetPolygonSize(i);

        int materialIndex = getPolygonIndex(pFbxMaterials, i);

        osg::Geometry* pGeometry = getGeometry(pGeode, geometryMap,
            stateSetList, geomType, materialIndex,
            pFbxNormals != 0, 
            pFbxUVs_diffuse != 0,
            pFbxUVs_opacity != 0,
            pFbxUVs_emissive != 0,
            // more UV elements here...
            pFbxColors != 0,
            options,
            lightmapTextures);

        osg::Array* pVertices = pGeometry->getVertexArray();
        osg::Array* pNormals = pGeometry->getNormalArray();

        // get texture coordinates...
        osg::Array* pTexCoords_diffuse = pGeometry->getTexCoordArray(StateSetContent::DIFFUSE_TEXTURE_UNIT);
        osg::Array* pTexCoords_opacity = pGeometry->getTexCoordArray(StateSetContent::OPACITY_TEXTURE_UNIT);
        osg::Array* pTexCoords_emissive = pGeometry->getTexCoordArray(StateSetContent::EMISSIVE_TEXTURE_UNIT);
        // more texture coordinates here...

        osg::Array* pColors = pGeometry->getColorArray();

        if (lPolygonSize == 3)
        {
            // Triangle
            readMeshTriangle(fbxMesh, i,
                0, 1, 2,
                nVertex, nVertex+1, nVertex+2,
                fbxToOsgVertMap, osgToFbxNormMap,
                pFbxVertices, pFbxNormals, pFbxUVs_diffuse, pFbxUVs_opacity, pFbxUVs_emissive, pFbxColors,
                pGeometry,
                pVertices, pNormals, pTexCoords_diffuse, pTexCoords_opacity, pTexCoords_emissive, pColors);
            nVertex += 3;
        }
        else if (lPolygonSize == 4)
        {
            // Quad - Convert to triangles
            // Use some fast specialized code to see how the should be decomposed
            // Two cases : Split at '02' (012 and 023), or split at '13 (013 and 123)
            bool split02 = quadSplit02(fbxMesh, i, 0, 1, 2, 3, pFbxVertices);
            int p02 = split02 ? 2 : 3; // Triangle 0, point 2
            int p10 = split02 ? 0 : 1; // Triangle 1, point 0
            readMeshTriangle(fbxMesh, i,
                0, 1, p02,
                nVertex, nVertex+1, nVertex+p02,
                fbxToOsgVertMap, osgToFbxNormMap,
                pFbxVertices, pFbxNormals, pFbxUVs_diffuse, pFbxUVs_opacity, pFbxUVs_emissive, pFbxColors,
                pGeometry,
                pVertices, pNormals, pTexCoords_diffuse, pTexCoords_opacity, pTexCoords_emissive, pColors);
            readMeshTriangle(fbxMesh, i,
                p10, 2, 3,
                nVertex+p10, nVertex+2, nVertex+3,
                fbxToOsgVertMap, osgToFbxNormMap,
                pFbxVertices, pFbxNormals, pFbxUVs_diffuse, pFbxUVs_opacity, pFbxUVs_emissive, pFbxColors,
                pGeometry,
                pVertices, pNormals, pTexCoords_diffuse, pTexCoords_opacity, pTexCoords_emissive, pColors);
            nVertex += 4;
        }
        else if (tessellatePolygons)
        {
            // Polygons - Store to add after triangles
            polygonRefList.push_back(PolygonRef(pGeometry, i, nVertex));
            nVertex += lPolygonSize;
		}
		else
		{
            int nVertex0 = nVertex;
            nVertex += (std::min)(2, lPolygonSize);

            for (int j = 2; j < lPolygonSize; ++j, ++nVertex)
            {
                readMeshTriangle(fbxMesh, i,
                    0, j - 1, j,
                    nVertex0, nVertex - 1, nVertex,
                    fbxToOsgVertMap, osgToFbxNormMap,
                    pFbxVertices, pFbxNormals, pFbxUVs_diffuse, pFbxUVs_opacity, pFbxUVs_emissive, pFbxColors,
                    pGeometry,
                    pVertices, pNormals, pTexCoords_diffuse, pTexCoords_opacity, pTexCoords_emissive, pColors);
            }
        }
    }

    for (unsigned i = 0; i < pGeode->getNumDrawables(); ++i)
    {
        osg::Geometry* pGeometry = pGeode->getDrawable(i)->asGeometry();
        osg::DrawArrays* pDrawArrays = new osg::DrawArrays(
            GL_TRIANGLES, 0, pGeometry->getVertexArray()->getNumElements());
        pGeometry->addPrimitiveSet(pDrawArrays);
    }

    // Now add polygons - Convert to triangles
    // We put vertices in their own PrimitiveSet with Mode=POLYGON; then run the
    // Tessellator on the Geometry which should tessellate the polygons
    // automagically.
    for (PolygonRefList::iterator it = polygonRefList.begin(), itEnd=polygonRefList.end();
        it != itEnd; ++it)
    {
        int i = it->numPoly;
        int lPolygonSize = fbxMesh->GetPolygonSize(i);
        //int materialIndex = getPolygonIndex(pFbxMaterials, i);
        osg::Geometry* pGeometry = it->pGeometry;

        osg::Array* pVertices = pGeometry->getVertexArray();
        osg::Array* pNormals = pGeometry->getNormalArray();
        osg::Array* pTexCoords_diffuse = pGeometry->getTexCoordArray(StateSetContent::DIFFUSE_TEXTURE_UNIT);
        osg::Array* pTexCoords_opacity = pGeometry->getTexCoordArray(StateSetContent::OPACITY_TEXTURE_UNIT);
        osg::Array* pTexCoords_emissive = pGeometry->getTexCoordArray(StateSetContent::EMISSIVE_TEXTURE_UNIT);
        osg::Array* pColors = pGeometry->getColorArray();
        // Index of the 1st vertex of the polygon in the geometry
        int osgVertex0 = pVertices->getNumElements();

        for (int j = 0, nVertex = it->nVertex; j<lPolygonSize; ++j, ++nVertex)
        {
            int v0 = fbxMesh->GetPolygonVertex(i, j);
            fbxToOsgVertMap.insert(FbxToOsgVertexMap::value_type(v0, GIPair(pGeometry, pVertices->getNumElements())));
            addVec3ArrayElement(*pVertices, pFbxVertices[v0]);
            if (pNormals)
            {
                int n0 = getVertexIndex(pFbxNormals, fbxMesh, i, j, nVertex);
                osgToFbxNormMap.insert(OsgToFbxNormalMap::value_type(GIPair(pGeometry, pNormals->getNumElements()), n0));
                addVec3ArrayElement(*pNormals, pFbxNormals->GetDirectArray().GetAt(n0));
            }

            // add texture maps data (avoid duplicates)...
            if (pTexCoords_diffuse)
            {
                addVec2ArrayElement(*pTexCoords_diffuse, getElement(pFbxUVs_diffuse, fbxMesh, i, j, nVertex));
            }
            if (pTexCoords_opacity && (pTexCoords_opacity != pTexCoords_diffuse))
            {
                addVec2ArrayElement(*pTexCoords_opacity, getElement(pFbxUVs_opacity, fbxMesh, i, j, nVertex));
            }

            // Only spherical reflection maps are supported (so do not add coordinates for the reflection map)

            if (pTexCoords_emissive && (pTexCoords_emissive != pTexCoords_opacity) && (pTexCoords_emissive != pTexCoords_diffuse))
            {
                addVec2ArrayElement(*pTexCoords_emissive, getElement(pFbxUVs_emissive, fbxMesh, i, j, nVertex));
            }
            // add more texture maps here...

            if (pColors)
            {
                addColorArrayElement(*pColors, getElement(pFbxColors, fbxMesh, i, j, nVertex));
            }
        }

        osg::DrawArrays* pDrawArrays = new osg::DrawArrays(
            GL_POLYGON, osgVertex0, pGeometry->getVertexArray()->getNumElements() - osgVertex0);
        pGeometry->addPrimitiveSet(pDrawArrays);
    }

    for (unsigned i = 0; i < pGeode->getNumDrawables(); ++i)
    {
        osg::Geometry* pGeometry = pGeode->getDrawable(i)->asGeometry();

        // Now split polygons if necessary
        osgUtil::Tessellator tessellator;
        tessellator.retessellatePolygons(*pGeometry);

        if (pGeode->getNumDrawables() > 1)
        {
            std::stringstream ss;
            ss << pGeode->getName() << " " << i + 1;
            pGeometry->setName(ss.str());
        }
        else
        {
            pGeometry->setName(pGeode->getName());
        }
    }

    if (geomType == GEOMETRY_RIG)
    {
        typedef std::map<osg::ref_ptr<osg::Geometry>,
            osg::ref_ptr<osgAnimation::RigGeometry> > GeometryRigGeometryMap;
        GeometryRigGeometryMap old2newGeometryMap;

        for (unsigned i = 0; i < pGeode->getNumDrawables(); ++i)
        {
            osg::Geometry* pGeometry = pGeode->getDrawable(i)->asGeometry();

            osgAnimation::RigGeometry* pRig = new osgAnimation::RigGeometry;
            pRig->setSourceGeometry(pGeometry);
            pRig->copyFrom(*pGeometry);
            old2newGeometryMap.insert(GeometryRigGeometryMap::value_type(
                pGeometry, pRig));
            pRig->setDataVariance(osg::Object::DYNAMIC);
            pRig->setUseDisplayList( false );
            pGeode->setDrawable(i, pRig);

            pRig->setInfluenceMap(new osgAnimation::VertexInfluenceMap);
            pGeometry = pRig;
        }

        for (int i = 0; i < nDeformerCount; ++i)
        {
            KFbxSkin* pSkin = (KFbxSkin*)fbxMesh->GetDeformer(i, KFbxDeformer::eSKIN);
            int nClusters = pSkin->GetClusterCount();
            for (int j = 0; j < nClusters; ++j)
            {
                KFbxCluster* pCluster = (KFbxCluster*)pSkin->GetCluster(j);
                //assert(KFbxCluster::eNORMALIZE == pCluster->GetLinkMode());
                KFbxNode* pBone = pCluster->GetLink();

                KFbxXMatrix transformLink;
                pCluster->GetTransformLinkMatrix(transformLink);
                KFbxXMatrix transformLinkInverse = transformLink.Inverse();
                const double* pTransformLinkInverse = transformLinkInverse;
                osg::Matrix bindMatrix(pTransformLinkInverse);

                int nIndices = pCluster->GetControlPointIndicesCount();
                int* pIndices = pCluster->GetControlPointIndices();
                double* pWeights = pCluster->GetControlPointWeights();

                for (int k = 0; k < nIndices; ++k)
                {
                    int fbxIndex = pIndices[k];
                    float weight = static_cast<float>(pWeights[k]);

                    for (FbxToOsgVertexMap::const_iterator it =
                        fbxToOsgVertMap.find(fbxIndex);
                        it != fbxToOsgVertMap.end() &&
                        it->first == fbxIndex; ++it)
                    {
                        GIPair gi = it->second;
                        osgAnimation::RigGeometry& rig =
                            dynamic_cast<osgAnimation::RigGeometry&>(
                            *old2newGeometryMap[gi.first]);
                        addBindMatrix(boneBindMatrices, pBone, bindMatrix, &rig);
                        osgAnimation::VertexInfluenceMap& vim =
                            *rig.getInfluenceMap();
                        osgAnimation::VertexInfluence& vi =
                            getVertexInfluence(vim, pBone->GetName());
                        vi.push_back(osgAnimation::VertexIndexWeight(
                            gi.second, weight));
                    }
                }
            }
        }
    }
    else if (geomType == GEOMETRY_MORPH)
    {
        for (unsigned i = 0; i < pGeode->getNumDrawables(); ++i)
        {
            osg::Geometry* pGeometry = pGeode->getDrawable(i)->asGeometry();

            osgAnimation::MorphGeometry& morph = dynamic_cast<osgAnimation::MorphGeometry&>(*pGeometry);

            pGeode->addUpdateCallback(new osgAnimation::UpdateMorph(morph.getName()));

            //read morph geometry
            for (int j = 0; j < nMorphShapeCount; ++j)
            {
                const KFbxGeometryBase* pMorphShape = fbxMesh->GetShape(i);

                const KFbxLayerElementNormal* pFbxShapeNormals = 0;
                if (const KFbxLayer* pFbxShapeLayer = pMorphShape->GetLayer(0))
                {
                    pFbxShapeNormals = pFbxShapeLayer->GetNormals();
                    if (!layerElementValid(pFbxShapeNormals)) pFbxShapeNormals = 0;
                }

                osg::Geometry* pMorphTarget = new osg::Geometry(morph);
                pMorphTarget->setVertexArray(static_cast<osg::Array*>(
                    pMorphTarget->getVertexArray()->clone(osg::CopyOp::DEEP_COPY_ARRAYS)));
                if (pFbxShapeNormals)
                {
                    if (osg::Array* pNormals = pMorphTarget->getNormalArray())
                    {
                        pMorphTarget->setNormalArray(static_cast<osg::Array*>(
                            pNormals->clone(osg::CopyOp::DEEP_COPY_ARRAYS)));
                    }
                }
                pMorphTarget->setName(fbxMesh->GetShapeName(j));
                morph.addMorphTarget(pMorphTarget, 0.0f);

                readAnimation(pNode, fbxScene, morph.getName(), pAnimationManager, fbxMesh, j);
            }
        }

        for (int i = 0; i < nMorphShapeCount; ++i)
        {
            const KFbxGeometryBase* pMorphShape = fbxMesh->GetShape(i);

            const KFbxLayerElementNormal* pFbxShapeNormals = 0;
            if (const KFbxLayer* pFbxShapeLayer = pMorphShape->GetLayer(0))
            {
                pFbxShapeNormals = pFbxShapeLayer->GetNormals();
                if (!layerElementValid(pFbxShapeNormals)) pFbxShapeNormals = 0;
            }

            const KFbxVector4* pControlPoints = pMorphShape->GetControlPoints();
            int nControlPoints = pMorphShape->GetControlPointsCount();
            for (int fbxIndex = 0; fbxIndex < nControlPoints; ++fbxIndex)
            {
                osg::Vec3d vPos = convertVec3(pControlPoints[fbxIndex]);
                for (FbxToOsgVertexMap::const_iterator it =
                    fbxToOsgVertMap.find(fbxIndex);
                    it != fbxToOsgVertMap.end() &&
                    it->first == fbxIndex; ++it)
                {
                    GIPair gi = it->second;
                    osgAnimation::MorphGeometry& morphGeom =
                        dynamic_cast<osgAnimation::MorphGeometry&>(*gi.first);
                    osg::Geometry* pGeometry = morphGeom.getMorphTarget(i).getGeometry();

                    if (pGeometry->getVertexArray()->getType() == osg::Array::Vec3dArrayType)
                    {
                        osg::Vec3dArray* pVertices = static_cast<osg::Vec3dArray*>(pGeometry->getVertexArray());
                        (*pVertices)[gi.second] = vPos;
                    }
                    else
                    {
                        osg::Vec3Array* pVertices = static_cast<osg::Vec3Array*>(pGeometry->getVertexArray());
                        (*pVertices)[gi.second] = vPos;
                    }

                    if (pFbxShapeNormals && pGeometry->getNormalArray())
                    {
                        if (pGeometry->getNormalArray()->getType() == osg::Array::Vec3dArrayType)
                        {
                            osg::Vec3dArray* pNormals = static_cast<osg::Vec3dArray*>(pGeometry->getNormalArray());
                            (*pNormals)[gi.second] = convertVec3(
                                pFbxShapeNormals->GetDirectArray().GetAt(osgToFbxNormMap[gi]));
                        }
                        else
                        {
                            osg::Vec3Array* pNormals = static_cast<osg::Vec3Array*>(pGeometry->getNormalArray());
                            (*pNormals)[gi.second] = convertVec3(
                                pFbxShapeNormals->GetDirectArray().GetAt(osgToFbxNormMap[gi]));
                        }
                    }
                }
            }
        }
    }

    KFbxXMatrix fbxGeometricTransform;
    fbxGeometricTransform.SetTRS(
        pNode->GeometricTranslation.Get(),
        pNode->GeometricRotation.Get(),
        pNode->GeometricScaling.Get());
    const double* pGeometricMat = fbxGeometricTransform;
    osg::Matrix osgGeometricTransform(pGeometricMat);

    if (geomType == GEOMETRY_RIG)
    {
        KFbxSkin* pSkin = (KFbxSkin*)fbxMesh->GetDeformer(0, KFbxDeformer::eSKIN);
        if (pSkin->GetClusterCount())
        {
            KFbxXMatrix fbxTransformMatrix;
            pSkin->GetCluster(0)->GetTransformMatrix(fbxTransformMatrix);
            const double* pTransformMatrix = fbxTransformMatrix;
            osgGeometricTransform.postMult(osg::Matrix(pTransformMatrix));
        }
    }

    osg::Node* pResult = pGeode;

    if (!osgGeometricTransform.isIdentity())
    {
        osg::MatrixTransform* pMatTrans = new osg::MatrixTransform(osgGeometricTransform);
        pMatTrans->addChild(pGeode);
        pResult = pMatTrans;
    }

    if (geomType == GEOMETRY_RIG)
    {
        //Add the geometry to the skeleton ancestor of one of the bones.
        KFbxSkin* pSkin = (KFbxSkin*)fbxMesh->GetDeformer(0, KFbxDeformer::eSKIN);
        if (pSkin->GetClusterCount())
        {
            osgAnimation::Skeleton* pSkeleton = getSkeleton(
                pSkin->GetCluster(0)->GetLink(), fbxSkeletons, skeletonMap);
            pSkeleton->addChild(pResult);
            return osgDB::ReaderWriter::ReadResult::FILE_LOADED;
        }
    }

    return osgDB::ReaderWriter::ReadResult(pResult);
}

osgDB::ReaderWriter::ReadResult OsgFbxReader::readFbxMesh(KFbxNode* pNode,
    std::vector<StateSetContent>& stateSetList)
{
    KFbxMesh* lMesh = dynamic_cast<KFbxMesh*>(pNode->GetNodeAttribute());

    if (!lMesh)
    {
        return osgDB::ReaderWriter::ReadResult::ERROR_IN_READING_FILE;
    }

    return readMesh(pNode, lMesh, stateSetList,
        pNode->GetName());
}
