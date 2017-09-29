//
//  FLChangeEmailViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLChangeEmailViewController.h"

@interface FLChangeEmailViewController ()<UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak, nonatomic) IBOutlet UITextField *emailTextField;
@property(nonatomic, strong) IBOutlet UIView *content;
@end

@implementation FLChangeEmailViewController

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
    
    self.navigationItem.title = @"Change Email";
    
    // Do any additional setup after loading the view from its nib.
    [self.scrollView addSubview:self.content];
    
    
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
}

-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}



-(void) goBack{
    [self.navigationController popViewControllerAnimated:YES];
}




-(void) viewWillAppear:(BOOL)animated{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

-(void) viewDidDisappear:(BOOL)animated{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}




#pragma mark - 
#pragma mark - Keyboard


- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 320, 416) animated:YES];
    [self performSelector:@selector(resizeScrollView:) withObject:[NSNumber numberWithFloat:keyboardSize.height] afterDelay:0.5f];
}

-(void) resizeScrollView:(NSNumber *) number{
    CGSize size = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height - number.floatValue);
    self.scrollView.contentSize = size;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize size = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height + keyboardSize.height);
    self.scrollView.contentSize = size;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 181, 320, 416) animated:YES];
}




#pragma mark -
#pragma mark Button Press Events

-(IBAction) resendEmailButtonPressed:(id)sender;{
    
}

-(IBAction) saveEmailAddressButtonPressed:(id)sender;{
    
}





#pragma mark -
#pragma mark UITextView Delegate

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
