//
//  EllipseController.m
//  Shape Master
//
//  Created by Justin Buchanan on 9/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EllipseController.h"


@implementation EllipseController


- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.tabBarItem.image = [UIImage imageNamed:@"Ellipse_Tabbar.png"];
		self.showsAngleUnit = NO;
		
		NSString *blankString = [[NSString alloc] initWithString:@""];
		NSArray *values = [[NSArray alloc] initWithObjects:blankString, blankString, blankString, nil];
		[blankString release];
		
		NSArray *measureNames = [[NSArray alloc] initWithObjects:@"majorAxis", @"minorAxis", @"focalDistance" , nil];
		
		self.measureValues = [NSMutableDictionary dictionaryWithObjects:values forKeys:measureNames];
		[values release];
		
		measureArrangement = [[NSMutableArray alloc] initWithArray:measureNames];
		[measureNames release];
	}
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ( section == 0 || section == 2 )
	{
		return 1;
	}
	
	return [measureArrangement count];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if ( section == 0 )
	{
		return NSLocalizedString( @"ellipseInfo", nil );
	}
	
	return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellReuseID;
	
	switch ( indexPath.section )
	{
		case 0:
		{
			NSString *cellReuseID = @"shapeDiagramCell";
			ShapeDiagramCell *shapeCell = (ShapeDiagramCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
			if ( !shapeCell )
			{
				UIImageView *diagramView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ellipse_Diagram.png"]];
				
				shapeCell = [[[ShapeDiagramCell alloc] initWithReuseIdentifier:cellReuseID shapeDiagramView:diagramView] autorelease];
				[diagramView release];
			}
		
			return shapeCell;
		}
		case 2:
		{
			//clearvaluescell
			cellReuseID = @"clearValuesCell";
			ClearValuesCell *clearValuesCell = (ClearValuesCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
			if ( !clearValuesCell )
			{
				clearValuesCell = [[[ClearValuesCell alloc] initWithShapeController:self reuseIdentifier:cellReuseID] autorelease];
			}
			
			return clearValuesCell;
		}
		default:
		{
			cellReuseID = @"measureDisplayCell";
			MeasureDisplayCell *cell = (MeasureDisplayCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
			
			NSString *cellKey = [measureArrangement objectAtIndex:indexPath.row];
			NSString *cellValue = [measureValues objectForKey:cellKey];
			
			if ( !cell )
			{
				cell = [[[MeasureDisplayCell alloc] initWithValue:cellValue forKey:cellKey reuseIdentifier:cellReuseID] autorelease];
			}
			else
			{
				cell.key = [measureArrangement objectAtIndex:indexPath.row];
				cell.value = [measureValues objectForKey:cell.key];
			}
			
			return cell;
		}
	}
}


- (void)reloadTable
{
	[measureArrangement release];

	NSString *blankString = [[NSString alloc] initWithString:@""];
	
	short int givenMeasures = 0;
	
	for (NSString *key in measureValues) {
		NSString *value =  (NSString *)[measureValues objectForKey:key];
		if ( ![value isEqualToString:blankString] ) {
			++givenMeasures;
		}
	}
	
	measureArrangement = [[NSMutableArray alloc] initWithCapacity:3];
	
	if ( givenMeasures == 2 )
	{
		if ( ![[measureValues objectForKey:@"majorAxis"] isEqualToString:blankString] ) {
			[measureArrangement addObject:@"majorAxis"];
		}
		if ( ![[measureValues objectForKey:@"minorAxis"] isEqualToString:blankString] ) {
			[measureArrangement addObject:@"minorAxis"];
		}
		if ( ![[measureValues objectForKey:@"focalDistance"] isEqualToString:blankString] ) {
			[measureArrangement addObject:@"focalDistance"];
		}
		
		[self showSolveButtonEnabled:YES];
	} else {
		[measureArrangement addObject:@"majorAxis"];
		[measureArrangement addObject:@"minorAxis"];
		[measureArrangement addObject:@"focalDistance"];
		
		[self showSolveButtonEnabled:NO];
	}
	
	[blankString release];
	[self.tableView reloadData];
}


- (void)solve
{
	JBEllipseSolver *ellipseSolver = [[JBEllipseSolver alloc] init];
	
	ellipseSolver.majorAxis = [(NSNumber *)[self.measureValues objectForKey:@"majorAxis"] doubleValue];
	ellipseSolver.minorAxis = [(NSNumber *)[self.measureValues objectForKey:@"minorAxis"] doubleValue];
	ellipseSolver.focalDistance = [(NSNumber *)[self.measureValues objectForKey:@"focalDistance"] doubleValue];
	
	NSDictionary *ellipseSolution = [ellipseSolver solve];
	
	if ( !ellipseSolution )
	{
		if ( ellipseSolver.minorAxis >= ellipseSolver.majorAxis || ellipseSolver.majorAxis <= ellipseSolver.focalDistance )
		{
			[self showNoSolutionWithMessage:NSLocalizedString( @"ellipseError", nil )];
		}
		else
		{
			[self showNoSolutionWithMessage:nil];
		}
		[ellipseSolver release];
		
		return;
	}
	else
	{
		[ellipseSolver release];
	}
	
	NSArray *solutionArrangement = [NSArray arrayWithObjects:	[NSArray arrayWithObjects:@"majorAxis", @"minorAxis", @"focalDistance", nil],
																[NSArray arrayWithObjects:@"area", @"circumference", nil],
																nil];
	EllipseView *ellipseDiagramView = [[EllipseView alloc] initWithEllipse:ellipseSolution];
	
	TSSolutionViewController *solutionController = [[TSSolutionViewController alloc] initWithSolutions:[NSArray arrayWithObject:ellipseSolution]
																							arrangement:solutionArrangement
																							diagramViews:[NSArray arrayWithObject:ellipseDiagramView]];
	solutionController.shapeController = self;
	[ellipseDiagramView release];
	
	UINavigationController *solutionNavigationController = [[UINavigationController alloc] initWithRootViewController:solutionController];
	[solutionController release];
	
	[self presentModalViewController:solutionNavigationController animated:YES];
	[solutionNavigationController release];
	
	[self showSolveButtonEnabled:YES];
}


@end

