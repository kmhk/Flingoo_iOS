//
//  FLCustomeScrollView.m
//  Flingoo
//
//  Created by Hemal on 11/13/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLCustomeScrollView.h"

@implementation FLCustomeScrollView

@synthesize view;


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [view endEditing:YES];
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
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
