//
//  FLSighInViewController.m
//  Flingoo
//
//  Created by Hemal on 11/11/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLSighInViewController.h"
#import "FLForgotPasswordViewController.h"
#import "FLUtilValidation.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Config.h"
#import "FLRegAddInfoViewController.h"
#import "FLGlobalSettings.h"
#import "SlideControllerSubclass.h"
#import "FLUser.h"
#import "FLTempVCViewController.h"
#import "FLUtilUserDefault.h"
#import "FLAppDelegate.h"
#import "BaseViewController.h"
#import "FLGlobalSettings.h"
#import "FLUtil.h"

@interface FLSighInViewController ()
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@property (nonatomic, retain) NSString *imgPofilePicName;
@end

@implementation FLSighInViewController









#pragma mark - Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    NSString *nib;
    if (IS_IPAD)
    {
        nib=[NSString stringWithFormat:@"%@-iPad",nibNameOrNil];
    }else if(IS_IPHONE5)
    {
        nib=[NSString stringWithFormat:@"%@-568h",nibNameOrNil];
    }
    else
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
#pragma mark view lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;

    [self.navigationItem setLeftBarButtonItem:[FLUtil backBarButtonWithTarget:self action:@selector(back:)]];
    [self.navigationItem setRightBarButtonItem:[FLUtil signInBarButtonWithTarget:self action:@selector(signinClicked:)]];
    
    self.navigationItem.title = @"Sign In";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}











#pragma mark -
#pragma mark Util methods

- (void)showValidationAlert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil)otherButtonTitles:nil, nil];
    [alert show];
}











#pragma mark -
#pragma mark Actions

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signinClicked:sender{
    [self.view endEditing:YES];
    if ([txtFieldEmail.text length]==0)
    {
        [self showValidationAlert:@"Email cannot be empty"];
        return;
    }
    else if(![FLUtilValidation validateEmail:txtFieldEmail.text])
    {
        [self showValidationAlert:@"Email is invalid"];
        return;
    }
    else if (![FLUtilValidation validatePassword:txtFieldPassword.text])
    {
        [self showValidationAlert:@"Password should be minimum 6 characters"];
        return;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Connecting";
    [HUD show:YES];
    
    NSDictionary *userDataDic = @{
    @"email" : txtFieldEmail.text,
    @"password" :txtFieldPassword.text
    };
    
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    [webSeviceApi signinUser:self withUserData:userDataDic];

    
//    //hemalasankas
//    SlideControllerSubclass *slideController = [[SlideControllerSubclass alloc] init];
//     [self presentViewController:slideController animated:YES completion:nil];
    
}

- (IBAction)forgotPasswordClicked:(id)sender{
    FLForgotPasswordViewController *forgotPwordViewCon=[[FLForgotPasswordViewController alloc] initWithNibName:@"FLForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgotPwordViewCon animated:YES];
}

- (IBAction)loginWithFbClicked:(id)sender{
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Connecting";
    [HUD show:YES];
    [self getUser];
}











#pragma mark -
#pragma mark Facecbook

- (void)getUser {
    
	if(!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookTypeAccount = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    [_accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                           options:@{ACFacebookAppIdKey:FACEBOOK_APP_KEY, ACFacebookPermissionsKey: @[@"email",@"user_relationships"]}
                                        completion:^(BOOL granted, NSError *error) {
                                            if(granted){
                                                NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
                                                _facebookAccount = [accounts lastObject];
                                                NSLog(@"Success");
                                                [self me];
                                                
                                            }else{
                                                // ouch
                                                
                                                HUD.labelText = @"Connecting fail";
                                                NSLog(@"Error: %@", error);
                                                [self performSelectorOnMainThread:@selector(showOtherError:) withObject:[NSNumber numberWithInt:[error code]] waitUntilDone:NO];
                                            }
                                        }];
    
}

- (void)me{
    
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:meurl parameters:nil];
    
    merequest.account = _facebookAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString *meDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        //        [HUD hide:YES];
        //        NSLog(@"%@", meDataString);
        
        //        [HUD hide:YES];
        
        //////////////////////////////////////////////////////////////////////////////
        
        NSData *JSONData = [meDataString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:JSONData
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"username %@", [json objectForKey:@"username"]);
        
//                NSDictionary *userDataDic = @{
//                @"email" : [json objectForKey:@"email"],
//                @"password":@"123456",
//                @"full_name": [json objectForKey:@"name"],
//                @"birth_date": [json objectForKey:@"birthday"]
//                };
        
        //        NSDictionary *userDataDic = @{
        //        @"email" : @"testuser2@gmail.com",
        //        @"password":@"24232423",
        //        @"full_name": @"Test User111",
        //        @"mobile_number": @"0775328568",//they not gave contact no
        //        @"birth_date": [json objectForKey:@"birthday"]
        //        };
        
//        NSDictionary *userDataDic = @{
//        @"email" : @"testuser8@gmail.com",
//        @"password":@"123123",
//        @"full_name": @"Test User111",
//        @"birth_date": [json objectForKey:@"birthday"]
//        };
//        
//        FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
//        [webSeviceApi createUser:self withUserData:userDataDic];
        //hemalasanlas****
//        NSDictionary *dicRwmp=[json objectForKey:@"location"];
//        [FLGlobalSettings sharedInstance].tempAddress=[dicRwmp objectForKey:@"name"] ;
//         NSLog(@"aaaaa %@", [FLGlobalSettings sharedInstance].tempAddress);
//         [FLUtilUserDefault setTempUserAddress:[FLGlobalSettings sharedInstance].tempAddress];
        
//        NSDictionary *userDataDic = @{
//        @"email" : [json objectForKey:@"email"],
//        @"uid":[json objectForKey:@"id"],
//        @"access_token": [json objectForKey:@"id"]
//        };
//
//               NSDictionary *userDataDic = @{
//               @"email" : @"email1555@gmail.com",
//               @"uid":@"aadasfdsfdsaewresafdsaf",
//               @"access_token": @"aadasfdsfdsaewresafdsaf"
//               };
        
//        NSDictionary *userDataDic = @{
//        @"email" : @"uf50test1@gmail.com",
//        @"uid":@"uf50test1@gmail.com",
//        @"access_token":@"uf50test1@gmail.com",
//        @"full_name": @"uf50test1",
//        @"birth_date": @"1980-10-15"
//        };
        
        facebookToken=[json objectForKey:@"id"];
        
        NSDictionary *userDataDic = @{
        @"email" : [json objectForKey:@"email"],
        @"uid":[json objectForKey:@"id"],
        @"access_token": [json objectForKey:@"id"],
        @"full_name": [json objectForKey:@"name"],
        @"birth_date": [json objectForKey:@"birthday"]
        };

        
        FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
        //        [webSeviceApi createUser:self withUserData:userDataDic];
        [webSeviceApi createUserFB:self withUserData:userDataDic];
       //response is signinUserResult
        
        
          //set temporary
//        [FLUtilUserDefault setTempUserFullName:[json objectForKey:@"name"]];
    }
     ];
}











#pragma mark -
#pragma mark error handling

- (void)showOtherError:(NSNumber*)error{
    /*
     * if error code is '6', that means user has not configured the Facebook in device.
     * if error code is '7', that means user has denied the access
     * if error code is '0', that means user has turned off the access to facebook
     */
    NSLog(@"error %d", [error intValue]);
    //    [HUD hide:YES afterDelay:0.4];
    [HUD hide:YES];
    switch ([error intValue]) {
        case 6:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"faceBook_not_configured", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            
            [alert show];
            break;
        }
            
        case 7:{
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"faceBook_access_denied", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            
            [alert show];
            break;
        }
            
        case 0:{
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"turn_on_the_facebook", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            
            [alert show];
            break;
        }
            
        default:
            break;
    }
}











#pragma mark -
#pragma mark textfield delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(txtFieldEmail.text.length > 0 && txtFieldPassword.text.length >0){
        [self.view endEditing:YES];
        if ([txtFieldEmail.text length]==0)
        {
            [self showValidationAlert:@"Email cannot be empty"];
            return NO;
        }
        else if(![FLUtilValidation validateEmail:txtFieldEmail.text])
        {
            [self showValidationAlert:@"Email is invalid"];
            return NO;
        }
        else if (![FLUtilValidation validatePassword:txtFieldPassword.text])
        {
            [self showValidationAlert:@"Password should be minimum 6 characters"];
            return NO;
        }
        
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        // Set the hud to display with a color
        //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        HUD.delegate = self;
        HUD.labelText = @"Connecting";
        [HUD show:YES];
        
        NSDictionary *userDataDic = @{
                                      @"email" : txtFieldEmail.text,
                                      @"password" :txtFieldPassword.text
                                      };
        
        FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
        [webSeviceApi signinUser:self withUserData:userDataDic];
        return YES;
    }
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}











#pragma mark -
#pragma mark webservice api methods

//signin form username & password and fb
- (void) signinUserResult:(FLUser *)current_user{
    
    NSLog(@"current_user.auth_token %@",current_user.auth_token);
//    [FLUtilUserDefault setAuthToken:current_user.auth_token];
    [FLGlobalSettings sharedInstance].current_user=current_user;
    FLAppDelegate *delegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate heartBeatCall];
    
    [FLUtilUserDefault setUsername:txtFieldEmail.text];
    [FLUtilUserDefault setPassword:txtFieldPassword.text];
    
    
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService getUserSettingsList:self];

}

- (void) userSettingListResult:(FLSetting *)settingObj{
    
    [FLGlobalSettings sharedInstance].settingObj = settingObj;
   
    FLWebServiceApi *webSeviceApi = [[FLWebServiceApi alloc] init];
    [webSeviceApi currentUser:self];
    
}

- (void) currentUserResult:(FLProfile *)me{
    
    [FLGlobalSettings sharedInstance].current_user_profile=me;
    FLAppDelegate *delegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate chatListen];
    [HUD hide:YES];
    
    ////////////////////////////////////////////
    if ([me.image isEqualToString:DEFUALT_PROFILE_PIC_URL] || [me.image isEqualToString:@""]) {
    //upload profile pic
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    FLImgObj *imgObj=[[FLImgObj alloc] init];
    imgObj.folder_name=IMAGE_DIRECTORY_PROFILE;
    
    UIImage* imgProfilePic = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=360&height=360",facebookToken]]]];
    imgObj.imgData=UIImageJPEGRepresentation(imgProfilePic,0.0);
    imgObj.imageName=[NSString stringWithFormat:@"%@.%@",[FLUtil imageNameForUpload:[FLGlobalSettings sharedInstance].current_user_profile.uid],@"jpg"];
    imgObj.imgContentType=@"image/jpeg";
    [webSeviceApi uploadImage:self withImgObj:imgObj];
    }
    ////////////////////////////////////////////
    

////    //hemalasankas** add age graterthan and lessthan to check in if statement
    if ([me.gender length]==0 || [me.who_looking_for length]==0 || [me.looking_for length]==0) {//if not added additional information redirect that view
        UIViewController *regAddVC;
        regAddVC=[[FLRegAddInfoViewController alloc] initWithNibName:@"FLRegAddInfoViewController" bundle:nil];
        
        UINavigationController *naviCon=[[UINavigationController alloc] initWithRootViewController:regAddVC];
        
        naviCon.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:naviCon animated:YES completion:nil];
    }
    else
    {
        if(IS_IPHONE){
            SlideControllerSubclass *slideController = [[SlideControllerSubclass alloc] init];
            [self presentViewController:slideController animated:YES completion:nil];
        }else{
            BaseViewController *baseViewController =[[BaseViewController alloc] initWithNibName:@"BaseViewController" bundle:nil];
            [self presentViewController:baseViewController animated:YES completion:nil];
        }
    }
//
    ////    //hemalasankas
//    FLTempVCViewController *tempView=[[FLTempVCViewController alloc] initWithNibName:@"FLTempVCViewController" bundle:nil];
//    [self.navigationController pushViewController:tempView animated:NO];

}

/*
 
 //create user form facebook email
 -(void)createUserResult:(FLUser *)current_user
 {
 NSLog(@"current_user.auth_token %@",current_user.auth_token);
 //    [FLUtilUserDefault setAuthToken:current_user.auth_token];
 [FLGlobalSettings sharedInstance].current_user=current_user;
 
 FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
 [webService getUserSettingsList:self];
 //    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
 //    [webSeviceApi currentUser:self];
 }

 
 */

//after upload image update image name in profile
- (void) profileImageUploaded:(FLImgObj *)imgObj{
    
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

- (void) profilePicUploaded:(NSString *)str{
    
    
    NSLog(@"profileUpdateResult msg %@",str);
    //set image name to current user singleton object
    
    [FLGlobalSettings sharedInstance].current_user_profile.image=[NSString stringWithFormat:@"%@profiles/%@",UNWANTED_IMG_URL_PART,self.imgPofilePicName];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PROFILE_PICTURE_UPLOADED
     object:self];
}

- (void) unknownFailureCall{
    [HUD hide:YES];
    [self showValidationAlert:@"Unknown Error" ];
}

- (void) requestFailCall:(NSString *)errorMsg{
    [HUD hide:YES];
    [self showValidationAlert:errorMsg];
}










#pragma mark - Other

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
