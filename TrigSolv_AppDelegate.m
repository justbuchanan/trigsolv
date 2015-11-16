//
//  TrigSolv_AppDelegate.m
//  Shape Master
//
//  Created by Justin Buchanan on 9/22/08.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import "TrigSolv_AppDelegate.h"


@interface TrigSolv_AppDelegate (Private)
- (UINavigationController *)createNavigationControllerWrappingViewControllerWithName:(NSString *)theIdentifier;
@end

@implementation TrigSolv_AppDelegate

@synthesize window;
@synthesize tabBarController;


- (void)dealloc
{
	[window release];
	[super dealloc];
	
	[tabBarController release];
}


#pragma mark Application Delegate Methods
- (void)applicationDidFinishLaunching:(UIApplication *)application
{	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	
	NSString *configFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/viewControllerConfig.plist"];
	
	NSArray *viewControllerNames = [[NSArray alloc] initWithContentsOfFile:configFilePath];
	
	if ( !viewControllerNames ) {
		NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"TrigSolv.app/DefaultViewControllerConfig.plist"];
		viewControllerNames = [[NSArray alloc] initWithContentsOfFile:path];
		/*
		Present First-time use info.
		*/
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
		[userDefaults setInteger:3 forKey:@"significantDigits"];
		[userDefaults setInteger:1 forKey:@"angleUnit"];
	}
	
	NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:6];
	
	for (NSString *controllerName in viewControllerNames) {
		UINavigationController *theController = [self createNavigationControllerWrappingViewControllerWithName:controllerName];
		[viewControllers addObject:theController];
	}
	[viewControllerNames release];
	
	tabBarController = [[UITabBarController alloc] init];
	tabBarController.delegate = self;
	tabBarController.viewControllers = viewControllers;
	[viewControllers release];
	[window addSubview:tabBarController.view];
	
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)theApplication
{
	[[NSUserDefaults standardUserDefaults] synchronize];//is this unnecessary
	
	NSLog(@"TrigSolv will terminmate");
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ( ![fileManager fileExistsAtPath:[NSHomeDirectory() stringByAppendingString:@"Documents/viewControllerConfig.plist"]] )
	{
		[self tabBarController:self.tabBarController didEndCustomizingViewControllers:tabBarController.viewControllers changed:YES];
	}
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	
	NSLog(@"TrigSolv App Delegate got a memory warning");
	
	//	Clean up trash
}

#pragma mark View Controller Initialization

- (UINavigationController *)createNavigationControllerWrappingViewControllerWithName:(NSString *)controllerName {
	ShapeController *theShapeController;
	
	if ( [controllerName isEqualToString:@"Triangle"] ) {
		theShapeController = [[TriangleController alloc] initWithStyle:UITableViewStyleGrouped];
	} else if ( [controllerName isEqualToString:@"Rectangle"] ) {
		theShapeController = [[RectangleController alloc] initWithStyle:UITableViewStyleGrouped];
	} else if ( [controllerName isEqualToString:@"Circle"] ) {
		theShapeController = [[CircleController alloc] initWithStyle:UITableViewStyleGrouped];
	} else if ( [controllerName isEqualToString:@"Ellipse"] ) {
		theShapeController = [[EllipseController alloc] initWithStyle:UITableViewStyleGrouped];
	} else if ( [controllerName isEqualToString:@"Parallelogram"] ) {
		theShapeController = [[ParallelogramController alloc] initWithStyle:UITableViewStyleGrouped];
	} else {
		theShapeController = [[TrapezoidController alloc] initWithStyle:UITableViewStyleGrouped];
	}
	theShapeController.title = NSLocalizedString(controllerName, nil);
	
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:theShapeController] autorelease];
	return navController;
}

- (void)tabBarController:(UITabBarController *)theTabbarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
	NSLog(@"the tabbarcontroller finished editing items");
	if (changed) {
		NSMutableArray *viewControllerConfiguration = [[NSMutableArray alloc] initWithCapacity:6];
		for (UINavigationController *navController in tabBarController.viewControllers) {
			[viewControllerConfiguration addObject:navController.topViewController.title];
		}
		
		[viewControllerConfiguration writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/viewControllerConfig.plist"] atomically:YES];
		[viewControllerConfiguration release];
	}
}


@end
