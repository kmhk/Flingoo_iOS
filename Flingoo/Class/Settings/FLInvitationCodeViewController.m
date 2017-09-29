//
//  FLInvitationCodeViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLInvitationCodeViewController.h"
#import "FLUtil.h"

@interface FLInvitationCodeViewController ()<UITextFieldDelegate>
    @property(weak, nonatomic) IBOutlet UITextField *codeTextField1;
    @property(weak, nonatomic) IBOutlet UITextField *codeTextField2;
    @property(weak, nonatomic) IBOutlet UITextField *codeTextField3;
@end

@implementation FLInvitationCodeViewController

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
    self.navigationItem.title = @"Invitation Code";
    
    
    //back button
    
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
    if(IS_IPAD){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:@"GLOBAL_BACK_BUTTON_PRESSED" object:nil];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}



-(void) goBack
{
    if(IS_IPAD){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GLOBAL_BACK_BUTTON_PRESSED" object:nil];
        NSDictionary *dict = @{RemoteAction:kHideRightBackButton};
        self.communicator(dict);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}











#pragma mark - button actions

-(IBAction) checkCodeButtonPressed:(id)sender;{
    if(self.codeTextField1.isFirstResponder) [self.codeTextField1 resignFirstResponder];
     if(self.codeTextField2.isFirstResponder) [self.codeTextField2 resignFirstResponder];
     if(self.codeTextField3.isFirstResponder) [self.codeTextField3 resignFirstResponder];
}










#pragma mark - textfield delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSLog(@"newString:%@", newString);
    
    BOOL shouldGoNext = (newString.length>3);
    
    if(textField.tag==10){
        if(shouldGoNext){
            UITextField *tf = (UITextField *) [self.view viewWithTag:11];
            [tf becomeFirstResponder];
        }
    }else if(textField.tag==11){
        if(shouldGoNext){
            UITextField *tf = (UITextField *) [self.view viewWithTag:12];
            [tf becomeFirstResponder];
        }
    }else {
        if(shouldGoNext){
            [textField resignFirstResponder];
        }
    }
    
    return YES;
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

@end
