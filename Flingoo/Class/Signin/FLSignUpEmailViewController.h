//
//  FLSignUpEmailViewController.h
//  Flingoo
//
//  Created by Hemal on 11/11/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLCustomeScrollView.h"
#import "MBProgressHUD.h"
#import "FLWebServiceApi.h"

@interface FLSignUpEmailViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,MBProgressHUDDelegate,FLWebServiceDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPopoverControllerDelegate>
{

    IBOutlet UITextField *txtFldEmail;
    IBOutlet UITextField *txtFldPassword;
    IBOutlet UITextField *txtFldFullName;
    IBOutlet UITextField *txtFldPhoneNo;
    IBOutlet UIButton *btnBirthday;
    IBOutlet FLCustomeScrollView *scrollView;
    BOOL keyboardIsShown;
    
    UIDatePicker *theDatePicker;
    NSDate *selectedDatePickerDate;
    UIActionSheet *actionSheet;
    UIPopoverController *popOver;
    UIView *popoverView;
    
    MBProgressHUD *HUD;
    IBOutlet UIImageView *imgBg;
    
    IBOutlet UIImageView *imgProfilePic;
    UIPopoverController *popoverController;
    IBOutlet UIButton *btnProfilePic;
}

- (IBAction)birthdayClicked:(id)sender;
- (IBAction)profilePicClicked:(id)sender;


@end
