//
//  FLChatGroupBubbleViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 1/13/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLChat.h"
#import "FLWebServiceDelegate.h"
#import "MBProgressHUD.h"
#import "FLParentSliderViewController.h"

@interface FLChatGroupBubbleViewController:FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
}
@property(weak, nonatomic) IBOutlet UITableView *chatTableView;
@property(nonatomic, strong) IBOutlet UIView *keyboardPanel;
@property(weak, nonatomic) IBOutlet UITextField *chatTextField;
@property(strong,nonatomic) FLChat *currentChatObj;//Globle chat arra user index
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;


@end
