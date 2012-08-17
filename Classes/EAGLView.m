//
//  EAGLView.m
//  Box2DiOS
//
//  Created by Campbell Chris on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "EAGLView.h"

@interface EAGLView (PrivateMethods)

- (void)createFramebuffer;

- (void)deleteFramebuffer;

@end

@implementation EAGLView

@synthesize context = _context;

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)init
{
    self = [super init];
	if (self)
    {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)[self layer];
        
        [eaglLayer setOpaque: TRUE];
        
        [eaglLayer setDrawableProperties: [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                           kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                           nil]];
    }
    
    return self;
}

- (void)dealloc
{
    [self deleteFramebuffer];    
    [_context release];
    
    [super dealloc];
}

- (void)setContext:(EAGLContext *)newContext
{
    if (_context != newContext)
    {
        [self deleteFramebuffer];
        
        [_context release];
        _context = [newContext retain];
        
        [EAGLContext setCurrentContext: nil];
    }
}

- (void)createFramebuffer
{
    if (_context && !defaultFramebuffer)
    {
        [EAGLContext setCurrentContext: _context];
        
        // Create default framebuffer object.
        glGenFramebuffers(1, &defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        
        // Create color render buffer and allocate backing store.
        
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        
        [_context renderbufferStorage: GL_RENDERBUFFER
                         fromDrawable: (CAEAGLLayer *)[self layer]];
        
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
        
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        {
            NSLog(@"Failed to make complete framebuffer object 0x%x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        }
         
    }
}

- (void)deleteFramebuffer
{
    if (_context)
    {
        [EAGLContext setCurrentContext: _context];
        
        if (defaultFramebuffer)
        {
            glDeleteFramebuffers(1, &defaultFramebuffer);
            defaultFramebuffer = 0;
        }
        
        if (colorRenderbuffer)
        {
            glDeleteRenderbuffers(1, &colorRenderbuffer);
            colorRenderbuffer = 0;
        }
    }
}

- (void)setFramebuffer
{
    if (_context)
    {
        [EAGLContext setCurrentContext: _context];
        
        if (!defaultFramebuffer)
        {
            [self createFramebuffer];
        }
        
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        
        glViewport(0, 0, framebufferWidth, framebufferHeight);
    }
}

- (BOOL)presentFramebuffer
{
    BOOL success = FALSE;
    
    if (_context)
    {
        [EAGLContext setCurrentContext: _context];
        
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        
        success = [_context presentRenderbuffer: GL_RENDERBUFFER];
    }
    
    return success;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // The framebuffer will be re-created at the beginning of the next setFramebuffer method call.
    //
    [self deleteFramebuffer];
}

#pragma mark - handle touch events

- (void)touchesBegan: (NSSet *)touches
           withEvent: (UIEvent *)event
{
    
}

- (void)touchesMoved: (NSSet *)touches
           withEvent: (UIEvent *)event
{
    
}

- (void)touchesEnded: (NSSet *)touches
           withEvent: (UIEvent *)event
{
    
}

@end
