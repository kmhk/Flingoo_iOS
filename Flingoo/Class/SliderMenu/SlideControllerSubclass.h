//
//  SlideControllerSubclass.h
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "CHSlideController.h"
#import "FLStaticMenuViewController.h"
#import "CHSlidingDemo.h"
#import "FLMFOverviewViewController.h"
#import "MBProgressHUD.h"
#import "FLWebServiceApi.h"
#import "FLRadarViewController.h"


@interface SlideControllerSubclass : CHSlideController <FLStaticMenuViewControllerDelegate,CHSlideControllerDelegate,MBProgressHUDDelegate,FLWebServiceDelegate,UIAlertViewDelegate>
{
//    FLMFOverviewViewController *overViewCon;
    UIImage *navImage;
    MBProgressHUD *HUD;
    
}

// Defining the controllers we wanna display in the slide controller
@property (nonatomic, strong) UINavigationController *textDisplayController;
@property (nonatomic, strong) FLStaticMenuViewController *textSelectionController;

@property (nonatomic,strong) UITabBarController *tabBarController;
@property (nonatomic,strong) UITabBarController *tabBarMatchesController;

@property (nonatomic,strong) UITabBarController *tabBarFindPeopleController;
@property (nonatomic,strong) UITabBarController *tabBarProfileVisitorsController;
@property (nonatomic,strong) UITabBarController *tabBarFavouritesController;
@property (nonatomic,strong) UITabBarController *tabBarChatController;
@property (nonatomic,strong) UINavigationController *buyNav;

@end
