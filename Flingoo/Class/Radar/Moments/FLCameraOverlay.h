//
//  FLCameraOverlay.h
//  Flingoo
//
//  Created by Prasad De Zoysa on 1/5/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLCameraOverlay : UIView

@property(nonatomic, strong) UIImagePickerController *picker;

- (id)initWithFrame:(CGRect)frame andPicker:(UIImagePickerController*)pikr;

@end
