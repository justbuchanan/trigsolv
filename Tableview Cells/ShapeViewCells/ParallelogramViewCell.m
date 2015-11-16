//
//  ParallelogramViewCell.m
//  
//
//  Created by Justin Buchanan on 11/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ParallelogramViewCell.h"


@implementation ParallelogramViewCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
