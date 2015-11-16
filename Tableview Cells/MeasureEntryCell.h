//
//  ShapeMeasureCell.h
//  Shape Master
//
//  Created by Justin Buchanan on 9/22/08.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "Defines.h"

@class MeasureEntryViewController;

@interface MeasureEntryCell : UITableViewCell <UITextFieldDelegate>
{
	UITextField *textField;
	
	MeasureEntryViewController *measureEntryController;
	
	NSString *key;
}

- (id)initWithMeasureEntryViewController:(MeasureEntryViewController *)viewController key:(NSString *)theKey;

@property (nonatomic, readonly, retain) UITextField *textField;
@property (nonatomic, readonly, assign) MeasureEntryViewController *measureEntryController;
@property (nonatomic, readonly, retain) NSString *key;

- (void)userFinishedEditingTextField;

@end
