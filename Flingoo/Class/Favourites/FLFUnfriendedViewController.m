//
//  FLFUnfriendedViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLFUnfriendedViewController.h"
#import "FLRevealUnfriendedViewController.h"

@interface FLFUnfriendedViewController ()

@end

@implementation FLFUnfriendedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Unfriended";
        self.tabBarItem.image = [UIImage imageNamed:@"fav_unfriended.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Unfriended";
    //back button
    
//    UIImage* image = [UIImage imageNamed:@"back_btn.png"];
//    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    UIButton* backbtn = [[UIButton alloc] initWithFrame:frame];
//    [backbtn setImage:image forState:UIControlStateNormal];
//    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
//    self.navigationItem.leftBarButtonItem = backButton;
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




//-(void) goBack{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}




#pragma mark - button actions

-(IBAction) facebookConnectButtonPressed:(id)sender;{
    FLRevealUnfriendedViewController *unfriended = [[FLRevealUnfriendedViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLRevealUnfriendedViewController-568h":@"FLRevealUnfriendedViewController" bundle:nil];
    [self.navigationController pushViewController:unfriended animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
