//
//  TriangleView.h
//  TrigSolv
//
//  Created by Justin Buchanan on 11/24/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBGeometry.h"
#import "UIView+FrameProperties.h"
#import "Defines.h"


@interface TriangleView : UIView
{
	NSDictionary *triangle;
	
	JBAngleUnit angleUnit;
	
	CGPoint vertexA;
	CGPoint vertexB;
	CGPoint vertexC;

	UILabel *vertexALabel;
	UILabel *vertexBLabel;
	UILabel *vertexCLabel;
	
	BOOL needsCalculation;
}

@property ( nonatomic, readwrite ) JBAngleUnit angleUnit;	//	default is JBAngleUnitRadian

- (id)initWithTriangle:(NSDictionary *)theTriangle;

@end
