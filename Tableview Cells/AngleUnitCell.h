//
//  AngleUnitCell.h
//  TrigSolv
//
//  Created by Justin Buchanan on 11/10/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AngleUnitCell : UITableViewCell
{
	UISegmentedControl *segmentedControl;
}

@property (readonly, retain) UISegmentedControl *segmentedControl;

@end
