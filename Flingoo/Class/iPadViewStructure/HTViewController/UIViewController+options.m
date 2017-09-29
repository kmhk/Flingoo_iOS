//
//  UIViewController+options.m
//  NewSructure
//
//  Created by Thilina Hewagama on 11/29/13.
//  Copyright (c) 2013 Thilina Hewagama. All rights reserved.
//

#import "UIViewController+options.h"

@implementation UIViewController (options)


-(void) dropShadow;{
   // [self.view.layer setShouldRasterize:YES];
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
	[self.view.layer setShadowOpacity:0.6];
	//[self.view.layer setShadowOffset:CGSizeMake(-5.0f,0)];
    CGRect frame = self.view.bounds;
    frame.origin.x = -3;
    frame.origin.y = 3;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:frame].CGPath;
}

@end
