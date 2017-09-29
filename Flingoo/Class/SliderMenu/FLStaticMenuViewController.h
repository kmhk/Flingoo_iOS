//
//  UIStaticDemo.h
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLStaticMenuViewControllerDelegate <NSObject>

// method to inform slidecontroller that something has been selected
-(void)staticDemoDidSelectText:(NSString *)text;

@end

@interface FLStaticMenuViewController : UITableViewController
{
    __weak id<FLStaticMenuViewControllerDelegate> delegate;
    NSArray *myDetailsTxtArr;
    NSArray *myStyTouchTxtArr;
    UIButton *btnVip;
    UIButton *btnFreeCrd;
    UIButton *btnSetting;
    UIImageView *imgNotificationBubble;
    UILabel *lblNoOfNotifications;
}

@property (nonatomic, weak) id<FLStaticMenuViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *data;

@end
