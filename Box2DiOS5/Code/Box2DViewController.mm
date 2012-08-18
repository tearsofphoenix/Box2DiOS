//
//  Box2DViewController.m
//  Box2DiOS
//
//  Created by tearsofphoenix on 8/17/12.
//
//

#import "Box2DViewController.h"

#import "VERender.h"

#import <Box2D/Box2D.h>

#import "Test.h"

@interface Box2DViewController ()
{
    Test *_test;
}
@end

@implementation Box2DViewController

- (id)initFunction: (TestCreateFcn *)function
{
    if (function)
    {
        if ((self = [super init]))
        {
            _render = [[VERender alloc] init];
            
            _test = function([_render world], [_render renderImpl]);
            
            _context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
        }
        return self;
    }
    return nil;
}

- (void)dealloc
{
    [_render setPaused: YES];
    [_render setView: nil];
    
    [_contentView release];
    
    if ([EAGLContext currentContext] == _context)
    {
        [EAGLContext setCurrentContext: nil];
    }
    
    [_context release];

    delete  _test;
    
    [_render tearDown];
    
    [_render release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contentView = [[GLKView alloc] initWithFrame: [[self view] bounds]
                                          context: _context];
    [[self view] addSubview: _contentView];
    
    [_render setView: _contentView];
    [_render setPaused: NO];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                              target: self
                                                                              action: @selector(backward)];
    [[self navigationItem] setRightBarButtonItem: doneItem];
    [doneItem release];
}

- (void)viewDidUnload
{
    [_render setPaused: YES];
    [_render setView: nil];
    
    [_contentView release];
    
    [super viewDidUnload];
}

- (void)backward
{
    [self dismissModalViewControllerAnimated: YES];
}

@end
