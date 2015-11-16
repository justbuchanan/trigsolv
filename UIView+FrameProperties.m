//
//  UIView+FrameProperties.m
//  Shape Master
//
//  Created by Justin Buchanan on 10/9/08.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import "UIView+FrameProperties.h"


@implementation UIView (UIView_FrameProperties)



# pragma mark Frame Property Setters
- (void)setFrameOrigin:(CGPoint)frameOrigin
{
	CGRect rect;
	rect.size = self.frame.size;
	rect.origin = frameOrigin;
	
	self.frame = rect;
}

- (void)setFrameOriginX:(float)frameOriginX
{
	CGRect rect;
	rect.size = self.frame.size;
	rect.origin = CGPointMake(frameOriginX, self.frame.origin.y);
	
	self.frame = rect;
}
- (void)setFrameOriginY:(float)frameOriginY
{
	CGRect rect;
	rect.size = self.frame.size;
	rect.origin = CGPointMake(self.frame.origin.x, frameOriginY);
	
	self.frame = rect;
}



- (void)setFrameSize:(CGSize)frameSize
{
	CGRect rect;
	rect.origin = self.frame.origin;
	rect.size = frameSize;
	
	self.frame = rect;
}

- (void)setFrameWidth:(float)frameWidth
{
	CGRect rect;
	rect.origin = self.frame.origin;
	rect.size = CGSizeMake(frameWidth, self.frame.size.height);
	
	self.frame = rect;
}
- (void)setFrameHeight:(float)frameHeight
{
	CGRect rect;
	rect.origin = self.frame.origin;
	rect.size = CGSizeMake(self.frame.size.width, frameHeight);
	
	self.frame = rect;
}


#pragma mark Frame Property Getters
- (CGPoint)frameOrigin
{
	return self.frame.origin;
}

- (float)frameOriginX
{
	return self.frame.origin.x;
}
- (float)frameOriginY
{
	return self.frame.origin.y;
}



- (CGSize)frameSize
{
	return self.frame.size;
}

- (float)frameWidth
{
	return self.frame.size.width;
}
- (float)frameHeight
{
	return self.frame.size.height;
}


@end
