//
//  MeasureEntryViewController.h
//  Shape Master
//
//  Created by Justin Buchanan on 10/1/03.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MeasureEntryCell.h"


@class ShapeController;

@interface MeasureEntryViewController : UITableViewController <UINavigationControllerDelegate>
{
	NSString *key;
	MeasureEntryCell *measureEntryCell;
	ShapeController *shapeController;
}

@property ( nonatomic, readonly, assign ) ShapeController *shapeController;

- (id)initWithShapeController:(ShapeController *)controller measureKey:(NSString *)measureKey;

- (void)userFinishedEnteringValue:(NSString *)theValue forKey:(NSString *)theKey;

@end
