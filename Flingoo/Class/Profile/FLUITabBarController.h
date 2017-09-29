//
//  FLUITabBarController.h
//  Take Secure Pics
//
//  Created by Prasad De Zoysa on 9/15/13.
//  Copyright (c) 2013 Prasad De Zoysa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeMenu.h"
#import "FLOtherProfile.h"
#import "FLWebServiceApi.h"

@interface FLUITabBarController : UITabBarController<UITabBarControllerDelegate,AwesomeMenuDelegate,FLWebServiceDelegate>
{
    UIView *viewDummy;
    AwesomeMenuItem *startItem;
    AwesomeMenu *menu;
}

@property(nonatomic, retain) UIButton *leftButton;
@property(nonatomic, retain) UIButton *centerButton;
@property(nonatomic, retain) UIButton *rightButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProfileObj:(FLOtherProfile *)profileObj;
@end

