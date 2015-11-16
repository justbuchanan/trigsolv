//
//  TrigSolv_AppDelegate.h
//  Shape Master
//
//  Created by Justin Buchanan on 9/22/08.
//  Copyright JustBuchanan Enterprises 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "ShapeController.h"
#import "TriangleController.h"
#import "RectangleController.h"
#import "ParallelogramController.h"
#import "CircleController.h"
#import "EllipseController.h"
#import "TrapezoidController.h"


@interface TrigSolv_AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>
{
	IBOutlet UIWindow *window;
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end

