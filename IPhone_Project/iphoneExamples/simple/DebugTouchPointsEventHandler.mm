/*
 *  DebugTouchPointsEventHandler.cpp
 *  OSGIPhone
 *
 *  Created by Stephan Huber on 13.09.10.
 *  Copyright 2010 Stephan Maximilian Huber, digital mind. All rights reserved.
 *
 */

#include "DebugTouchPointsEventHandler.h"
#include <iostream>


bool DebugTouchPointsEventHandler::handle (const osgGA::GUIEventAdapter &ea, osgGA::GUIActionAdapter &aa, osg::Object *, osg::NodeVisitor *)
{
	switch( ea.getEventType() ) {
		case osgGA::GUIEventAdapter::PUSH:
		case osgGA::GUIEventAdapter::DRAG:
		case osgGA::GUIEventAdapter::RELEASE:

			if (ea.isMultiTouchEvent()) 
			{
				osgGA::GUIEventAdapter::TouchData* data = ea.getTouchData();
				for(osgGA::GUIEventAdapter::TouchData::iterator i = data->begin(); i != data->end(); ++i) {
					std::cout << "id: " << i->id << " phase: " << i->phase << " " << i->x << "/" << i->y << " tapCount:" << i->tapCount << std::endl;
				}
			}
			return true;
			break;
	}
	return false;
}