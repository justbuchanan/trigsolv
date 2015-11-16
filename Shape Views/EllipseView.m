//
//  EllipseView.m
//  TrigSolv
//
//  Created by Justin Buchanan on 11/24/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import "EllipseView.h"


@interface EllipseView ()
- (void)calculatePoints;
@end


@implementation EllipseView


- (id)initWithEllipse:(NSDictionary *)theEllipse
{
    if ( self = [super initWithFrame:CGRectZero] )
	{
        ellipse = [theEllipse retain];
		
		needsCalculation = YES;
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
    
	if ( needsCalculation )
	{
		[self calculatePoints];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineCap( context, SHAPE_DIAGRAM_LINE_CAP_STYLE );
	CGContextSetLineWidth( context, SHAPE_DIAGRAM_LINE_WIDTH );
	[SHAPE_DIAGRAM_COLOR setStroke];
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddEllipseInRect( path, NULL, ellipseRect );
	
	CGContextAddPath( context, path );
	CGContextStrokePath( context );
	
	[[UIColor blackColor] set];
	
	CGContextFlush( context );
	CGMutablePathRef leftFocusDot = CGPathCreateMutable();
	CGPathAddEllipseInRect( leftFocusDot, NULL, CGRectMake( leftFocus.x - 4, leftFocus.y - 4, 8, 8 ) );
	CGContextAddPath( context, leftFocusDot );
	CGContextFillPath( context );
	
	CGContextFlush( context );
	CGMutablePathRef rightFocusDot = CGPathCreateMutable();
	CGPathAddEllipseInRect( rightFocusDot, NULL, CGRectMake( rightFocus.x - 4, rightFocus.y - 4, 8, 8 ) );
	CGContextAddPath( context, rightFocusDot );
	CGContextFillPath( context );
	
	
	NSLog(@"the ellipse view was drawn");
}


- (void)dealloc
{
	[ellipse release];
	
    [super dealloc];
}

- (void)calculatePoints
{
	ellipseRect.size.width = [[ellipse objectForKey:@"majorAxis"] doubleValue];
	ellipseRect.size.height = [[ellipse objectForKey:@"minorAxis"] doubleValue];
	
	
	//BEGIN scaling
	double scaleFactor;		//multiply a distance by scaleFactor to get its scaled size
	if ( ( ellipseRect.size.width - self.bounds.size.width )/self.bounds.size.width > ( ellipseRect.size.height - self.bounds.size.height )/self.bounds.size.height )
	{
		scaleFactor = ( self.bounds.size.width - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) ) / ellipseRect.size.width;
	}
	else
	{
		scaleFactor = ( self.bounds.size.height - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) ) / ellipseRect.size.height;
	}
	
	NSLog(@"At ellipseview, scaleFactor = %f", scaleFactor );	//	remove this
	
	ellipseRect.size.width = ( scaleFactor * ellipseRect.size.width );
	ellipseRect.size.height = ( scaleFactor * ellipseRect.size.height );
	//END scaling
	
	
	//BEGIN centering
	ellipseRect.origin.x = ( ( self.bounds.size.width - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) - ellipseRect.size.width ) / 2 ) + SHAPE_DIAGRAM_VIEW_MARGIN;
	ellipseRect.origin.y = ( ( self.bounds.size.height - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) - ellipseRect.size.height ) / 2 ) + SHAPE_DIAGRAM_VIEW_MARGIN;
	
	NSLog(@"ellipse origin.y = %f\nellipse origin.x = %f",ellipseRect.origin.y, ellipseRect.origin.x);
	//END centering
	
	//BEGIN foci
	leftFocus.y = ellipseRect.origin.y + ( ellipseRect.size.height / 2 );
	rightFocus.y = leftFocus.y;
	
	double scaledFocalDistance = scaleFactor * [[ellipse objectForKey:@"focalDistance"] doubleValue];
	
	leftFocus.x = ellipseRect.origin.x + ( ( ellipseRect.size.width - scaledFocalDistance ) / 2 );
	rightFocus.x = ellipseRect.origin.x + ( ( ellipseRect.size.width + scaledFocalDistance ) / 2 );
	//END fock
	
	
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
