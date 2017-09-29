//
//  FLRegAddInfoViewController.m
//  Flingoo
//
//  Created by Hemal on 11/11/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLRegAddInfoViewController.h"
#import "QuartzCore/CALayer.h"
#import "SlideControllerSubclass.h"
#import "FLUtilUserDefault.h"
#import "FLProfile.h"
#import "FLGlobalSettings.h"
#import "BaseViewController.h"

@interface FLRegAddInfoViewController ()

@end

@implementation FLRegAddInfoViewController

@synthesize sliderAge;






#pragma mark - Initializing

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
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
#pragma mark view lifecycle

- (void) viewDidLoad{
    [super viewDidLoad];

    if (IS_IPHONE5)
    {
        NSString *fileLocation = [[NSBundle mainBundle] pathForResource:@"Bg_h568@2x" ofType:@"png"];
        imgBg.image = [UIImage imageWithContentsOfFile:fileLocation];
    }
    
    //set navigationbar image
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *navImage = [UIImage imageNamed:@"navigationbar.png"];
    [navBar setBackgroundImage:navImage  forBarMetrics:UIBarMetricsDefault];
    
    //set navigationbar back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(back:)];
 
    self.navigationItem.rightBarButtonItem = [FLUtil barButtonWithImage:[UIImage imageNamed:@"finish_btn.png"] target:self action:@selector(finish:)];
    
    self.navigationItem.title = @"Sign Up";
    

    [self configureLabelSlider];
    
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    [super viewWillAppear:YES];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateSliderLabels];

    
}











#pragma mark -
#pragma mark Actions

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)finish:(id)sender{

   gender=nil;
    if (btnImMale.isSelected) {
        gender=@"male";
    }
    else if(btnImFemale.isSelected)
    {
        gender=@"female";
    }
    
    lookingFor=nil;
    
    if (btnLookingMen.isSelected)
    {
        lookingFor=@"male";
    }
    else if (btnLookingWomen.isSelected)
    {
        lookingFor=@"women";
    }
    else if(btnLookingBoth.isSelected)
    {
        lookingFor=@"both";
    }
    
    whoLookingFor=nil;
    if (btnWhoAreMen.isSelected)
    {
        whoLookingFor=@"male";
    }
    else if (btnWhoAreWomen.isSelected)
    {
        whoLookingFor=@"women";
    }
    else if(btnWhoAreBoth)
    {
        whoLookingFor=@"both";
    }
    
    lookingAgeMin=sliderAge.minimumValue;
    lookingAgeMax=sliderAge.maximumValue;
    
//    [FLUtilUserDefault setGender:gender];
//    [FLUtilUserDefault setLookingFor:lookingFor];
//    [FLUtilUserDefault setWhoAreLookingFor:whoLookingFor];
//    [FLUtilUserDefault setLookingAgeMin:lookingAgeMin];
//    [FLUtilUserDefault setLookingAgeMax:lookingAgeMax];
   
    //////////////////
//    SlideControllerSubclass *slideController = [[SlideControllerSubclass alloc] init];
//    [self presentViewController:slideController animated:YES completion:nil];
    
    ///////////////////////////
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    // Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    HUD.delegate = self;
    HUD.labelText = @"Connecting";
    [HUD show:YES];

    
    FLUserDetail *userData=[[FLUserDetail alloc] init];
    if (gender!=nil) {
        userData.gender=gender;
    }
    if (lookingFor!=nil) {
        userData.looking_for=lookingFor;
    }
    if (whoLookingFor!=nil) {
        userData.who_looking_for=whoLookingFor;
    }
    userData.full_name=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
    userData.birth_date=[FLGlobalSettings sharedInstance].current_user_profile.birth_date;
    
    userData.looking_for_age_min=[NSNumber numberWithFloat:self.sliderAge.lowerValue];
    
    userData.looking_for_age_max=[NSNumber numberWithFloat:self.sliderAge.upperValue];
    
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi profileUpdate:self withUserData:userData];
    

}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender{
    [self updateSliderLabels];
}

- (IBAction)imClicked:(id)sender{
    if ([sender tag]==1)
    {
        if (!imMale) {
            imMale=!imMale;
            [btnImMale setSelected:imMale];
            if (imFemale)
            {
                imFemale=!imFemale;
                [btnImFemale setSelected:imFemale];
            }
        }
    }
    else
    {
        if (!imFemale) {
            imFemale=!imFemale;
            [btnImFemale setSelected:imFemale];
            if (imMale)
            {
                imMale=!imMale;
                [btnImMale setSelected:imMale];
            }
            
        }
    }
}

- (IBAction)lookingForClicked:(id)sender{
    if ([sender tag]==3)
    {
        if (!lookingMen) {
            lookingMen=!lookingMen;
            [btnLookingMen setSelected:lookingMen];
            if (lookingWomen)
            {
                lookingWomen=!lookingWomen;
                [btnLookingWomen setSelected:lookingWomen];
            }
            else if(lookingBoth)
            {
                lookingBoth=!lookingBoth;
                [btnLookingBoth setSelected:lookingBoth];
            }
        }
    }
    else if([sender tag]==4)
    {
        if (!lookingWomen) {
            lookingWomen=!lookingWomen;
            [btnLookingWomen setSelected:lookingWomen];
            if (lookingMen)
            {
                lookingMen=!lookingMen;
                [btnLookingMen setSelected:lookingMen];
            }
            else if(lookingBoth)
            {
                lookingBoth=!lookingBoth;
                [btnLookingBoth setSelected:lookingBoth];
            }
        }
    }
    else
    {
        if (!lookingBoth) {
            lookingBoth=!lookingBoth;
            [btnLookingBoth setSelected:lookingBoth];
            if (lookingMen)
            {
                lookingMen=!lookingMen;
                [btnLookingMen setSelected:lookingMen];
            }
            else if(lookingWomen)
            {
                lookingWomen=!lookingWomen;
                [btnLookingWomen setSelected:lookingWomen];
            }
        }
    }
}

- (IBAction)whoAreClicked:(id)sender{
    if ([sender tag]==6)
    {
        if (!whoAreMen) {
            whoAreMen=!whoAreMen;
            [btnWhoAreMen setSelected:whoAreMen];
            if (whoAreWomen)
            {
                whoAreWomen=!whoAreWomen;
                [btnWhoAreWomen setSelected:whoAreWomen];
            }
            else if(whoAreBoth)
            {
                whoAreBoth=!whoAreBoth;
                [btnWhoAreBoth setSelected:whoAreBoth];
            }
        }
    }
    else if([sender tag]==7)
    {
        if (!whoAreWomen) {
            whoAreWomen=!whoAreWomen;
            [btnWhoAreWomen setSelected:whoAreWomen];
            if (whoAreMen)
            {
                whoAreMen=!whoAreMen;
                [btnWhoAreMen setSelected:whoAreMen];
            }
            else if(whoAreBoth)
            {
                whoAreBoth=!whoAreBoth;
                [btnWhoAreBoth setSelected:whoAreBoth];
            }
        }
    }
    else
    {
        if (!whoAreBoth) {
            whoAreBoth=!whoAreBoth;
            [btnWhoAreBoth setSelected:whoAreBoth];
            if (whoAreMen)
            {
                whoAreMen=!whoAreMen;
                [btnWhoAreMen setSelected:whoAreMen];
            }
            else if(whoAreWomen)
            {
                whoAreWomen=!whoAreWomen;
                [btnWhoAreWomen setSelected:whoAreWomen];
            }
        }
    }
}











#pragma mark -
#pragma mark slider

- (void) configureLabelSlider{
    self.sliderAge.minimumValue = 0;
    self.sliderAge.maximumValue = 43;
    
    self.sliderAge.lowerValue = 0;
    self.sliderAge.upperValue = 43;
    
    self.sliderAge.minimumRange = 1;
}

- (void) updateSliderLabels{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.sliderAge.lowerCenter.x + self.sliderAge.frame.origin.x);
    lowerCenter.y = (self.sliderAge.center.y - 30.0f);
        self.lowerLabel.center = lowerCenter;
        self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.sliderAge.lowerValue+17];
    
    CGPoint upperCenter;
    upperCenter.x = (self.sliderAge.upperCenter.x + self.sliderAge.frame.origin.x);
    upperCenter.y = (self.sliderAge.center.y - 30.0f);
    
        self.upperLabel.center = upperCenter;
        self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.sliderAge.upperValue+17];
}











#pragma mark - Webservice Api

- (void) profileUpdateResult:(NSString *)msg{
    if (gender!=nil) {
        [FLGlobalSettings sharedInstance].current_user_profile.gender=gender;
    }
    if (lookingFor!=nil) {
        [FLGlobalSettings sharedInstance].current_user_profile.looking_for=lookingFor;
    }
    if (whoLookingFor!=nil) {
        [FLGlobalSettings sharedInstance].current_user_profile.who_looking_for=whoLookingFor;
    }
    [FLGlobalSettings sharedInstance].current_user_profile.looking_for_age_max=[NSNumber numberWithFloat:self.sliderAge.upperValue];
    
    [FLGlobalSettings sharedInstance].current_user_profile.looking_for_age_min=[NSNumber numberWithFloat:self.sliderAge.lowerValue];
    
    [HUD hide:YES];
    
    if(IS_IPHONE){
        SlideControllerSubclass *slideController = [[SlideControllerSubclass alloc] init];
        [self presentViewController:slideController animated:YES completion:nil];
    }else{
        BaseViewController *baseViewController =[[BaseViewController alloc] initWithNibName:@"BaseViewController" bundle:nil];
        [self presentViewController:baseViewController animated:YES completion:nil];
    }
}











#pragma mark - Webservice Api Error

- (void) unknownFailureCall{
    [HUD hide:YES];
    [self showValidationAlert:@"Unknown Error" ];
}

- (void) requestFailCall:(NSString *)errorMsg{
    [HUD hide:YES];
    [self showValidationAlert:errorMsg];
}











#pragma mark -
#pragma mark Util methods

- (void)showValidationAlert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil)otherButtonTitles:nil, nil];
    [alert show];
}










#pragma mark - Other

- (void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
