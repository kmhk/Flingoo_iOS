//
//  FLEditProfileViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//


#import "FLEditProfileViewController.h"
#import "FLChangeEmailViewController.h"
#import "FLGlobalSettings.h"
#import "Config.h"
#import "FLChangeMobileNumberViewController.h"
#import "RightPanelViewController.h"
#import "FLChangePasswordViewController.h"

@interface FLEditProfileViewController ()

@property(weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property(weak, nonatomic) IBOutlet UILabel *cityLabel;
@property(weak, nonatomic) IBOutlet UILabel *languagesLabel;

@end

@implementation FLEditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title  = @"Edit Profile";
    
    //back button
    lblName.text=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
    [btnDateofBirth setTitle:[FLGlobalSettings sharedInstance].current_user_profile.birth_date forState:UIControlStateNormal];
    
    //back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    //hemalasankas**
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        //            lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyBest;
        lm.distanceFilter = kCLDistanceFilterNone;
        [lm startUpdatingLocation];
        CLLocation *location = [lm location];
        CLGeocoder *gc = [[CLGeocoder alloc] init];
        [gc reverseGeocodeLocation:location completionHandler:^(NSArray *placemark, NSError *error) {
            CLPlacemark *pm = [placemark objectAtIndex:0];
            NSDictionary *address = pm.addressDictionary;
            NSString*frm = [address valueForKey:@"City"];
            
            NSLog(@"add %@", address);
            NSLog(@"AAA %@", frm);
            if (frm!=nil)
            {
                txtCity.text = frm;
            }
            
        }];
        
        
    }
    
    if(IS_IPAD){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:@"GLOBAL_BACK_BUTTON_PRESSED" object:nil];
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
//    FLUserDetail *userDetailObj;
//    if (![[FLGlobalSettings sharedInstance].current_user_profile.full_name isEqualToString:lblName.text])
//    {
//       userDetailObj =[[FLUserDetail alloc] init];
//        userDetailObj.full_name=lblName.text;
//    }
//    if (![[FLGlobalSettings sharedInstance].current_user_profile.birth_date isEqualToString:btnDateofBirth.titleLabel.text])
//    {
//        if (userDetailObj==nil) {
//            userDetailObj =[[FLUserDetail alloc] init];
//        }
//        userDetailObj.birth_date=btnDateofBirth.titleLabel.text;
//    }
//    
//    
//    if (newPhoneNo && ![[FLGlobalSettings sharedInstance].current_user_profile.mobile_number isEqualToString:newPhoneNo])
//    {
//        if (userDetailObj==nil) {
//            userDetailObj =[[FLUserDetail alloc] init];
//        }
//        userDetailObj.mobile_number=newPhoneNo;
//    }
//    
//    if (userDetailObj!=nil)
//    {
//        HUD=[[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:HUD];
//        HUD.dimBackground = YES;
//        // Set the hud to display with a color
//        //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
//        HUD.delegate = self;
//        HUD.labelText = @"Updating";
//        HUD.square = YES;
//        [HUD show:YES];
//        
//        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
//        [webService profileUpdate:self withUserData:userDetailObj];
//    }
}


-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Button Actions


-(void) goBack
{
    [self.view endEditing:YES];
    if(IS_IPAD){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GLOBAL_BACK_BUTTON_PRESSED" object:nil];
        NSDictionary *dict = @{RemoteAction:kHideRightBackButton};
        self.communicator(dict);
    }
    ////////////////////////////////////////////////////////////////////
    FLUserDetail *userDetailObj;
    if (![[FLGlobalSettings sharedInstance].current_user_profile.full_name isEqualToString:lblName.text])
    {
        userDetailObj =[[FLUserDetail alloc] init];
        userDetailObj.full_name=lblName.text;
    }
    if (![[FLGlobalSettings sharedInstance].current_user_profile.birth_date isEqualToString:btnDateofBirth.titleLabel.text])
    {
        if (userDetailObj==nil) {
            userDetailObj =[[FLUserDetail alloc] init];
        }
        userDetailObj.birth_date=btnDateofBirth.titleLabel.text;
    }
    
    
    if (newPhoneNo && ![[FLGlobalSettings sharedInstance].current_user_profile.mobile_number isEqualToString:newPhoneNo])
    {
        if (userDetailObj==nil) {
            userDetailObj =[[FLUserDetail alloc] init];
        }
        userDetailObj.mobile_number=newPhoneNo;
    }
    
    if (userDetailObj!=nil)
    {
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        // Set the hud to display with a color
        //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        HUD.delegate = self;
        HUD.labelText = @"Updating";
        HUD.square = YES;
        [HUD show:YES];
        
        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
        [webService profileUpdate:self withUserData:userDetailObj];
    }
    else
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
    
    ///////////////////////////////////////////////////////////////////////
//    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(IBAction) dateOfBirthButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    [self createActionSheet];
    select = NO;
    [self createUIDatePicker:sender];
}




-(IBAction) cityButtonPressed:(id)sender;{
    
}

-(IBAction) languagesButtonPressed:(id)sender;{
    
}

-(IBAction) changeEmailButtonPressed:(id)sender;{
    if(IS_IPHONE){
          FLChangeEmailViewController *email = [[FLChangeEmailViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLChangeEmailViewController-568h":@"FLChangeEmailViewController" bundle:nil];
        [self.navigationController pushViewController:email animated:YES];      
    }else{

    }
}

-(IBAction) changeMobileButtonPressed:(id)sender;{
    if(IS_IPHONE){
        FLChangeMobileNumberViewController *email = [[FLChangeMobileNumberViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLChangeMobileNumberViewController-568h":@"FLChangeMobileNumberViewController" bundle:nil];
        email.delegate=self;
        [self.navigationController pushViewController:email animated:YES];
    }else{
        
    }
}

-(IBAction) changePasswordButtonPressed:(id)sender
{
    if(IS_IPHONE){
        FLChangePasswordViewController *changePasswordVC = [[FLChangePasswordViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLChangePasswordViewController-568h":@"FLChangePasswordViewController" bundle:nil];
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    }else{
        
    }
}


-(IBAction) deleteAccountButtonPressed:(id)sender;{
    
}

#pragma mark - Date picker creation 

- (void)createActionSheet {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (actionSheet == nil) {
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
            
            
            UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancel:)];
            
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone:)];
            
            
            [barItems addObject:cancelBtn];
            [barItems addObject:flexSpace];
            [barItems addObject:doneBtn];
            
            [pickerToolbar setItems:barItems animated:YES];
            [actionSheet addSubview:pickerToolbar];
            [actionSheet showInView:self.view];
            [actionSheet setBounds:CGRectMake(0,0,320, 464)];
        }
    }else
    {
        
        if (popOver == nil) {
            
            UIViewController* popoverContent = [[UIViewController alloc] init];
            
            UIToolbar *toolbr = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            
            UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self
                                                                          action:@selector(pickerDone:)];
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(pickerCancel:)];
            popoverView = [[UIView alloc] init];   //view
            popoverView.backgroundColor = [UIColor blackColor];
            
            NSMutableArray *items = [[NSMutableArray alloc] init];
            [items addObject:cancelButton];
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
}

-(void)createUIDatePicker:(id)sender
{
    UIButton *butt = (UIButton *)sender;
    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    theDatePicker.datePickerMode = UIDatePickerModeDate;
    [theDatePicker setDate:[NSDate date]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [actionSheet addSubview:theDatePicker];
    }else
    {
        [popoverView addSubview:theDatePicker];
        
        CGRect frm = butt.frame;
        frm.origin.y = frm.origin.y ;
        
        [popOver presentPopoverFromRect:frm inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    theDatePicker.tag=butt.tag;
    //    [theDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [theDatePicker addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    
    if([btnDateofBirth.titleLabel.text length]>0)
    {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:btnDateofBirth.titleLabel.text];
    [theDatePicker setDate:dateFromString animated:NO];
}
}

-(void)dateChanged:(id)sender {
    NSLog(@"dateChanged");
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"]; // changed line in your code
    
    
    selectedStartPickerDate=[theDatePicker date];
    NSString *dateText = [dateFormatter2 stringFromDate:selectedStartPickerDate];
    [btnDateofBirth setTitle:dateText forState: UIControlStateNormal];
    
}

// Item picked
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    select = YES;
    
    //                [btnDateofBirth setTitle:sdateBtn.currentTitle forState:UIControlStateNormal];
    selectedendPickerDate=selectedStartPickerDate;
    
}


- (void)pickerDone:(id)sender
{
    
    if(select == NO)
    {
        selectedendPickerDate=[theDatePicker date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // changed line in your code
        NSString *dateText = [dateFormatter stringFromDate:selectedendPickerDate];
        [btnDateofBirth setTitle:dateText forState: UIControlStateNormal];
    }
    [popOver dismissPopoverAnimated:YES];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    popOver=nil;
    actionSheet = nil;
}
- (void)pickerCancel:(id)sender
{
    [popOver dismissPopoverAnimated:YES];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    popOver=nil;
    actionSheet = nil;
}

#pragma mark -
#pragma mark - text feild delegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - Webservice api delegate method

-(void)profileUpdateResult:(NSString *)msg
{
     [HUD hide:YES];
    [FLGlobalSettings sharedInstance].current_user_profile.full_name=lblName.text;
    [FLGlobalSettings sharedInstance].current_user_profile.birth_date=btnDateofBirth.titleLabel.text;
    [FLGlobalSettings sharedInstance].current_user_profile.mobile_number=newPhoneNo;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PROFILE_UPDATED
                                                        object:self];
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- FLWebServiceDelegate Fail
#pragma mark-

-(void)unknownFailureCall
{
    [HUD hide:YES];
    [self showValidationAlert:@"Unknown Error"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestFailCall:(NSString *)errorMsg
{
    [HUD hide:YES];
    [self showValidationAlert:errorMsg];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showValidationAlert:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark- PhoneNoDelegate method
#pragma mark-

- (void)phoneNoViewDismiss:(NSString *)phoneNo
{
    newPhoneNo=phoneNo;
}


@end
