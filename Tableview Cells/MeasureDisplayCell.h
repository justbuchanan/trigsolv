//
//  MeasureDisplayCell.h
//  Shape Master
//
//  Created by Justin Buchanan on 10/2/03.
//  Copyright 2003 JustBuchanan Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"


@interface MeasureDisplayCell : UITableViewCell
{
	NSString *key;
	BOOL selectable;
}

- (id)initWithValue:(NSString *)aValue forKey:(NSString *)aKey reuseIdentifier:(NSString *)reuseIdentifier;

@property (readwrite, retain) NSString *key;
@property (readwrite, retain) NSString *value;
@property (readwrite) BOOL selectable;

@end
