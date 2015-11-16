//
//  ParallelogramView.h
//  TrigSolv
//
//  Created by Justin Buchanan on 11/24/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "UIView+FrameProperties.h"
#import "JBGeometry.h"


@interface ParallelogramView : UIView
{
	NSDictionary *parallelogram;
	JBAngleUnit angleUnit;
	
	CGPoint vertexA;
	CGPoint vertexB;
	CGPoint vertexC;
	CGPoint vertexD;

	UILabel *vertexALabel;
	UILabel *vertexBLabel;
	
	BOOL needsCalculation;
}

@property ( nonatomic, readwrite ) JBAngleUnit angleUnit;

- (id)initWithParallelogram:(NSDictionary *)theParallelogram;

@end
