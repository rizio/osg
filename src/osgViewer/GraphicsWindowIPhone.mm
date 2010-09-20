

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
        
        eaglLayer.opaque = YES;
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



- (void)layoutSubviews {
    [EAGLContext setCurrentContext:_context];
    [self destroyFramebuffer];
    [self createFramebuffer];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &_viewFramebuffer);
    glGenRenderbuffersOES(1, &_viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);

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
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &_viewFramebuffer);
    _viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &_viewRenderbuffer);
    _viewRenderbuffer = 0;
    
    if(_depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &_depthRenderbuffer);
        _depthRenderbuffer = 0;
    }
	
	if(_stencilBuffer) {
		glDeleteFramebuffersOES(1, &_stencilBuffer);
		_stencilBuffer = 0;
	}
}

//
//Swap the view and render buffers
//
- (void)swapBuffers {

	//swap buffers (sort of i think?)
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
	//display render in context
    [_context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	//re bind the frame buffer for next frames renders
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
}

//
//bind view buffer as current for new render pass
//
- (void)bindFrameBuffer {

	//bind the frame buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
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
		
		if (!osg_event) {
			osg_event = _win->getEventQueue()->touchBegan(i, [self convertTouchPhase: [touch phase]], pos.x, pos.y);
		} else {
			osg_event->addTouchPoint(i, [self convertTouchPhase: [touch phase]], pos.x, pos.y);
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
		
		if (!osg_event) {
			osg_event = _win->getEventQueue()->touchMoved(i, [self convertTouchPhase: [touch phase]], pos.x, pos.y);
		} else {
			osg_event->addTouchPoint(i, [self convertTouchPhase: [touch phase]], pos.x, pos.y);
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
		
		if (!osg_event) {
			osg_event = _win->getEventQueue()->touchEnded(i, [self convertTouchPhase: [touch phase]], pos.x, pos.y, [touch tapCount]);
		} else {
			osg_event->addTouchPoint(i, [self convertTouchPhase: [touch phase]], pos.x, pos.y, [touch tapCount]);
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
    osg::notify(osg::INFO) << "shouldAutorotateToInterfaceOrientation for " << interfaceOrientation << ": " << ((result==YES) ? "YES" : "NO") << std::endl;
    return result;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration 
{
    osgViewer::GraphicsWindowIPhone* win = [(GraphicsWindowIPhoneGLView*)(self.view) getGraphicsWindow];
    if (win) {
        CGRect frame = self.view.bounds;
        osg::notify(osg::INFO) 
            << "willAnimateRotationToInterfaceOrientation, resize to " 
            <<  frame.origin.x << " " << frame.origin.y << " " 
            << frame.size.width << " " << frame.size.height 
            << std::endl;
        win->resized (frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
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
	
        
    IPhoneWindowingSystemInterface* wsi = dynamic_cast<IPhoneWindowingSystemInterface*>(osg::GraphicsContext::getWindowingSystemInterface());
    int screenLeft(0), screenTop(0);
    if (wsi) {
        wsi->getScreenTopLeft((*_traits), screenLeft, screenTop);
    }
    
    CGRect rect =  [[UIScreen mainScreen] bounds];// = //CGRectMake((CGFloat)(_traits->x + screenLeft), (CGFloat)(_traits->y + screenTop), (CGFloat)(_traits->width), (CGFloat)(_traits->height));
	rect.origin.x = _traits->x; rect.origin.y = _traits->y;
	rect.size.width = _traits->width; rect.size.height = _traits->height;
	
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
    } 
    

    osg::notify(osg::DEBUG_INFO) << "GraphicsWindowIPhone::realizeImplementation / ownsWindow: " << _ownsWindow << std::endl;

    if (_ownsWindow) 
    {
		//create the IPhone window object
        _window = [[GraphicsWindowIPhoneWindow alloc] initWithFrame: rect];// styleMask: style backing: NSBackingStoreBuffered defer: NO];
        
        if (!_window) {
            osg::notify(osg::WARN) << "GraphicsWindowIPhone::realizeImplementation :: could not create window" << std::endl;
            return false;
        }
    } 
            
	//create the desired OpenGLES context type
#if OSG_GLES1_FEATURES
	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
#elif OSG_GLES2_FEATURES
	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
#endif
	
	if (!_context || ![EAGLContext setCurrentContext:_context]) {
		osg::notify(osg::WARN) << "GraphicsWindowIPhone::realizeImplementation :: could not create graphics context" << std::endl;
		return false;
	}

	//create the view to display our context in our window
    GraphicsWindowIPhoneGLView* theView = [[ GraphicsWindowIPhoneGLView alloc ] initWithFrame:[ _window frame ] : this ];
    [theView setAutoresizingMask:  ( UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight) ];
    [theView setGraphicsWindow: this];
    [theView setOpenGLContext:_context];
    _view = theView;
    osg::notify(osg::DEBUG_INFO) << "GraphicsWindowIPhone::realizeImplementation / view: " << theView << std::endl;

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
    _valid = false;
    _realized = false;
    
    
    if (_view) {
        [_view setGraphicsWindow: NULL];
    }
    
    if (_viewController) {
        [_viewController release];
    }
        
    if (_window) {  
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
    osg::notify(osg::INFO) << "GraphicsWindowIPhone :: grabFocusIfPointerInWindow not implemented yet " << std::endl;
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
    osg::notify(osg::INFO) << "GraphicsWindowIPhone :: setWindowRectangleImplementation not implemented yet " << std::endl;
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
    osg::notify(osg::INFO) << "GraphicsWindowIPhone :: setWindowName not implemented yet " << std::endl;
}


// ----------------------------------------------------------------------------------------------------------
// useCursor, no cursor on IPhone
// ----------------------------------------------------------------------------------------------------------

void GraphicsWindowIPhone::useCursor(bool cursorOn)
{
    osg::notify(osg::INFO) << "GraphicsWindowIPhone :: useCursor not implemented yet " << std::endl;
}


// ----------------------------------------------------------------------------------------------------------
// setCursor, no cursor on IPhone
// ----------------------------------------------------------------------------------------------------------

void GraphicsWindowIPhone::setCursor(MouseCursor mouseCursor)
{
    osg::notify(osg::INFO) << "GraphicsWindowIPhone :: setCursor not implemented yet " << std::endl;
}


// ----------------------------------------------------------------------------------------------------------
// setVSync, no vsync on IPhone
// ----------------------------------------------------------------------------------------------------------

void GraphicsWindowIPhone::setVSync(bool f) 
{
    osg::notify(osg::INFO) << "GraphicsWindowIPhone :: setVSync not implemented yet " << std::endl;
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
