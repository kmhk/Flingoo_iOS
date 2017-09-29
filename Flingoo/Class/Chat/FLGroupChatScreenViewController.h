//
//  FLChatScreenViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLChat.h"
#import "FLWebServiceDelegate.h"
#import "MBProgressHUD.h"

@interface FLGroupChatScreenViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;

}
@property(weak, nonatomic) IBOutlet UITableView *chatTableView;
@property(nonatomic, strong) IBOutlet UIView *keyboardPanel;
@property(weak, nonatomic) IBOutlet UITextField *chatTextField;
@property(strong,nonatomic) FLChat *currentChatObj;//Globle chat arra user index
@end
