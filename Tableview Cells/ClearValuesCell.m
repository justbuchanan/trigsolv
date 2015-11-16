//
//  ClearValuesCell.m
//  TrigSolv
//
//  Created by Justin Buchanan on 11/10/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import "ClearValuesCell.h"
#import "ShapeController.h"


@implementation ClearValuesCell

@synthesize shapeController;

- (id)initWithShapeController:(ShapeController *)aShapeController reuseIdentifier:(NSString *)reuseIdentifier;
{
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
	{
		DebugLog(@"a clearvalues cell was initialized");
		clearValuesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

		[clearValuesButton setBackgroundImage:[UIImage imageNamed:@"redButton.png"] forState:UIControlStateNormal];

		[clearValuesButton setTitle:NSLocalizedString( @"clearValues", nil ) forState:UIControlStateNormal];
		[clearValuesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

		[self.contentView addSubview:clearValuesButton];
		clearValuesButton.frame = self.contentView.bounds;					///////////////////////////////////////////////////////////////////////////////////////
		[clearValuesButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDown];

		shapeController = aShapeController;
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	//[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}


- (void)dealloc
{
	[clearValuesButton release];

	[super dealloc];
}

- (void)buttonPressed
{
	DebugLog(@"clear values button pressed in clearvaluescell");
	[self.shapeController confirmClearValues];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	clearValuesButton.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height + 2);
}


@end
