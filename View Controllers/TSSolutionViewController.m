//
//  TSSolutionViewController.m
//  TrigSolv
//
//  Created by Justin Buchanan on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TSSolutionViewController.h"

@interface TSSolutionViewController ()
- (NSString *)stringWithDouble:(double)input roundedToDecimalPlaces:(int)decimals;
@end


@implementation TSSolutionViewController

@synthesize shapeController, displaysAngleInfo;


- (id)initWithSolutions:(NSArray *)theSolutions arrangement:(NSArray *)arrangement diagramViews:(NSArray *)views
{
    if ( self = [super initWithNibName:nil bundle:nil] )
	{
        solutions = [theSolutions retain];
		solutionArrangement = [arrangement retain];
		diagramViews = [views retain];
		
		displaysAngleInfo = NO;	//	default value
		transitioning = NO;
		
		_significantDigits = [[NSUserDefaults standardUserDefaults] integerForKey:@"significantDigits"];
		
		solution1View = nil;
		solution2View = nil;
    }
    return self;
}


- (void)loadView
{
	solution1View = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	solution1View.delegate = self;
	solution1View.dataSource = self;
	solution1View.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.view = solution1View;
	
	if ( [solutions count] == 2 )
	{
		solution2View = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
		solution2View.delegate = self;
		solution2View.dataSource = self;
		solution2View.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	}
	else
	{
		solution2View = nil;
	}
	
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideSolutions)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	if ( solution2View )
	{
		segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Solution 1", @"Solution 2", nil]];
		segmentedControl.selectedSegmentIndex = 0;
		[segmentedControl addTarget:self action:@selector(switchDisplayedSolution) forControlEvents:UIControlEventValueChanged];
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		
		self.navigationItem.titleView = segmentedControl;
		[segmentedControl release];
	}
	else
	{
		self.navigationItem.title = @"Solution";
		segmentedControl = nil;
	}
	
}


- (void)dealloc
{
	[solutions release];
	[solutionArrangement release];
	[diagramViews release];
	
	[solution1View release];
	[solution2View release];
	
	[super dealloc];
}



#pragma mark Autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark Changing Displayed Solution

- (void)switchDisplayedSolution
{
	if ( transitioning )
	{
		return;
	}

	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	[animation setType:kCATransitionPush];
		
	[animation setDuration:.5];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	UIView *superViewOfSolutionView = [self.view superview];
	
	if ( segmentedControl.selectedSegmentIndex == 1 )
	{
		[animation setSubtype:kCATransitionFromRight];
		
		[solution1View removeFromSuperview];
		
		solution2View.frame = self.view.frame;
		self.view = solution2View;
		[superViewOfSolutionView addSubview:self.view];
	}
	else
	{
		[animation setSubtype:kCATransitionFromLeft];
		
		[solution2View removeFromSuperview];
		
		solution1View.frame = self.view.frame;
		self.view = solution1View;
		[superViewOfSolutionView addSubview:self.view];
	}
	
	[superViewOfSolutionView.layer addAnimation:animation forKey:@"transitionViewAnimation"];
}

- (void)animationDidStart:(CAAnimation *)animation
{
	segmentedControl.enabled = NO;	//	disable segmented control while transitioning
	transitioning = YES;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished
{
	segmentedControl.enabled = YES;
	transitioning = NO;
}


#pragma mark Hiding Solutions

- (void)hideSolutions
{
	[shapeController dismissModalViewControllerAnimated:YES];
}


#pragma mark TableView Delegate & DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [solutionArrangement count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ( section == 0 ) ? 1 : [[solutionArrangement objectAtIndex:section - 1] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if ( section == 1 && displaysAngleInfo )
	{
		switch ( [[NSUserDefaults standardUserDefaults] integerForKey:@"angleUnit"] )
		{
			case JBAngleUnitRadian:		return NSLocalizedString( @"angleInfoRadian", nil );
			case JBAngleUnitDegree:		return NSLocalizedString( @"angleInfoDegree", nil );
			case JBAngleUnitGradian:	return NSLocalizedString( @"angleInfoGradian", nil );
		}
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ( indexPath.section == 0 ) ? 150 : 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( indexPath.section == 0 )
	{
		static NSString *shapeDiagramCellReuseID = @"shapeDiagramCell";
		ShapeDiagramCell *shapeDiagramCell = (ShapeDiagramCell *)[tableView dequeueReusableCellWithIdentifier:shapeDiagramCellReuseID];
		if ( !shapeDiagramCell )
		{
			UIView *shapeDiagramView = ( tableView == solution1View ) ? [diagramViews objectAtIndex:0] : [diagramViews objectAtIndex:1];
			shapeDiagramCell = [[[ShapeDiagramCell alloc] initWithReuseIdentifier:shapeDiagramCellReuseID shapeDiagramView:shapeDiagramView] autorelease];
		}
		
		return shapeDiagramCell;
	}

	NSString *cellReuseID = @"measureDisplayCell";
	
	MeasureDisplayCell *cell = (MeasureDisplayCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
	if ( !cell )
	{
		cell = [[[MeasureDisplayCell alloc] initWithValue:nil forKey:nil reuseIdentifier:cellReuseID] autorelease];
	}
	
	NSString *measureKey = (NSString *)[[solutionArrangement objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
	
	cell.key = measureKey;
	cell.value = [self stringWithDouble:[[[solutions objectAtIndex:( ( tableView == solution1View ) ? 0 : 1 )] objectForKey:measureKey] doubleValue] roundedToDecimalPlaces:_significantDigits];
	cell.selectable = NO;
	
	return cell;
}



#pragma mark Other

- (NSString *)stringWithDouble:(double)input roundedToDecimalPlaces:(int)decimals
{
	double value = input * pow(10, (double)decimals );
	value = roundf(value);
	value = (value / pow(10, (double)decimals));
	
	NSMutableString *string = [NSMutableString stringWithFormat:@"%f",value];
	
	while ([string characterAtIndex:[string length] - 1] == '0') {
		[string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
	}
	
	if ([string characterAtIndex:[string length] - 1] == '.') {
		[string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
	}
	
	return string;
}


@end
