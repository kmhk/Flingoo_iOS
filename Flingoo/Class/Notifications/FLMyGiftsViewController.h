//
//  FLMyGiftsViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

typedef enum {
    kGiftViewModePresent,
    kGiftViewModePush
}GiftViewMode;

@interface FLMyGiftsViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil launchMode:(GiftViewMode) launchMode;

@end
