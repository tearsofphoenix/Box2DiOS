//
//  Box2DViewController.h
//  Box2DiOS
//
//  Created by tearsofphoenix on 8/17/12.
//
//

#import <GLKit/GLKit.h>

#include "Test.h"

@class VERender;

@interface Box2DViewController : UIViewController
{
    VERender *_render;
    EAGLContext *_context;
    GLKView *_contentView;
}

- (id)initFunction: (TestCreateFcn *)function;

@end
