//
//  FLChangeMobileNumberViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 12/30/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLChangeMobileNumberViewController.h"
#import "FLGlobalSettings.h"

@interface FLChangeMobileNumberViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNo;
@end

@implementation FLChangeMobileNumberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    self.txtPhoneNo.text=[FLGlobalSettings sharedInstance].current_user_profile.mobile_number;
}


-(void) goBack
{
    if ([self.delegate respondsToSelector:@selector(phoneNoViewDismiss:)])
    {
        [self.delegate phoneNoViewDismiss:self.txtPhoneNo.text];
    }
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Change Mobile Number

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
