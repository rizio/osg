#include <osg/MatrixTransform>

#include <osgAnimation/Animation>
#include <osgAnimation/BasicAnimationManager>
#include <osgAnimation/Channel>
#include <osgAnimation/Sampler>

#if defined(_MSC_VER)
    #pragma warning( disable : 4505 )
#endif
#include <fbxsdk.h>
#include <fbxfilesdk/fbxfilesdk_nsuse.h>

#include "fbxReader.h"

osg::Quat makeQuat(const fbxDouble3&, ERotationOrder);

osg::Quat makeQuat(const osg::Vec3& radians, ERotationOrder fbxRotOrder)
{
    fbxDouble3 degrees(
        osg::RadiansToDegrees(radians.x()),
        osg::RadiansToDegrees(radians.y()),
        osg::RadiansToDegrees(radians.z()));
    return makeQuat(degrees, fbxRotOrder);
}

void readKeys(KFbxAnimCurve* curveX, KFbxAnimCurve* curveY, KFbxAnimCurve* curveZ,
              const fbxDouble3& defaultValue,
              std::vector<osgAnimation::TemplateKeyframe<osg::Vec3> >& keyFrameCntr, float scalar = 1.0f)
{
    KFbxAnimCurve* curves[3] = {curveX, curveY, curveZ};

    typedef std::set<double> TimeSet;
    typedef std::map<double, float> TimeFloatMap;
    TimeSet times;
    TimeFloatMap curveTimeMap[3];

    for (int nCurve = 0; nCurve < 3; ++nCurve)
    {
        KFbxAnimCurve* pCurve = curves[nCurve];
        
        int nKeys = pCurve ? pCurve->KeyGetCount() : 0;

        if (!nKeys)
        {
            times.insert(0.0);
            curveTimeMap[nCurve][0.0] = defaultValue[nCurve] * scalar;
        }

        for (int i = 0; i < nKeys; ++i)
        {
            KFbxAnimCurveKey key = pCurve->KeyGet(i);
            double fTime = key.GetTime().GetSecondDouble();
            times.insert(fTime);
            curveTimeMap[nCurve][fTime] = static_cast<float>(key.GetValue()) * scalar;
        }
    }

    for (TimeSet::iterator it = times.begin(); it != times.end(); ++it)
    {
        double fTime = *it;
        osg::Vec3 val;
        for (int i = 0; i < 3; ++i)
        {
            if (curveTimeMap[i].empty()) continue;

            TimeFloatMap::iterator lb = curveTimeMap[i].lower_bound(fTime);
            if (lb == curveTimeMap[i].end()) --lb;
            val[i] = lb->second;
        }
        keyFrameCntr.push_back(osgAnimation::Vec3Keyframe(fTime, val));
    }
}

void readKeys(KFbxAnimCurve* curveX, KFbxAnimCurve* curveY, KFbxAnimCurve* curveZ,
              const fbxDouble3& defaultValue,
              std::vector<osgAnimation::Vec3CubicBezierKeyframe>& keyFrameCntr, float scalar = 1.0f)
{
    KFbxAnimCurve* curves[3] = {curveX, curveY, curveZ};

    typedef std::set<double> TimeSet;
    typedef std::map<double, osgAnimation::FloatCubicBezier> TimeValueMap;
    TimeSet times;
    TimeValueMap curveTimeMap[3];

    for (int nCurve = 0; nCurve < 3; ++nCurve)
    {
        KFbxAnimCurve* pCurve = curves[nCurve];

        int nKeys = pCurve ? pCurve->KeyGetCount() : 0;

        if (!nKeys)
        {
            times.insert(0.0);
            curveTimeMap[nCurve][0.0] = osgAnimation::FloatCubicBezier(defaultValue[nCurve] * scalar);
        }

        for (int i = 0; i < nKeys; ++i)
        {
            double fTime = pCurve->KeyGetTime(i).GetSecondDouble();
            float val = pCurve->KeyGetValue(i);
            times.insert(fTime);
            KFCurveTangeantInfo leftTangent = pCurve->KeyGetLeftDerivativeInfo(i);
            KFCurveTangeantInfo rightTangent = pCurve->KeyGetRightDerivativeInfo(i);

            if (i > 0)
            {
                leftTangent.mDerivative *= fTime - pCurve->KeyGetTime(i - 1).GetSecondDouble();
            }
            if (i + 1 < pCurve->KeyGetCount())
            {
                rightTangent.mDerivative *= pCurve->KeyGetTime(i + 1).GetSecondDouble() - fTime;
            }

            osgAnimation::FloatCubicBezier key(
                val * scalar,
                (val + leftTangent.mDerivative / 3.0) * scalar,
                (val + rightTangent.mDerivative / 3.0) * scalar);

            curveTimeMap[nCurve][fTime] = key;
        }
    }

    for (TimeSet::iterator it = times.begin(); it != times.end(); ++it)
    {
        double fTime = *it;
        osg::Vec3 val, cpIn, cpOut;
        for (int i = 0; i < 3; ++i)
        {
            if (curveTimeMap[i].empty()) continue;

            TimeValueMap::iterator lb = curveTimeMap[i].lower_bound(fTime);
            if (lb == curveTimeMap[i].end()) --lb;
            val[i] = lb->second.getPosition();
            cpIn[i] = lb->second.getControlPointIn();
            cpOut[i] = lb->second.getControlPointOut();
        }

        keyFrameCntr.push_back(osgAnimation::Vec3CubicBezierKeyframe(fTime,
            osgAnimation::Vec3CubicBezier(val, cpIn, cpOut)));
    }
}

// osgAnimation requires control points to be in a weird order. This function
// reorders them from the conventional order to osgAnimation order.
template <typename T>
void reorderControlPoints(osgAnimation::TemplateKeyframeContainer<osgAnimation::TemplateCubicBezier<T> >& vkfCont)
{
    if (vkfCont.size() <= 1)
    {
        if (vkfCont.size() == 1)
        {
            osgAnimation::TemplateCubicBezier<T> tcb = vkfCont.front().getValue();
            T inCP = tcb.getControlPointIn();
            tcb.setControlPointIn(tcb.getControlPointOut());
            tcb.setControlPointOut(inCP);
            vkfCont.front().setValue(tcb);
        }
        return;
    }

    osgAnimation::TemplateCubicBezier<T> first = vkfCont.front().getValue();

    for (unsigned i = 0; i < vkfCont.size() - 1; ++i)
    {
        osgAnimation::TemplateCubicBezier<T> tcb = vkfCont[i].getValue();
        tcb.setControlPointIn(tcb.getControlPointOut());
        tcb.setControlPointOut(vkfCont[i + 1].getValue().getControlPointIn());
        vkfCont[i].setValue(tcb);
    }

    osgAnimation::TemplateCubicBezier<T> last = vkfCont.back().getValue();
    last.setControlPointIn(last.getControlPointOut());
    last.setControlPointOut(first.getControlPointIn());
    vkfCont.back().setValue(last);
}

osgAnimation::Channel* readFbxChannels(KFbxAnimCurve* curveX, KFbxAnimCurve* curveY,
    KFbxAnimCurve* curveZ,
    const fbxDouble3& defaultValue,
    const char* targetName, const char* channelName)
{
    if (!(curveX && curveX->KeyGetCount()) &&
        !(curveY && curveY->KeyGetCount()) &&
        !(curveZ && curveZ->KeyGetCount()))
    {
        return 0;
    }

    KFbxAnimCurveDef::EInterpolationType interpolationType = KFbxAnimCurveDef::eINTERPOLATION_CONSTANT;
    if (curveX && curveX->KeyGetCount()) interpolationType = curveX->KeyGetInterpolation(0);
    else if (curveY && curveY->KeyGetCount()) interpolationType = curveY->KeyGetInterpolation(0);
    else if (curveZ && curveZ->KeyGetCount()) interpolationType = curveZ->KeyGetInterpolation(0);

    osgAnimation::Channel* pChannel = 0;

    if (interpolationType == KFbxAnimCurveDef::eINTERPOLATION_CUBIC)
    {
        osgAnimation::Vec3CubicBezierKeyframeContainer* pKeyFrameCntr = new osgAnimation::Vec3CubicBezierKeyframeContainer;
        readKeys(curveX, curveY, curveZ, defaultValue, *pKeyFrameCntr);
        reorderControlPoints(*pKeyFrameCntr);

        osgAnimation::Vec3CubicBezierChannel* pCubicChannel = new osgAnimation::Vec3CubicBezierChannel;
        pCubicChannel->getOrCreateSampler()->setKeyframeContainer(pKeyFrameCntr);
        pChannel = pCubicChannel;
    }
    else
    {
        osgAnimation::Vec3KeyframeContainer* pKeyFrameCntr = new osgAnimation::Vec3KeyframeContainer;
        readKeys(curveX, curveY, curveZ, defaultValue, *pKeyFrameCntr);

        if (interpolationType == KFbxAnimCurveDef::eINTERPOLATION_CONSTANT)
        {
            osgAnimation::Vec3StepChannel* pStepChannel = new osgAnimation::Vec3StepChannel;
            pStepChannel->getOrCreateSampler()->setKeyframeContainer(pKeyFrameCntr);
            pChannel = pStepChannel;
        }
        else
        {
            osgAnimation::Vec3LinearChannel* pLinearChannel = new osgAnimation::Vec3LinearChannel;
            pLinearChannel->getOrCreateSampler()->setKeyframeContainer(pKeyFrameCntr);
            pChannel = pLinearChannel;
        }
    }

    pChannel->setTargetName(targetName);
    pChannel->setName(channelName);

    return pChannel;
}

osgAnimation::Channel* readFbxChannels(
    KFbxTypedProperty<fbxDouble3>& fbxProp, KFbxAnimLayer* pAnimLayer,
    const char* targetName, const char* channelName)
{
    if (!fbxProp.IsValid()) return 0;

    return readFbxChannels(
        fbxProp.GetCurve<KFbxAnimCurve>(pAnimLayer, "X"),
        fbxProp.GetCurve<KFbxAnimCurve>(pAnimLayer, "Y"),
        fbxProp.GetCurve<KFbxAnimCurve>(pAnimLayer, "Z"),
        fbxProp.Get(),
        targetName, channelName);
}

osgAnimation::Channel* readFbxChannelsQuat(
    KFbxAnimCurve* curveX, KFbxAnimCurve* curveY, KFbxAnimCurve* curveZ,
    const fbxDouble3& defaultValue,
    const char* targetName, ERotationOrder rotOrder)
{
    if (!(curveX && curveX->KeyGetCount()) &&
        !(curveY && curveY->KeyGetCount()) &&
        !(curveZ && curveZ->KeyGetCount()))
    {
        return 0;
    }

    osgAnimation::QuatSphericalLinearChannel* pChannel = new osgAnimation::QuatSphericalLinearChannel;
    pChannel->setTargetName(targetName);
    pChannel->setName("quaternion");
    typedef std::vector<osgAnimation::TemplateKeyframe<osg::Vec3> > KeyFrameCntr;
    KeyFrameCntr eulerFrameCntr;
    readKeys(curveX, curveY, curveZ, defaultValue, eulerFrameCntr, static_cast<float>(osg::PI / 180.0));

    osgAnimation::QuatSphericalLinearSampler::KeyframeContainerType& quatFrameCntr =
        *pChannel->getOrCreateSampler()->getOrCreateKeyframeContainer();
    quatFrameCntr.reserve(eulerFrameCntr.size());

    for (KeyFrameCntr::iterator it = eulerFrameCntr.begin(), end = eulerFrameCntr.end();
        it != end; ++it)
    {
        const osg::Vec3& euler = it->getValue();
        quatFrameCntr.push_back(osgAnimation::QuatKeyframe(
            it->getTime(), makeQuat(euler, rotOrder)));
    }

    return pChannel;
}

osgAnimation::Animation* addChannels(
    osgAnimation::Channel* pTranslationChannel,
    osgAnimation::Channel* pRotationChannels[],
    osgAnimation::Channel* pScaleChannel,
    osg::ref_ptr<osgAnimation::AnimationManagerBase>& pAnimManager,
    const char* pTakeName)
{
    if (pTranslationChannel ||
        pRotationChannels[0] ||
        pRotationChannels[1] ||
        pRotationChannels[2] ||
        pScaleChannel)
    {
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

        if (pTranslationChannel) pAnimation->addChannel(pTranslationChannel);
        if (pRotationChannels[0]) pAnimation->addChannel(pRotationChannels[0]);
        if (pRotationChannels[1]) pAnimation->addChannel(pRotationChannels[1]);
        if (pRotationChannels[2]) pAnimation->addChannel(pRotationChannels[2]);
        if (pScaleChannel) pAnimation->addChannel(pScaleChannel);


        return pAnimation;
    }

    return 0;
}

void readFbxRotationAnimation(osgAnimation::Channel* channels[3],
    KFbxNode* pNode,
    KFbxAnimLayer* pAnimLayer, const char* targetName)
{
    if (!pNode->LclRotation.IsValid())
    {
        return;
    }

    ERotationOrder rotOrder = pNode->RotationOrder.IsValid() ? pNode->RotationOrder.Get() : eEULER_XYZ;

    if (pNode->QuaternionInterpolate.IsValid() && pNode->QuaternionInterpolate.Get())
    {
        channels[0] = readFbxChannelsQuat(
            pNode->LclRotation.GetCurve<KFbxAnimCurve>(pAnimLayer, KFCURVENODE_R_X),
            pNode->LclRotation.GetCurve<KFbxAnimCurve>(pAnimLayer, KFCURVENODE_R_Y),
            pNode->LclRotation.GetCurve<KFbxAnimCurve>(pAnimLayer, KFCURVENODE_R_Z),
            pNode->LclRotation.Get(),
            targetName, rotOrder);
    }
    else
    {
        char* curveNames[3] = {KFCURVENODE_R_X, KFCURVENODE_R_Y, KFCURVENODE_R_Z};

        fbxDouble3 fbxPropValue = pNode->LclRotation.Get();
        fbxPropValue[0] = osg::DegreesToRadians(fbxPropValue[0]);
        fbxPropValue[1] = osg::DegreesToRadians(fbxPropValue[1]);
        fbxPropValue[2] = osg::DegreesToRadians(fbxPropValue[2]);

        for (int i = 0; i < 3; ++i)
        {
            KFbxAnimCurve* curve = pNode->LclRotation.GetCurve<KFbxAnimCurve>(pAnimLayer, curveNames[i]);
            if (!curve)
            {
                continue;
            }

            KFbxAnimCurveDef::EInterpolationType interpolationType = KFbxAnimCurveDef::eINTERPOLATION_CONSTANT;
            if (curve && curve->KeyGetCount()) interpolationType = curve->KeyGetInterpolation(0);

            if (interpolationType == KFbxAnimCurveDef::eINTERPOLATION_CUBIC)
            {
                osgAnimation::FloatCubicBezierKeyframeContainer* pKeyFrameCntr = new osgAnimation::FloatCubicBezierKeyframeContainer;

                for (int j = 0; j < curve->KeyGetCount(); ++j)
                {
                    double fTime = curve->KeyGetTime(j).GetSecondDouble();
                    float angle = curve->KeyGetValue(j);
                    //KFbxAnimCurveDef::EWeightedMode tangentWeightMode = curve->KeyGet(j).GetTangentWeightMode();

                    KFCurveTangeantInfo leftTangent = curve->KeyGetLeftDerivativeInfo(j);
                    KFCurveTangeantInfo rightTangent = curve->KeyGetRightDerivativeInfo(j);
                    if (j > 0)
                    {
                        leftTangent.mDerivative *= fTime - curve->KeyGetTime(j - 1).GetSecondDouble();
                    }
                    if (j + 1 < curve->KeyGetCount())
                    {
                        rightTangent.mDerivative *= curve->KeyGetTime(j + 1).GetSecondDouble() - fTime;
                    }
                    osgAnimation::FloatCubicBezier key(
                        osg::DegreesToRadians(angle),
                        osg::DegreesToRadians(angle + leftTangent.mDerivative / 3.0),
                        osg::DegreesToRadians(angle - rightTangent.mDerivative / 3.0));

                    pKeyFrameCntr->push_back(osgAnimation::FloatCubicBezierKeyframe(
                        fTime,
                        key));
                }

                reorderControlPoints(*pKeyFrameCntr);

                osgAnimation::FloatCubicBezierChannel* pCubicChannel = new osgAnimation::FloatCubicBezierChannel;
                pCubicChannel->getOrCreateSampler()->setKeyframeContainer(pKeyFrameCntr);
                channels[i] = pCubicChannel;
            }
            else
            {
                osgAnimation::FloatKeyframeContainer* keys = new osgAnimation::FloatKeyframeContainer;

                for (int j = 0; j < curve->KeyGetCount(); ++j)
                {
                    KFbxAnimCurveKey key = curve->KeyGet(j);
                    keys->push_back(osgAnimation::FloatKeyframe(
                        key.GetTime().GetSecondDouble(),
                        static_cast<float>(osg::DegreesToRadians(key.GetValue()))));
                }

                if (interpolationType == KFbxAnimCurveDef::eINTERPOLATION_CONSTANT)
                {
                    osgAnimation::FloatStepChannel* pStepChannel = new osgAnimation::FloatStepChannel();
                    pStepChannel->getOrCreateSampler()->setKeyframeContainer(keys);
                    channels[i] = pStepChannel;
                }
                else
                {
                    osgAnimation::FloatLinearChannel* pLinearChannel = new osgAnimation::FloatLinearChannel();
                    pLinearChannel->getOrCreateSampler()->setKeyframeContainer(keys);
                    channels[i] = pLinearChannel;
                }
            }

            channels[i]->setTargetName(targetName);
            channels[i]->setName(std::string("rotate") + curveNames[i]);
        }
    }
}

osgAnimation::Animation* readFbxAnimation(KFbxNode* pNode,
    KFbxAnimLayer* pAnimLayer, const char* pTakeName, const char* targetName,
    osg::ref_ptr<osgAnimation::AnimationManagerBase>& pAnimManager)
{
    osgAnimation::Channel* pTranslationChannel = 0;
    osgAnimation::Channel* pRotationChannels[3] = {0};
    readFbxRotationAnimation(pRotationChannels, pNode, pAnimLayer, targetName);


    if (pNode->LclTranslation.IsValid())
    {
        pTranslationChannel = readFbxChannels(
            pNode->LclTranslation.GetCurve<KFbxAnimCurve>(pAnimLayer, KFCURVENODE_T_X),
            pNode->LclTranslation.GetCurve<KFbxAnimCurve>(pAnimLayer, KFCURVENODE_T_Y),
            pNode->LclTranslation.GetCurve<KFbxAnimCurve>(pAnimLayer, KFCURVENODE_T_Z),
            pNode->LclTranslation.Get(),
            targetName, "translate");
    }

    osgAnimation::Channel* pScaleChannel = readFbxChannels(
        pNode->LclScaling, pAnimLayer, targetName, "scale");

    return addChannels(pTranslationChannel, pRotationChannels, pScaleChannel, pAnimManager, pTakeName);
}

std::string OsgFbxReader::readFbxAnimation(KFbxNode* pNode, const char* targetName)
{
    std::string result;
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

            if (osgAnimation::Animation* pAnimation = ::readFbxAnimation(
                pNode, pAnimLayer, pTakeName, targetName, pAnimationManager))
            {
                result = targetName;
            }
        }
    }
    return result;
}
