//
//  ParallelogramView.m
//  TrigSolv
//
//  Created by Justin Buchanan on 11/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ParallelogramView.h"


@interface ParallelogramView ()
- (UILabel *)labelWithString:(NSString *)string;
- (void)calculatePoints;
@end


@implementation ParallelogramView

@synthesize angleUnit;


- (id)initWithParallelogram:(NSDictionary *)theParallelogram
{
    if ( self = [super initWithFrame:CGRectZero] )
	{
		parallelogram = [theParallelogram retain];
		
		angleUnit = JBAngleUnitRadian;
		
		needsCalculation = YES;
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
	   
	   
		vertexALabel = [self labelWithString:@"A"];
		vertexBLabel = [self labelWithString:@"B"];//The -labelWithString method returns autoreleased labels, but when they are added as subviews, they are retained.
		
		[self addSubview:vertexALabel];
		[self addSubview:vertexBLabel];
	}
    return self;
}

- (void)dealloc
{
	[parallelogram release];
	
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	if ( needsCalculation )
	{
		[self calculatePoints];
	}

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[SHAPE_DIAGRAM_COLOR setStroke];
	CGContextSetLineWidth( context, SHAPE_DIAGRAM_LINE_WIDTH );
	CGContextSetLineCap(context, SHAPE_DIAGRAM_LINE_CAP_STYLE );
	
	CGContextMoveToPoint( context, vertexA.x, vertexA.y );
	CGContextAddLineToPoint( context, vertexB.x, vertexB.y );
	CGContextAddLineToPoint( context, vertexC.x, vertexC.y );
	CGContextAddLineToPoint( context, vertexD.x, vertexD.y );
	CGContextClosePath( context );

	CGContextStrokePath( context );
}


- (void)calculatePoints
{
	NSLog( @"the parallelogram calculated the points");
	
	double angleARadian = JBAngleConvert( self.angleUnit, JBAngleUnitRadian, [[parallelogram objectForKey:@"angleA"] doubleValue] );
	double angleBRadian = JBAngleConvert( self.angleUnit, JBAngleUnitRadian, [[parallelogram objectForKey:@"angleB"] doubleValue] );
	double angleCRadian = JBAngleConvert( self.angleUnit, JBAngleUnitRadian, [[parallelogram objectForKey:@"angleA"] doubleValue] );
	double angleDRadian = JBAngleConvert( self.angleUnit, JBAngleUnitRadian, [[parallelogram objectForKey:@"angleB"] doubleValue] );

	if ( angleARadian == .5 * M_PI )	//
	{
		angleARadian += .00001;			//
	}
	if ( angleBRadian == .5 * M_PI )	//
	{
		angleBRadian += .00001;			//	If an angle is right, it is offset slightly to avoid undefined an slope.
	}
	if ( angleCRadian == .5 * M_PI )	//
	{
		angleCRadian += .00001;			//
	}
	if ( angleDRadian == .5 * M_PI )	//
	{
		angleDRadian += .00001;			//
	}
	
	
	
	//BEGIN original drawing
	vertexA.y = self.bounds.size.height - SHAPE_DIAGRAM_VIEW_MARGIN;
	vertexA.x = SHAPE_DIAGRAM_VIEW_MARGIN;
	
	vertexB.y = vertexA.y;
	vertexB.x = vertexA.x + [[parallelogram objectForKey:@"base"] doubleValue];
	
	vertexD.y = vertexA.y - ( sin( angleARadian ) * [[parallelogram objectForKey:@"side"] doubleValue] );
	vertexD.x = vertexA.x + ( cos( angleARadian ) * [[parallelogram objectForKey:@"side"] doubleValue] );
	
	vertexC.y = vertexD.y;
	vertexC.x = vertexD.x + [[parallelogram objectForKey:@"base"] doubleValue];
	//END original drawing
	
	
	//BEGIN Scaling
	CGPoint *leftMostPoint;
	CGPoint *rightMostPoint;
	
	if ( vertexD.x < vertexA.x )
	{
		leftMostPoint = &vertexD;
		rightMostPoint = &vertexB;
	}
	else if ( vertexC.x > vertexB.x )
	{
		leftMostPoint = &vertexA;
		rightMostPoint = &vertexC;
	}
	else
	{
		leftMostPoint = &vertexA;
		rightMostPoint = &vertexB;
	}
	
		
	double parallelogramWidth = ( rightMostPoint->x - leftMostPoint->x );
	double parallelogramHeight = ( vertexA.y - vertexC.y );
	
	double scaleFactor;		//multiply a distance by scaleFactor to get its scaled size
	if ( ( parallelogramWidth - self.bounds.size.width )/self.bounds.size.width > ( parallelogramHeight - self.bounds.size.height )/self.bounds.size.height )
	{
		scaleFactor = ( self.bounds.size.width - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) ) / parallelogramWidth;
	}
	else
	{
		scaleFactor = ( self.bounds.size.height - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) ) / parallelogramHeight;
	}
	
	
	
	//vertexA is already good so we can leave it
	
	//vertexB.y is already good so we can leave it
	vertexB.x = vertexA.x + ( scaleFactor * [[parallelogram objectForKey:@"base"] doubleValue] );
	
	vertexD.y = vertexA.y - ( scaleFactor * sin( angleARadian ) * [[parallelogram objectForKey:@"side"] doubleValue] );
	vertexD.x = vertexA.x + ( scaleFactor * cos( angleARadian ) * [[parallelogram objectForKey:@"side"] doubleValue] );
	
	vertexC.y = vertexD.y;
	vertexC.x = vertexD.x + ( scaleFactor * [[parallelogram objectForKey:@"base"] doubleValue] );
	//END scaling
	
	
	//BEGIN centering
	parallelogramWidth = ( rightMostPoint->x - leftMostPoint->x );
	parallelogramHeight = ( vertexA.y - vertexC.y );
	
	double horizontalSlideFactor = ( ( self.bounds.size.width - parallelogramWidth ) / 2 ) - leftMostPoint->x;
	double verticalSlideFactor = ( ( self.bounds.size.height - parallelogramHeight ) / 2 ) - vertexC.y;
	
	vertexA.x += horizontalSlideFactor;
	vertexB.x += horizontalSlideFactor;
	vertexC.x += horizontalSlideFactor;
	vertexD.x += horizontalSlideFactor;
	
	vertexA.y += verticalSlideFactor;
	vertexB.y += verticalSlideFactor;
	vertexC.y += verticalSlideFactor;
	vertexD.y += verticalSlideFactor;
	//END centering
	
	CGPoint labelCenter;
	
	double angle = angleARadian / 2;
	labelCenter.y = vertexA.y + ( SHAPE_DIAGRAM_LABEL_DISTANCE * sin( angle ) );
	labelCenter.x = vertexA.x - ( SHAPE_DIAGRAM_LABEL_DISTANCE * cos( angle ) );
	vertexALabel.center = labelCenter;
	
	angle = M_PI - ( angleBRadian / 2 );
	labelCenter.y = vertexB.y + ( SHAPE_DIAGRAM_LABEL_DISTANCE * sin( angle ) );
	labelCenter.x = vertexB.x - ( SHAPE_DIAGRAM_LABEL_DISTANCE * cos( angle ) );
	vertexBLabel.center = labelCenter;
	
	
	needsCalculation = NO;
}



- (UILabel *)labelWithString:(NSString *)string
{
	UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SHAPE_DIAGRAM_LABEL_WIDTH, SHAPE_DIAGRAM_LABEL_HEIGHT )];
	
	theLabel.text = string;
	theLabel.font = [UIFont systemFontOfSize:12];
	theLabel.textAlignment = UITextAlignmentCenter;
	
	return [theLabel autorelease];
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