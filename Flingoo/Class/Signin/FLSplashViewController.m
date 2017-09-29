//
//  FLSplashViewController.m
//  Flingoo
//
//  Created by Hemal on 11/11/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLSplashViewController.h"
#import "FLSignUpViewController.h"
#import "FLMe.h"
#import "FLGlobalSettings.h"
#import "SlideControllerSubclass.h"
#import "FLUtilUserDefault.h"
#import "FLUser.h"
#import "BaseViewController.h"
#import "FLAppDelegate.h"
#import "FLGlobalSettings.h"
#import "FLRegAddInfoViewController.h"

@implementation FLSplashViewController





#pragma mark - Initializing 

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










#pragma mark - View Lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    if ([FLUtilUserDefault getUsername]!=nil &&[[FLUtilUserDefault getFBAuthToken] length]>0)
    {
        NSDictionary *userDataDic = @{
        @"email" : [FLUtilUserDefault getUsername],
        @"uid":[FLUtilUserDefault getFBAuthToken],
        @"access_token": [FLUtilUserDefault getFBAuthToken]
        };
        
        FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
        //        [webSeviceApi createUser:self withUserData:userDataDic];
        [webSeviceApi createUserFB:self withUserData:userDataDic];
        
        
        [actIndicatorInitial startAnimating];
        
    }
    
    else if ([FLUtilUserDefault getUsername]!=nil &&[[FLUtilUserDefault getUsername] length]>0)
    {
        NSDictionary *userDataDic = @{
        @"email" : [FLUtilUserDefault getUsername],
        @"password" :[FLUtilUserDefault getPassword]
        };
        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
        [webService signinUser:self withUserData:userDataDic];
        [actIndicatorInitial startAnimating];
    }
    else
    {
//        [self move];
        [self performSelector:@selector(move) withObject:nil afterDelay:1];
    }
    
//    [self performSelector:@selector(move) withObject:nil afterDelay:2];
    
    if(IS_IPHONE_4){
        self.backgroundView.image = [UIImage imageNamed:@"Default.png"];
    }else if(IS_IPHONE_5){
        self.backgroundView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
        CGRect frame = actIndicatorInitial.frame;
        frame.origin.y +=100;
        actIndicatorInitial.frame = frame;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    [self move];
}

- (void)move{
    
    [actIndicatorInitial stopAnimating];
    
    UIViewController *tempVC;
    
        tempVC=[[FLSignUpViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLSignUpViewController-568h":@"FLSignUpViewController" bundle:nil];

    
    
    UINavigationController *naviCon=[[UINavigationController alloc] initWithRootViewController:tempVC];
    
    naviCon.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:naviCon animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testAction:(id)sender{
    FLSignUpViewController *signUpViewCon = [[FLSignUpViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLSignUpViewController-568h":@"FLSignUpViewController" bundle:nil];
    UINavigationController *naviCon=[[UINavigationController alloc] initWithRootViewController:signUpViewCon];
    
    naviCon.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:naviCon animated:YES completion:nil];
    
}











#pragma mark-
#pragma mark- FLWebServiceDelegate methods

//signin form facebook Auth token
- (void) signinUserResult:(FLUser *)current_user {
    NSLog(@"current_user.auth_token %@",current_user.auth_token);
    [FLGlobalSettings sharedInstance].current_user=current_user;
    FLAppDelegate *delegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate heartBeatCall];
    
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService getUserSettingsList:self];
    
  
}

- (void) userSettingListResult:(FLSetting *)settingObj{
    [FLGlobalSettings sharedInstance].settingObj=settingObj;
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    [webSeviceApi currentUser:self];
}

- (void) currentUserResult:(FLProfile *)me{
    [FLGlobalSettings sharedInstance].current_user_profile=me;
    FLAppDelegate *delegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate chatListen];
    [actIndicatorInitial stopAnimating];
    
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











#pragma mark- FLWebServiceDelegate Fail
#pragma mark-

-(void)unknownFailureCall{
    [actIndicatorInitial stopAnimating];
    [self showValidationAlert:@"Unknown Error"];
}

-(void)requestFailCall:(NSString *)errorMsg{
    [self move];
//    [self showValidationAlert:errorMsg];
}

-(void)showValidationAlert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}


@end
