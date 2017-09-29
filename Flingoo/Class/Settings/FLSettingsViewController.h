//
//  FLSettingsViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "FLEditProfileViewController.h"

typedef enum {
    kSettingsLaunchModeSlider,
    kSettingsLaunchModeWheel
}SettingsLaunchMode;

@interface FLSettingsViewController : FLParentSliderViewController<FLWebServiceDelegate>
{
    FLEditProfileViewController *editProfileViewController;//if not created like that we can't recognize settings is save or not in FLEditProfileViewController view
}

@property(nonatomic, assign) SettingsLaunchMode launchMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil launchMode:(SettingsLaunchMode) launchMode;
- (IBAction)facebookSwitchClicked:(id)sender;
- (IBAction)radarSwitchClicked:(id)sender;
- (IBAction)messageSwitchClicked:(id)sender;
- (IBAction)ghostModeSwitchClicked:(id)sender;
- (IBAction)highlitenSwitchClicked:(id)sender;
- (IBAction)locationTracingSwitchClicked:(id)sender;



@end
