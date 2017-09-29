//
//  LeftPanelViewController.h
//  NewSructure
//
//  Created by Thilina Hewagama on 11/29/13.
//  Copyright (c) 2013 Thilina Hewagama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTViewController.h"
#import "SDNestedTableViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LeftPanelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *_dataList;
    UIButton *btnVip;
    UIButton *btnFreeCrd;
    UIButton *btnSetting;
    
    UIImageView *imgNotificationBubble;
    UILabel *lblNoOfNotifications;
}

@property(nonatomic, copy) Communicator communicator;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
