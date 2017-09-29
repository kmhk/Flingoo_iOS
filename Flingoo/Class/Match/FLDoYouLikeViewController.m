//
//  FLDoYouLikeViewController.m
//  Flingoo
//
//  Created by Hemal on 11/18/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLDoYouLikeViewController.h"
#import "FLProfileViewController.h"
#import "FLUITabBarController.h"
#import "FLMFDetailsViewController.h"
#import "FLMatchesViewController.h"
#import "FLMFPhotoGalleryViewController.h"
#import "FLAdvancedSearchViewController.h"
#import "Config.h"
#import <QuartzCore/QuartzCore.h>
#import "FLGlobalSettings.h"

@interface FLDoYouLikeViewController ()
    @property(weak, nonatomic) IBOutlet UIImageView *profilePictureHolder1;
    @property(weak, nonatomic) IBOutlet UIImageView *profilePictureHolder2;
    @property(weak, nonatomic) IBOutlet UIImageView *profilePictureHolder3;
    @property(weak, nonatomic) IBOutlet UIView *gradientView;
    @property(nonatomic, strong) NSMutableArray *tempUsersList;
@property(nonatomic, strong) FLOtherProfile *currentOtherProfile;

@end

@implementation FLDoYouLikeViewController





#pragma mark - Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Do you like?";
        self.tabBarItem.image = [UIImage imageNamed:@"do_like_tabbar.png"];
        
    }
    return self;
}











#pragma mark - view lifecyle
#pragma mark -

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [self blueGradient];
    gradient.frame = self.gradientView.bounds;
    [self.gradientView.layer addSublayer:gradient];
    
    self.navigationItem.title=@"Username";
    
    UIImage* filterBtnImg = [UIImage imageNamed:@"filterBtn.png"];
    CGRect frameFilter = CGRectMake(0, 0, filterBtnImg.size.width, filterBtnImg.size.height);
    UIButton* filterBtn = [[UIButton alloc]initWithFrame:frameFilter];
    [filterBtn setBackgroundImage:filterBtnImg forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
    //    [self.navigationItem setRightBarButtonItem:filterBarButton];
    self.navigationItem.rightBarButtonItem=filterBarButton;
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
    //define temp users list
    self.tempUsersList = [[NSMutableArray alloc] init];
    
    [FLGlobalSettings sharedInstance].matchListArr=[[NSMutableArray alloc] init];
    [self reloadUsers];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}

- (CAGradientLayer*) blueGradient {
    
    UIColor *colorOne = [UIColor clearColor];
    UIColor *colorTwo = [UIColor colorWithRed:0 green:0  blue:0  alpha:4.0];
    UIColor *colorThree = [UIColor colorWithRed:0 green:0  blue:0  alpha:6.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.8];
    NSNumber *stopThree = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo,stopThree, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (btnProfile.alpha==1.0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        btnProfile.alpha = 0.0;
        btnYesLike.alpha = 0.0;
        btnMaybe.alpha = 0.0;
        btnNo.alpha = 0.0;
        lblProfile.alpha = 0.0;
        lblYesLike.alpha = 0.0;
        lblMaybe.alpha = 0.0;
        lblNo.alpha = 0.0;
        [UIView commitAnimations];
    }
    else if (btnProfile.alpha==0.0)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        btnProfile.alpha = 1.0;
        btnYesLike.alpha = 1.0;
        btnMaybe.alpha = 1.0;
        btnNo.alpha = 1.0;
        lblProfile.alpha = 1.0;
        lblYesLike.alpha = 1.0;
        lblMaybe.alpha = 1.0;
        lblNo.alpha = 1.0;
        [UIView commitAnimations];
    }
}











#pragma mark - Util
#pragma mark -

-(void)reloadUsers{
    if (IS_IPHONE || IS_IPHONE_5) {
        HUD=[[MBProgressHUD alloc] initWithView:self.tabBarController.view];
        [self.tabBarController.view addSubview:HUD];
    }
    else
    {
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Uploading...";
    [HUD show:YES];
    
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi matchUsersList:self];
    
}











#pragma mark - Action
#pragma mark -

- (void)filterClicked:sender{
    
    
}

- (void)back:sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)profileClicked:(id)sender{
    
    
    if(IS_IPAD){
        NSDictionary *actionDic=@{@"Profile":OTHER_PROFILE,@"ProfileObject":@""};
        NSDictionary *dict = @{RemoteAction:kRemoteActionShowProfile,@"ClickAction":actionDic};
        self.communicator(dict);
    }else{
        
        FLMFDetailsViewController *detailViewCon=[[FLMFDetailsViewController alloc] initWithNibName:@"FLMFDetailsViewController" bundle:nil
                                                                                            profile:@
                                                  "OtherProfile" withProfileObj:nil];
        UINavigationController *navDetail=[[UINavigationController alloc] initWithRootViewController:detailViewCon];
        
        
        
        
        
        FLProfileViewController *profileViewCon=[[FLProfileViewController alloc] initWithNibName:@"FLProfileViewController" bundle:nil profile:OTHER_PROFILE withProfileObj:nil];
        UINavigationController *navProfile=[[UINavigationController alloc] initWithRootViewController:profileViewCon];
        
        
        
        FLMFPhotoGalleryViewController *photoGalleryViewCon=[[FLMFPhotoGalleryViewController alloc] initWithNibName:@"FLMFPhotoGalleryViewController" bundle:nil profile:OTHER_PROFILE withProfileObj:nil];
        UINavigationController *navPhotoGallery=[[UINavigationController alloc] initWithRootViewController:photoGalleryViewCon];
        
        
        
        UIImage *navImage1 = [UIImage imageNamed:@"navigationbar.png"];
        [navDetail.navigationBar setBackgroundImage:navImage1 forBarMetrics:UIBarMetricsDefault];
        
        UIImage *navImage2 = [UIImage imageNamed:@"navigationbar.png"];
        [navProfile.navigationBar setBackgroundImage:navImage2 forBarMetrics:UIBarMetricsDefault];
        
        UIImage *navImage3 = [UIImage imageNamed:@"navigationbar.png"];
        [navPhotoGallery.navigationBar setBackgroundImage:navImage3 forBarMetrics:UIBarMetricsDefault];
        
        FLUITabBarController *tabBarController = [[FLUITabBarController alloc] init];
        
        [[tabBarController tabBar] setBackgroundImage:[UIImage imageNamed:nil]];
        [[tabBarController tabBar] setSelectionIndicatorImage:[UIImage imageNamed:nil]];
        
        
        tabBarController.viewControllers = @[navDetail,navProfile,navPhotoGallery];
        
        //    [tabBarController setSelectedIndex:1];
        
        [self presentViewController:tabBarController animated:YES completion:nil];
        
        [tabBarController setSelectedIndex:1];
    }


}

- (IBAction)yesClicked:(id)sender {
    [self moveLeft];
}

- (IBAction)maybeClicked:(id)sender {
    [self moveLeft];
}

- (IBAction)noClicked:(id)sender {
    [self moveLeft];
}

- (void) filterButtonPressed{
    
    //back button
//
//    UIImage* image = [UIImage imageNamed:@"back_btn.png"];
//    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    UIButton* backbtn = [[UIButton alloc] initWithFrame:frame];
//    [backbtn setImage:image forState:UIControlStateNormal];
//    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
//    self.navigationItem.leftBarButtonItem = backButton;
    
    //set navigatiobar image & btn
    

    
    
    FLAdvancedSearchViewController *advancedSearchViewController = [[FLAdvancedSearchViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLAdvancedSearchViewController-568h":@"FLAdvancedSearchViewController" bundle:nil withType:kMatchFilter];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:advancedSearchViewController] ;
    
//    nav.navigationBar.topItem.leftBarButtonItem =menuBarButton3;
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self presentViewController:nav animated:YES completion:nil];
}







#pragma mark - Animations

- (void) loadInitialOtherProfile{
    self.currentOtherProfile = nil;
    
    if(self.tempUsersList.count>0){
        self.currentOtherProfile = (FLOtherProfile *)[self.tempUsersList objectAtIndex:0];
    }
    
    CGRect frame1 = self.profilePictureHolder1.frame;
    CGRect frame2 = self.profilePictureHolder2.frame;
    CGRect frame3 = self.profilePictureHolder3.frame;
    
    if(!self.currentOtherProfile) return;
    
    //detect the next visible profilePictureHolder
    if(IS_IPAD){
        if(frame1.origin.x>=0 && frame1.origin.x<=756){
            [self.profilePictureHolder1 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }else if(frame2.origin.x>=0 && frame2.origin.x<=756){
            [self.profilePictureHolder2 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }else if(frame3.origin.x>=0 && frame3.origin.x<=756){
            [self.profilePictureHolder3 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }
    }else{
        if(frame1.origin.x>=0 && frame1.origin.x<=320){
            [self.profilePictureHolder1 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }else if(frame2.origin.x>=0 && frame2.origin.x<=320){
            [self.profilePictureHolder2 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }else if(frame3.origin.x>=0 && frame3.origin.x<=320){
            [self.profilePictureHolder3 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }
    }
}

- (void) moveLeft{
    
    CGRect frame1 = self.profilePictureHolder1.frame;
    NSLog(@"frame1:%@",NSStringFromCGRect(frame1));
    CGRect frame2 = self.profilePictureHolder2.frame;
    NSLog(@"frame2:%@",NSStringFromCGRect(frame2));
    CGRect frame3 = self.profilePictureHolder3.frame;
    NSLog(@"frame3:%@",NSStringFromCGRect(frame3));
    
    if(IS_IPAD){
        frame1.origin.x -= 756;
        frame2.origin.x -= 756;
        frame3.origin.x -= 756;
    }else{
        frame1.origin.x -= 320;
        frame2.origin.x -= 320;
        frame3.origin.x -= 320;
    }
    
    NSLog(@"Assign -=320");
    NSLog(@"frame1:%@",NSStringFromCGRect(frame1));
    NSLog(@"frame2:%@",NSStringFromCGRect(frame2));
    NSLog(@"frame3:%@",NSStringFromCGRect(frame3));
    
    //remove previous profile
    [self.tempUsersList removeObject:[self.tempUsersList objectAtIndex:0]];
    
    self.currentOtherProfile = nil;
    
    if(self.tempUsersList.count>0){
        self.currentOtherProfile = (FLOtherProfile *)[self.tempUsersList objectAtIndex:0];
    }
    
    if(!self.currentOtherProfile) return;
    
    //detect the next visible profilePictureHolder
    if(IS_IPAD){
        if(frame1.origin.x>=0 && frame1.origin.x<=756){
            [self.profilePictureHolder1 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }else if(frame2.origin.x>=0 && frame2.origin.x<=756){
            [self.profilePictureHolder2 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }else if(frame3.origin.x>=0 && frame3.origin.x<=756){
            [self.profilePictureHolder3 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }
    }else{
        if(frame1.origin.x>=0 && frame1.origin.x<=320){
            [self.profilePictureHolder1 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }else if(frame2.origin.x>=0 && frame2.origin.x<=320){
            [self.profilePictureHolder2 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }else if(frame3.origin.x>=0 && frame3.origin.x<=320){
            [self.profilePictureHolder3 setImageWithURL:[NSURL URLWithString:self.currentOtherProfile.image] placeholderImage:nil];
        }
    }
    
    
    [UIView animateWithDuration:0.7
                          delay:0.2 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.profilePictureHolder1.frame = frame1;
                         self.profilePictureHolder2.frame = frame2;
                         self.profilePictureHolder3.frame = frame3;
                     }
                     completion:^(BOOL finished){
                         
                         if(IS_IPAD){
                             CGRect frame1 = self.profilePictureHolder1.frame;
                             if(frame1.origin.x<-916){
                                 frame1.origin.x = 916;
                                 self.profilePictureHolder1.frame = frame1;
                             }
                             CGRect frame2 = self.profilePictureHolder2.frame;
                             if(frame2.origin.x<-916){
                                 frame2.origin.x = 916;
                                 self.profilePictureHolder2.frame = frame2;
                             }
                             CGRect frame3 = self.profilePictureHolder3.frame;
                             if(frame3.origin.x<-916){
                                 frame3.origin.x = 916;
                                 self.profilePictureHolder3.frame = frame3;
                             }
                         }else{
                             CGRect frame1 = self.profilePictureHolder1.frame;
                             if(frame1.origin.x<-320){
                                 frame1.origin.x = 320;
                                 self.profilePictureHolder1.frame = frame1;
                             }
                             CGRect frame2 = self.profilePictureHolder2.frame;
                             if(frame2.origin.x<-320){
                                 frame2.origin.x = 320;
                                 self.profilePictureHolder2.frame = frame2;
                             }
                             CGRect frame3 = self.profilePictureHolder3.frame;
                             if(frame3.origin.x<-320){
                                 frame3.origin.x = 320;
                                 self.profilePictureHolder3.frame = frame3;
                             }
                         }
//
                     }];
    
}

- (void)enableDisableSliderView:(BOOL)enable{
    self.view.userInteractionEnabled=enable;
}











#pragma mark -
#pragma mark WebService Api delegate methods

- (void)matchListResult:(NSMutableArray *)matchsArr{
     [HUD hide:YES];
    [[FLGlobalSettings sharedInstance].matchListArr removeAllObjects];
    [[FLGlobalSettings sharedInstance].matchListArr addObjectsFromArray:matchsArr];
    [self.tempUsersList removeAllObjects];
    [self.tempUsersList addObjectsFromArray:matchsArr];
    [self loadInitialOtherProfile];
}











#pragma mark -
#pragma mark - webservice Api Fail

- (void)unknownFailureCall{
    [self showValidationAlert:NSLocalizedString(@"unknown_error", nil)];
}

- (void)requestFailCall:(NSString *)errorMsg{
    [self showValidationAlert:errorMsg];
}

- (void)showValidationAlert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}



@end
