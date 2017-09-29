//
//  FLSignUpEmailViewController.m
//  Flingoo
//
//  Created by Hemal on 11/11/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLSignUpEmailViewController.h"
#import "FLRegAddInfoViewController.h"
#import "FLUtilValidation.h"
#import "FLGlobalSettings.h"
#import "FLUtilUserDefault.h"
#import "FLAppDelegate.h"
#import "FLImgObj.h"
#import "Config.h"
#import "FLUtil.h"
#import <QuartzCore/QuartzCore.h>

@interface FLSignUpEmailViewController ()
@property(nonatomic,strong) NSString *imgPofilePicName;//uploaded profile pic image name
@end

@implementation FLSignUpEmailViewController





#pragma mark - Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSString *nib;
    if (IS_IPAD)
    {
        nib=[NSString stringWithFormat:@"%@-iPad",nibNameOrNil];
    }else
    {
        nib=nibNameOrNil;
    }
    self = [super initWithNibName:nib bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}











#pragma mark -
#pragma mark view life cycle

- (void)viewDidLoad{
    [super viewDidLoad];
  
    [scrollView setView:self.view];
    
    if (IS_IPHONE5)
    {
        NSString *fileLocation = [[NSBundle mainBundle] pathForResource:@"Bg_h568@2x" ofType:@"png"];
        imgBg.image = [UIImage imageWithContentsOfFile:fileLocation];
    }
    
//    //set navigationbar image
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    UIImage *navImage = [UIImage imageNamed:@"navigationbar.png"];
//    [navBar setBackgroundImage:navImage  forBarMetrics:UIBarMetricsDefault];
    
    //set navigationbar back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(back:)];

    
    
    UIImage* registerBtnImg = [UIImage imageNamed:@"register_btn.png"];
    CGRect frameRegister = CGRectMake(0, 0, registerBtnImg.size.width, registerBtnImg.size.height);
    UIButton* registerBtn = [[UIButton alloc]initWithFrame:frameRegister];
    [registerBtn setBackgroundImage:registerBtnImg forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* finishBarButton = [[UIBarButtonItem alloc] initWithCustomView:registerBtn];
    [self.navigationItem setRightBarButtonItem:finishBarButton];
    
    self.navigationItem.title = @"Sign Up";
    
    imgProfilePic.layer.masksToBounds = YES;
    imgProfilePic.layer.cornerRadius = 10.0;
//    imgProfilePic.layer.borderWidth = 1.0;
//    imgProfilePic.layer.borderColor = [[UIColor grayColor] CGColor];
    
  // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}











#pragma mark -
#pragma mark Actions

- (IBAction)birthdayClicked:(id)sender{
    if (IS_IPHONE || IS_IPHONE_5) {
        [self.view endEditing:YES];
        int height=IS_IPHONE5?140:165;
        [scrollView setContentOffset:CGPointMake(0, height) animated:YES];
        [self createActionSheet];
        [self createUIDatePicker];
    }
    else if(IS_IPAD)
    {
        [self.view endEditing:YES];
        [self createActionSheet];
        [self createUIDatePicker];
    }
  
}

- (IBAction)profilePicClicked:(id)sender {
//    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
//    [webServiceApi getImageFromName:self withImgName:@"69-2BBCAFE9-27B4-405D-8E81-BC76F0B11C25.jpg"];
    
    
    
//    // Create the sheet without buttons
	UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:@"Profile Picture"
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    
	// Add buttons one by one (e.g. in a loop from array etc...)
	[sheet addButtonWithTitle:@"Upload Photo"];
	[sheet addButtonWithTitle:@"Take Photo"];    
	// Also add a cancel button
	[sheet addButtonWithTitle:@"Cancel"];
	// Set cancel button index to the one we just added so that we know which one it is in delegate call
	// NB - This also causes this button to be shown with a black background
	sheet.cancelButtonIndex = sheet.numberOfButtons-1;
    
//	[sheet showFromRect:self.view.bounds inView:self.view animated:YES];

    if (IS_IPAD)
    {
        [sheet showFromRect:btnProfilePic.frame inView:scrollView animated:YES];
    }else{
    [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet1.cancelButtonIndex) {
        return;
    }
	switch (buttonIndex) {
		case 0:
		{
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *_picker=nil;
                if (popoverController) {
                    [popoverController dismissPopoverAnimated:NO];
                    
                }
                _picker = [[UIImagePickerController alloc] init];
                _picker.delegate = self;
                _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                _picker.wantsFullScreenLayout = YES;
                
                //[popoverController presentPopoverFromBarButtonItem:sender
                //   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
                if (IS_IPHONE || IS_IPHONE_5) {
                    
                    [self presentViewController:_picker animated:YES completion:nil];
                    
                    
                } else
                {
                    popoverController = [[UIPopoverController alloc] initWithContentViewController:_picker];
                    [popoverController setDelegate:self];
//                    [popoverController presentPopoverFromRect:imgProfilePic.frame
//                                                       inView:self.view
//                                     permittedArrowDirections:UIPopoverArrowDirectionLeft
//                                                     animated:YES];
                    
                    CGRect frm = imgProfilePic.frame;
//                    frm.origin.y = frm.origin.y;
                    
                     [popoverController presentPopoverFromRect:frm inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error access photo library"
                                                                message:@"your device non support photo library"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
			break;
		}
		case 1:
		{
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                if( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) return;
                
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//                imagePickerController.allowsImageEditing = YES;

                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error to access Camera"
                                                                message:@""
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
			break;
		}
	
	}
}

- (void)pickerDone:sender{
        selectedDatePickerDate=[theDatePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // changed line in your code
        NSString *dateText = [dateFormatter stringFromDate:selectedDatePickerDate];
        [btnBirthday setTitle:dateText forState: UIControlStateNormal];
    
//    }
    if (IS_IPHONE || IS_IPHONE_5)
	{
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        actionSheet = nil;
    }
    else if(IS_IPAD)
    {
        [popOver dismissPopoverAnimated:YES];
        popOver=nil;
    }
   
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerClicked:(id)sender{
    [self.view endEditing:YES];
    if ([txtFldEmail.text length]==0)
    {
        [self showValidationAlert:@"Email cannot be empty"];
        return;
    }
    else if(![FLUtilValidation validateEmail:txtFldEmail.text])
    {
        [self showValidationAlert:@"Email is invalid"];
        return;
    }
    else if (![FLUtilValidation validatePassword:txtFldPassword.text])
    {
        [self showValidationAlert:@"Password should be minimum 6 characters"];
        return;
    }
    else if ([txtFldFullName.text length]==0)
    {
        [self showValidationAlert:@"Full name cannot be empty"];
        return;
    }
    else if ([btnBirthday.titleLabel.text isEqualToString:@"Birthday"])
    {
        [self showValidationAlert:@"Birthday cannot be empty"];
        return;
    }
    
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Connecting";
    [HUD show:YES];
    
    NSDictionary *userDataDic = @{
    @"email" :txtFldEmail.text,
    @"password":txtFldPassword.text,
    @"full_name": txtFldFullName.text,
    @"mobile_number": txtFldPhoneNo.text,
    @"birth_date": btnBirthday.titleLabel.text
    };
    
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    [webSeviceApi createUser:self withUserData:userDataDic];
    

}











#pragma mark -
#pragma mark Image picker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // write your code here ........
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    [imgProfilePic setContentMode:UIViewContentModeScaleAspectFit];
    
    
    
    imgProfilePic.image=originalImage;

//    imgProfilePic.layer.masksToBounds = YES;
//    imgProfilePic.layer.cornerRadius = 10.0;
//    imgProfilePic.layer.borderWidth = 1.0;
//    imgProfilePic.layer.borderColor = [[UIColor grayColor] CGColor];
    
    
//    [imgProfilePic.layer setCornerRadius:10.0];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
   [picker dismissViewControllerAnimated:YES completion:nil];
}











#pragma mark -
#pragma mark Util methods

-(void)showValidationAlert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}











#pragma mark -
#pragma mark date picker

- (void)createActionSheet {
    
    if ((IS_IPHONE || IS_IPHONE_5) && actionSheet == nil) {
        // setup actionsheet to contain the UIPicker
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone:)];
        [barItems addObject:doneBtn];
        
        [pickerToolbar setItems:barItems animated:YES];
        [actionSheet addSubview:pickerToolbar];
        [actionSheet showInView:self.view];
        [actionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
    else if(IS_IPAD && popOver==nil)
    {
        UIViewController* popoverContent = [[UIViewController alloc] init];
        
        UIToolbar *toolbr = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(pickerDone:)];
        popoverView = [[UIView alloc] init];   //view
        popoverView.backgroundColor = [UIColor blackColor];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:editButton];
        toolbr.items = items;
        [popoverView addSubview:toolbr];
        ///
        
        ////
        //[popoverView addSubview:theDatePicker];
        
        popoverContent.view = popoverView;
        popOver = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        //    popOver.delegate=self;
        
        [popOver setPopoverContentSize:CGSizeMake(320, 260) animated:NO];
    
    }
}

- (void)createUIDatePicker{
    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    theDatePicker.datePickerMode = UIDatePickerModeDate;
    [theDatePicker setDate:[NSDate date]];
    
    if (IS_IPHONE || IS_IPHONE_5)
	{
         [actionSheet addSubview:theDatePicker];
    }
    else if(IS_IPAD)
    {
        [popoverView addSubview:theDatePicker];
        
        CGRect frm = btnBirthday.frame;
//        frm.origin.y = frm.origin.y ;
        
        [popOver presentPopoverFromRect:frm inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        [theDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    }
   
}

- (void)dateChanged:(id)sender{
    if(IS_IPAD)
    {
        selectedDatePickerDate=[theDatePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // changed line in your code
        NSString *dateText = [dateFormatter stringFromDate:selectedDatePickerDate];
        [btnBirthday setTitle:dateText forState: UIControlStateNormal];
    }
}










#pragma mark -
#pragma mark - UITextFieldDelegate Methods
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        // submit the login form.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    if (IS_IPHONE)
    {
        if (textField == txtFldFullName) {
            [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
        }
        else if (textField == txtFldPhoneNo) {
            int height=IS_IPHONE5?130:145;
            [scrollView setContentOffset:CGPointMake(0, height) animated:YES];
        }
        else if (textField == txtFldPassword) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    else
    {
        if (textField == txtFldEmail) {
            [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
        }
        else if (textField == txtFldPassword)
        {
            [scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
        }
        else if (textField == txtFldFullName) {
            [scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
        }
        else if (textField == txtFldPhoneNo) {
            [scrollView setContentOffset:CGPointMake(0, 190) animated:YES];
        }
    
    }

    return YES;
}











#pragma mark -
#pragma mark Keyboard notification

- (void)keyboardWillHide:(NSNotification *)n{
    if (IS_IPHONE)
    {
        NSDictionary* userInfo = [n userInfo];
        
        // get the size of the keyboard
        NSValue* boundsValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
        CGSize keyboardSize = [boundsValue CGRectValue].size;
        
        // resize the scrollview
        CGRect viewFrame = scrollView.frame;
        // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
        viewFrame.size.height += (keyboardSize.height - 0);//kTabBarHeight
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [scrollView setFrame:viewFrame];
        [UIView commitAnimations];
        [scrollView setContentSize:CGSizeMake(318, 416)];
    }
    else
    {
        [scrollView setContentSize:CGSizeMake(1024, 704)];
       
        
    }
     [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
     keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n{
    if (keyboardIsShown) {
        return;
    }
    if (IS_IPHONE) {
        [scrollView setContentSize:CGSizeMake(318, 416.5)];
        NSDictionary* userInfo = [n userInfo];
        
        NSValue* boundsValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
        CGSize keyboardSize = [boundsValue CGRectValue].size;
        CGRect viewFrame = scrollView.frame;
        // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
        viewFrame.size.height -= (keyboardSize.height - 0);//kTabBarHeight
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [scrollView setFrame:viewFrame];
        [UIView commitAnimations];
    }
    else{
        [scrollView setContentSize:CGSizeMake(1024, 900)];
    }
    keyboardIsShown = YES;
}











#pragma mark -
#pragma mark WebService delegate methods

- (void)createUserResult:(FLUser *)current_user{
    NSLog(@"current_user.auth_token %@",current_user.auth_token);
//    [FLUtilUserDefault setAuthToken:current_user.auth_token];
    [FLGlobalSettings sharedInstance].current_user=current_user;
    [FLUtilUserDefault setUsername:txtFldEmail.text];
    [FLUtilUserDefault setPassword:txtFldPassword.text];
    
    
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService getUserSettingsList:self];
}

- (void)userSettingListResult:(FLSetting *)settingObj{
    [FLGlobalSettings sharedInstance].settingObj=settingObj;
    
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    [webSeviceApi currentUser:self];
    
}

- (void)currentUserResult:(FLProfile *)me{
    [FLGlobalSettings sharedInstance].current_user_profile=me;
    FLAppDelegate *delegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;//start chat lisn
    [delegate chatListen];
    [HUD hide:YES];
    
    //upload profile pic
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    FLImgObj *imgObj=[[FLImgObj alloc] init];
    imgObj.folder_name=IMAGE_DIRECTORY_PROFILE;
    imgObj.imgData=UIImageJPEGRepresentation(imgProfilePic.image,0.0);
    imgObj.imageName=[NSString stringWithFormat:@"%@.%@",[FLUtil imageNameForUpload:[FLGlobalSettings sharedInstance].current_user_profile.uid],@"jpg"];
    imgObj.imgContentType=@"image/jpeg";
    [webSeviceApi uploadImage:self withImgObj:imgObj];
    
    
    FLRegAddInfoViewController *regAddInfoVC=[[FLRegAddInfoViewController alloc] initWithNibName:@"FLRegAddInfoViewController" bundle:nil];
    [self.navigationController pushViewController:regAddInfoVC animated:YES];
}

//after upload image update image name in profile
- (void)profileImageUploaded:(FLImgObj *)imgObj{
//    FLUserDetail *userDetail=[[FLUserDetail alloc] init];
//    userDetail.imageNameProfile=imgObj.imageName;
//    userDetail.full_name=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
//    userDetail.birth_date=[FLGlobalSettings sharedInstance].current_user_profile.birth_date;
//    self.imgPofilePicName=imgObj.imageName;
//     FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
//    [webSeviceApi profileUpdate:self withUserData:userDetail];

    
    self.imgPofilePicName=imgObj.imageName;
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    //    [webSeviceApi profileUpdate:self withUserData:userDetail];
    [webSeviceApi imageUploadToDir:self withImageName:imgObj.imageName];
}

- (void)profilePicUploaded:(NSString *)str{
    NSLog(@"profileUpdateResult msg %@",str);
    //set image name to current user singleton object
    
    [FLGlobalSettings sharedInstance].current_user_profile.image=[NSString stringWithFormat:@"http://flingoo.s3.amazonaws.com/profiles/%@",self.imgPofilePicName];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PROFILE_PICTURE_UPLOADED
     object:self];
}

/*
 
 -(void)profileUpdateResult:(NSString *)msg
 {
 NSLog(@"profileUpdateResult msg %@",msg);
 //set image name to current user singleton object
 
 [FLGlobalSettings sharedInstance].current_user_profile.image=[NSString stringWithFormat:@"http://flingoo.s3.amazonaws.com/profiles/%@",self.imgPofilePicName];
 
 [[NSNotificationCenter defaultCenter]
 postNotificationName:PROFILE_PICTURE_UPLOADED
 object:self];
 
 //    //temp
 //    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
 //    [webSeviceApi currentUser:self];
 }

 
 */










#pragma mark -
#pragma mark Error Handling

- (void)unknownFailureCall{
    [HUD hide:YES];
    [self showValidationAlert:@"Unknown Error" ];
}

- (void)requestFailCall:(NSString *)errorMsg{
    [HUD hide:YES];
    if (errorMsg) {
        [self showValidationAlert:errorMsg];
    }
}






@end
