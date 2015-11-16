//
//  RectangleView.m
//  TrigSolv
//
//  Created by Justin Buchanan on 11/24/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import "RectangleView.h"


@interface RectangleView ()
- (void)calculatePoints;
@end


@implementation RectangleView


- (id)initWithRectangle:(NSDictionary *)theRectangle
{
    if ( self = [super initWithFrame:CGRectZero] )
	{
		rectangle = [theRectangle retain];
		
		needsCalculation = YES;
	   
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
	}
    return self;
}


- (void)drawRect:(CGRect)rect
{
	if ( needsCalculation )
	{
		[self calculatePoints];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[SHAPE_DIAGRAM_COLOR setStroke];
	CGContextSetLineCap( context, SHAPE_DIAGRAM_LINE_CAP_STYLE );
	CGContextSetLineWidth( context, SHAPE_DIAGRAM_LINE_WIDTH );
	
	CGContextAddRect( context, rectangleRect );
	CGContextStrokePath( context );
	
	NSLog(@"drawRect was called on the rectangle view");
	NSLog(@"rectangle.x = %f\nrectangle.y = %f", rectangleRect.origin.x, rectangleRect.origin.y);
	
	[super drawRect:rect];
}


- (void)dealloc
{
	[rectangle release];
	
    [super dealloc];
}

- (void)calculatePoints
{
	rectangleRect.size.width = [[rectangle objectForKey:@"base"] doubleValue];
	rectangleRect.size.height = [[rectangle objectForKey:@"height"] doubleValue];
	
	//BEGIN scaling
	double scaleFactor;		//multiply a distance by scaleFactor to get its scaled size
	if ( ( rectangleRect.size.width - self.bounds.size.width )/self.bounds.size.width > ( rectangleRect.size.height - self.bounds.size.height )/self.bounds.size.height )
	{
		scaleFactor = ( self.bounds.size.width - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) ) / rectangleRect.size.width;
	}
	else
	{
		scaleFactor = ( self.bounds.size.height - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) ) / rectangleRect.size.height;
	}
	
	NSLog(@"At rectangleview, scaleFactor = %f", scaleFactor );	//	remove this
	
	rectangleRect.size.width = ( scaleFactor * rectangleRect.size.width );
	rectangleRect.size.height = ( scaleFactor * rectangleRect.size.height );
	//END scaling
	
	
	//BEGIN centering
	rectangleRect.origin.x = ( ( self.bounds.size.width - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) - rectangleRect.size.width ) / 2 ) + SHAPE_DIAGRAM_VIEW_MARGIN;
	rectangleRect.origin.y = ( ( self.bounds.size.height - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) - rectangleRect.size.height ) / 2 ) + SHAPE_DIAGRAM_VIEW_MARGIN;
	
	NSLog(@"rectangle origin.y = %f\nrectangle origin.x = %f",rectangleRect.origin.y, rectangleRect.origin.x);
	//END centering
	
	
	needsCalculation = NO;
}


- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	needsCalculation = YES;
}

- (void)setBounds:(CGRect)bounds
{
	[super setBounds:bounds];
	
	needsCalculation = YES;
}



@end
