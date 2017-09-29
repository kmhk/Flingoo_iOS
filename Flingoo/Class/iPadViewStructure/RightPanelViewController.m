//
//  RightPanelViewController.m
//  NewSructure
//
//  Created by Thilina Hewagama on 11/29/13.
//  Copyright (c) 2013 Thilina Hewagama. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RightPanelViewController.h"

@interface RightPanelViewController ()
@property(nonatomic, strong) IBOutlet UIBarButtonItem *backBarButton;
@end

@implementation RightPanelViewController

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
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_ipad.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor whiteColor], UITextAttributeTextColor,
                                                [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], UITextAttributeFont,nil]];
    self.navigationBar.layer.zPosition = MAXFLOAT;
    
    //back button
    
    UIImage* image = [UIImage imageNamed:@"back_btn.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backbtn = [[UIButton alloc] initWithFrame:frame];
    [backbtn setImage:image forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
}




#pragma mark - Navigation Bar

-(void)setRightPanelTitle:(NSString *)panelTitle{
    self.navigationBar.topItem.title = panelTitle;
    NSLog(@"[self.view bringSubviewToFront:self.navigationBar]");
    [self.view bringSubviewToFront:self.navigationBar];
}

-(void) goBack{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GLOBAL_BACK_BUTTON_PRESSED" object:nil];
}

-(void) showBackbutton;{
        self.navigationBar.topItem.leftBarButtonItem = self.backBarButton;
}

-(void) hideBackButton;{
        self.navigationBar.topItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
