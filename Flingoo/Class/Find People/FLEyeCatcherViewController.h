//
//  FLEyeCatcherViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/19/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "MBProgressHUD.h"
#import "FLWebServiceApi.h"


@interface FLEyeCatcherViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@end
