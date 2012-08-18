/*
 *  VERender.h
 *  Box2DiOS
 *
 *  Created by Campbell Chris on 7/30/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <GLKit/GLKit.h>

class b2World;
class b2BodyDef;
class b2FixtureDef;

class VERenderImplementation;

@interface VERender : NSObject<GLKViewDelegate>
{
@protected
    b2World *_world;
}

@property (nonatomic, readonly) b2World *world;

@property (nonatomic, readonly) VERenderImplementation *renderImpl;

@property (nonatomic) NSTimeInterval worldUpdateInterval; //world update interval for Box2D, default is 1.0 / 60;

@property (nonatomic) NSTimeInterval frameInterval; // frame update interval, default is 1.0 / 60;

@property (nonatomic, retain) GLKView *view; //target view to update

@property (nonatomic, getter = isPaused) BOOL paused; //default is YES, set this to NO to start render

//this will invalidate all update timers, clear up context
//
- (void)tearDown;

//create body in world with defination
//
- (void)addBodyByDefination: (const b2BodyDef&)bodyDefination
          fixtureDefination: (const b2FixtureDef&)fixtureDefination;

//update the Box2D world, if you subclassed VERender, you should call super
//
- (void)updateWorld;

//re-draw the GLKView, if you subclassed VERender, you should call super
//
- (void)renderViewInRect: (CGRect)rect;

@end