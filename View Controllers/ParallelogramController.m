//
//  ParallelogramController.m
//  Shape Master
//
//  Created by Justin Buchanan on 9/24/08.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import "ParallelogramController.h"


@implementation ParallelogramController


- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.tabBarItem.image = [UIImage imageNamed:@"Parallelogram_Tabbar.png"];
		self.showsAngleUnit = YES;
		
		NSString *blankString = [[NSString alloc] initWithString:@""];
		NSArray *values = [[NSArray alloc] initWithObjects:blankString, blankString, blankString, blankString, nil];
		[blankString release];
		NSArray *measureNames = [[NSArray alloc] initWithObjects:@"base", @"side", @"angleA", @"angleB", nil];
		self.measureValues = [NSMutableDictionary dictionaryWithObjects:values forKeys:measureNames];
		[values release];
		[measureNames release];
		
		NSArray *visibleAngles = [[NSArray alloc] initWithObjects:@"angleA", @"angleB", nil];
		NSArray *visiblesides = [[NSArray alloc] initWithObjects:@"base", @"side", nil];
		measureArrangement = [[NSMutableArray alloc] initWithObjects:visibleAngles, visiblesides, @"angleUnit", @"clearValues", nil];
		[visibleAngles release];
		[visiblesides release];
	}
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [measureArrangement count] + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ( section == 0 )
	{
		return 1;
	}
	
	NSObject *tableSection = [measureArrangement objectAtIndex:section - 1];
	if ( [tableSection isKindOfClass:[NSString class]] )
	{
		return 1;
	}
	
	return [(NSArray *)tableSection count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellReuseID;
	
	if ( indexPath.section == 0 )
	{
		cellReuseID = @"shapeDiagramCell";
		ShapeDiagramCell *shapeCell = (ShapeDiagramCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
		if ( !shapeCell )
		{
			UIImageView *parallelogramDiagram = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Parallelogram_Diagram.png"]];
			shapeCell = [[[ShapeDiagramCell alloc] initWithReuseIdentifier:cellReuseID shapeDiagramView:parallelogramDiagram] autorelease];
			
			[parallelogramDiagram release];
		}
		
		return shapeCell;
	}
	else
	{
		NSObject *tableSection = [measureArrangement objectAtIndex:indexPath.section - 1];
		
		if ( [tableSection isKindOfClass:[NSString class]] )
		{
			if ( [(NSString *)tableSection isEqualToString:@"angleUnit"] )
			{//angleunitcell
				cellReuseID = @"angleUnitCell";
				AngleUnitCell *angleUnitCell = (AngleUnitCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
				if ( !angleUnitCell )
				{
					angleUnitCell = [[[AngleUnitCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellReuseID] autorelease];
				}
				
				return angleUnitCell;
			}
			else
			{//clearvaluescell
				cellReuseID = @"clearValuesCell";
				ClearValuesCell *clearValuesCell = (ClearValuesCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
				if ( !clearValuesCell )
				{
					clearValuesCell = [[[ClearValuesCell alloc] initWithShapeController:self reuseIdentifier:cellReuseID] autorelease];
				}
				
				return clearValuesCell;
			}
		}
		else
		{
			cellReuseID = @"measureDisplayCell";
			MeasureDisplayCell *cell = (MeasureDisplayCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
			
			NSString *cellKey = [(NSArray *)tableSection objectAtIndex:indexPath.row];
			NSString *cellValue = [measureValues objectForKey:cellKey];
			
			if ( !cell )
			{
				cell = [[[MeasureDisplayCell alloc] initWithValue:cellValue forKey:cellKey reuseIdentifier:cellReuseID] autorelease];
			}
			else
			{
				cell.key = cellKey;
				cell.value = [measureValues objectForKey:cellKey];
			}
			
			return cell;
		}
	}
}



- (void)reloadTable
{
	[measureArrangement release];
	int angleCount = 0;
	int sideCount = 0;
	
	NSString *angleAKey = @"angleA";
	NSString *angleBKey = @"angleB";
	NSString *baseKey = @"base";
	NSString *sideKey = @"side";
	
	NSString *blankString = [[NSString alloc] initWithString:@""];
	
	if (! [[self.measureValues objectForKey:angleAKey] isEqualToString:blankString] ) {
		++angleCount;	}
	if (! [[self.measureValues objectForKey:angleBKey] isEqualToString:blankString] ) {
		++angleCount;
	}
	
	if (! [[self.measureValues objectForKey:baseKey] isEqualToString:blankString] ) {
		++sideCount;
	}
	if (! [[self.measureValues objectForKey:sideKey] isEqualToString:blankString] ) {
		++sideCount;
	}
	
	NSMutableArray *visibleAngles = [[NSMutableArray alloc] initWithCapacity:2];
	NSMutableArray *visiblesides = [[NSMutableArray alloc] initWithCapacity:3];
	
	if ( (angleCount + sideCount == 3)) {
		if (![[measureValues objectForKey:angleAKey] isEqualToString:blankString]) {
			[visibleAngles addObject:angleAKey];
		}
		if (![[measureValues objectForKey:angleBKey] isEqualToString:blankString]) {
			[visibleAngles addObject:angleBKey];
		}
		
		[visiblesides addObject:baseKey];
		[visiblesides addObject:sideKey];
		
		[self showSolveButtonEnabled:YES];
		
	}else if (angleCount == 1) {
		if (![[measureValues objectForKey:angleAKey] isEqualToString:blankString]) {
			[visibleAngles addObject:angleAKey];
		}
		if (![[measureValues objectForKey:angleBKey] isEqualToString:blankString]) {
			[visibleAngles addObject:angleBKey];
		}
		
		[visiblesides addObject:baseKey];
		[visiblesides addObject:sideKey];
		
		[self showSolveButtonEnabled:NO];
	}
	else
	{
		[visibleAngles addObject:angleAKey];
		[visibleAngles addObject:angleBKey];
		[visiblesides addObject:baseKey];
		[visiblesides addObject:sideKey];
		
		[self showSolveButtonEnabled:NO];
	}
	
	[blankString release];

	measureArrangement = [[NSMutableArray alloc] initWithCapacity:2];
	if ( [visibleAngles count] )
	{
		[measureArrangement addObject:visibleAngles];
	}
	
	[measureArrangement addObject:visiblesides];
	[measureArrangement addObject:@"angleUnit"];
	[measureArrangement addObject:@"clearValues"];
	
	[visibleAngles release];
	[visiblesides release];

	[self.tableView reloadData];
}


- (void)solve
{
	JBParallelogramSolver *parallelogramSolver = [[JBParallelogramSolver alloc] init];
	parallelogramSolver.angleUnit = [[NSUserDefaults standardUserDefaults] integerForKey:@"angleUnit"];
	
	parallelogramSolver.angleA = [(NSNumber *)[self.measureValues objectForKey:@"angleA"] doubleValue];
	if ( !parallelogramSolver.angleA )
	{
		parallelogramSolver.angleB = [(NSNumber *)[self.measureValues objectForKey:@"angleB"] doubleValue];
	}
	parallelogramSolver.base = [(NSNumber *)[self.measureValues objectForKey:@"base"] doubleValue];
	parallelogramSolver.side = [(NSNumber *)[self.measureValues objectForKey:@"side"] doubleValue];
	
	NSDictionary *parallelogramSolution = [parallelogramSolver solve];
	[parallelogramSolver release];
	
	if ( !parallelogramSolution )
	{
		[self showNoSolutionWithMessage:nil];
		
		return;
	}
	
	
	NSArray *solutionArrangement = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"angleA", @"angleB", nil],
																[NSArray arrayWithObjects:@"base", @"side", nil],
																[NSArray arrayWithObjects:@"area", @"perimeter", nil],
																nil];
	
	ParallelogramView *parallelogramDiagram = [[ParallelogramView alloc] initWithParallelogram:parallelogramSolution];
	parallelogramDiagram.angleUnit = [[NSUserDefaults standardUserDefaults] integerForKey:@"angleUnit"];
	
	TSSolutionViewController *solutionController = [[TSSolutionViewController alloc] initWithSolutions:[NSArray arrayWithObject:parallelogramSolution]
																							arrangement:solutionArrangement
																							diagramViews:[NSArray arrayWithObject:parallelogramDiagram]];
	solutionController.shapeController = self;
	solutionController.displaysAngleInfo = YES;
	[parallelogramDiagram release];
	
	UINavigationController *solutionNavigationController = [[UINavigationController alloc] initWithRootViewController:solutionController];
	[solutionController release];
	
	[self presentModalViewController:solutionNavigationController animated:YES];
	[solutionNavigationController release];
	
	[self showSolveButtonEnabled:YES];
}





@end

