//
//  ShapeDiagramCell.m
//  MetriSolv
//
//  Created by Justin Buchanan on 10/26/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import "ShapeDiagramCell.h"


@implementation ShapeDiagramCell

@synthesize shapeDiagramView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier shapeDiagramView:(UIView *)view;
{
	if ( self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] )
	{
		shapeDiagramView = [view retain];
		[self.contentView addSubview:shapeDiagramView];
	}
	
	return self;
}


- (void)dealloc
{
	[shapeDiagramView release];
	
	[super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	//	this cell isn't selectable, so we do nothing here
}


- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGFloat size = self.contentView.bounds.size.height;
	CGRect frame;
	frame.size = CGSizeMake(size * 2, size);
	shapeDiagramView.frame = frame;
	shapeDiagramView.center = CGPointMake(self.contentView.bounds.size.width / 2, size / 2);	
}


@end
