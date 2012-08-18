//
//  VEMainViewController.m
//  Box2DiOS
//
//  Created by tearsofphoenix on 8/18/12.
//
//

#import "VEMainViewController.h"
#include "Test.h"
#import "Box2DViewController.h"

@implementation VEMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *testSelectView =  [[UITableView alloc] initWithFrame: [[self view] bounds]
                                                                style: UITableViewStylePlain];
    [[self view] addSubview: testSelectView];
    
    [testSelectView setDataSource: self];
    [testSelectView setDelegate: self];
    
    [testSelectView release];
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    TestEntry *entryLooper = g_testEntries;
    NSInteger count = 0;
    while (entryLooper->name)
    {
        ++count;
        ++entryLooper;
    }
    return count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    const char* name = g_testEntries[[indexPath row]].name;
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [[cell textLabel] setText: [NSString stringWithUTF8String: name]];
    return [cell autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestCreateFcn *function = g_testEntries[[indexPath row]].createFcn;
    printf("name: %s\n", g_testEntries[[indexPath row]].name);
    
    Box2DViewController *viewController = [[Box2DViewController alloc] initFunction: function];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: viewController];
    
    [self presentModalViewController: navController
                            animated: YES];
    
    [navController release];
    [viewController release];
    
}

@end
