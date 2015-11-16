//
//  MeasureEntryViewController.m
//  Shape Master
//
//  Created by Justin Buchanan on 10/1/03.
//  Copyright 2003 JustBuchanan Enterprises. All rights reserved.
//

#import "MeasureEntryViewController.h"
#import "ShapeController.h"


@implementation MeasureEntryViewController

@synthesize shapeController;


- (id)initWithShapeController:(ShapeController *)controller measureKey:(NSString *)measureKey
{
	if ( self = [super initWithStyle:UITableViewStyleGrouped] )
	{
		shapeController = controller;
		key = [measureKey retain];
	}
	return self;
}

- (void)viewDidAppear:(BOOL)animated
{
	[measureEntryCell.textField becomeFirstResponder];
	[super viewDidAppear:animated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( !measureEntryCell )
		measureEntryCell = [[MeasureEntryCell alloc] initWithMeasureEntryViewController:self key:key];
	
	return measureEntryCell;
}


- (void)userFinishedEnteringValue:(NSString *)theValue forKey:(NSString *)theKey
{
	[shapeController.measureValues setObject:theValue forKey:theKey];
	[shapeController reloadTable];
}


- (void)dealloc
{
	[key release];
	[measureEntryCell release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ( viewController == self.shapeController )
	{
		[measureEntryCell userFinishedEditingTextField];
		navigationController.delegate = nil;
	}
}
	

@end

