//
//  SlideControllerSubclass.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "SlideControllerSubclass.h"
#import "FLMFDetailsViewController.h"
#import "FLMFOverviewViewController.h"
#import "FLMFPhotoGalleryViewController.h"
#import "FLParentSliderViewController.h"
#import "FLLikeYouViewController.h"
#import "FLMatchesViewController.h"
#import "FLDoYouLikeViewController.h"
#import "FLFindPeopleViewController.h"
#import "FLAdvancedSearchViewController.h"
#import "FLEyeCatcherViewController.h"
#import "FLFindMeViewController.h"
#import "FLNotificationViewController.h"
#import "FLProfileVisitorsViewController.h"
#import "FLProfileVisitsViewController.h"
#import "FLFavouritsViewController.h"
#import "FLFFriendsViewController.h"
#import "FLFUnfriendedViewController.h"
#import "FLRadarViewController.h"
#import "FLChangeEmailViewController.h"
#import "FLMyChatViewController.h"
#import "FLChatRequestsViewController.h"
#import "FLVIPUpgradeViewController.h"
#import "FLFreeCreditsViewController.h"
#import "FLSettingsViewController.h"
#import "FLUtilUserDefault.h"
#import "FLSignUpViewController.h"
#import "FLAppDelegate.h"
#import "FLUserLocation.h"
#import "Config.h"

@interface SlideControllerSubclass (private)

-(void)pressedLeftButton;

@end

@implementation SlideControllerSubclass

@synthesize textDisplayController = _textDisplayController;
@synthesize textSelectionController = _textSelectionController;


- (id)init
{
    self = [super init];
    if (self) {
        
        // Creating the controllers
        self.delegate=self;
      FLRadarViewController  *textDisplayController = [[FLRadarViewController alloc] initWithNibName:@"FLRadarViewController" bundle:nil];
        
        _textSelectionController = [[FLStaticMenuViewController alloc] init];
        // Assigning the delegate to get informed when somethin has been selected
        _textSelectionController.delegate = self;
        
        // Adding navcontroller and barbutton
       _textDisplayController = [[UINavigationController alloc] initWithRootViewController:textDisplayController];
        
        UIImage* btnMenuImg = [UIImage imageNamed:@"menuBtn.png"];
        CGRect frame = CGRectMake(0, 0, btnMenuImg.size.width, btnMenuImg.size.height);
        UIButton * menuButton = [[UIButton alloc]initWithFrame:frame];
        [menuButton setBackgroundImage:btnMenuImg forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        [textDisplayController.navigationItem setLeftBarButtonItem:menuBarButton];
        
        textDisplayController.title = NSLocalizedString(@"flingoo", @"Flingoo");
        
        //set navigationbar image
        navImage = [UIImage imageNamed:@"navigationbar.png"];
        [textDisplayController.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
        
        // finally assigning the controllers as static and sliding view controller
        // to the CHSlideController
        
        self.view.backgroundColor = [UIColor blackColor];
        // self.allowInteractiveSlideing = YES;
        self.leftStaticViewWidth = 320-55;
        self.rightStaticViewWidth = 320-55;
        //self.slideViewVisibleWidthWhenHidden = 50;
        self.leftStaticViewController = _textSelectionController;
        self.slidingViewController = _textDisplayController;
        
        /////////////////
        ////////////////////
        
//        self.slidingViewController = _textDisplayController;
//        [self showSlidingViewAnimated:YES];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    FLAppDelegate *appDelegate = (FLAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setSliderController:self];
//     locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    
//    [locationManager startUpdatingLocation];
   
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
//  static dispatch_once_t once;
//        dispatch_once(&once, ^{
//            self.slidingViewController = _textDisplayController;
//            [self showSlidingViewAnimated:YES];
//        });
}


// Our subclass is responsible for handling events happening
// in static and sliding controller and for showing/hiding stuff

-(void)staticDemoDidSelectText:(NSString *)text
{
    
    UIViewController *controller;
    //    controller = _textDisplayController;
    
    
    if ([text isEqualToString:@"TopCell"])
    {
        
        if (self.tabBarController==nil)
        {
            //define viewcontroller
            UIViewController *overViewCon = [[FLMFOverviewViewController alloc] initWithNibName:@"FLMFOverviewViewController" bundle:nil];
            
            UIViewController *photoGalleryViewCon = [[FLMFPhotoGalleryViewController alloc] initWithNibName:@"FLMFPhotoGalleryViewController" bundle:nil profile:MY_PROFILE withProfileObj:nil];
            
            UIViewController *detailsViewCon = [[FLMFDetailsViewController alloc] initWithNibName:@"FLMFDetailsViewController" bundle:nil profile:MY_PROFILE withProfileObj:nil];
            
            //define navigationbar
            UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:overViewCon];
            
            UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:photoGalleryViewCon];
            
            UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:detailsViewCon];
            
            //define navigationbar btn
            UIImage* btnMenuImg1 = [UIImage imageNamed:@"menuBtn.png"];
            CGRect frame1 = CGRectMake(0, 0, btnMenuImg1.size.width, btnMenuImg1.size.height);
            UIButton * menuButton1 = [[UIButton alloc]initWithFrame:frame1];
            [menuButton1 setBackgroundImage:btnMenuImg1 forState:UIControlStateNormal];
            [menuButton1 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *menuBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:menuButton1];
            
            UIImage* btnMenuImg2 = [UIImage imageNamed:@"menuBtn.png"];
            CGRect frame2 = CGRectMake(0, 0, btnMenuImg2.size.width, btnMenuImg2.size.height);
            UIButton * menuButton2 = [[UIButton alloc]initWithFrame:frame2];
            [menuButton2 setBackgroundImage:btnMenuImg2 forState:UIControlStateNormal];
            [menuButton2 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *menuBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:menuButton2];
            
          
            UIImage* btnMenuImg3 = [UIImage imageNamed:@"menuBtn.png"];
            CGRect frame3 = CGRectMake(0, 0, btnMenuImg3.size.width, btnMenuImg3.size.height);
            UIButton * menuButton3 = [[UIButton alloc]initWithFrame:frame3];
            [menuButton3 setBackgroundImage:btnMenuImg3 forState:UIControlStateNormal];
            [menuButton3 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *menuBarButton3 = [[UIBarButtonItem alloc] initWithCustomView:menuButton3];
            
            //set navigatiobar image & btn
            [nav1.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            nav1.navigationBar.topItem.leftBarButtonItem =menuBarButton1;
            
            [nav2.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            nav2.navigationBar.topItem.leftBarButtonItem =menuBarButton2;
            [nav3.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            nav3.navigationBar.topItem.leftBarButtonItem =menuBarButton3;
            
            
            self.tabBarController = [[UITabBarController alloc] init];
            self.tabBarController.viewControllers = @[nav1, nav2,nav3];
            
        }
        controller = self.tabBarController;
        
    }else if([text isEqualToString:@"Find people"]){
        
        if(self.tabBarFindPeopleController==nil){
            
            //set navigationbar back button
            UIImage* btnMenuImg1 = [UIImage imageNamed:@"FP_navigation_menu_btn.PNG"];
            CGRect frame1 = CGRectMake(0, 0, btnMenuImg1.size.width, btnMenuImg1.size.height);
            UIButton* menuButton1 = [[UIButton alloc]initWithFrame:frame1];
            [menuButton1 setBackgroundImage:btnMenuImg1 forState:UIControlStateNormal];
            [menuButton1 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* menuBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:menuButton1];
            
            //set navigationbar back button
            UIImage* btnMenuImg2 = [UIImage imageNamed:@"FP_navigation_menu_btn.PNG"];
            CGRect frame2 = CGRectMake(0, 0, btnMenuImg2.size.width, btnMenuImg2.size.height);
            UIButton* menuButton2 = [[UIButton alloc] initWithFrame:frame2];
            [menuButton2 setBackgroundImage:btnMenuImg2 forState:UIControlStateNormal];
            [menuButton2 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* menuBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:menuButton2];
            
            //set navigationbar back button
            UIImage* btnMenuImg3 = [UIImage imageNamed:@"FP_navigation_menu_btn.PNG"];
            CGRect frame3 = CGRectMake(0, 0, btnMenuImg3.size.width, btnMenuImg3.size.height);
            UIButton* menuButton3 = [[UIButton alloc]initWithFrame:frame3];
            [menuButton3 setBackgroundImage:btnMenuImg3 forState:UIControlStateNormal];
            [menuButton3 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* menuBarButton3 = [[UIBarButtonItem alloc] initWithCustomView:menuButton3];
            
            
            FLFindPeopleViewController *findPeopleViewController = [[FLFindPeopleViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLFindPeopleViewController-568h":@"FLFindPeopleViewController" bundle:nil];
            FLAdvancedSearchViewController *advancedSearchViewController = [[FLAdvancedSearchViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLAdvancedSearchViewController-568h":@"FLAdvancedSearchViewController" bundle:nil withType:kAdvencedSearch];
            FLEyeCatcherViewController *eyeCatcherViewController = [[FLEyeCatcherViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLEyeCatcherViewController-568h":@"FLEyeCatcherViewController" bundle:nil];
            
            
            UINavigationController *findPeopleNav = [[UINavigationController alloc] initWithRootViewController:findPeopleViewController];;
            UINavigationController *advancedSearchNav = [[UINavigationController alloc] initWithRootViewController:advancedSearchViewController];
            UINavigationController *eyeCatcherNav = [[UINavigationController alloc] initWithRootViewController:eyeCatcherViewController];
            
            findPeopleNav.navigationBar.topItem.leftBarButtonItem = menuBarButton1;
            advancedSearchNav.navigationBar.topItem.leftBarButtonItem = menuBarButton2;
            eyeCatcherNav.navigationBar.topItem.leftBarButtonItem = menuBarButton3;
            
            
            [findPeopleNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            [advancedSearchNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            [eyeCatcherNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            
            self.tabBarFindPeopleController = [[UITabBarController alloc] init];
            self.tabBarFindPeopleController.viewControllers = @[findPeopleNav, advancedSearchNav,eyeCatcherNav];
        }
        
        controller = self.tabBarFindPeopleController;
        
    }else if([text isEqualToString:@"Match"])
    {
        if (self.tabBarMatchesController==nil)
        {
            
            //        self.tabBarMatchesController = [[UITabBarController alloc] init];
            //        self.tabBarMatchesController.viewControllers = @[doYouLikeViewCon, matchesViewCon,likeYouViewCon];
            
            ////////////////////////////////////////////////////////////////
            ////////////////////////////////////////////////////////////////
            
            //define viewcontroller
            UIViewController *doYouLikeViewCon = [[FLDoYouLikeViewController alloc] initWithNibName:@"FLDoYouLikeViewController" bundle:nil];
            
            //            UIViewController *doYouLikeViewCon = [[FLMatchesViewController alloc] initWithNibName:@"FLMatchesViewController" bundle:nil];
            
            FLLikeYouViewController *matchesViewCon = [[FLLikeYouViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLLikeYouViewController-568h":@"FLLikeYouViewController" bundle:nil];
            
            FLMatchesViewController *likeYouViewCon = [[FLMatchesViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLMatchesViewController-568h":@"FLMatchesViewController" bundle:nil];
            
            //define navigationbar
            UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:doYouLikeViewCon];
            
            UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:matchesViewCon];
            
            UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:likeYouViewCon];
            
            //define navigationbar btn
            UIImage* btnMenuImg1 = [UIImage imageNamed:@"menuBtn.png"];
            CGRect frame1 = CGRectMake(0, 0, btnMenuImg1.size.width, btnMenuImg1.size.height);
            UIButton * menuButton1 = [[UIButton alloc]initWithFrame:frame1];
            [menuButton1 setBackgroundImage:btnMenuImg1 forState:UIControlStateNormal];
            [menuButton1 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *menuBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:menuButton1];
            
            UIImage* btnMenuImg2 = [UIImage imageNamed:@"menuBtn.png"];
            CGRect frame2 = CGRectMake(0, 0, btnMenuImg2.size.width, btnMenuImg2.size.height);
            UIButton * menuButton2 = [[UIButton alloc]initWithFrame:frame2];
            [menuButton2 setBackgroundImage:btnMenuImg2 forState:UIControlStateNormal];
            [menuButton2 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *menuBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:menuButton2];
            
            UIImage* btnMenuImg3 = [UIImage imageNamed:@"menuBtn.png"];
            CGRect frame3 = CGRectMake(0, 0, btnMenuImg3.size.width, btnMenuImg3.size.height);
            UIButton * menuButton3 = [[UIButton alloc]initWithFrame:frame3];
            [menuButton3 setBackgroundImage:btnMenuImg3 forState:UIControlStateNormal];
            [menuButton3 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *menuBarButton3 = [[UIBarButtonItem alloc] initWithCustomView:menuButton3];
            
            //set navigatiobar image & btn
            
            nav1.navigationBar.topItem.leftBarButtonItem =menuBarButton1;
            [nav1.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            
            nav2.navigationBar.topItem.leftBarButtonItem =menuBarButton2;
            [nav2.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            
            nav3.navigationBar.topItem.leftBarButtonItem =menuBarButton3;
            [nav3.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            
            
            self.tabBarMatchesController = [[UITabBarController alloc] init];
            self.tabBarMatchesController.viewControllers = @[nav1, nav3,nav2];
            
        }
        controller = self.tabBarMatchesController;
        
    }else if([text isEqualToString:@"Live Radar"])
    {
//        UINavigationController *nav;
//        
//        if(_textDisplayController == nil){
//            nav = [self setupRadar];
//        }
        
        controller = _textDisplayController;
//        _textDisplayController.textLabel.text = text;
    }
    else if ([text isEqualToString:@"Chat"]) {
        
        if(self.tabBarChatController == nil){
            //set navigationbar back button

            //define navigationbar btn
            UIImage* btnMenuImg1 = [UIImage imageNamed:@"menuBtn.png"];
            CGRect frame1 = CGRectMake(0, 0, btnMenuImg1.size.width, btnMenuImg1.size.height);
            UIButton * menuButton1 = [[UIButton alloc]initWithFrame:frame1];
            [menuButton1 setBackgroundImage:btnMenuImg1 forState:UIControlStateNormal];
            [menuButton1 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *menuBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:menuButton1];
            
            //set navigationbar back button
            UIImage* btnMenuImg2 = [UIImage imageNamed:@"FP_navigation_menu_btn.PNG"];
            CGRect frame2 = CGRectMake(0, 0, btnMenuImg2.size.width, btnMenuImg2.size.height);
            UIButton* menuButton2 = [[UIButton alloc] initWithFrame:frame2];
            [menuButton2 setBackgroundImage:btnMenuImg2 forState:UIControlStateNormal];
            [menuButton2 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* menuBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:menuButton2];
            
            
            

            UIViewController *myChatViewController = [[FLMyChatViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLMyChatViewController-568h":@"FLMyChatViewController" bundle:nil];
            UIViewController *chatRequestsViewController = [[FLChatRequestsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLChatRequestsViewController-568h":@"FLChatRequestsViewController" bundle:nil];
            
            

            UINavigationController *myChatNav = [[UINavigationController alloc] initWithRootViewController:myChatViewController];;
            UINavigationController *chatRequestsNav = [[UINavigationController alloc] initWithRootViewController:chatRequestsViewController];
            
            myChatNav.navigationBar.topItem.leftBarButtonItem = menuBarButton1;
            chatRequestsNav.navigationBar.topItem.leftBarButtonItem = menuBarButton2;
            
            [myChatNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            [chatRequestsNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            
            self.tabBarChatController = [[UITabBarController alloc] init];
            [[self.tabBarChatController tabBar] setBackgroundImage:[UIImage imageNamed:@"pv_tab_background.png"]];
            [[self.tabBarChatController tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"pv_selectedFooter.png"]];
            self.tabBarChatController.viewControllers = @[myChatNav, chatRequestsNav];
        }
        
        controller = self.tabBarChatController;
        
    }else if([text isEqualToString:@"Profile Visitors"]){
        
        
        if(self.tabBarProfileVisitorsController == nil){
            //set navigationbar back button
            //set navigationbar back button
            UIImage* btnMenuImg1 = [UIImage imageNamed:@"FP_navigation_menu_btn.PNG"];
            CGRect frame1 = CGRectMake(0, 0, btnMenuImg1.size.width, btnMenuImg1.size.height);
            UIButton* menuButton1 = [[UIButton alloc]initWithFrame:frame1];
            [menuButton1 setBackgroundImage:btnMenuImg1 forState:UIControlStateNormal];
            [menuButton1 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* menuBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:menuButton1];
            
            //set navigationbar back button
            UIImage* btnMenuImg2 = [UIImage imageNamed:@"FP_navigation_menu_btn.PNG"];
            CGRect frame2 = CGRectMake(0, 0, btnMenuImg2.size.width, btnMenuImg2.size.height);
            UIButton* menuButton2 = [[UIButton alloc] initWithFrame:frame2];
            [menuButton2 setBackgroundImage:btnMenuImg2 forState:UIControlStateNormal];
            [menuButton2 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* menuBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:menuButton2];
            
            
            
            
            
            FLProfileVisitorsViewController *profileVisitorsViewController = [[FLProfileVisitorsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLProfileVisitorsViewController-568h":@"FLProfileVisitorsViewController" bundle:nil];
            FLProfileVisitsViewController *profileVisitsViewController = [[FLProfileVisitsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLProfileVisitsViewController-568h":@"FLProfileVisitsViewController" bundle:nil];
            
            
            
            UINavigationController *profileVisitorsNav = [[UINavigationController alloc] initWithRootViewController:profileVisitorsViewController];;
            UINavigationController *profileVisitsNav = [[UINavigationController alloc] initWithRootViewController:profileVisitsViewController];
            
            
            profileVisitorsNav.navigationBar.topItem.leftBarButtonItem = menuBarButton1;
            profileVisitsNav.navigationBar.topItem.leftBarButtonItem = menuBarButton2;
            
            
            //set navigationbar image
            [profileVisitorsNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            [profileVisitsNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
            
            
            self.tabBarProfileVisitorsController = [[UITabBarController alloc] init];
            [[self.tabBarProfileVisitorsController tabBar] setBackgroundImage:[UIImage imageNamed:@"pv_tab_background.png"]];
            [[self.tabBarProfileVisitorsController tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"pv_selectedFooter.png"]];
            self.tabBarProfileVisitorsController.viewControllers = @[profileVisitorsNav,profileVisitsNav];
        }
        
        
        
        controller = self.tabBarProfileVisitorsController;
        
        
    }else if([text isEqualToString:@"Favorites"]){
        //set navigationbar back button
        
        if(self.tabBarFavouritesController==nil){
            self.tabBarFavouritesController = [self createFavouritesTabBarController];
        }
        
        
        [self.tabBarFavouritesController setSelectedIndex:1];
        controller = self.tabBarFavouritesController;
        
        
    }else if([text isEqualToString:@"Friends"]){
        
        if(self.tabBarFavouritesController==nil){
            self.tabBarFavouritesController = [self createFavouritesTabBarController];
        }
        
        
        [self.tabBarFavouritesController setSelectedIndex:0];
        controller = self.tabBarFavouritesController;
        
        //        NSLog(@"Maximize animated");
        //
        //        [self maximizeAnimated];
        //
        //
        //        return;
        
    }
    else if ([text isEqualToString:@"Notifications"]) {
        
        
        controller = _textDisplayController;
//        _textDisplayController.textLabel.text = text;
        
        FLNotificationViewController *notificationViewController = [[FLNotificationViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLNotificationViewController-568h":@"FLNotificationViewController" bundle:nil];
        UINavigationController *notificationNav = [[UINavigationController alloc] initWithRootViewController:notificationViewController];
        
        //menu button
        UIImage* btnMenuImg = [UIImage imageNamed:@"FP_navigation_menu_btn.PNG"];
        CGRect frame = CGRectMake(0, 0, btnMenuImg.size.width, btnMenuImg.size.height);
        UIButton* menuButton = [[UIButton alloc]initWithFrame:frame];
        [menuButton setBackgroundImage:btnMenuImg forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        
        notificationNav.navigationBar.topItem.leftBarButtonItem = menuBarButton;
        
        //set navigationbar image
        [notificationNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
        
        
        controller = notificationNav;
        
    }else if([text isEqualToString:@"Find Me"]){
        //set navigationbar back button
        
        UIImage* btnMenuImg = [UIImage imageNamed:@"FP_navigation_menu_btn.PNG"];
        CGRect frame = CGRectMake(0, 0, btnMenuImg.size.width, btnMenuImg.size.height);
        UIButton* menuButton = [[UIButton alloc]initWithFrame:frame];
        [menuButton setBackgroundImage:btnMenuImg forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        
        
        FLFindMeViewController *findMeViewController = [[FLFindMeViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLFindMeViewController-568h":@"FLFindMeViewController" bundle:nil];
        UINavigationController *findMeNav = [[UINavigationController alloc] initWithRootViewController:findMeViewController];
        findMeNav.navigationBar.topItem.leftBarButtonItem = menuBarButton;
        
        
        //set navigationbar image
        [findMeNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
        
        controller = findMeNav;
        
    }
    else if([text isEqualToString:@"Settings"]){
        if (self.buyNav== nil) {
            UIImage* btnMenuImg = [UIImage imageNamed:@"FP_navigation_menu_btn.PNG"];
            CGRect frame = CGRectMake(0, 0, btnMenuImg.size.width, btnMenuImg.size.height);
            UIButton* menuButton = [[UIButton alloc]initWithFrame:frame];
            [menuButton setBackgroundImage:btnMenuImg forState:UIControlStateNormal];
            [menuButton addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
            
            
            FLSettingsViewController *settingsViewController = [[FLSettingsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLSettingsViewController-568h":@"FLSettingsViewController" bundle:nil launchMode:kSettingsLaunchModeSlider];
        
            self.buyNav = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            self.buyNav.navigationBar.topItem.leftBarButtonItem = menuBarButton;
            
            [self.buyNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
        }
        

        controller = self.buyNav;
    }
    else if([text isEqualToString:@"Sign Out"])
    {
     
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sign_out", nil) message:NSLocalizedString(@"log_off", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
        [alert show];
        
        return;
    }
    
    
    self.slidingViewController = controller;
    [self showSlidingViewAnimated:YES];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex !=0)
    {
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        // Set the hud to display with a color
        //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        HUD.delegate = self;
        HUD.labelText = @"Sign Out...";
        HUD.square = YES;
        [HUD show:YES];
        FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
        [webSeviceApi signOutUser:self];
    }
    

}

-(void)menuClicked
{
    
    if (isLeftStaticViewVisible) {
        [self showSlidingViewAnimated:YES];
    }else {
        [self showLeftStaticView:YES];
    }
    
    
}


-(void)maximize
{
    if (self.isVisibleStaticViewMaximized) {
        [self unmaximizeStaticViewAnimated:NO];
    }else {
        [self maximizeStaticViewAnimated:NO];
    }
}

-(void)maximizeAnimated
{
    if (self.isVisibleStaticViewMaximized) {
        [self unmaximizeStaticViewAnimated:YES];
    }else {
        [self maximizeStaticViewAnimated:YES];
    }
}

//-(UINavigationController*)setupRadar{
//    _textDisplayController = [[FLRadarViewController alloc] initWithNibName:@"FLRadarViewController" bundle:nil];
//    _textDisplayController.title = @"Piliyandala";
//    
//    _textSelectionController = [[FLStaticMenuViewController alloc] init];
//    
//    
//    // Assigning the delegate to get informed when somethin has been selected
//    _textSelectionController.delegate = self;
//    
//    
//    // Adding navcontroller and barbutton
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_textDisplayController];
//    
//    UIImage* btnMenuImg = [UIImage imageNamed:@"menuBtn.png"];
//    CGRect frame = CGRectMake(0, 0, btnMenuImg.size.width, btnMenuImg.size.height);
//    UIButton * menuButton = [[UIButton alloc]initWithFrame:frame];
//    [menuButton setBackgroundImage:btnMenuImg forState:UIControlStateNormal];
//    [menuButton addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
//    [_textDisplayController.navigationItem setLeftBarButtonItem:menuBarButton];
//    
//    
//    
//    //set navigationbar image
//    navImage = [UIImage imageNamed:@"navigationbar.png"];
//    [_textDisplayController.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
//    
//    return nav;
//}

#pragma mark -
#pragma mark - CHSlideController Delegate

-(void)slideController:(CHSlideController *)slideController willShowSlindingController:(UIViewController *)slidingController
{
    NSLog(@"Will show sliding controller");
    [self enableDisableSliderView:slidingController withEnable:YES];
}

-(void)slideController:(CHSlideController *)slideController willHideSlindingController:(UIViewController *)slidingController
{
    NSLog(@"Will hide sliding controller");
    
    [self enableDisableSliderView:slidingController withEnable:NO];
    
    //    if ([slidingController isKindOfClass:[UINavigationController class]])
    //    {
    //        UINavigationController *nav=(UINavigationController *)slidingController;
    //
    //        if ([nav.topViewController isKindOfClass:[UITabBarController class]])
    //        {
    //            UITabBarController *tabBar=(UITabBarController *)nav.topViewController ;
    //            if ([tabBar.selectedViewController isKindOfClass:[FLParentSliderViewController class]])
    //            {
    //                FLParentSliderViewController *overViewCon=(FLParentSliderViewController *)tabBar.selectedViewController;
    //
    //                [overViewCon disableControllers];
    //            }
    //
    //
    //        }
    //    }
    
}

-(void)slideController:(CHSlideController *)slideController didShowSlindingController:(UIViewController *)slidingController
{
    NSLog(@"Did show sliding controller");
}

-(void)slideController:(CHSlideController *)slideController didHideSlindingController:(UIViewController *)slidingController
{
    NSLog(@"Did hide sliding controller");
}

#pragma mark -
#pragma mark - Util method

-(void)enableDisableSliderView:(UIViewController *)slidingController withEnable:(BOOL)enable
{
    if ([slidingController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBar=(UITabBarController *)slidingController;
        if ([tabBar.selectedViewController isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *nav=(UINavigationController *)tabBar.selectedViewController;
            if ([nav.topViewController isKindOfClass:[FLParentSliderViewController class]])
            {
                FLParentSliderViewController *parentViewCon=(FLParentSliderViewController *)nav.topViewController;
                [parentViewCon enableDisableSliderView:enable];
            }
            
            
        }
    }
    
}


////show menu static view
//
//-(void)slideController:(CHSlideController *)slideController willShowLeftStaticController:(UIViewController *)leftStaticController
//{
//    NSLog(@"Will show left static controller %@" ,[leftStaticController class]);
//
//    if (overViewCon!=nil)
//    {
//        [overViewCon.txtStatusUpdate resignFirstResponder];
//
//        for(UIView *currentView in overViewCon.view.subviews)
//        {
//            if([currentView isKindOfClass: [UIButton class]] || [currentView isKindOfClass: [UITextField class]] || [currentView isKindOfClass: [UITabBar class]])
//            {
//                currentView.userInteractionEnabled = NO;
//            }
//        }
//    }
//}
//
//-(void)slideController:(CHSlideController *)slideController didShowLeftStaticController:(UIViewController *)leftStaticController
//{
//    NSLog(@"Did show left static controller");
//}
//
////hide menu static view
//
//-(void)slideController:(CHSlideController *)slideController willHideLeftStaticController:(UIViewController *)leftStaticController
//{
//
//        NSLog(@"Will hide left static controller");
//
//
//
//
//}
//
//-(void)slideController:(CHSlideController *)slideController didHideLeftStaticController:(UIViewController *)leftStaticController
//{
//    NSLog(@"Did hide left static controller");
//}
//
//





#pragma mark - Helpers

-(UITabBarController *) createFavouritesTabBarController{
    //set navigationbar back button
    //define navigationbar btn
    UIImage* btnMenuImg1 = [UIImage imageNamed:@"menuBtn.png"];
    CGRect frame1 = CGRectMake(0, 0, btnMenuImg1.size.width, btnMenuImg1.size.height);
    UIButton * menuButton1 = [[UIButton alloc]initWithFrame:frame1];
    [menuButton1 setBackgroundImage:btnMenuImg1 forState:UIControlStateNormal];
    [menuButton1 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:menuButton1];
    
    UIImage* btnMenuImg2 = [UIImage imageNamed:@"menuBtn.png"];
    CGRect frame2 = CGRectMake(0, 0, btnMenuImg2.size.width, btnMenuImg2.size.height);
    UIButton * menuButton2 = [[UIButton alloc]initWithFrame:frame2];
    [menuButton2 setBackgroundImage:btnMenuImg2 forState:UIControlStateNormal];
    [menuButton2 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:menuButton2];
    
    UIImage* btnMenuImg3 = [UIImage imageNamed:@"menuBtn.png"];
    CGRect frame3 = CGRectMake(0, 0, btnMenuImg3.size.width, btnMenuImg3.size.height);
    UIButton * menuButton3 = [[UIButton alloc]initWithFrame:frame3];
    [menuButton3 setBackgroundImage:btnMenuImg3 forState:UIControlStateNormal];
    [menuButton3 addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton3 = [[UIBarButtonItem alloc] initWithCustomView:menuButton3];
    
    
    
    
    FLFavouritsViewController *favouritsViewController = [[FLFavouritsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLFavouritsViewController-568h":@"FLFavouritsViewController" bundle:nil];
    FLFFriendsViewController *friendsViewController = [[FLFFriendsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLFFriendsViewController-568h":@"FLFFriendsViewController" bundle:nil];
    FLFUnfriendedViewController *unfriendedViewController = [[FLFUnfriendedViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLFUnfriendedViewController-568h":@"FLFUnfriendedViewController" bundle:nil];
    
    
    UINavigationController *favouritsNav = [[UINavigationController alloc] initWithRootViewController:favouritsViewController];;
    UINavigationController *friendsNav = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
    UINavigationController *unfriendedNav = [[UINavigationController alloc] initWithRootViewController:unfriendedViewController];
    
    favouritsNav.navigationBar.topItem.leftBarButtonItem = menuBarButton1;
    friendsNav.navigationBar.topItem.leftBarButtonItem = menuBarButton2;
    unfriendedNav.navigationBar.topItem.leftBarButtonItem = menuBarButton3;
    
    
    //set navigationbar image
    [favouritsNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    [friendsNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    [unfriendedNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = @[friendsNav,favouritsNav,unfriendedNav];
    return tab;
}

#pragma mark- FLWebServiceDelegate methods
#pragma mark-

-(void)signOutUserResult:(NSString *)message
{
    NSLog(@"signOutUserResult");
    [FLUtilUserDefault removeAllUserData];
    FLAppDelegate *appDelegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopHeartBeatCall];
    [appDelegate chatUnsuscribe];
    [HUD hide:YES];    
    [appDelegate showSignUpView];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}


//#pragma mark - CLLocationManagerDelegate
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
//}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"didUpdateToLocation: %@", newLocation);
//    CLLocation *currentLocation = newLocation;
//    
//    if (currentLocation != nil)
//    {
//        FLUserLocation *userLocationObj=[[FLUserLocation alloc] init];
//        userLocationObj.latitude=[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//        userLocationObj.longitude=[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        userLocationObj.is_online=YES;
//        [locationManager stopUpdatingLocation];
//        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
//        [webService userLocationSet:self withUserData:userLocationObj];
//    }
//}

@end
