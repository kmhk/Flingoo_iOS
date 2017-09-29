//
//  FLShowGiftsViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"
#import "FLOtherProfile.h"


typedef enum {
    kGiftTableTypeKiss,
    kGiftTableTypeDrink
} GiftTableType;


@interface FLShowGiftsViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
    @property(weak, nonatomic) IBOutlet UILabel *giftTypeNameLabel;
    @property(nonatomic, assign) GiftTableType giftType;
@property(nonatomic,strong) NSMutableArray *giftObjArr;

@property(nonatomic,strong) FLOtherProfile *profileObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil giftTableType:(GiftTableType) gType;

@end
