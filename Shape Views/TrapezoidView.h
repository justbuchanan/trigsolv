//
//  TrapezoidView.h
//  TrigSolv
//
//  Created by Justin Buchanan on 11/24/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBGeometry.h"
#import "UIView+FrameProperties.h"
#import "Defines.h"


@interface TrapezoidView : UIView
{
	NSDictionary *trapezoid;
	
	JBAngleUnit angleUnit;
	
	CGPoint vertexA;
	CGPoint vertexB;
	CGPoint vertexC;
	CGPoint vertexD;

	UILabel *vertexALabel;
	UILabel *vertexBLabel;
	UILabel *vertexCLabel;
	UILabel *vertexDLabel;
	
	BOOL needsCalculation;
}

@property ( nonatomic, readwrite ) JBAngleUnit angleUnit;	//	default is JBAngleUnitRadian

- (id)initWithTrapezoid:(NSDictionary *)theTrapezoid;

@end
