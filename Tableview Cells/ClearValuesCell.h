//
//  ClearValuesCell.h
//  TrigSolv
//
//  Created by Justin Buchanan on 11/10/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ShapeController;

@interface ClearValuesCell : UITableViewCell
{
	UIButton *clearValuesButton;
	ShapeController *shapeController;
}

- (id)initWithShapeController:(ShapeController *)aShapeController reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readwrite, assign) ShapeController *shapeController;

@end
