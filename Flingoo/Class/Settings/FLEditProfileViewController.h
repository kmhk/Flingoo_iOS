//
//  FLEditProfileViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"
#import "FLChangeMobileNumberViewController.h"

@interface FLEditProfileViewController : FLParentSliderViewController<FLWebServiceDelegate,UIActionSheetDelegate,MBProgressHUDDelegate,PhoneNoDelegate>
{

    IBOutlet UITextField *lblName;
    IBOutlet UIButton *btnDateofBirth;
    BOOL select;
    UIActionSheet *actionSheet;
    UIPopoverController *popOver;
    UIView *popoverView;
    UIDatePicker *theDatePicker;
    NSDate *selectedendPickerDate;
    NSDate *selectedStartPickerDate;
    MBProgressHUD *HUD;
    IBOutlet UITextField *txtCity;
    NSString *newPhoneNo;
}

@end
