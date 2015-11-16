//
//  AngleUnitCell.m
//  TrigSolv
//
//  Created by Justin Buchanan on 11/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AngleUnitCell.h"

@interface AngleUnitCell (Private)
- (void)angleUnitChanged:(NSNotification *)notif;
@end


@implementation AngleUnitCell

@synthesize segmentedControl;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:UITableViewStylePlain reuseIdentifier:reuseIdentifier])
	{
		segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString( @"radians", nil ),
																								NSLocalizedString( @"degrees", nil ),
																								NSLocalizedString( @"gradians", nil ), nil]];
		[segmentedControl addTarget:self action:@selector(segmentedControlChanged) forControlEvents:UIControlEventValueChanged];
		[self.contentView addSubview:segmentedControl];
		[segmentedControl release];	//segmented control is released because it is retained as a subview
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(angleUnitChanged:) name:@"angleUnitChanged" object:nil];
		
		[self angleUnitChanged:nil];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	
	CGRect frame = self.contentView.bounds;
	frame.size.height += 2;
	
	segmentedControl.frame = frame;
}


- (void)segmentedControlChanged
{
	[[NSUserDefaults standardUserDefaults] setInteger:[segmentedControl selectedSegmentIndex] forKey:@"angleUnit"];
	
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"angleUnitChanged" object:nil]];
}
		
- (void)angleUnitChanged:(NSNotification *)notif
{
	segmentedControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"angleUnit"];
}

@end




