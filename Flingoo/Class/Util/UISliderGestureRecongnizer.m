//
//  UISliderGestureRecongnizer.m
//  RadarNew1
//
//  Created by Prasad De Zoysa on 11/21/13.
//  Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved.
//

#import "UISliderGestureRecongnizer.h"

@implementation UISliderGestureRecongnizer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"LOG %@", _slider);
    CGPoint pointInB = [_slider convertPoint:point fromView:self];
    
    if ([_slider pointInside:pointInB withEvent:event])
        return _slider;
    
    return [super hitTest:point withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
