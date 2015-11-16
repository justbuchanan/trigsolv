//
//  ShapeController.h
//  Shape Master
//
//  Created by Justin Buchanan on 9/24/08.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "MeasureEntryCell.h"
#import "MeasureDisplayCell.h"
#import "MeasureEntryViewController.h"
#import "TSSolutionViewController.h"
#import "AngleUnitCell.h"
#import "ShapeDiagramCell.h"
#import "ClearValuesCell.h"
#import "JBGeometry.h"


/*

This is the ABSTRACT superclass of all of the shape controllers

*/
@interface ShapeController : UITableViewController <UIActionSheetDelegate>
{	
	NSMutableArray *measureArrangement;
	NSMutableDictionary *measureValues;
	
	BOOL showsAngleUnit;
	BOOL fadingOut;
}

@property (nonatomic, readwrite, retain) NSMutableDictionary *measureValues;
@property (nonatomic, readwrite) BOOL showsAngleUnit;

- (void)solve;
- (void)showNoSolutionWithMessage:(NSString *)message;
- (void)showSolveButtonEnabled:(BOOL)enabled;

- (void)reloadTable;

- (void)clearValues;
- (void)confirmClearValues;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
