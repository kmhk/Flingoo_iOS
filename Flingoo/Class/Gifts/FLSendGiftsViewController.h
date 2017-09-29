//
//  FLSendGiftsViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"
#import "FLOtherProfile.h"

@interface FLSendGiftsViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property(nonatomic,strong) FLOtherProfile *profileObj;
@end
