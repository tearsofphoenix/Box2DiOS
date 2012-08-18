//
//  AppDelegate.m
//  Box2DiOS5
//
//  Created by tearsofphoenix on 8/17/12.
//
//

#import "AppDelegate.h"

#import "VEMainViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    VEMainViewController *viewController = [[VEMainViewController alloc] init];
    
    [_window setRootViewController: viewController];
    [viewController release];
    
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
