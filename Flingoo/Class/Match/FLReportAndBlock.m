//
//  FLReportAndBlock.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/26/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLReportAndBlock.h"

@interface FLReportAndBlock ()

@end

@implementation FLReportAndBlock





#pragma mark - Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}










#pragma mark - View Lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //back button
    
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    UIImage* image2 = [UIImage imageNamed:@"submitbtn.PNG"];
    CGRect frame2 = CGRectMake(0, 0, image2.size.width, image2.size.height);
    UIButton* backbtn2 = [[UIButton alloc] initWithFrame:frame2];
    [backbtn2 setImage:image2 forState:UIControlStateNormal];
    [backbtn2 addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithCustomView:backbtn2];
    
    self.navigationItem.rightBarButtonItem = submitButton;
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
}

- (void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}










#pragma mark - Button Actions

- (void) goBack{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitClicked{
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService blockUser:self withUserID:[NSString stringWithFormat:@"%@",self.profileObj.uid]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}











#pragma mark -
#pragma mark - Webservice api delegate method

- (void)blockUserResult:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:str delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}











#pragma mark- FLWebServiceDelegate Fail
#pragma mark-

- (void)unknownFailureCall{
    [self showValidationAlert:@"Unknown Error"];
}

- (void)requestFailCall:(NSString *)errorMsg{
    [self showValidationAlert:errorMsg];
}

- (void)showValidationAlert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}


@end
