//
//  Box2DiOSViewController.h
//  Box2DiOS
//
//  Created by Campbell Chris on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CADisplayLink;

@interface Box2DiOSViewController : UIViewController
{
    GLuint program;

    CADisplayLink *displayLink;
	
}

- (BOOL)isAnimating;

@property (nonatomic) NSInteger animationFrameInterval;

- (void)startAnimation;

- (void)stopAnimation;

@end
