//
//  FLCameraOverlay.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 1/5/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLCameraOverlay.h"

@implementation FLCameraOverlay

- (id)initWithFrame:(CGRect)frame andPicker:(UIImagePickerController*)pikr
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"FLMomentCameraView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.picker = pikr;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        // Initialization code
    }
    return self;
}

- (IBAction)takePhoto:(UIButton *)sender {
    [self.picker takePicture];
}



- (IBAction)closeCamera:(UIButton *)sender {
    [self.picker dismissViewControllerAnimated:YES completion:nil];
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
