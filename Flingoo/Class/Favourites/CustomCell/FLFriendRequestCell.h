//
//  FLFriendRequestCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FLWebServiceApi.h"

@interface FLFriendRequestCell : UITableViewCell<MBProgressHUDDelegate,FLWebServiceDelegate>
{
    MBProgressHUD *HUD;

}

@property(nonatomic, strong) IBOutlet UIButton *rejectButton;
@property(nonatomic, strong) IBOutlet UIButton *acceptButton;
@property(nonatomic, strong) IBOutlet UILabel *profileNameLabel;
@property(nonatomic, strong) IBOutlet UIImageView *profilePictureView;
@property(nonatomic,strong) NSString *friendship_id;
@property(nonatomic, assign) BOOL online;

@property(nonatomic, assign) BOOL targetSet;
- (IBAction)rejectClicked:(id)sender;
- (IBAction)actionClicked:(id)sender;

@end
