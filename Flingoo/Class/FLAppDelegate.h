//
//  FLAppDelegate.h
//  Flingoo
//
//  Created by Hemal on 11/10/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLWebServiceApi.h"
#import "CHDraggingCoordinator.h"
#import "PTPusher.h"
#import "Bugsnag.h"
#import "CHSlideController.h"

@class FLSplashViewController;

@interface FLAppDelegate : UIResponder <UIApplicationDelegate,FLWebServiceDelegate, CHDraggingCoordinatorDelegate,PTPusherDelegate>
{
    BOOL timerActive;
    NSTimer *callServiceTimer;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FLSplashViewController *viewController;

@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator1;

@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator2;

@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator3;

@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator4;

@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator5;

@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator6;

@property (strong,nonatomic) PTPusher *client;

@property (nonatomic, weak) CHSlideController *sliderController;

-(void) showSignUpView;
-(void)chatListen;
-(void)chatUnsuscribe;
-(void)heartBeatCall;
-(void)stopHeartBeatCall;
-(void)callNotificationService;
@end
