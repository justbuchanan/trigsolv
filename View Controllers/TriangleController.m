//
//  TriangleController.m
//  Shape Master
//
//  Created by Justin Buchanan on 9/24/08.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import "TriangleController.h"
#import "Defines.h"

@implementation TriangleController


- (id)initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style])
	{
		self.tabBarItem.image = [UIImage imageNamed:@"Triangle_Tabbar.png"];
		self.showsAngleUnit = YES;
		
		NSString *blankString = [[NSString alloc] initWithString:@""];
		NSArray *values = [[NSArray alloc] initWithObjects:blankString, blankString, blankString, blankString, blankString, blankString, nil];
		[blankString release];
		
		NSArray *measureNames = [[NSArray alloc] initWithObjects:@"angleA", @"angleB", @"angleC", @"sideBC", @"sideAC", @"sideAB", nil];
		self.measureValues = [NSMutableDictionary dictionaryWithObjects:values forKeys:measureNames];
		[values release];
		[measureNames release];
		
		NSArray *visibleAngles = [[NSArray alloc] initWithObjects:@"angleA", @"angleB", @"angleC", nil];
		NSArray *visibleSides = [[NSArray alloc] initWithObjects:@"sideAB", @"sideBC", @"sideAC", nil];
		measureArrangement = [[NSMutableArray alloc] initWithObjects:visibleAngles, visibleSides, @"angleUnit", @"clearValues", nil];
		[visibleAngles release];
		[visibleSides release];
	}
	
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [measureArrangement count] + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	DebugLog(@"tableview is looking for the number of rows in section %d",section);//remove this
	
	if ( section == 0 )
	{
		return 1;
	}
	
	id tableSection = [measureArrangement objectAtIndex:section - 1];
	if ( [tableSection isKindOfClass:[NSString class]] )
	{
		return 1;
	}
	else
	{
		return [tableSection count];
	}
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
			NSNumber *number = [[NSNumber alloc] initWithDouble:M_PI / 3];
			NSArray *keys = [[NSArray alloc] initWithObjects:@"angleA", @"angleB", @"angleC", @"sideAB", @"sideBC", @"sideAC", nil];
			NSArray *values = [[NSArray alloc] initWithObjects:number, number, number, number, number, number, nil];
			
			NSDictionary *triangleSolution = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
			[number release];
			[keys release];
			[values release];
			
			TriangleView *triangleDiagram = [[TriangleView alloc] initWithTriangle:triangleSolution];
			[triangleSolution release];
			
			shapeCell = [[[ShapeDiagramCell alloc] initWithReuseIdentifier:cellReuseID shapeDiagramView:triangleDiagram] autorelease];
			[triangleDiagram release];
		}
		
		return shapeCell;
	}
	
	
	id tableSection = [measureArrangement objectAtIndex:indexPath.section - 1];
	DebugLog(@"tableSection = %@", tableSection);
	
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
		
		DebugLog(@"@ tableView:cellForRowAtIndexPath: measureArrangement = %@", measureArrangement);
		NSString *cellKey = [tableSection objectAtIndex:indexPath.row];
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

- (void)solve
{
	JBTriangleSolver *triangleSolver = [[JBTriangleSolver alloc] init];
	triangleSolver.angleUnit = [[NSUserDefaults standardUserDefaults] integerForKey:@"angleUnit"];
	
	triangleSolver.angleA = [(NSNumber *)[self.measureValues objectForKey:@"angleA"] doubleValue];
	triangleSolver.angleB = [(NSNumber *)[self.measureValues objectForKey:@"angleB"] doubleValue];
	triangleSolver.angleC = [(NSNumber *)[self.measureValues objectForKey:@"angleC"] doubleValue];
	triangleSolver.sideAB = [(NSNumber *)[self.measureValues objectForKey:@"sideAB"] doubleValue];
	triangleSolver.sideBC = [(NSNumber *)[self.measureValues objectForKey:@"sideBC"] doubleValue];
	triangleSolver.sideAC = [(NSNumber *)[self.measureValues objectForKey:@"sideAC"] doubleValue];
	
	NSArray *triangleSolutions = [triangleSolver solve];
	[triangleSolver release];
	
	if ( !triangleSolutions )
	{
		[self showNoSolutionWithMessage:nil];
		
		return;
	}
	
	
	NSArray *solutionArrangement = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"angleA", @"angleB", @"angleC", nil],
																[NSArray arrayWithObjects:@"sideAB", @"sideBC", @"sideAC", nil],
																[NSArray arrayWithObjects:@"area", @"perimeter", nil],
																nil];
	
	TriangleView *diagram1View = [[TriangleView alloc] initWithTriangle:[triangleSolutions objectAtIndex:0]];
	diagram1View.angleUnit = [[NSUserDefaults standardUserDefaults] integerForKey:@"angleUnit"];
	
	TriangleView *diagram2View;
	if ( [triangleSolutions count] == 2 )
	{
		diagram2View = [[TriangleView alloc] initWithTriangle:[triangleSolutions objectAtIndex:1]];
		diagram2View.angleUnit = [[NSUserDefaults standardUserDefaults] integerForKey:@"angleUnit"];
	}
	else
	{
		diagram2View = nil;
	}
	
	TSSolutionViewController *solutionController = [[TSSolutionViewController alloc] initWithSolutions:triangleSolutions
																							arrangement:solutionArrangement
																							diagramViews:[NSArray arrayWithObjects:diagram1View, diagram2View, nil]];
	
	solutionController.shapeController = self;
	[solutionController setDisplaysAngleInfo:YES];
	[diagram1View release];
	[diagram2View release];
	
	UINavigationController *solutionNavigationController = [[UINavigationController alloc] initWithRootViewController:solutionController];
	[solutionController release];
	
	[self presentModalViewController:solutionNavigationController animated:YES];
	[solutionNavigationController release];
	
	[self showSolveButtonEnabled:YES];
}

- (void)reloadTable
{
	
	[measureArrangement release];
	int angleCount = 0;
	int sideCount = 0;
	
	NSString *angleAKey = @"angleA";
	NSString *angleBKey = @"angleB";
	NSString *angleCKey = @"angleC";
	NSString *sideBCKey = @"sideBC";
	NSString *sideACKey = @"sideAC";
	NSString *sideABKey = @"sideAB";
	
	NSString *blankString = [[NSString alloc] initWithString:@""];
	
	if (! [[self.measureValues objectForKey:angleAKey] isEqualToString:blankString] ) {
		++angleCount;
	}
	if (! [[self.measureValues objectForKey:angleBKey] isEqualToString:blankString] ) {
		++angleCount;
	}
	if (! [[self.measureValues objectForKey:angleCKey] isEqualToString:blankString] ) {
		++angleCount;
	}
	
	if (! [[self.measureValues objectForKey:sideBCKey] isEqualToString:blankString] ) {
		++sideCount;
	}
	if (! [[self.measureValues objectForKey:sideACKey] isEqualToString:blankString] ) {
		++sideCount;
	}
	if (! [[self.measureValues objectForKey:sideABKey] isEqualToString:blankString] ) {
		++sideCount;
	}
	DebugLog(@"the trianglecontroller is reloading the table");
	NSMutableArray *visibleAngles = [[NSMutableArray alloc] initWithCapacity:3];
	NSMutableArray *visibleSides = [[NSMutableArray alloc] initWithCapacity:3];
	
	if ( (angleCount + sideCount == 3)) {
		if (![[measureValues objectForKey:angleAKey] isEqualToString:blankString]) {
			[visibleAngles addObject:angleAKey];
		}
		if (![[measureValues objectForKey:angleBKey] isEqualToString:blankString]) {
			[visibleAngles addObject:angleBKey];
		}
		if (![[measureValues objectForKey:angleCKey] isEqualToString:blankString]) {
			[visibleAngles addObject:angleCKey];
		}
		
		if (![[measureValues objectForKey:sideABKey] isEqualToString:blankString]) {
			[visibleSides addObject:sideABKey];
		}
		if (![[measureValues objectForKey:sideBCKey] isEqualToString:blankString]) {
			[visibleSides addObject:sideBCKey];
		}
		if (![[measureValues objectForKey:sideACKey] isEqualToString:blankString]) {
			[visibleSides addObject:sideACKey];
		}
		
		[self showSolveButtonEnabled:YES];
		
	}else if (angleCount == 2) {
		if (![[measureValues objectForKey:angleAKey] isEqualToString:blankString]) {
			[visibleAngles addObject:angleAKey];
		}
		if (![[measureValues objectForKey:angleBKey] isEqualToString:blankString]) {
			[visibleAngles addObject:angleBKey];
		}
		if (![[measureValues objectForKey:angleCKey] isEqualToString:blankString]) {
			[visibleAngles addObject:angleCKey];
		}
		
		[visibleSides addObject:sideABKey];
		[visibleSides addObject:sideBCKey];
		[visibleSides addObject:sideACKey];
		
		[self showSolveButtonEnabled:NO];
	} else {
		[visibleAngles addObject:angleAKey];
		[visibleAngles addObject:angleBKey];
		[visibleAngles addObject:angleCKey];
		[visibleSides addObject:sideABKey];
		[visibleSides addObject:sideBCKey];
		[visibleSides addObject:sideACKey];
		
		[self showSolveButtonEnabled:NO];
	}
	
	[blankString release];

	measureArrangement = [[NSMutableArray alloc] initWithCapacity:2];
	if ( [visibleAngles count] )
	{
		[measureArrangement addObject:visibleAngles];
	}
	
	[measureArrangement addObject:visibleSides];
	[measureArrangement addObject:@"angleUnit"];
	[measureArrangement addObject:@"clearValues"];
	
	[visibleAngles release];
	[visibleSides release];
	
	[self.tableView reloadData];
}

@end

