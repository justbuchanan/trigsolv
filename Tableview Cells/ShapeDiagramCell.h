//
//  ShapeDiagramCell.h
//  MetriSolv
//
//  Created by Justin Buchanan on 10/26/08.
//  Copyright 2008 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShapeDiagramCell : UITableViewCell
{
	UIView *shapeDiagramView;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier shapeDiagramView:(UIView *)view;

@property (readwrite, retain) UIView *shapeDiagramView;

@end
