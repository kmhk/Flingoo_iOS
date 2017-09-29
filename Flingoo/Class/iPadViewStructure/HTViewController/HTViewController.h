//
//  HTViewController.h
//  NewSructure
//
//  Created by Thilina Hewagama on 11/29/13.
//  Copyright (c) 2013 Thilina Hewagama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+options.h"

@interface HTViewController : UIViewController

@property(nonatomic, strong) UIScrollView *parentScrollView;
@property(nonatomic, copy) Communicator communicator;

@end
