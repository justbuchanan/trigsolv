//
//  InputViewController.m
//  Shape Master
//
//  Created by Justin Buchanan on 9/24/08.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import "ShapeController.h"


@implementation ShapeController

@synthesize measureValues, showsAngleUnit;

- (id)initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style])
	{
		UIBarButtonItem *solveButton = [[UIBarButtonItem alloc] initWithTitle:@"Solve" style:UIBarButtonItemStyleBordered target:self action:@selector(solve)];
		solveButton.enabled = NO;
		self.navigationItem.rightBarButtonItem =  solveButton;
		[solveButton release];
		
		measureValues = nil;
		measureArrangement = nil;
		fadingOut = NO;
	}
	return self;
}

- (void)dealloc
{
	[measureValues release];
	[measureArrangement release];
	
	[super dealloc];
}

#pragma mark TableView Delegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( indexPath.section == 0 )
	{
		return 150;
	}
	return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( [[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[MeasureDisplayCell class]] )
	{
		MeasureDisplayCell *displayCell = (MeasureDisplayCell *)[tableView cellForRowAtIndexPath:indexPath];
		
		MeasureEntryViewController *measureEntryViewController = [[MeasureEntryViewController alloc] initWithShapeController:self measureKey:displayCell.key];
		
		self.navigationController.delegate = measureEntryViewController;
	
		[self.navigationController pushViewController:measureEntryViewController animated:YES];
		[measureEntryViewController release];
	}
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)textFieldFinishedEditing
{
	[self.navigationController popViewControllerAnimated:YES];
}



#pragma mark Other

- (void)showSolveButtonEnabled:(BOOL)enabled
{
	self.navigationItem.rightBarButtonItem.enabled = enabled;
}


- (void)solve {
	//this needs to be implemented in subclasses
}

- (void)reloadTable {
	//this needs to be implemented in subclasses
}

- (void)showNoSolutionWithMessage:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"noSolution", nil ) message:message
						delegate:self cancelButtonTitle:NSLocalizedString( @"ok", nil ) otherButtonTitles: nil];
	[alert show];	
	[alert release];
	
	[self showSolveButtonEnabled:YES];
}

- (void)confirmClearValues
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															delegate:self
															cancelButtonTitle:NSLocalizedString( @"cancel", nil )
															destructiveButtonTitle:NSLocalizedString( @"clearValues", nil )
															otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromTabBar:(UITabBar *)self.tabBarController.view];
	[actionSheet release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ( buttonIndex == 0 )
	{
		[self clearValues];
	}
}

- (void)clearValues
{
	NSString *blankString = @"";
	NSArray *keys = [measureValues allKeys];
	for (NSString *measureName in keys)
	{
		[measureValues setObject:blankString forKey:measureName];
	}
	
	//set the tableview to white or clear
	
	
	CATransition *fadeOut = [CATransition animation];
	[fadeOut setDelegate:self];
	[fadeOut setType:kCATransitionFade];
		
	[fadeOut setDuration:.35];
	[fadeOut setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[self.tableView setAlpha:0.0f];
	
	[[[UIApplication sharedApplication] keyWindow].layer addAnimation:fadeOut forKey:@"fadeViewAnimation"];
	
	fadingOut = YES;
}




- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished
{
	if ( fadingOut )
	{
		fadingOut = NO;
		
		
		[self reloadTable];
		
		
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		
		CATransition *fadeIn = [CATransition animation];
		[fadeIn setDelegate:self];
		[fadeIn setType:kCATransitionFade];
			
		[fadeIn setDuration:.35];
		[fadeIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		[self.tableView setAlpha:1.0f];
		
		[[[UIApplication sharedApplication] keyWindow].layer addAnimation:fadeIn forKey:@"fadeViewAnimation"];
	}
}


@end

