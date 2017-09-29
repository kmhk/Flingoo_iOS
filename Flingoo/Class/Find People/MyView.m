//
//  MyView.m
//  HitTest
//
//  Created by Prasad De Zoysa on 11/21/13.
//  Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    // UIView will be "transparent" for touch events if we return NO
//    return (point.y < 220 || point.y > 280);
//}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"LOG %@", _sld);
    CGPoint pointInB = [_sld convertPoint:point fromView:self];

    if ([_sld pointInside:pointInB withEvent:event])
        return _sld;
    
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
