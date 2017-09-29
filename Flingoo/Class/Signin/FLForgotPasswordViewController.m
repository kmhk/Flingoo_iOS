//
//  FLForgotPasswordViewController.m
//  Flingoo
//
//  Created by Hemal on 11/14/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLForgotPasswordViewController.h"
#import "FLSignUpEmailViewController.h"
#import "FLUtilValidation.h"

@interface FLForgotPasswordViewController ()

@end

@implementation FLForgotPasswordViewController






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










#pragma mark - View Lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
   
    //set navigationbar back button
    self.navigationItem.leftBarButtonItem  = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [FLUtil signInBarButtonWithTarget:self action:@selector(loginClicked:)];

    self.navigationItem.title=@"Forgot Password";

}











#pragma mark - Button Actions

- (void)loginClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)createAccountClicked:(id)sender{
    FLSignUpEmailViewController *signUpEmailViewCon=[[FLSignUpEmailViewController alloc] initWithNibName:@"FLSignUpEmailViewController" bundle:nil];
    [self.navigationController pushViewController:signUpEmailViewCon animated:YES];
}

- (IBAction)sendEmailClicked:(id)sender{
    
    if (![FLUtilValidation validateEmail:txtFieldEmail.text]) {
        [self showValidationAlert:@"Email is invalid"];
        return;
    }
    [txtFieldEmail resignFirstResponder];

    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Connecting";
    [HUD show:YES];
    
   
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    [webSeviceApi forgotPassword:self withEmail:txtFieldEmail.text];
    
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [txtFieldEmail resignFirstResponder];
}









#pragma mark -
#pragma mark webservice api methods

-(void)forgetPasswodResult:(NSString *)msg{
    [HUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil)otherButtonTitles:nil, nil];
    [alert show];
}











#pragma mark -
#pragma mark webservice api error

-(void)unknownFailureCall{
    [HUD hide:YES];
    [self showValidationAlert:@"Unknown Error" ];
}

-(void)requestFailCall:(NSString *)errorMsg{
    [HUD hide:YES];
    [self showValidationAlert:errorMsg];
}

-(void)showValidationAlert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil)otherButtonTitles:nil, nil];
    [alert show];
}











#pragma mark - Others

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
