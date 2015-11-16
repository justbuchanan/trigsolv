//
//  TriangleView.m
//  TrigSolv
//
//  Created by Justin Buchanan on 11/24/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import "TriangleView.h"


@interface TriangleView ()
- (UILabel *)labelWithString:(NSString *)string;
- (void)calculatePoints;
@end


@implementation TriangleView

@synthesize angleUnit;


- (id)initWithTriangle:(NSDictionary *)theTriangle
{
    if ( self = [super initWithFrame:CGRectZero] )
	{
		triangle = [theTriangle retain];
		
		angleUnit = JBAngleUnitRadian;
		
		needsCalculation = YES;
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
	   
	   
		vertexALabel = [self labelWithString:@"A"];
		vertexBLabel = [self labelWithString:@"B"];	//The -labelWithString method returns autoreleased labels, but when they are added as subviews, they are retained.
		vertexCLabel = [self labelWithString:@"C"];
		
		[self addSubview:vertexALabel];
		[self addSubview:vertexBLabel];
		[self addSubview:vertexCLabel];
    }
    return self;
}

- (void)dealloc
{
	[triangle release];
	
    [super dealloc];
}


- (void)drawRect:(CGRect)rect
{
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
	CGContextClosePath( context );
	
	CGContextStrokePath( context );
}


- (void)calculatePoints
{
	NSLog( @"the triangleview calculated the points");
	
	double angleARadian = JBAngleConvert( self.angleUnit, JBAngleUnitRadian, [[triangle objectForKey:@"angleA"] doubleValue] );
	double angleBRadian = JBAngleConvert( self.angleUnit, JBAngleUnitRadian, [[triangle objectForKey:@"angleB"] doubleValue] );
	double angleCRadian = JBAngleConvert( self.angleUnit, JBAngleUnitRadian, [[triangle objectForKey:@"angleC"] doubleValue] );

	if ( angleARadian == .5 * M_PI )	//
	{
		angleARadian += .00001;			//
	}
	if ( angleBRadian == .5 * M_PI )	//
	{
		angleBRadian += .00001;			//	If the angles are right, they are offset slightly to avoid undefined slopes.
	}
	if ( angleCRadian == .5 * M_PI )	//
	{
		angleCRadian += .00001;			//
	}
	
	
	//BEGIN original drawing
	vertexA.y = self.bounds.size.height - SHAPE_DIAGRAM_VIEW_MARGIN;
	vertexA.x = SHAPE_DIAGRAM_VIEW_MARGIN;
	
	vertexB.y = vertexA.y;
	vertexB.x = vertexA.x + [[triangle objectForKey:@"sideAB"] doubleValue];
	
	vertexC.y = vertexA.y - ( [[triangle objectForKey:@"sideAC"] doubleValue] * sin(angleARadian) );
	vertexC.x = vertexA.x + ( [[triangle objectForKey:@"sideAC"] doubleValue] * cos(angleARadian) );
	//END original drawing
	
	
	//BEGIN Scaling
	CGPoint *leftMostPoint;
	CGPoint *rightMostPoint;
	
	if ( vertexC.x < vertexA.x )
	{
		leftMostPoint = &vertexC;
		rightMostPoint = &vertexB;
	}
	else if ( vertexB.x < vertexC.x )
	{
		leftMostPoint = &vertexA;
		rightMostPoint = &vertexC;
	}
	else
	{
		leftMostPoint = &vertexA;
		rightMostPoint = &vertexB;
	}
	
		
	double triangleWidth = ( rightMostPoint->x - leftMostPoint->x );
	double triangleHeight = ( vertexA.y - vertexC.y );
	
	double scaleFactor;		//multiply a distance by scaleFactor to get its scaled size
	if ( ( triangleWidth - self.bounds.size.width )/self.bounds.size.width > ( triangleHeight - self.bounds.size.height )/self.bounds.size.height )
	{
		scaleFactor = ( self.bounds.size.width - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) ) / triangleWidth;
	}
	else
	{
		scaleFactor = ( self.bounds.size.height - ( 2 * SHAPE_DIAGRAM_VIEW_MARGIN ) ) / triangleHeight;
	}
	
	NSLog(@"At TriangleView, scaleFactor = %f", scaleFactor );	//	remove this
	
	//vertexA is already good so we can leave it
	
	//vertexB.y is already good so we can leave it
	vertexB.x = vertexA.x + ( scaleFactor * [[triangle objectForKey:@"sideAB"] doubleValue] );
	
	vertexC.y = vertexA.y - ( scaleFactor * [[triangle objectForKey:@"sideAC"] doubleValue] * sin( angleARadian ) );
	vertexC.x = vertexA.x + ( scaleFactor * [[triangle objectForKey:@"sideAC"] doubleValue] * cos( angleARadian ) );
	//END scaling
	
	
	//BEGIN centering
	triangleWidth = ( rightMostPoint->x - leftMostPoint->x );
	triangleHeight = ( vertexA.y - vertexC.y );
	
	double horizontalSlideFactor = ( ( self.bounds.size.width - triangleWidth ) / 2 ) - leftMostPoint->x;
	double verticalSlideFactor = ( ( self.bounds.size.height - triangleHeight ) / 2 ) - vertexC.y;
	
	vertexA.x += horizontalSlideFactor;
	vertexB.x += horizontalSlideFactor;
	vertexC.x += horizontalSlideFactor;
	
	vertexA.y += verticalSlideFactor;
	vertexB.y += verticalSlideFactor;
	vertexC.y += verticalSlideFactor;
	//END centering
	
	CGPoint labelCenter;
	
	double angle = angleARadian / 2;
	labelCenter.y = vertexA.y + ( SHAPE_DIAGRAM_LABEL_DISTANCE * sin( angle) );
	labelCenter.x = vertexA.x - ( SHAPE_DIAGRAM_LABEL_DISTANCE * cos( angle ) );
	vertexALabel.center = labelCenter;
	
	angle = M_PI - (  angleBRadian / 2 );
	labelCenter.y = vertexB.y + ( SHAPE_DIAGRAM_LABEL_DISTANCE * sin( angle) );
	labelCenter.x = vertexB.x - ( SHAPE_DIAGRAM_LABEL_DISTANCE * cos( angle ) );
	vertexBLabel.center = labelCenter;
	
	angle = angleARadian + ( M_PI - angleBRadian - angleARadian ) / 2;
	labelCenter.y = vertexC.y - ( SHAPE_DIAGRAM_LABEL_DISTANCE * sin( angle) );
	labelCenter.x = vertexC.x + ( SHAPE_DIAGRAM_LABEL_DISTANCE * cos( angle ) );
	vertexCLabel.center = labelCenter;
	
	needsCalculation = NO;
}



- (UILabel *)labelWithString:(NSString *)string
{
	UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 8, 15 )];
	theLabel.opaque = NO;
	
	theLabel.text = string;
	theLabel.font = [UIFont systemFontOfSize:12];
	
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
