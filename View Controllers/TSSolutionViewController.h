//
//  TSSolutionViewController.h
//  TrigSolv
//
//  Created by Justin Buchanan on 1/5/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "MeasureDisplayCell.h"
#import "ShapeDiagramCell.h"
#import "JBGeometry.h"

@class ShapeController;

@interface TSSolutionViewController : UIViewController < UITableViewDelegate, UITableViewDataSource >
{
	ShapeController *shapeController;	//	this is the parent view controller that launched this solution view controller.  You MUST set this before use!!!!!!!!!!!
	
	int _significantDigits;
	
	NSArray *solutions;
	NSArray *diagramViews;
	NSArray *solutionArrangement;
	
	UITableView *solution1View;
	UITableView *solution2View;
	
	UISegmentedControl *segmentedControl;	//	only used if there are two solutions
	
	BOOL transitioning;	//	indicates whether or not the solutions are currently switching
	BOOL displaysAngleInfo;
}

- (id)initWithSolutions:(NSArray *)theSolutions arrangement:(NSArray *)arrangement diagramViews:(NSArray *)views;

- (void)switchDisplayedSolution;

@property ( nonatomic, readwrite, assign ) ShapeController *shapeController;
@property ( nonatomic, readwrite ) BOOL displaysAngleInfo;	//	default is no.  if yes, the angle unit is displayed in the footer below section 2 (index 1)

@end
