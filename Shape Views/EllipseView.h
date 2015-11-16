//
//  EllipseView.h
//  TrigSolv
//
//  Created by Justin Buchanan on 11/24/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"


@interface EllipseView : UIView
{
	NSDictionary *ellipse;
	
	CGRect ellipseRect;
	CGPoint leftFocus;
	CGPoint rightFocus;
	
	BOOL needsCalculation;
}

- (id)initWithEllipse:(NSDictionary *)theEllipse;

@end
