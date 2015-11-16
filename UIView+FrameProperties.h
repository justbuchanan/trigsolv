//
//  UIView+FrameProperties.h
//  Shape Master
//
//  Created by Justin Buchanan on 10/9/08.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (UIView_FrameProperties)

#pragma mark Frame Property Setters
- (void)setFrameOrigin:(CGPoint)frameOrigin;

- (void)setFrameOriginX:(float)frameOriginX;
- (void)setFrameOriginY:(float)frameOriginY;


- (void)setFrameSize:(CGSize)frameSize;

- (void)setFrameWidth:(float)frameWidth;
- (void)setFrameHeight:(float)frameHeight;


#pragma mark Frame Property Getters
- (CGPoint)frameOrigin;

- (float)frameOriginX;
- (float)frameOriginY;


- (CGSize)frameSize; 

- (float)frameWidth;
- (float)frameHeight;


@end
