//
//  RectangleController.m
//  Shape Master
//
//  Created by Justin Buchanan on 9/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RectangleController.h"


@implementation RectangleController


- (id)initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style])
	{
		self.tabBarItem.image = [UIImage imageNamed:@"Rectangle_Tabbar.png"];
		self.showsAngleUnit = NO;
		
		NSString *blankString = [[NSString alloc] initWithString:@""];
		NSArray *values = [[NSArray alloc] initWithObjects:blankString, blankString, nil];
		[blankString release];
		
		NSArray *measureNames = [[NSArray alloc] initWithObjects:@"base", @"height", nil];
		self.measureValues = [NSMutableDictionary dictionaryWithObjects:values forKeys:measureNames];
		[values release];
		
		measureArrangement = [[NSMutableArray alloc] initWithArray:measureNames];
		[measureNames release];
	}
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0 || section == 2)
	{
		return 1;
	}
	else
	{
		return [measureArrangement count];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellReuseID;
	
	switch ( indexPath.section )
	{
		case 0:
		{
			cellReuseID = @"shapeDiagramCell";
			ShapeDiagramCell *shapeCell = (ShapeDiagramCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
			if ( !shapeCell )
			{
				
				UIImageView *rectangleDiagram = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle_Diagram.png"]];
				shapeCell = [[[ShapeDiagramCell alloc] initWithReuseIdentifier:cellReuseID shapeDiagramView:rectangleDiagram] autorelease];
				[rectangleDiagram release];
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




- (void)reloadTable {
	int valuesGiven = 0;
	
	NSString *blankString = [[NSString alloc] initWithString:@""];
	
	for (NSString *key in measureValues)
	{
		if ( ![[measureValues objectForKey:key] isEqualToString:blankString] )
		{
			++valuesGiven;
		}
	}
	[blankString release];
	
	if ( valuesGiven == 2 )
	{
		[self showSolveButtonEnabled:YES];
	}
	else
	{
		[self showSolveButtonEnabled:NO];
	}
	
	[self.tableView reloadData];
}


- (void)solve
{
	JBRectangleSolver *rectangleSolver = [[JBRectangleSolver alloc] init];
	rectangleSolver.base = [[self.measureValues objectForKey:@"base"] doubleValue];
	rectangleSolver.height = [[self.measureValues objectForKey:@"height"] doubleValue];
	
	NSDictionary *rectangleSolution = [rectangleSolver solve];
	[rectangleSolver release];
	
	if (!rectangleSolution)
	{
		[self showNoSolutionWithMessage:nil];
		
		return;
	}
	
	NSArray *solutionArrangement = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"base", @"height", nil],
																[NSArray arrayWithObjects: @"area", @"perimeter", nil],
																nil];
	
	UIView *rectangleDiagram = [[RectangleView alloc] initWithRectangle:rectangleSolution];
	
	TSSolutionViewController *solutionController = [[TSSolutionViewController alloc] initWithSolutions:[NSArray arrayWithObject:rectangleSolution]
																							arrangement:solutionArrangement
																							diagramViews:[NSArray arrayWithObject:rectangleDiagram]];
	solutionController.shapeController = self;
	[rectangleDiagram release];
	
	UINavigationController *solutionNavigationController = [[UINavigationController alloc] initWithRootViewController:solutionController];
	[solutionController release];
	
	[self presentModalViewController:solutionNavigationController animated:YES];
	[solutionNavigationController release];
	
	[self showSolveButtonEnabled:YES];
}


@end

