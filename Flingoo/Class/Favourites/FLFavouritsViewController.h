//
//  FLFavouritsViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "MBProgressHUD.h"
#import "FLWebServiceApi.h"

@interface FLFavouritsViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *favoriteListArr;
    MBProgressHUD *HUD;
}

@end