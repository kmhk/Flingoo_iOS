//
//  FLChangePasswordViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 12/30/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLChangePasswordViewController.h"
#import "FLUtilUserDefault.h"

@interface FLChangePasswordViewController ()<UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

//textfields
@property(weak, nonatomic) IBOutlet UITextField *currentPassword;
@property(weak, nonatomic) IBOutlet UITextField *nPassword;
@property(weak, nonatomic) IBOutlet UITextField *confirmPassword;

@property(nonatomic, weak) UITextField *activeField;

@end

@implementation FLChangePasswordViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


-(void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.activeField = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (IBAction)passwordChangeClicked:(id)sender
{
    [self.view endEditing:YES];
    if (!self.currentPassword.text || [self.currentPassword.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:@"Field cannot be empty" delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!self.nPassword.text || [self.nPassword.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:@"Field cannot be empty" delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!self.confirmPassword.text || [self.confirmPassword.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:@"Field cannot be empty" delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.nPassword.text isEqualToString:self.confirmPassword.text])
    {
        if ([self.nPassword.text length]>=6)
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
            [webService updatePassword:self withCurrentPassword:self.currentPassword.text withNewPassword:self.nPassword.text];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:@"Password required minimum 6 characters" delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:@"Passwords do not match" delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark- FLWebServiceDelegate Fail
#pragma mark-

-(void)unknownFailureCall
{
    [HUD hide:YES];
    [self showValidationAlert:@"Unknown Error"];
}

-(void)requestFailCall:(NSString *)errorMsg
{
    [HUD hide:YES];
    [self showValidationAlert:errorMsg];
}

-(void)showValidationAlert:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark- FLWebServiceDelegate method
#pragma mark-

-(void)updatePasswordResult:(NSString *)str
{
    [HUD hide:YES];
    [FLUtilUserDefault setPassword:self.nPassword.text];
    self.currentPassword.text=@"";
    self.nPassword.text=@"";
    self.confirmPassword.text=@"";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:str delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}

@end
