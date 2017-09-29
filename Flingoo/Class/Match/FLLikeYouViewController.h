//
//  FLLikeYouViewController.h
//  Flingoo
//
//  Created by Hemal on 11/18/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLLikeYouViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    NSString *titleLbl;
    NSMutableArray *likeUsersArr;
    MBProgressHUD *HUD;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTitle:(NSString *)lableTitle;

@end
