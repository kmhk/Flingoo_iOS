//
//  FLProfilePicView.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 12/14/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLProfilePicView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FLProfilePicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 7;
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
