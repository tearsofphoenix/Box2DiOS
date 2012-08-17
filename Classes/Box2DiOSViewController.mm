//
//  Box2DiOSViewController.m
//  Box2DiOS
//
//  Created by Campbell Chris on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#include <Box2D/Box2D.h>

#include "Box2DiOSRender.h"

#import "Box2DiOSViewController.h"
#import "EAGLView.h"

// Uniform index.
enum
{
    UNIFORM_TRANSLATE,
    NUM_UNIFORMS
};

GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

@interface Box2DiOSViewController ()
{
@private
    b2World* m_world;
    
	Box2DiOSRender *m_debugDraw;

    BOOL _animating;
}

@property (nonatomic, retain) EAGLContext *context;

- (BOOL)loadShaders;

- (BOOL)compileShader: (GLuint *)shader
                 type: (GLenum)type
                 file: (NSString *)file;

- (BOOL)linkProgram:(GLuint)prog;

- (BOOL)validateProgram:(GLuint)prog;

@end

@implementation Box2DiOSViewController

@synthesize context = _context;

- (id)init
{
    if ((self = [super init]))
    {
        
        EAGLContext *aContext = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
        
        if (!aContext)
        {
            aContext = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
        }
        
        if (!aContext)
        {
            NSLog(@"Failed to create ES context");
            
        }else if (![EAGLContext setCurrentContext: aContext])
        {
            NSLog(@"Failed to set ES context current");
        }
        
        [self setContext: aContext];
        
        [aContext release];
        
        EAGLView *view = [[EAGLView alloc] init];
        [self setView: view];
        [view release];
        
        [view setContext: _context];
        [view setFramebuffer];
        
        if ([_context API] == kEAGLRenderingAPIOpenGLES2)
        {
            [self loadShaders];
        }
        
        _animating = FALSE;
        
        _animationFrameInterval = 1;
                
        m_world = new b2World( b2Vec2(0,-10));
        m_world->SetAllowSleeping(true);
        
        m_debugDraw = new Box2DiOSRender;
        
        m_debugDraw->SetFlags(b2Draw::e_shapeBit);
        
        m_world->SetDebugDraw(m_debugDraw);
        
        {
            //body definition
            b2BodyDef myBodyDef;
            myBodyDef.type = b2_dynamicBody;
            
            //shape definition
            b2PolygonShape polygonShape;
            polygonShape.SetAsBox(1, 1); //a 2x2 rectangle
            
            //fixture definition
            b2FixtureDef myFixtureDef;
            myFixtureDef.shape = &polygonShape;
            myFixtureDef.density = 1;
            
            //create dynamic bodies
            for (int i = 0; i < 10; i++)
            {
                myBodyDef.position.Set(0, 10);
                m_world->CreateBody(&myBodyDef)->CreateFixture(&myFixtureDef);
            }
            
            //a static body
            myBodyDef.type = b2_staticBody;
            myBodyDef.position.Set(0, 0);
            b2Body* staticBody = m_world->CreateBody(&myBodyDef);
            
            //create some circles
            b2CircleShape circleShape;
            circleShape.m_radius = 2;

            b2FixtureDef circleFixtureDef;
            circleFixtureDef.shape = &circleShape;
            circleFixtureDef.density = 0.5;
            
            myBodyDef.type = b2_dynamicBody;
            myBodyDef.position.Set(0, 10);

            m_world->CreateBody(&myBodyDef)->CreateFixture(&circleFixtureDef);
            
            //add a fixture to the static body
            polygonShape.SetAsBox( 10, 1, b2Vec2(0, 0), 0);
            staticBody->CreateFixture(&myFixtureDef);
        }
    }
    return self;
}

- (void)dealloc
{
    if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }
    
    // Tear down context.
    if ([EAGLContext currentContext] == _context)
    {
        [EAGLContext setCurrentContext: nil];
    }
    
    [_context release];
    
    [super dealloc];
}

- (BOOL)isAnimating
{
    return _animating;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self startAnimation];
    
    [super viewWillAppear: animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAnimation];
    
    [super viewWillDisappear: animated];
}

- (void)viewDidUnload
{
	delete m_world;
	
	[super viewDidUnload];
	
    if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }
    
    // Tear down context.
    if ([EAGLContext currentContext] == _context)
    {
        [EAGLContext setCurrentContext:nil];
    }
	[self setContext: nil];
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1)
    {
        _animationFrameInterval = frameInterval;
        
        if (_animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!_animating)
    {
        displayLink = [CADisplayLink displayLinkWithTarget: self
                                                  selector: @selector(drawFrame)];
        [displayLink setFrameInterval: _animationFrameInterval];
        
        [displayLink addToRunLoop: [NSRunLoop currentRunLoop]
                          forMode: NSDefaultRunLoopMode];
        
        _animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (_animating)
    {
        
        [displayLink invalidate];
        displayLink = nil;
        
        _animating = FALSE;
    }
}

- (void)drawFrame
{
	[(EAGLView *)[self view] setFramebuffer];
	
	glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glOrthof(-16, 16, -8, 40, -1, 1);
	
	m_world->Step(1/60.0f, 8, 3);
	m_world->DrawDebugData();
    
    [(EAGLView *)[self view] presentFramebuffer];
}

- (BOOL)compileShader: (GLuint *)shader
                 type: (GLenum)type
                 file: (NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(program, ATTRIB_COLOR, "color");
    
    // Link program.
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        
        return FALSE;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_TRANSLATE] = glGetUniformLocation(program, "translate");
    
    // Release vertex and fragment shaders.
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
    
    return TRUE;
}

@end
