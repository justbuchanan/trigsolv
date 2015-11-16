//
//  CircleController.m
//  Shape Master
//
//  Created by Justin Buchanan on 9/23/08.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import "CircleController.h"


@implementation CircleController


- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.tabBarItem.image = [UIImage imageNamed:@"Circle_Tabbar.png"];
		self.showsAngleUnit = NO;
		
		NSString *blankString = [[NSString alloc] initWithString:@""];
		NSArray *values = [[NSArray alloc] initWithObjects:blankString, blankString, blankString, blankString, nil];
		[blankString release];
		
		NSArray *measureNames = [[NSArray alloc] initWithObjects:@"radius", @"diameter", @"area", @"circumference", nil];
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
	if (section == 0 || section == 2)
	{
		return 1;
	}
	
	return [measureArrangement count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellReuseID;
	switch ( indexPath.section )
	{
		case 0:
		{
			cellReuseID = @"shapeDiagramCell";
			ShapeDiagramCell *shapeCell = (ShapeDiagramCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
			if ( !shapeCell )
			{
				UIImageView *shapeDiagram = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Circle_Diagram.png"]];
				
				shapeCell = [[[ShapeDiagramCell alloc] initWithReuseIdentifier:cellReuseID shapeDiagramView:shapeDiagram] autorelease];
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


- (void)solve
{
	JBCircleSolver *circleSolver = [[JBCircleSolver alloc] init];
	
	NSString *blankString = @"";
	
	if ( ![[self.measureValues objectForKey:@"radius"] isEqualToString:blankString] )
	{
		circleSolver.radius = [(NSNumber *)[self.measureValues objectForKey:@"radius"] doubleValue];
	}
	else if ( ![[self.measureValues objectForKey:@"diameter"] isEqualToString:blankString] )
	{
		circleSolver.diameter = [(NSNumber *)[self.measureValues objectForKey:@"diameter"] doubleValue];
	}
	else if ( ![[self.measureValues objectForKey:@"area"] isEqualToString:blankString] )
	{
		circleSolver.area = [(NSNumber *)[self.measureValues objectForKey:@"area"] doubleValue];
	}
	else
	{
		circleSolver.circumference = [(NSNumber *)[self.measureValues objectForKey:@"circumference"] doubleValue];
	}
	
	NSDictionary *circleSolution = [circleSolver solve];
	[circleSolver release];
	
	if ( !circleSolution )
	{
		[self showNoSolutionWithMessage:nil];
		
		return;
	}
	
	NSArray *solutionArrangement = [NSArray arrayWithObject:[NSArray arrayWithObjects:@"radius", @"diameter", @"area", @"circumference", nil]];
	UIImageView *circleDiagramView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Circle_Diagram.png"]];
	
	TSSolutionViewController *solutionController = [[TSSolutionViewController alloc] initWithSolutions:[NSArray arrayWithObject:circleSolution]
																							arrangement:solutionArrangement
																							diagramViews:[NSArray arrayWithObject:circleDiagramView]];
	solutionController.shapeController = self;
	[circleDiagramView release];
	
	UINavigationController *solutionNavigationController = [[UINavigationController alloc] initWithRootViewController:solutionController];
	[solutionController release];
	[self presentModalViewController:solutionNavigationController animated:YES];
	[solutionNavigationController release];
	
	[self showSolveButtonEnabled:YES];
}





- (void)reloadTable
{
	[measureArrangement release];

	NSString *blankString = [[NSString alloc] initWithString:@""];
	
	BOOL valueIsGiven = NO;
	
	for (NSString *key in measureValues)
	{
		NSString *value =  (NSString *)[measureValues objectForKey:key];
		if ( ![value isEqualToString:blankString] )
		{
			valueIsGiven = YES;
		}
	}
	
	measureArrangement = [[NSMutableArray alloc] initWithCapacity:4];
	
	if (valueIsGiven) {
		if ( ![[measureValues objectForKey:@"radius"] isEqualToString:blankString] ) {
			[measureArrangement addObject:@"radius"];
		} else if ( ![[measureValues objectForKey:@"diameter"] isEqualToString:blankString] ) {
			[measureArrangement addObject:@"diameter"];
		} else if ( ![[measureValues objectForKey:@"area"] isEqualToString:blankString] ) {
			[measureArrangement addObject:@"area"];
		} else {//circumference
			[measureArrangement addObject:@"circumference"];
		}
		[self showSolveButtonEnabled:YES];
	} else {
		[measureArrangement addObject:@"radius"];
		[measureArrangement addObject:@"diameter"];
		[measureArrangement addObject:@"area"];
		[measureArrangement addObject:@"circumference"];
		[self showSolveButtonEnabled:NO];
	}
	
	[blankString release];
	[self.tableView reloadData];
}


@end

