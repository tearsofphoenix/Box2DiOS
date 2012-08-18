//
//  Box2DiOSAppDelegate.m
//  Box2DiOS
//
//  Created by Campbell Chris on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DiOSAppDelegate.h"
#import "Box2DiOSViewController.h"

@implementation Box2DiOSAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    _viewController = [[Box2DiOSViewController alloc] init];
    [_window setRootViewController: _viewController];
    
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [_viewController stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [_viewController startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [_viewController stopAnimation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Handle any background procedures not related to animation here.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Handle any foreground procedures not related to animation here.
}

- (void)dealloc
{
    [_viewController release];
    [_window release];
    
    [super dealloc];
}

@end
