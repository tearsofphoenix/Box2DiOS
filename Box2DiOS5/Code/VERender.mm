/*
 *  VERender.cpp
 *  Box2DiOS
 *
 *  Created by Campbell Chris on 7/30/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <OpenGLES/ES1/gl.h>
#import <QuartzCore/QuartzCore.h>

#include <Box2D/Box2D.h>

#import "VERender.h"

#import "NVTimer.h"

#include "VERenderImplementation.h"

#import "CADisplayLink+BloackSupport.h"

@interface VERender ()
{
@private
    VERenderImplementation *_render;
    CADisplayLink *_displayTimer;
    CADisplayLink *_worldUpdateTimer;
}
@end

@implementation VERender

@synthesize world = _world;

- (id)init
{
    if ((self = [super init]))
    {
        _paused = YES;
        
        _world = new b2World(b2Vec2(0, -10));
        _render = new VERenderImplementation;
        _render->SetFlags(b2Draw::e_shapeBit);
        
        _world->SetDebugDraw(_render);
        
        //set update timer
        //
        _worldUpdateInterval = 1.0 / 60;
        
        _displayTimer = [CADisplayLink displayLinkWithTimeInterval: 1
                                                             block: (^
                                                                     {
                                                                         [_view display];
                                                                     })];
        
        //world update timer
        //
        _worldUpdateTimer = [CADisplayLink displayLinkWithTimeInterval: 1
                                                                 block: (^
                                                                         {
                                                                             [self updateWorld];
                                                                         })];
        
        [_displayTimer addToRunLoop: [NSRunLoop currentRunLoop]
                            forMode: NSDefaultRunLoopMode];
        [_worldUpdateTimer addToRunLoop: [NSRunLoop currentRunLoop]
                                forMode: NSDefaultRunLoopMode];
    }
    
    return self;
}

- (void)dealloc
{
    printf("in func: %s\n", __func__);
    
    delete _render;
    delete _world;
    
    if (_stepBlock)
    {
        Block_release(_stepBlock);
    }
    
    if (_renderBlock)
    {
        Block_release(_renderBlock);
    }
    
    [super dealloc];
}

- (void)addBodyByDefination: (const b2BodyDef&)bodyDefination
          fixtureDefination: (const b2FixtureDef&)fixtureDefination
{
    _world->CreateBody(&bodyDefination)->CreateFixture(&fixtureDefination);
}

@synthesize worldUpdateInterval = _worldUpdateInterval;

- (void)setWorldUpdateInterval: (NSTimeInterval)worldUpdateInterval
{
    if (_worldUpdateInterval != worldUpdateInterval)
    {
        _worldUpdateInterval = worldUpdateInterval;
        
        [_worldUpdateTimer setFrameInterval: _worldUpdateInterval];
    }
}

- (void)setFrameInterval: (NSTimeInterval)frameInterval
{
    [_displayTimer setFrameInterval: frameInterval];
}

- (NSTimeInterval)frameInterval
{
    return [_displayTimer frameInterval];
}

//update

- (void)updateWorld
{
    _world->Step(_worldUpdateInterval, 8, 3);
    if (_stepBlock)
    {
        _stepBlock();
    }
}


- (void)renderViewInRect: (CGRect)rect
{
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glOrthof(-16, 16, -8, 40, -1, 1);
    
	_world->DrawDebugData();
    
    if (_renderBlock)
    {
        _renderBlock();
    }
}

#pragma mark - GLKViewDelegate

- (void)glkView: (GLKView *)view
     drawInRect: (CGRect)rect
{
    [self renderViewInRect: rect];
}

@synthesize view = _view;

- (void)setView: (GLKView *)view
{
    if (_view != view)
    {
        [_view setDelegate: nil];
        [_view release];
        _view = [view retain];
        
        [_view setDelegate: self];
    }
}

@synthesize paused = _paused;

- (void)setPaused: (BOOL)paused
{
    if (_paused != paused)
    {
        _paused = paused;
        [_displayTimer setPaused: _paused];
        [_worldUpdateTimer setPaused: _paused];
    }
}

- (void)tearDown
{
    [self setStepBlock: nil];
    [self setRenderBlock: nil];

    [_displayTimer invalidate];
    _displayTimer = nil;
    
    [_worldUpdateTimer invalidate];
    _worldUpdateTimer = nil;
    
    [_view setDelegate: nil];
    [_view release];
    _view = nil;
    
}

@synthesize renderImpl = _render;

- (id)retain
{
    //NSLog(@"retian: %@", [NSThread callStackSymbols]);
    
    return [super retain];
}

- (oneway void)release
{
    //NSLog(@"release: %@", [NSThread callStackSymbols]);
    
    [super release];
}

@synthesize stepBlock = _stepBlock;

@synthesize renderBlock = _renderBlock;

@end
