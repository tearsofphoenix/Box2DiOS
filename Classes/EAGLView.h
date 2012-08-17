//
//  EAGLView.h
//  Box2DiOS
//
//  Created by Campbell Chris on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


@interface EAGLView : UIView
{
@private
    
    // The pixel dimensions of the CAEAGLLayer.
    GLint framebufferWidth;
    GLint framebufferHeight;
    
    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view.
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
}

@property (nonatomic, retain) EAGLContext *context;

- (void)setFramebuffer;

- (BOOL)presentFramebuffer;

@end
