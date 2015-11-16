//
//  RectangleView.h
//  TrigSolv
//
//  Created by Justin Buchanan on 11/24/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"


@interface RectangleView : UIView
{
	NSDictionary *rectangle;
	CGRect rectangleRect;
	BOOL needsCalculation;
}

- (id)initWithRectangle:(NSDictionary *)theRectangle;

@end
