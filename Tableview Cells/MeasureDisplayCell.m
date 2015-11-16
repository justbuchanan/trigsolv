//
//  MeasureDisplayCell.m
//  Shape Master
//
//  Created by Justin Buchanan on 10/2/03.
//  Copyright 2003 JustBuchanan Enterprises. All rights reserved.
//

#import "MeasureDisplayCell.h"


@implementation MeasureDisplayCell

@synthesize key, selectable;

- (id)initWithValue:(NSString *)aValue forKey:(NSString *)aKey reuseIdentifier:(NSString *)reuseIdentifier;
{
	if ( self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] )
	{
		self.value = aValue;
		self.key = aKey;

		self.accessoryType = UITableViewCellAccessoryNone;
		self.textLabel.textColor = MEASURE_NAME_COLOR;
		self.detailTextLabel.textColor = MEASURE_VALUE_COLOR;
		self.selectable = YES;
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	if (selectable)
	{
		[super setSelected:selected animated:animated];

		//	do stuff here !!!!!!!!!!!!!!!!!!!!!!!!

	}
}


- (void)dealloc
{
	self.key = nil;
	[super dealloc];
}


#pragma mark Properties

- (void)setValue:(NSString *)aValue
{
	self.detailTextLabel.text = aValue;
}
- (NSString *)value
{
	return self.detailTextLabel.text;
}

- (void)setKey:(NSString *)aKey
{
	[aKey retain];
	[key release];
	key = aKey;

	self.textLabel.text = NSLocalizedString( key, nil );
}
- (NSString *)key
{
	return key;
}

- (void)setSelectable:(BOOL)aValue
{
	selectable = aValue;
	self.accessoryType = ( selectable ) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}


@end
