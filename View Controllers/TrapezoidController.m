//
//  TrapezoidController.m
//  Shape Master
//
//  Created by Justin Buchanan on 9/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TrapezoidController.h"


@implementation TrapezoidController


- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.tabBarItem.image = [UIImage imageNamed:@"Trapezoid_Tabbar.png"];
		self.showsAngleUnit = YES;
		
		NSString *blankString = [[NSString alloc] initWithString:@""];
		NSArray *objects = [[NSArray alloc] initWithObjects:blankString, blankString, blankString, blankString, blankString, blankString, blankString, blankString, nil];
		[blankString release];
		
		NSArray *keys = [[NSArray alloc] initWithObjects:@"angleA", @"angleB", @"angleC", @"angleD", @"sideAB", @"sideBC", @"sideCD", @"sideAD", nil];
		
		self.measureValues = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
		[keys release];
		[objects release];
		[measureValues release];//it is retained by the property setter, so we can release it here
		
		NSArray *visibleAngles = [[NSArray alloc] initWithObjects:@"angleA", @"angleB", @"angleC", @"angleD", nil];
		NSArray *visibleSides = [[NSArray alloc] initWithObjects:@"sideAB", @"sideBC", @"sideCD", @"sideAD", nil];
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


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if ( section == 0 )
	{
		return NSLocalizedString( @"trapezoidInfo", nil );
	}
	
	return nil;
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
			NSNumber *aValue = [[NSNumber alloc] initWithDouble:10];
			NSNumber *sideAB = [[NSNumber alloc] initWithDouble:20];
			NSNumber *bottomAngle = [[NSNumber alloc] initWithDouble:M_PI / 3];
			NSNumber *topAngle = [[NSNumber alloc] initWithDouble:(2 * M_PI) / 3];
			
			NSArray *values = [[NSArray alloc] initWithObjects:bottomAngle, bottomAngle, topAngle, topAngle, sideAB, aValue, aValue, aValue, nil];
			[aValue release];
			[sideAB release];
			[bottomAngle release];
			[topAngle release];
			
			NSArray *keys = [[NSArray alloc] initWithObjects:@"angleA", @"angleB", @"angleC", @"angleD", @"sideAB", @"sideBC", @"sideCD", @"sideAD", nil];
			
			NSDictionary *trapezoidSolution = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
			[values release];
			[keys release];
			
			TrapezoidView *trapezoidDiagram = [[TrapezoidView alloc] initWithTrapezoid:trapezoidSolution];
			[trapezoidSolution release];
			
			shapeCell = [[[ShapeDiagramCell alloc] initWithReuseIdentifier:cellReuseID shapeDiagramView:trapezoidDiagram] autorelease];
			[trapezoidDiagram release];
		}
		
		return shapeCell;
	}
	else
	{
		id tableSection = [measureArrangement objectAtIndex:indexPath.section - 1];
		
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
}

- (void)reloadTable
{
	[measureArrangement release];
	int angleCount = 0;
	BOOL angleAOrDGiven = NO;
	BOOL angleBOrCGiven = NO;
	int sideCount = 0;
	
	BOOL angleAVisible = YES;
	BOOL angleBVisible = YES;
	BOOL angleCVisible = YES;
	BOOL angleDVisible = YES;
	BOOL sideABVisible = YES;
	BOOL sideBCVisible = YES;
	BOOL sideCDVisible = YES;
	BOOL sideADVisible = YES;
	
	NSString *angleAKey = @"angleA";
	NSString *angleBKey = @"angleB";
	NSString *angleCKey = @"angleC";
	NSString *angleDKey = @"angleD";
	NSString *sideABKey = @"sideAB";
	NSString *sideBCKey = @"sideBC";
	NSString *sideCDKey = @"sideCD";
	NSString *sideADKey = @"sideAD";
	
	NSString *blankString = [[NSString alloc] initWithString:@""];
	
	if (! [[self.measureValues objectForKey:angleAKey] isEqualToString:blankString] ) {
		++angleCount;
		angleAOrDGiven = YES;
	}
	if (! [[self.measureValues objectForKey:angleBKey] isEqualToString:blankString] ) {
		++angleCount;
		angleBOrCGiven = YES;
	}
	if (! [[self.measureValues objectForKey:angleCKey] isEqualToString:blankString] ) {
		++angleCount;
		angleBOrCGiven = YES;
	}
	if (! [[self.measureValues objectForKey:angleDKey] isEqualToString:blankString] ) {
		++angleCount;
		angleAOrDGiven = YES;
	}
	
	if (! [[self.measureValues objectForKey:sideABKey] isEqualToString:blankString] ) {
		++sideCount;
	}
	if (! [[self.measureValues objectForKey:sideBCKey] isEqualToString:blankString] ) {
		++sideCount;
	}
	if (! [[self.measureValues objectForKey:sideCDKey] isEqualToString:blankString] ) {
		++sideCount;
	}
	if (! [[self.measureValues objectForKey:sideADKey] isEqualToString:blankString] ) {
		++sideCount;
	}
	
	[self showSolveButtonEnabled:NO];
	
	if ( (angleCount + sideCount == 4)) {//If 4 measures are given, then the ones with no measures are hidden
	
		if ([[measureValues objectForKey:angleAKey] isEqualToString:blankString]) {
			angleAVisible = NO;
		}
		if ([[measureValues objectForKey:angleBKey] isEqualToString:blankString]) {
			angleBVisible = NO;
		}
		if ([[measureValues objectForKey:angleCKey] isEqualToString:blankString]) {
			angleCVisible = NO;
		}
		if ([[measureValues objectForKey:angleDKey] isEqualToString:blankString]) {
			angleDVisible = NO;
		}
		
		if ([[measureValues objectForKey:sideABKey] isEqualToString:blankString]) {
			sideABVisible = NO;
		}
		if ([[measureValues objectForKey:sideBCKey] isEqualToString:blankString]) {
			sideBCVisible = NO;
		}
		if ([[measureValues objectForKey:sideCDKey] isEqualToString:blankString]) {
			sideCDVisible = NO;
		}
		if ([[measureValues objectForKey:sideADKey] isEqualToString:blankString]) {
			sideADVisible = NO;
		}
		
		[self showSolveButtonEnabled:YES];
		
	}else if ( angleCount + sideCount == 3 )
	{
		if ( [[measureValues objectForKey:sideABKey] isEqualToString:blankString] && [[measureValues objectForKey:sideCDKey] isEqualToString:blankString] )	//if 3 measures are given and the top and bottom arent given, 
		{																																						//then everything is hidden that isnt given except for the top and bottom
			
			if ([[measureValues objectForKey:angleAKey] isEqualToString:blankString])
			{
				angleAVisible = NO;
			}
			if ([[measureValues objectForKey:angleBKey] isEqualToString:blankString])
			{
				angleBVisible = NO;
			}
			if ([[measureValues objectForKey:angleCKey] isEqualToString:blankString])
			{
				angleCVisible = NO;
			}
			if ([[measureValues objectForKey:angleDKey] isEqualToString:blankString])
			{
				angleDVisible = NO;
			}
			if ([[measureValues objectForKey:sideBCKey] isEqualToString:blankString])
			{
				sideBCVisible = NO;
			}
			if ([[measureValues objectForKey:sideADKey] isEqualToString:blankString])
			{
				sideADVisible = NO;
			}
		}
	
	
	}
	
	if (angleCount > 0) {
		if (angleAOrDGiven)
		{
			if (![[measureValues objectForKey:angleAKey] isEqualToString:blankString])
			{
				angleDVisible = NO;
			}
			if (![[measureValues objectForKey:angleDKey] isEqualToString:blankString])
			{
				angleAVisible = NO;
			}
		}
			
		if (angleBOrCGiven)
		{
			if (![[measureValues objectForKey:angleBKey] isEqualToString:blankString])
			{
				angleCVisible = NO;
			}
			if (![[measureValues objectForKey:angleCKey] isEqualToString:blankString])
			{
				angleBVisible = NO;
			}
		}
	}
		
	
	NSMutableArray *visibleAngles = [[NSMutableArray alloc] initWithCapacity:4];
	NSMutableArray *visibleSides = [[NSMutableArray alloc] initWithCapacity:4];
	if (angleAVisible) {
		[visibleAngles addObject:angleAKey];
	}
	if (angleBVisible) {
		[visibleAngles addObject:angleBKey];
	}
	if (angleCVisible) {
		[visibleAngles addObject:angleCKey];
	}
	if (angleDVisible) {
		[visibleAngles addObject:angleDKey];
	}
	
	if (sideABVisible) {
		[visibleSides addObject:sideABKey];
	}
	if (sideBCVisible) {
		[visibleSides addObject:sideBCKey];
	}
	if (sideCDVisible) {
		[visibleSides addObject:sideCDKey];
	}
	if (sideADVisible) {
		[visibleSides addObject:sideADKey];
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



- (void)solve
{
	JBTrapezoidSolver *trapezoidSolver = [[JBTrapezoidSolver alloc] init];
	trapezoidSolver.angleUnit = [[NSUserDefaults standardUserDefaults] integerForKey:@"angleUnit"];
	
	double anAngle;
	if ( anAngle = [[self.measureValues objectForKey:@"angleA"] doubleValue] )
	{
		trapezoidSolver.angleA = anAngle;
	}
	else if ( anAngle = [[self.measureValues objectForKey:@"angleD"] doubleValue] )
	{
		trapezoidSolver.angleD = anAngle;
	}
	
	if ( anAngle = [[self.measureValues objectForKey:@"angleB"] doubleValue] )
	{
		trapezoidSolver.angleB = anAngle;
	}
	else if ( anAngle = [[self.measureValues objectForKey:@"angleC"] doubleValue] )
	{
		trapezoidSolver.angleC = anAngle;
	}
	trapezoidSolver.sideAB = [[self.measureValues objectForKey:@"sideAB"] doubleValue];
	trapezoidSolver.sideBC = [[self.measureValues objectForKey:@"sideBC"] doubleValue];
	trapezoidSolver.sideCD = [[self.measureValues objectForKey:@"sideCD"] doubleValue];
	trapezoidSolver.sideAD = [[self.measureValues objectForKey:@"sideAD"] doubleValue];
	
	NSArray *trapezoidSolutions = [trapezoidSolver solve];
	
	if ( !trapezoidSolutions )
	{
		if ( trapezoidSolver.sideCD >= trapezoidSolver.sideAB && trapezoidSolver.sideAB > 0 )
		{
			[self showNoSolutionWithMessage:NSLocalizedString( @"trapezoidError", nil )];
		}
		else
		{
			[self showNoSolutionWithMessage:nil];
		}
		
		[trapezoidSolver release];
		
		return;
	}
	else
	{
		[trapezoidSolver release];
	}
	
	
	NSArray *solutionArrangement = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"angleA", @"angleB", @"angleC", @"angleD", nil],
																[NSArray arrayWithObjects:@"sideAB", @"sideBC", @"sideCD", @"sideAD", nil],
																[NSArray arrayWithObjects:@"area", @"perimeter", nil],
																nil];
	
	TrapezoidView *diagram1View = [[TrapezoidView alloc] initWithTrapezoid:[trapezoidSolutions objectAtIndex:0]];
	diagram1View.angleUnit = [[NSUserDefaults standardUserDefaults] integerForKey:@"angleUnit"];
	
	TrapezoidView *diagram2View;
	if ( [trapezoidSolutions count] == 2 )
	{
		diagram2View = [[TrapezoidView alloc] initWithTrapezoid:[trapezoidSolutions objectAtIndex:1]];
		diagram2View.angleUnit = [[NSUserDefaults standardUserDefaults] integerForKey:@"angleUnit"];
	}
	else
	{
		diagram2View = nil;
	}
	
	TSSolutionViewController *solutionController = [[TSSolutionViewController alloc] initWithSolutions:trapezoidSolutions
																							arrangement:solutionArrangement
																							diagramViews:[NSArray arrayWithObjects:diagram1View, diagram2View, nil]];
	solutionController.shapeController = self;
	solutionController.displaysAngleInfo = YES;
	[diagram1View release];
	[diagram2View release];
	
	UINavigationController *solutionNavigationController = [[UINavigationController alloc] initWithRootViewController:solutionController];
	[solutionController release];
	
	[self presentModalViewController:solutionNavigationController animated:YES];
	[solutionNavigationController release];
	
	[self showSolveButtonEnabled:YES];
}


@end

