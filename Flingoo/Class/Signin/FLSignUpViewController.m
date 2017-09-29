//
//  FLSignUpViewController.m
//  Flingoo
//
//  Created by Hemal on 11/10/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLSignUpViewController.h"
#import "FLRegAddInfoViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Config.h"
#import "FLSignUpEmailViewController.h"
#import "FLSighInViewController.h"
#import "FLGlobalSettings.h"
#import "FLUtilUserDefault.h"
#import "FLAppDelegate.h"
#import "SlideControllerSubclass.h"
#import "BaseViewController.h"
#import "FLGlobalSettings.h"

@interface FLSignUpViewController ()

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@property (nonatomic, retain) NSString *imgPofilePicName;

@end

@implementation FLSignUpViewController









#pragma mark - Initialization

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

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    [super viewWillAppear:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if (IS_IPHONE5)
    {
        NSString *fileLocation = [[NSBundle mainBundle] pathForResource:@"RadarBg-h568@2x" ofType:@"png"];
        imgBg.image = [UIImage imageWithContentsOfFile:fileLocation];
    }
    
}











#pragma mark -
#pragma mark Actions

- (IBAction)loginWithFB:(id)sender{
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Connecting";
    [HUD show:YES];
    [self getUser];
}

- (IBAction)registerWithEmail:(id)sender{
    FLSignUpEmailViewController *signUpwithEmail=[[FLSignUpEmailViewController alloc] initWithNibName:@"FLSignUpEmailViewController" bundle:nil];
    [self.navigationController pushViewController:signUpwithEmail animated:YES];
}

- (IBAction)signInNow:(id)sender{
    FLSighInViewController *signInViewCon=[[FLSighInViewController alloc] initWithNibName:@"FLSighInViewController" bundle:nil];
    [self.navigationController pushViewController:signInViewCon animated:YES];
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
        
        NSLog(@"JSONDataJSONData %@", json);
 

        //hemalasankas**
        NSDictionary *dicRwmp=[json objectForKey:@"location"];
        [FLGlobalSettings sharedInstance].tempAddress=[dicRwmp objectForKey:@"name"];
        
         [FLUtilUserDefault setTempUserAddress:[FLGlobalSettings sharedInstance].tempAddress];
        
//        1524429770
//        NSDictionary *userDataDic = @{
//        @"email" : [json objectForKey:@"email"],
//        @"uid":[json objectForKey:@"id"],
//        @"access_token": [json objectForKey:@"id"],
//        @"full_name": [json objectForKey:@"name"],
//        @"birth_date": [json objectForKey:@"birthday"]
//        };
        
        NSLog(@"ididid%@",[json objectForKey:@"id"]);
        
//        NSDictionary *userDataDic = @{
//        @"email" : @"uf40@gmail.com",
//        @"uid":@"uf40gmailcom",
//        @"access_token":@"uf40gmailcom",
//        @"full_name": @"uf40",
//        @"birth_date": @"1980-10-15"
//        };
        
//        NSDictionary *userDataDic = @{
//        @"email" : @"uf50test2@gmail.com",
//        @"uid":@"uf50test2@gmail.com",
//        @"access_token":@"uf50test2@gmail.com",
//        @"full_name": @"uf50test2",
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
         [webSeviceApi createUserFB:self withUserData:userDataDic];
     
    }
     ];
    
}











#pragma mark -
#pragma mark WebService delegate methods
/*
 
 {
 //-(void)createUserResult:(FLUser *)current_user
 //{
 //    NSLog(@"current_user.auth_token %@",current_user.auth_token);
 ////    [FLUtilUserDefault setAuthToken:current_user.auth_token];
 //    [FLGlobalSettings sharedInstance].current_user=current_user;
 //    [HUD hide:YES];
 //
 //    FLRegAddInfoViewController *regAddInfoVC=[[FLRegAddInfoViewController alloc] initWithNibName:@"FLRegAddInfoViewController" bundle:nil];
 //    [self.navigationController pushViewController:regAddInfoVC animated:YES];
 //
 //}
 }
 
 */


//signin form username & password and fb
-(void)signinUserResult:(FLUser *)current_user{
    NSLog(@"current_user.auth_token %@",current_user.auth_token);
    //    [FLUtilUserDefault setAuthToken:current_user.auth_token];
    [FLGlobalSettings sharedInstance].current_user=current_user;
    FLAppDelegate *delegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate heartBeatCall];
//    [FLUtilUserDefault setUsername:txtFieldEmail.text];
//    [FLUtilUserDefault setPassword:txtFieldPassword.text];
    
    
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService getUserSettingsList:self];
}

-(void)userSettingListResult:(FLSetting *)settingObj{
    [FLGlobalSettings sharedInstance].settingObj=settingObj;
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    [webSeviceApi currentUser:self];
}

-(void)currentUserResult:(FLProfile *)me{
    [FLGlobalSettings sharedInstance].current_user_profile=me;
    FLAppDelegate *delegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate chatListen];
    [HUD hide:YES];
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

    
    
    //hemalasankas** add age graterthan and lessthan to check in if statement
    if ([me.gender length]==0 || [me.who_looking_for length]==0 || [me.looking_for length]==0) {//if not added additional information redirect that view
        UIViewController *regAddVC;
        regAddVC=[[FLRegAddInfoViewController alloc] initWithNibName:@"FLRegAddInfoViewController" bundle:nil];
        
        UINavigationController *naviCon=[[UINavigationController alloc] initWithRootViewController:regAddVC];
        
        naviCon.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:naviCon animated:YES completion:nil];
    }
    else{
        if(IS_IPHONE){
            SlideControllerSubclass *slideController = [[SlideControllerSubclass alloc] init];
            [self presentViewController:slideController animated:YES completion:nil];
        }else{
            BaseViewController *baseViewController =[[BaseViewController alloc] initWithNibName:@"BaseViewController" bundle:nil];
            [self presentViewController:baseViewController animated:YES completion:nil];
        }
    }
}

//after upload image update image name in profile
-(void)profileImageUploaded:(FLImgObj *)imgObj{
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

-(void)profilePicUploaded:(NSString *)str{
    NSLog(@"profileUpdateResult msg %@",str);
    //set image name to current user singleton object
    
    [FLGlobalSettings sharedInstance].current_user_profile.image=[NSString stringWithFormat:@"http://flingoo.s3.amazonaws.com/profiles/%@",self.imgPofilePicName];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PROFILE_PICTURE_UPLOADED
     object:self];
}











#pragma mark -
#pragma mark Error handle



-(void)requestFailCall:(NSString *)errorMsg{
        [HUD hide:YES];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:errorMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
        [alert show];
}

-(void)unknownFailureCall{
    [HUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"unknown_error", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}

-(void)showOtherError:(NSNumber*)error{
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

/*
 
 -(void)showError:(BBError)error{
 
 switch (error) {
 case NO_INTERNET:{
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"") message:NSLocalizedString(@"no_internet", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
 
 [alert show];
 
 break;
 }
 
 case SERVER_NOT_REACHABLE:{
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"") message:NSLocalizedString(@"not_reach", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
 
 [alert show];
 
 break;
 }
 
 case UNDEFINED:{
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"") message:NSLocalizedString(@"u_error", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
 
 [alert show];
 
 break;
 }
 
 case DEVICE_INUSE:{
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"") message:NSLocalizedString(@"device_error", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
 
 [alert show];
 
 break;
 }
 
 case EMAIL_INUSE:{
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"") message:NSLocalizedString(@"email_error", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
 
 [alert show];
 
 break;
 }
 
 
 
 default:
 
 NSLog(@"unknown error");
 break;
 }
 }

 
 */









#pragma mark - Others

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
