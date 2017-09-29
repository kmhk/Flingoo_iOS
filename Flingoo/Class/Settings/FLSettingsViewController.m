//
//  FLSettingsViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLSettingsViewController.h"
#import "FLEditProfileViewController.h"
#import "FLInvitationCodeViewController.h"
#import "FLNotificationSettingsViewController.h"
#import "FLBlockedPeopleViewController.h"
#import "FLGlobalSettings.h"
#import "FLSetting.h"
#import "Config.h"

@interface FLSettingsViewController ()

@property(weak, nonatomic) IBOutlet UISwitch *facebook;
@property(weak, nonatomic) IBOutlet UISwitch *radar;
@property(weak, nonatomic) IBOutlet UISwitch *message;
@property(weak, nonatomic) IBOutlet UISwitch *ghostMode;
@property(weak, nonatomic) IBOutlet UISwitch *highlighter;
@property(weak, nonatomic) IBOutlet UISwitch *locationTracking;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UIView *content;


@end

@implementation FLSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil launchMode:(SettingsLaunchMode) launchMode;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _launchMode = launchMode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //switches
    
    self.facebook.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.radar.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.message.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.ghostMode.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.highlighter.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.locationTracking.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
//    USER_SETTING_LIST {
//        facebook = 1;
//        "ghost_mode" = 1;
//        highlighted = 1;
//        "location_tracking" = 1;
//        messages = 1;
//        radar = 1;
//    }
    
    [self.facebook setOn:[FLGlobalSettings sharedInstance].settingObj.facebook];
    [self.radar setOn:[FLGlobalSettings sharedInstance].settingObj.radar];
    [self.message setOn:[FLGlobalSettings sharedInstance].settingObj.messages];
    [self.ghostMode setOn:[FLGlobalSettings sharedInstance].settingObj.ghost_mode];
    [self.highlighter setOn:[FLGlobalSettings sharedInstance].settingObj.highlighted];
    [self.locationTracking setOn:[FLGlobalSettings sharedInstance].settingObj.location_tracking];
    
    
    if(IS_IPHONE){
        [self.scrollView addSubview:self.content];
        [self.scrollView setContentSize:self.content.frame.size];
    }
    
    
    self.navigationItem.title = @"Settings";

    
    
    
    if(self.launchMode==kSettingsLaunchModeWheel){
        //back button
        self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    }
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
    if(IS_IPAD){
        self.navigationController.navigationBarHidden = YES;
    }
    
}

-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:YES];
//    
//    if (self.tempSettingObj.facebook!=self.facebook.isOn)
//    {
//        
//    }
//    if (self.tempSettingObj.radar!=self.radar.isOn)
//    {
//        
//    }
//    if (self.tempSettingObj.messages!=self.message.isOn)
//    {
//        
//    }
//    if (self.tempSettingObj.ghost_mode!=self.ghostMode.isOn)
//    {
//        
//    }
//    if (self.tempSettingObj.highlighted!=self.highlighter.isOn)
//    {
//        
//    }
//    if (self.tempSettingObj.location_tracking!=self.locationTracking.isOn)
//    {
//        
//    }
//    
////    HUD=[[MBProgressHUD alloc] initWithView:self.view];
////    [self.view addSubview:HUD];
////    HUD.dimBackground = YES;
////    // Set the hud to display with a color
////    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
////    HUD.delegate = self;
////    HUD.labelText = @"Loading...";
////    HUD.square = YES;
////    [HUD show:YES];
//    
//    
//}

-(void) goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark - button actions


-(IBAction) editMyProfileButtonPressed:(id)sender;{
    
    if (!editProfileViewController) {
        editProfileViewController = [[FLEditProfileViewController alloc] initWithNibName:(IS_IPAD)?@"FLEditProfileViewController-iPad":(IS_IPHONE_5)?@"FLEditProfileViewController-568h":@"FLEditProfileViewController" bundle:nil];
    }
    
    if(IS_IPAD){
        NSDictionary *dict = @{RemoteAction:kShowRightBackButton};
        self.communicator(dict);
        __block FLSettingsViewController *settings = self;
        [editProfileViewController setCommunicator:^(NSDictionary *dict){
            NSString *command = [dict objectForKey:RemoteAction];
            if([command isEqualToString:kHideRightBackButton]){
                NSDictionary *dict = @{RemoteAction:kHideRightBackButton};
                settings.communicator(dict);
            }
        }];
    }
    
    [self.navigationController pushViewController:editProfileViewController animated:YES];
}






-(IBAction) invitationCodeButtonPressed:(id)sender;{
    
    FLInvitationCodeViewController *inviation = [[FLInvitationCodeViewController alloc] initWithNibName:(IS_IPAD)?@"FLInvitationCodeViewController-iPad":((IS_IPHONE5)?@"FLInvitationCodeViewController-568h":@"FLInvitationCodeViewController") bundle:nil];
    
    if(IS_IPAD){
        NSDictionary *dict = @{RemoteAction:kShowRightBackButton};
        self.communicator(dict);
        __block FLSettingsViewController *settings = self;
        
        [inviation setCommunicator:^(NSDictionary *dict){
            NSString *command = [dict objectForKey:RemoteAction];
            if([command isEqualToString:kHideRightBackButton]){
                NSDictionary *dict = @{RemoteAction:kHideRightBackButton};
                settings.communicator(dict);
            }
        }];
    }
    
    [self.navigationController pushViewController:inviation animated:YES];
    
}






-(IBAction) notificationButtonPressed:(id)sender;{
    
    FLNotificationSettingsViewController *notification = [[FLNotificationSettingsViewController alloc] initWithNibName:(IS_IPAD)?@"FLNotificationSettingsViewController-iPad":(IS_IPHONE5)?@"FLNotificationSettingsViewController-568h":@"FLNotificationSettingsViewController" bundle:nil];
    
    if(IS_IPAD){
        NSDictionary *dict = @{RemoteAction:kShowRightBackButton};
        self.communicator(dict);
        __block FLSettingsViewController *settings = self;
        
        [notification setCommunicator:^(NSDictionary *dict){
            NSString *command = [dict objectForKey:RemoteAction];
            if([command isEqualToString:kHideRightBackButton]){
                NSDictionary *dict = @{RemoteAction:kHideRightBackButton};
                settings.communicator(dict);
            }
        }];
    }
    
    [self.navigationController pushViewController:notification animated:YES];
}






-(IBAction) blockedPeopleButtonPressed:(id)sender;{
    
    FLBlockedPeopleViewController *blockedeopleViewController = [[FLBlockedPeopleViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLBlockedPeopleViewController-568h":@"FLBlockedPeopleViewController" bundle:nil];
    
    if(IS_IPAD){
        NSDictionary *dict = @{RemoteAction:kShowRightBackButton};
        self.communicator(dict);
        
        __block FLSettingsViewController *settings = self;
        
        [blockedeopleViewController setCommunicator:^(NSDictionary *dict){
            NSString *command = [dict objectForKey:RemoteAction];
            if([command isEqualToString:kHideRightBackButton]){
                NSDictionary *dict = @{RemoteAction:kHideRightBackButton};
                settings.communicator(dict);
            }
        }];
    }
    
    [self.navigationController pushViewController:blockedeopleViewController animated:YES];
}






-(IBAction) helpButtonPressed:(id)sender;{
    
}

-(IBAction) aboutUsButtonPressed:(id)sender;{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Webservice api delegate method

-(void)settingsUpdatedResult:(NSString *)key:(NSNumber *)value
{
    NSLog(@"settingsUpdatedResult key %@ value %@",key,value);
    
    if ([key isEqualToString:@"facebook"]) {
        [FLGlobalSettings sharedInstance].settingObj.facebook=[value boolValue];
    }
    else if ([key isEqualToString:@"ghost_mode"])
    {
        [FLGlobalSettings sharedInstance].settingObj.ghost_mode=[value boolValue];
        
    }
    else if ([key isEqualToString:@"highlighted"])
    {
         [FLGlobalSettings sharedInstance].settingObj.highlighted=[value boolValue];
    }
    else if ([key isEqualToString:@"location_tracking"])
    {
         [FLGlobalSettings sharedInstance].settingObj.location_tracking=[value boolValue];
    }
    else if ([key isEqualToString:@"messages"])
    {
          [FLGlobalSettings sharedInstance].settingObj.messages=[value boolValue];
    }
    else if ([key isEqualToString:@"radar"])
    {
        [FLGlobalSettings sharedInstance].settingObj.radar=[value boolValue];
    }
    NSDictionary* setting_changed_dict =@{key : value};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SETTING_CHANGED
                                                        object:self
                                                      userInfo:setting_changed_dict];
    
}

#pragma mark- FLWebServiceDelegate Fail
#pragma mark-

-(void)unknownFailureCall
{
    [self showValidationAlert:@"Unknown Error"];
}

-(void)requestFailCall:(NSString *)errorMsg
{
    [self showValidationAlert:errorMsg];
}

-(void)showValidationAlert:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark -
#pragma mark - Action method

- (IBAction)facebookSwitchClicked:(id)sender {
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService settingUpdate:self withKey:@"facebook" withValue:[NSNumber numberWithBool:self.facebook.isOn]];
}

- (IBAction)radarSwitchClicked:(id)sender {
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService settingUpdate:self withKey:@"radar" withValue:[NSNumber numberWithBool:self.radar.isOn]];
}

- (IBAction)messageSwitchClicked:(id)sender {
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService settingUpdate:self withKey:@"messages" withValue:[NSNumber numberWithBool:self.message.isOn]];
}

- (IBAction)ghostModeSwitchClicked:(id)sender {
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService settingUpdate:self withKey:@"ghost_mode" withValue:[NSNumber numberWithBool:self.ghostMode.isOn]];
}

- (IBAction)highlitenSwitchClicked:(id)sender {
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService settingUpdate:self withKey:@"highlighted" withValue:[NSNumber numberWithBool:self.highlighter.isOn]];
}

- (IBAction)locationTracingSwitchClicked:(id)sender {
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService settingUpdate:self withKey:@"location_tracking" withValue:[NSNumber numberWithBool:self.locationTracking.isOn]];
}


@end
