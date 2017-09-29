//
//  FLProfileVisitorsViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLProfileVisitorsViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
//    NSMutableArray *profileVisitorsListArr;
}

@end
