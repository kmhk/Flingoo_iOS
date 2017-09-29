//
//  FLBlockedPeopleViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLBlockedPeopleViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@end
