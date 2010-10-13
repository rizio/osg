

#include <iostream>
//#include <osgViewer/api/IPhone/PixelBufferIPhone>
#include <osgViewer/api/IPhone/GraphicsWindowIPhone>

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#if OSG_GLES1_FEATURES
	#import <OpenGLES/ES1/glext.h>
#else
	#import <OpenGLES/ES2/glext.h>
#endif

#include "IPhoneUtils.h"




#pragma mark GraphicsWindowIPhoneWindow

// ----------------------------------------------------------------------------------------------------------
// GraphicsWindowIPhoneWindow, implements canBecomeKeyWindow + canBecomeMainWindow
// ----------------------------------------------------------------------------------------------------------

@interface GraphicsWindowIPhoneWindow : UIWindow
{
}

- (BOOL) canBecomeKeyWindow;
- (BOOL) canBecomeMainWindow;

@end

@implementation GraphicsWindowIPhoneWindow

//
//Implement dealloc 
//
- (void) dealloc
{
	[super dealloc];
}

- (BOOL) canBecomeKeyWindow
{
    return YES;
}

- (BOOL) canBecomeMainWindow
{
    return YES;
}

@end

#pragma mark GraphicsWindowIPhoneGLView

// ----------------------------------------------------------------------------------------------------------
// GraphicsWindowIPhoneGLView
// custom UIView-class handling creation and display of frame/render buffers plus receives touch input
// ----------------------------------------------------------------------------------------------------------

@interface GraphicsWindowIPhoneGLView : UIView
{
    @private
        osgViewer::GraphicsWindowIPhone* _win;
		EAGLContext* _context;
	
		/* The pixel dimensions of the backbuffer */
		GLint _backingWidth;
		GLint _backingHeight;
	
		//the pixel buffers for the video
		/* OpenGL names for the renderbuffer and framebuffers used to render to this view */
		GLuint _viewRenderbuffer, _viewFramebuffer;
		
		/* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
		GLuint _depthRenderbuffer;
	
		/* OpenGL name for the stencil buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
		GLuint _stencilBuffer;
        
        // for multisampled antialiased rendering
        GLuint _msaaFramebuffer, _msaaRenderBuffer, _msaaDepthBuffer;
	
}

- (void)setGraphicsWindow: (osgViewer::GraphicsWindowIPhone*) win;
- (osgViewer::GraphicsWindowIPhone*) getGraphicsWindow;
- (void)setOpenGLContext: (EAGLContext*) context;

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;
- (void)swapBuffers;
- (void)bindFrameBuffer;

- (BOOL)acceptsFirstResponder;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;

- (osgGA::GUIEventAdapter::TouchPhase) convertTouchPhase: (UITouchPhase) phase;
- (osg::Vec2) convertPointToPixel: (osg::Vec2) point;

@end

@implementation GraphicsWindowIPhoneGLView 

- (osgGA::GUIEventAdapter::TouchPhase) convertTouchPhase: (UITouchPhase) phase 
{
	switch(phase) {
	
		case UITouchPhaseBegan:
			return osgGA::GUIEventAdapter::TOUCH_BEGAN;
			break;
		case UITouchPhaseMoved:
			return osgGA::GUIEventAdapter::TOUCH_MOVED;
			break;

		case UITouchPhaseStationary:
			return osgGA::GUIEventAdapter::TOUCH_STATIONERY;
			break;

		case UITouchPhaseEnded:
		case UITouchPhaseCancelled:
			return osgGA::GUIEventAdapter::TOUCH_ENDED;
			break;
	}
	
	return osgGA::GUIEventAdapter::TOUCH_ENDED;

}

- (osg::Vec2) convertPointToPixel: (osg::Vec2) point
{
	//get the views contentscale factor and multiply the point by it
	float scale = 1.0f;
	
#ifdef __IPHONE_4_0 && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0)
	scale = self.contentScaleFactor;
#endif
	return osg::Vec2(point.x()*scale, point.y()*scale);
	
}

-(void) setGraphicsWindow: (osgViewer::GraphicsWindowIPhone*) win
{
    _win = win;
}

- (osgViewer::GraphicsWindowIPhone*) getGraphicsWindow {
    return _win;
}

-(void) setOpenGLContext: (EAGLContext*) context
{
    _context = context;
}

// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

//
//Called when the view is created using a frame for dimensions
//
- (id)initWithFrame:(CGRect)frame : (osgViewer::GraphicsWindowIPhone*)win{
	
	_win = win;

    if ((self = [super initWithFrame:frame])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;//need to look into this, can't remember why it's here, i.e. do I set it to no for alphaed window?
		if(_win->getTraits()->alpha > 0)
		{
			//create layer with alpha channel RGBA8
			eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
											[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		}else{
			//else no alpha, iphone uses RBG565
			eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
											[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil];

		}
    }
	self.multipleTouchEnabled = YES;
	
    return self;
}

//
//Implement dealloc to destory our frame buffer
//
- (void) dealloc
{
	//[self destroyFramebuffer];
	//[_context release];//OBJC_TEST
	//_context = nil;
	//_win = NULL;
	[super dealloc];
}

- (void)layoutSubviews {
    [EAGLContext setCurrentContext:_context];
    [self destroyFramebuffer];
    [self createFramebuffer];
}


- (BOOL)createFramebuffer {

    _msaaFramebuffer = _msaaRenderBuffer = 0;
    
    glGenFramebuffersOES(1, &_viewFramebuffer);
    glGenRenderbuffersOES(1, &_viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);
	
	osg::notify(osg::DEBUG_INFO) << "GraphicsWindowIPhone::createFramebuffer INFO: Created GL RenderBuffer of size " << _backingWidth << ", " << _backingHeight << " ." << std::endl;

	//add depth if requested
	if(_win->getTraits()->depth > 0) {
        glGenRenderbuffersOES(1, &_depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderbuffer);
		if(_win->getTraits()->depth == 16)
		{
			glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, _backingWidth, _backingHeight);
		}else if(_win->getTraits()->depth == 24){
			glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT24_OES, _backingWidth, _backingHeight);
		}
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthRenderbuffer);
    }
	
	//add stencil if requested
	if(_win->getTraits()->stencil > 0) {
		glGenRenderbuffersOES(1, &_stencilBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _stencilBuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_STENCIL_INDEX8_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_STENCIL_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _stencilBuffer);
    }	
    
    //MSAA only available for >= 4.0 sdk
    
#ifdef __IPHONE_4_0 && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0)
    
    if(_win->getTraits()->sampleBuffers > 0) 
    {
        glGenFramebuffersOES(1, &_msaaFramebuffer); 
        glGenRenderbuffersOES(1, &_msaaRenderBuffer);
        
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, _msaaFramebuffer); 
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, _msaaRenderBuffer);
        
        // Samples is the amount of pixels the MSAA buffer uses to make one pixel on the render // buffer. Use a small number like 2 for the 3G and below and 4 or more for newer models
        
        glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER_OES, _win->getTraits()->samples, GL_RGB5_A1_OES, _backingWidth, _backingHeight);
        
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _msaaRenderBuffer);
        glGenRenderbuffersOES(1, &_msaaDepthBuffer); 
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, _msaaDepthBuffer);
        
        glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER_OES, _win->getTraits()->samples, ( _win->getTraits()->depth == 16) ? GL_DEPTH_COMPONENT16_OES : GL_DEPTH_COMPONENT24_OES, _backingWidth , _backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _msaaDepthBuffer);
    
    }
#endif
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		OSG_FATAL << "GraphicsWindowIPhone::createFramebuffer ERROR: Failed to create a GL RenderBuffer, glCheckFramebufferStatusOES returned '" 
				  << glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) << "'." << std::endl;
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    
	if(_viewFramebuffer)
    {
		glDeleteFramebuffersOES(1, &_viewFramebuffer);
		_viewFramebuffer = 0;
	}
	if(_viewRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &_viewRenderbuffer);
		_viewRenderbuffer = 0;
	}
    
    if(_depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &_depthRenderbuffer);
        _depthRenderbuffer = 0;
    }
	
	if(_stencilBuffer) {
		glDeleteFramebuffersOES(1, &_stencilBuffer);
		_stencilBuffer = 0;
	}
    
    if(_msaaRenderBuffer) {
        glDeleteFramebuffersOES(1, &_msaaRenderBuffer);
        _msaaRenderBuffer = 0;
    }
    
    if(_msaaDepthBuffer) {
        glDeleteFramebuffersOES(1, &_msaaDepthBuffer);
        _msaaDepthBuffer = 0;
    }

    if(_msaaFramebuffer) {
        glDeleteFramebuffersOES(1, &_msaaFramebuffer);
        _msaaFramebuffer = 0;
    }
}

//
//Swap the view and render buffers
//
- (void)swapBuffers {


#ifdef __IPHONE_4_0 && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0)    
    if(_msaaFramebuffer) 
    {
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, _msaaFramebuffer);
        
        glBindFramebufferOES(GL_READ_FRAMEBUFFER_APPLE, _msaaFramebuffer); 
        glBindFramebufferOES(GL_DRAW_FRAMEBUFFER_APPLE, _viewFramebuffer);
        
        glResolveMultisampleFramebufferAPPLE();
        
        GLenum attachments[] = {GL_DEPTH_ATTACHMENT_OES, GL_COLOR_ATTACHMENT0_OES}; 
        glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 2, attachments);
    }
#endif


  	//swap buffers (sort of i think?)
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
    
    //display render in context
    [_context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	//re bind the frame buffer for next frames renders
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
    
#ifdef __IPHONE_4_0 && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0)
    if (_msaaFramebuffer)
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, _msaaFramebuffer);;
#endif
}

//
//bind view buffer as current for new render pass
//
- (void)bindFrameBuffer {

	//bind the frame buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
    
#ifdef __IPHONE_4_0 && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0)
    if (_msaaFramebuffer)
        glBindFramebufferOES(GL_READ_FRAMEBUFFER_APPLE, _msaaFramebuffer);
#endif
}


- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (BOOL)becomeFirstResponder
{
  return YES;
}

- (BOOL)resignFirstResponder
{
  return YES;
}

//
//Touch input callbacks
//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSSet *allTouches = [event allTouches];
    
	osg::ref_ptr<osgGA::GUIEventAdapter> osg_event(NULL);

	for(int i=0; i<[allTouches count]; i++)
	{
		
		UITouch *touch = [[allTouches allObjects] objectAtIndex:i];
		CGPoint pos = [touch locationInView:touch.view];
		osg::Vec2 pixelPos = [self convertPointToPixel: osg::Vec2(pos.x,pos.y)];
		
		if (!osg_event) {
			osg_event = _win->getEventQueue()->touchBegan(i, [self convertTouchPhase: [touch phase]], pixelPos.x(), pixelPos.y());
		} else {
			osg_event->addTouchPoint(i, [self convertTouchPhase: [touch phase]], pixelPos.x(), pixelPos.y());
		}
	}
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSSet *allTouches = [event allTouches];
	
	osg::ref_ptr<osgGA::GUIEventAdapter> osg_event(NULL);

	for(int i=0; i<[allTouches count]; i++)
	{
		UITouch *touch = [[allTouches allObjects] objectAtIndex:i];
		CGPoint pos = [touch locationInView:touch.view];
		osg::Vec2 pixelPos = [self convertPointToPixel: osg::Vec2(pos.x,pos.y)];
		
		if (!osg_event) {
			osg_event = _win->getEventQueue()->touchMoved(i, [self convertTouchPhase: [touch phase]], pixelPos.x(), pixelPos.y());
		} else {
			osg_event->addTouchPoint(i, [self convertTouchPhase: [touch phase]], pixelPos.x(), pixelPos.y());
		}


	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event

{	
    NSSet *allTouches = [event allTouches];
	
	osg::ref_ptr<osgGA::GUIEventAdapter> osg_event(NULL);
	
	for(int i=0; i<[allTouches count]; i++)
	{
		UITouch *touch = [[allTouches allObjects] objectAtIndex:i];
		CGPoint pos = [touch locationInView:touch.view];
		osg::Vec2 pixelPos = [self convertPointToPixel: osg::Vec2(pos.x,pos.y)];
		
		if (!osg_event) {
			osg_event = _win->getEventQueue()->touchEnded(i, [self convertTouchPhase: [touch phase]], pixelPos.x(), pixelPos.y(), [touch tapCount]);
		} else {
			osg_event->addTouchPoint(i, [self convertTouchPhase: [touch phase]], pixelPos.x(), pixelPos.y(), [touch tapCount]);
		}

	}
}


@end



@interface GraphicsWindowIPhoneGLViewController : UIViewController
{

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;

@end

@implementation GraphicsWindowIPhoneGLViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    osgViewer::GraphicsWindowIPhone* win = [(GraphicsWindowIPhoneGLView*)(self.view) getGraphicsWindow];
   
    if ((win) && (win->adaptToDeviceOrientation() == false))
        return NO;
    
    BOOL result(NO);
    
    switch (interfaceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            result = YES;
            break;
        default:
            {
                result = (win) ? (win->getTraits()->supportsResize) ? YES : NO : NO;
            }
            break;
    }
    OSG_INFO << "shouldAutorotateToInterfaceOrientation for " << interfaceOrientation << ": " << ((result==YES) ? "YES" : "NO") << std::endl;
    return result;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration 
{
    osgViewer::GraphicsWindowIPhone* win = [(GraphicsWindowIPhoneGLView*)(self.view) getGraphicsWindow];
    if (win) {
        CGRect frame = self.view.bounds;
		osg::Vec2 pointOrigin = osg::Vec2(frame.origin.x,frame.origin.y);
		osg::Vec2 pointSize = osg::Vec2(frame.size.width,frame.size.height);
		osg::Vec2 pixelOrigin = [(GraphicsWindowIPhoneGLView*)(self.view) convertPointToPixel:pointOrigin];
		osg::Vec2 pixelSize = [(GraphicsWindowIPhoneGLView*)(self.view) convertPointToPixel:pointSize];
       OSG_INFO << "willAnimateRotationToInterfaceOrientation, resize to " 
            <<  pixelOrigin.x() << " " << pixelOrigin.y() << " " 
            << pixelSize.x() << " " << pixelSize.y() 
            << std::endl;
        win->resized(pixelOrigin.x(), pixelOrigin.y(), pixelSize.x(), pixelSize.y());
    }

}



@end



using namespace osgIPhone; 
namespace osgViewer {

	
	
#pragma mark GraphicsWindowIPhone



// ----------------------------------------------------------------------------------------------------------
// init
// ----------------------------------------------------------------------------------------------------------

void GraphicsWindowIPhone::init()
{
    if (_initialized) return;

    _ownsWindow = false;
    _context = NULL;
    _window = NULL;
    _updateContext = false;
	//if -1.0 we use the screens scale factor
	_viewContentScaleFactor = -1.0f;
    _valid = _initialized = true;
}


// ----------------------------------------------------------------------------------------------------------
// realizeImplementation, creates the window + context
// ----------------------------------------------------------------------------------------------------------

bool GraphicsWindowIPhone::realizeImplementation()
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    BOOL bar_hidden = (_traits->windowDecoration) ? NO: YES;
	#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
	#if __IPHONE_OS_VERSION_MIN_REQUIRED > 30100
		[[UIApplication sharedApplication] setStatusBarHidden: bar_hidden withAnimation:UIStatusBarAnimationNone];
	#else
		[[UIApplication sharedApplication] setStatusBarHidden: bar_hidden animated:NO];
	#endif
	#endif
	
	//Get info about the requested screen
    IPhoneWindowingSystemInterface* wsi = dynamic_cast<IPhoneWindowingSystemInterface*>(osg::GraphicsContext::getWindowingSystemInterface());
    osg::Vec2 screenSizePoints;
	osg::Vec2 screenSizePixels;
	float screenScaleFactor = 1.0f;
	UIScreen* screen = nil;
	osg::GraphicsContext::ScreenSettings screenSettings;
    if (wsi) {
		wsi->getScreenContentScaleFactor((*_traits), screenScaleFactor);
		wsi->getScreenSizeInPoints((*_traits), screenSizePoints); 
		screenSizePixels = osg::Vec2(screenSettings.width, screenSettings.height);
		wsi->getScreenSettings((*_traits), screenSettings);
		screen = wsi->getUIScreen((*_traits));
    }else{
		OSG_FATAL << "GraphicsWindowIPhone::realizeImplementation: ERROR: Failed to create IPhone windowing system, OSG will be unable to create a vaild gl context and will not be able to render." << std::endl;
		return false;
	}
    
    _ownsWindow = true;
    
    // see if an existing inherited window was passed in
    WindowData* windowData = _traits->inheritedWindowData ? dynamic_cast<WindowData*>(_traits->inheritedWindowData.get()) : NULL;
    if (windowData) 
    {
        if (windowData->_window)
		{
            _ownsWindow = false;        
			_window = windowData->_window;
		}
        
        _adaptToDeviceOrientation = windowData->_adaptToDeviceOrientation;
		_viewContentScaleFactor = windowData->_viewContentScaleFactor;
    } 
	
	//if the user hasn't specified a viewScaleFactor we will use the screens scale factor
	//so we get a full res buffer
	if(_viewContentScaleFactor < 0.0f)
	{_viewContentScaleFactor = screenScaleFactor;}
    

	OSG_DEBUG << "GraphicsWindowIPhone::realizeImplementation / ownsWindow: " << _ownsWindow << std::endl;

	
	//Here's the confusing bit, the default traits use the screen res which is in pixels and the user will want to use pixels also
	//but we need to create our views and windows in points. By default we create a full res buffer across all devices. This
	//means that for backward compatibility you need to set the windowData _viewContentScaleFactor to 1.0f and set the screen res to the
	//res of the older gen device.
	CGRect viewBounds;
	osg::Vec2 pointsOrigin = this->pixelToPoint(osg::Vec2(_traits->x, _traits->y));
	osg::Vec2 pointsSize = this->pixelToPoint(osg::Vec2(_traits->width, _traits->height));

	viewBounds.origin.x = pointsOrigin.x(); 
	viewBounds.origin.y = pointsOrigin.y();
	viewBounds.size.width = pointsSize.x(); 
	viewBounds.size.height = pointsSize.y();
	
	
	//if we own the window we need to create one
    if (_ownsWindow) 
    {
		//create the IPhone window object using the viewbounds (in points) required for our context size
        _window = [[GraphicsWindowIPhoneWindow alloc] initWithFrame: viewBounds];// styleMask: style backing: NSBackingStoreBuffered defer: NO];
        
        if (!_window) {
            OSG_WARN << "GraphicsWindowIPhone::realizeImplementation: ERROR: Failed to create GraphicsWindowIPhoneWindow can not display gl view" << std::endl;
            return false;
        }
		
		OSG_DEBUG << "GraphicsWindowIPhone::realizeImplementation: INFO: Created UIWindow with bounds '" << viewBounds.size.width << ", " << viewBounds.size.height << "' (points)." << std::endl;
		
		//if the user has requested a differnet screenNum from default 0 get the UIScreen object and
		//apply to our window (this is for IPad external screens, I don't have one, so I've no idea if it works)
		//I'm also not sure if we should apply this to external windows also?
		if(_traits->screenNum > 0 && screen != nil)
		{
			_window.screen = screen;
		}
    } 
            
	//create the desired OpenGLES context type
#if OSG_GLES1_FEATURES
	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
#elif OSG_GLES2_FEATURES
	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
#endif
	
	if (!_context || ![EAGLContext setCurrentContext:_context]) {
		
		#if OSG_GLES1_FEATURES
		OSG_FATAL << "GraphicsWindowIPhone::realizeImplementation: ERROR: Failed to create a valid OpenGLES1 context" << std::endl;
		#elif OSG_GLES2_FEATURES
		OSG_FATAL << "GraphicsWindowIPhone::realizeImplementation: ERROR: Failed to create a valid OpenGLES2 context" << std::endl;
		#endif
		return false;
	}

	//create the view to display our context in our window
    GraphicsWindowIPhoneGLView* theView = [[ GraphicsWindowIPhoneGLView alloc ] initWithFrame:[ _window frame ] : this ];
	if(!theView)
	{
		OSG_FATAL << "GraphicsWindowIPhone::realizeImplementation: ERROR: Failed to create GraphicsWindowIPhoneGLView, can not create frame buffers." << std::endl;
		return false;
	}
	
    [theView setAutoresizingMask:  ( UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight) ];
    
	//Apply our content scale factor to our view, this is what converts the views points
	//size to our desired context size.
#ifdef __IPHONE_4_0 && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0)
	theView.contentScaleFactor = _viewContentScaleFactor;
    
#endif	
	[theView setGraphicsWindow: this];
    [theView setOpenGLContext:_context];
    _view = theView;
	
    OSG_DEBUG << "GraphicsWindowIPhone::realizeImplementation / view: " << theView << std::endl;

	//
	_viewController = [[GraphicsWindowIPhoneGLViewController alloc] init];
	_viewController.view = _view;
	
	
	// Attach view to window
	[_window addSubview: _view];
	[theView release];
	
	//if we own the window also make it visible
    if (_ownsWindow) {
		//show window
		[_window makeKeyAndVisible];
    }

    [pool release];
    
    // iphones origin is top/left:
    getEventQueue()->getCurrentEventState()->setMouseYOrientation(osgGA::GUIEventAdapter::Y_INCREASING_DOWNWARDS);
    
    _valid = _initialized = _realized = true;
    return _valid;
}




// ----------------------------------------------------------------------------------------------------------
// closeImplementation
// ----------------------------------------------------------------------------------------------------------
void GraphicsWindowIPhone::closeImplementation()
{
	OSG_ALWAYS << "close iphone window" << std::endl;
    _valid = false;
    _realized = false;
   
	
    if (_view) {
        [_view setGraphicsWindow: NULL];
		[_view release];
    }
    
    if (_viewController) {
        [_viewController release];
		_viewController = NULL;
    }
        
    if (_window && _ownsWindow) {  
		[_window release];
		//[glView release];
	}

    
    _window = NULL;
    _view = NULL;    
}


// ----------------------------------------------------------------------------------------------------------
// makeCurrentImplementation
// ----------------------------------------------------------------------------------------------------------

bool GraphicsWindowIPhone:: makeCurrentImplementation()
{
    if (_updateContext)
    {
        //[_context update];
        _updateContext = false; 
    }
    
	//bind the context
    [EAGLContext setCurrentContext:_context];
	
	//i think we also want to bind the frame buffer here
	//[_view bindFrameBuffer];

    return true;
}


// ----------------------------------------------------------------------------------------------------------
// releaseContextImplementation
// ----------------------------------------------------------------------------------------------------------

bool GraphicsWindowIPhone::releaseContextImplementation()
{
	if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    return true;
}


// ----------------------------------------------------------------------------------------------------------
// swapBuffersImplementation
// ----------------------------------------------------------------------------------------------------------

void GraphicsWindowIPhone::swapBuffersImplementation()
{
    //[_context flushBuffer];
	[_view swapBuffers];
}



// ----------------------------------------------------------------------------------------------------------
// setWindowDecorationImplementation
//
// We will use this to toggle the status bar on IPhone, nearest thing to window decoration
// ----------------------------------------------------------------------------------------------------------

bool GraphicsWindowIPhone::setWindowDecorationImplementation(bool flag)
{
    if (!_realized || !_ownsWindow) return false;

	BOOL bar_hidden = (flag) ? NO: YES;
	#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
	#if __IPHONE_OS_VERSION_MIN_REQUIRED > 30100
		[[UIApplication sharedApplication] setStatusBarHidden: bar_hidden withAnimation:UIStatusBarAnimationNone];
	#else
		[[UIApplication sharedApplication] setStatusBarHidden: bar_hidden animated:NO];
	#endif
	#endif
	
    return true;
}


// ----------------------------------------------------------------------------------------------------------
// grabFocus
// ----------------------------------------------------------------------------------------------------------
void GraphicsWindowIPhone::grabFocus()
{
	//i think make key is the equivalent of focus on iphone 
	[_window makeKeyWindow];
}


// ----------------------------------------------------------------------------------------------------------
// grabFocusIfPointerInWindow
// ----------------------------------------------------------------------------------------------------------
void GraphicsWindowIPhone::grabFocusIfPointerInWindow()
{
    OSG_INFO << "GraphicsWindowIPhone :: grabFocusIfPointerInWindow not implemented yet " << std::endl;
}

// ----------------------------------------------------------------------------------------------------------
// raiseWindow
// Raise the window to the top.
// ----------------------------------------------------------------------------------------------------------
void GraphicsWindowIPhone::raiseWindow()
{
	[_window bringSubviewToFront:_view];
}

// ----------------------------------------------------------------------------------------------------------
// resizedImplementation
// ----------------------------------------------------------------------------------------------------------

void GraphicsWindowIPhone::resizedImplementation(int x, int y, int width, int height)
{
    GraphicsContext::resizedImplementation(x, y, width, height);
    
    _updateContext = true;
    
	getEventQueue()->windowResize(x,y,width, height, getEventQueue()->getTime());
}




// ----------------------------------------------------------------------------------------------------------
// setWindowRectangleImplementation
// ----------------------------------------------------------------------------------------------------------
bool GraphicsWindowIPhone::setWindowRectangleImplementation(int x, int y, int width, int height)
{
    OSG_INFO << "GraphicsWindowIPhone :: setWindowRectangleImplementation not implemented yet " << std::endl;
    if (!_ownsWindow)
        return false;
            
    return true;
}

	
void GraphicsWindowIPhone::checkEvents()
{
	
	
}



// ----------------------------------------------------------------------------------------------------------
// setWindowName
// ----------------------------------------------------------------------------------------------------------

void GraphicsWindowIPhone::setWindowName (const std::string & name)
{
    OSG_INFO << "GraphicsWindowIPhone :: setWindowName not implemented yet " << std::endl;
}


// ----------------------------------------------------------------------------------------------------------
// useCursor, no cursor on IPhone
// ----------------------------------------------------------------------------------------------------------

void GraphicsWindowIPhone::useCursor(bool cursorOn)
{
    OSG_INFO << "GraphicsWindowIPhone :: useCursor not implemented yet " << std::endl;
}


// ----------------------------------------------------------------------------------------------------------
// setCursor, no cursor on IPhone
// ----------------------------------------------------------------------------------------------------------

void GraphicsWindowIPhone::setCursor(MouseCursor mouseCursor)
{
    OSG_INFO << "GraphicsWindowIPhone :: setCursor not implemented yet " << std::endl;
}


// ----------------------------------------------------------------------------------------------------------
// setVSync, no vsync on IPhone
// ----------------------------------------------------------------------------------------------------------

void GraphicsWindowIPhone::setVSync(bool f) 
{
    OSG_INFO << "GraphicsWindowIPhone :: setVSync not implemented yet " << std::endl;
}
	
	
// ----------------------------------------------------------------------------------------------------------
// helper funcs for converting points to pixels taking into account the views contents scale factor
// ----------------------------------------------------------------------------------------------------------

osg::Vec2 GraphicsWindowIPhone::pointToPixel(const osg::Vec2& point)
{
	return point * _viewContentScaleFactor;
}
	
osg::Vec2 GraphicsWindowIPhone::pixelToPoint(const osg::Vec2& pixel)
{
	float scaler = 1.0f / _viewContentScaleFactor;
	return pixel * scaler;
}


// ----------------------------------------------------------------------------------------------------------
// d'tor
// ----------------------------------------------------------------------------------------------------------

GraphicsWindowIPhone::~GraphicsWindowIPhone() 
{
    close();
}



class CocoaWindowingSystemInterface : public  IPhoneWindowingSystemInterface {
public:
    CocoaWindowingSystemInterface()
    :    IPhoneWindowingSystemInterface()
    {
    }
    
    virtual osg::GraphicsContext* createGraphicsContext(osg::GraphicsContext::Traits* traits) 
    {											//osg::GraphicsContext
        return createGraphicsContextImplementation<GraphicsWindowIPhone, GraphicsWindowIPhone>(traits);
    }
};

}//end namspace


RegisterWindowingSystemInterfaceProxy<osgViewer::CocoaWindowingSystemInterface> createWindowingSystemInterfaceProxy;


// declare C entry point for static compilation.
extern "C" void graphicswindow_IPhone(void)
{
    osg::GraphicsContext::setWindowingSystemInterface(new osgViewer::CocoaWindowingSystemInterface());
}
