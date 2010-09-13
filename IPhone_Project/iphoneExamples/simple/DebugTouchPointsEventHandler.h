/*
 *  DebugTouchPointsEventHandler.h
 *  OSGIPhone
 *
 *  Created by Stephan Huber on 13.09.10.
 *  Copyright 2010 Stephan Maximilian Huber, digital mind. All rights reserved.
 *
 */

#ifndef DEBUG_TOUCH_POINT_EVENT_HANDLER_HEADER
#define DEBUG_TOUCH_POINT_EVENT_HANDLER_HEADER

#include <osgGA/GUIEventHandler>

class DebugTouchPointsEventHandler : public osgGA::GUIEventHandler {
public:
	virtual bool handle (const osgGA::GUIEventAdapter &ea, osgGA::GUIActionAdapter &aa, osg::Object *, osg::NodeVisitor *);
	

};


#endif