//
//  FLMyFansViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLMyFansViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *likeUsersArr;
    MBProgressHUD *HUD;
}

@end
