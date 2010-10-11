/*
 *  DarwinUtils.cpp
 *  OpenSceneGraph
 *
 *  Created by Stephan Huber on 27.06.08.
 *  Copyright 2008 Stephan Maximilian Huber, digital mind. All rights reserved.
 *
 */

#include <osg/Referenced>
#include <osg/DeleteHandler>
#include <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "IPhoneUtils.h"


namespace osgIPhone {


/** ctor, get a list of all attached displays */
IPhoneWindowingSystemInterface::IPhoneWindowingSystemInterface() :
    _displayCount(0)
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	//get the screens array from the UIScreen class, screen 0 is always mainScreen
	NSArray* screens = [UIScreen screens];
	
    NSEnumerator* enumerator = [screens objectEnumerator];
    id obj;
	int currentID = 0;
	
	//make an ID per screen
    while ( obj = [enumerator nextObject] ) {
		_displayIds.push_back(currentID);
		currentID++;
    }
	
	//set count by the number of ids we made
	_displayCount = _displayIds.size();
	
	[pool release];
}

/** dtor */
IPhoneWindowingSystemInterface::~IPhoneWindowingSystemInterface()
{
    if (osg::Referenced::getDeleteHandler())
    {
        osg::Referenced::getDeleteHandler()->setNumFramesToRetainObjects(0);
        osg::Referenced::getDeleteHandler()->flushAll();
    }

    _displayIds.clear();
}

/** @return a CGDirectDisplayID for a ScreenIdentifier */
int IPhoneWindowingSystemInterface::getDisplayID(const osg::GraphicsContext::ScreenIdentifier& si) 
{
    if (si.screenNum <= _displayCount)
        return _displayIds[si.screenNum];
    else {
        OSG_WARN << "GraphicsWindowIPhone::getDisplayID: WARN: Invalid screen # " << si.screenNum << ", returning main-screen instead" << std::endl;
        return _displayIds[0];
    }
}

/** @return count of attached screens */
unsigned int IPhoneWindowingSystemInterface::getNumScreens(const osg::GraphicsContext::ScreenIdentifier& si) 
{
    return _displayCount;
}

void IPhoneWindowingSystemInterface::getScreenSettings(const osg::GraphicsContext::ScreenIdentifier& si, osg::GraphicsContext::ScreenSettings & resolution)
{
	if(si.screenNum >= _displayCount){return;}
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	//get the screens array from the UIScreen class
	NSArray* screens = [UIScreen screens];
	//iterate to the desired screen num
    UIScreen* screen = [screens objectAtIndex:si.screenNum];

	//get the screen mode
	NSArray* modesArray = [screen availableModes];
	
	if(modesArray)
	{
		//for this method we copy the first mode (default) then return
		UIScreenMode* mode = [modesArray objectAtIndex:0];

		CGSize size = [mode size];
		resolution.width = size.width;
		resolution.height = size.height;
		resolution.colorDepth = 24; 
		resolution.refreshRate = 60; //i've read 60 is max, not sure if thats true
	}
	[pool release];
	return;
}

//
//Due to the weird
void IPhoneWindowingSystemInterface::enumerateScreenSettings(const osg::GraphicsContext::ScreenIdentifier& si, 
															 osg::GraphicsContext::ScreenSettingsList & resolutionList) 
{
	if(si.screenNum >= _displayCount){return;}
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	//get the screens array from the UIScreen class
	NSArray* screens = [UIScreen screens];
	//get the desired screen num
    UIScreen* screen = [screens objectAtIndex:si.screenNum];

	//get the screen mode
	NSArray* modesArray = [screen availableModes];
	NSEnumerator* modesEnum = [modesArray objectEnumerator];
	UIScreenMode* mode;
	//iterate over modes and get their size property
	while ( mode = [modesEnum nextObject] ) {
		
		osg::GraphicsContext::ScreenSettings resolution;
		CGSize size = [mode size];
		resolution.width = size.width;
		resolution.height = size.height;
		resolution.colorDepth = 24; 
		resolution.refreshRate = 60; //i've read 60 is max, not sure if thats true
		resolutionList.push_back(resolution);
	}

	[pool release];
}

/** return the top left coord of a specific screen in global screen space, this needs looking at in regards to pixels and points */
void IPhoneWindowingSystemInterface::getScreenTopLeft(const osg::GraphicsContext::ScreenIdentifier& si, int& x, int& y)
{
	if(si.screenNum >= _displayCount){return;}
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	//get the screens array from the UIScreen class
	NSArray* screens = [UIScreen screens];
	
	//get desired screen num
    UIScreen* screen = [screens objectAtIndex:si.screenNum];	

	//bounds will return full screen in points, application frame includes the IPhone status bar at the top
	CGRect lFrame = [screen bounds]; //applicationFrame];
	x = static_cast<int>(lFrame.origin.x);
	y = static_cast<int>(lFrame.origin.y);
    
	[pool release];
    // osg::notify(osg::DEBUG_INFO) << "topleft of screen " << si.screenNum <<" " << bounds.origin.x << "/" << bounds.origin.y << std::endl;
}


bool IPhoneWindowingSystemInterface::setScreenSettings(const osg::GraphicsContext::ScreenIdentifier &si, const osg::GraphicsContext::ScreenSettings & settings)
{
    bool result = setScreenResolutionImpl(si, settings.width, settings.height);
    if (result)
        setScreenRefreshRateImpl(si, settings.refreshRate);
    
    return result;
}



/** implementation of setScreenResolution */
//IPad can have extenal screens which we can request a res for
//the main screen screenNum 0 can not currently have its res changed
//as it only has one mode (might change though and this should still handle it)
//
bool IPhoneWindowingSystemInterface::setScreenResolutionImpl(const osg::GraphicsContext::ScreenIdentifier& si, unsigned int width, unsigned int height) 
{
	if(si.screenNum >= _displayCount){return false;}

	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	//get the screens array from the UIScreen class
	NSArray* screens = [UIScreen screens];
	
	//iterate to the desired screen num
    UIScreen* screen = [screens objectAtIndex:si.screenNum];

	//get the screen mode
	NSArray* modesArray = [screen availableModes];
	NSEnumerator* modesEnum = [modesArray objectEnumerator];
	UIScreenMode* mode;
	//iterate over modes and get their size property
	while ( mode = [modesEnum nextObject] ) {
		
		osg::GraphicsContext::ScreenSettings resolution;
		CGSize size = [mode size];
		
		//if the modes size/resolution matches the passed width/height then assign this
		//mode as the screens current mode
		if(size.width == width && size.height == height)
		{
			screen.currentMode = mode;
			OSG_INFO << "IPhoneWindowingSystemInterface::setScreenResolutionImpl: Set resolution of screen '" << si.screenNum << "', to '" << width << ", " << height << "'." << std::endl;
			[pool release];
			return true;
		}
		
	}

	OSG_WARN << "IPhoneWindowingSystemInterface::setScreenResolutionImpl: Failed to set resolution of screen '" << si.screenNum << "', to '" << width << ", " << height << "'." << std::endl;
    [pool release];
	return false; 
}

/** implementation of setScreenRefreshRate, don't think you can do this on IPhone */
bool IPhoneWindowingSystemInterface::setScreenRefreshRateImpl(const osg::GraphicsContext::ScreenIdentifier& screenIdentifier, double refreshRate) { 
    
    return true;
}


unsigned int IPhoneWindowingSystemInterface::getScreenContaining(int x, int y, int w, int h)
{
    return 1;
}

//
//return the UIScreen object asscoiated with the passed ScreenIdentifier
//returns nil if si isn't found
//
UIScreen* IPhoneWindowingSystemInterface::getUIScreen(const osg::GraphicsContext::ScreenIdentifier& si)
{
	if(si.screenNum >= _displayCount){return nil;}
	
	//get the screens array from the UIScreen class
	NSArray* screens = [UIScreen screens];
	
	//iterate to the desired screen num
    NSEnumerator* screenEnum = [screens objectEnumerator];
    UIScreen* screen;
	int currentID = 0;
    while ( screen = [screenEnum nextObject] ) {
		
		//if it's our desired screen
		if(currentID == si.screenNum)
		{	return screen;}
	}
	return nil;
}

//
//Returns the contents scale factor of the screen, this is the scale factor required
//to convert points to pixels on this screen
//
bool IPhoneWindowingSystemInterface::getScreenContentScaleFactor(const osg::GraphicsContext::ScreenIdentifier& si, float& scaleFactor)
{
	if(si.screenNum >= _displayCount){return false;}
	
    UIScreen* screen = this->getUIScreen(si);
	if(screen != nil)
	{
		scaleFactor = 1.0f;
#ifdef __IPHONE_4_0 && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0)
		CGFloat scale = [screen scale];
		scaleFactor = scale;
#endif
		return true;
	}
	return false;
}
	
//
//Returns the screens size in points, docs state a point is roughly 1/160th of an inch
//
bool IPhoneWindowingSystemInterface::getScreenSizeInPoints(const osg::GraphicsContext::ScreenIdentifier& si, osg::Vec2& pointSize)
{
	if(si.screenNum >= _displayCount){return false;}
	
    UIScreen* screen = this->getUIScreen(si);
	if(screen != nil)
	{
		CGRect bounds = [screen bounds];
		pointSize.x() = bounds.size.width;
		pointSize.y() = bounds.size.height;
		return true;
	}
	return false;	
}

}
