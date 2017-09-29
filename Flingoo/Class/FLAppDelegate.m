//
//  FLAppDelegate.m
//  Flingoo
//
//  Created by Hemal on 11/10/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLAppDelegate.h"
#import "FLSplashViewController.h"
#import "FLSignUpViewController.h"
#import "CHDraggableView.h"
#import "CHDraggableView+Avatar.h"
#import "FLChatScreenViewController.h"
#import <AWSRuntime/AWSRuntime.h>
#import "FLChat.h"
#import "PTPusherChannel.h"
#import "PTPusherEvent.h"
#import "FLGlobalSettings.h"
#import "Config.h"
#import "FLChatMessage.h"
#import "FLNotication.h"
#import "FLGift.h"
#import "FLChatBubbleViewController.h"
#import "FLChatGroupBubbleViewController.h"
#import "FLGroupChatScreenViewController.h"
#import "FLUtil.h"

#define MAX_CHAT_BUBBLE 6

@implementation FLAppDelegate

#pragma mark - Application Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
//    [FlingooIAPHelper sharedInstance];
    timerActive=NO;
    
    //Bug tracking
//    [Bugsnag startBugsnagWithApiKey:@"6f00adabd7338ca7dbbe27f6329336a4"];
    
    
    //////
    UIImage* tabBarBackground = [UIImage imageNamed:@"FP_tab_backgound.PNG"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:185/255.0f green:185/255.0f blue:185/255.0f alpha:1.0f]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"FP_tabSelected.png"]];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], UITextAttributeTextColor,
                                                       [UIColor blackColor], UITextAttributeTextShadowColor,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(-0.5f, -0.5f)], UITextAttributeTextShadowOffset,
                                                       nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:185/255.0f green:185/255.0f blue:185/255.0f alpha:1.0f], UITextAttributeTextColor,
                                                       [UIColor blackColor], UITextAttributeTextShadowColor,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(-0.5f, -0.5f)], UITextAttributeTextShadowOffset,
                                                       nil] forState:UIControlStateHighlighted];
    
    //Slider
    [[UISlider appearance] setMaximumTrackImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"SliderBrn"] forState:UIControlStateNormal];//SliderBrn
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"SliderBrn"] forState:UIControlStateHighlighted];//send_kisses.PNG
    
    //////
    
    
    ///////navigationbar
    if (IS_IPHONE) {
  
        UIImage *navImage = [UIImage imageNamed:@"navigationbar.png"];
        [[UINavigationBar appearance] setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    }
    else if (IS_IPAD)
    {
        UIImage *navImage = [UIImage imageNamed:@"navi_ipad.png"];
        [[UINavigationBar appearance] setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor whiteColor], UITextAttributeTextColor,
                                                              [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], UITextAttributeFont,nil]];
    }
    
    
    //////
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.viewController = [[FLSplashViewController alloc] initWithNibName:@"FLSplashViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
//    //chat bubble
//    CHDraggableView *draggableView = [CHDraggableView draggableViewWithImage:[UIImage imageNamed:@"CmraBtn.png"]];
//    draggableView.tag = 1;
//    
//    CHDraggableView *draggableView2 = [CHDraggableView draggableViewWithImage:[UIImage imageNamed:@"profilePic4.png"]];
//    draggableView2.tag = 2;
//    
//    _draggingCoordinator1 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
//    _draggingCoordinator1.delegate = self;
//    _draggingCoordinator1.snappingEdge = CHSnappingEdgeBoth;
//    draggableView.delegate = _draggingCoordinator1;
//    
//    _draggingCoordinator2 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView2.bounds];
//    _draggingCoordinator2.delegate = self;
//    _draggingCoordinator2.snappingEdge = CHSnappingEdgeBoth;
//    draggableView2.delegate = _draggingCoordinator2;
//    
//    [self.window addSubview:draggableView];
//    [self.window addSubview:draggableView2];
    
#ifdef DEBUG
    [AmazonLogger verboseLogging];
#else
    [AmazonLogger turnLoggingOff];
#endif
    
    [AmazonErrorHandler shouldNotThrowExceptions];
    
    [FLGlobalSettings sharedInstance].chatArr=[[NSMutableArray alloc] init];
    [FLGlobalSettings sharedInstance].notificationArr=[[NSMutableArray alloc] init];
//    [FLGlobalSettings sharedInstance].groupChatArr=[[NSMutableArray alloc] init];
    [FLGlobalSettings sharedInstance].profileVisitorsArr=[[NSMutableArray alloc] init];
    [FLGlobalSettings sharedInstance].chatBubbleObjArr=[[NSMutableArray alloc] init];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [self heartBeatCall];
    [self chatListen];
}

#pragma mark - Other

- (void) showSignUpView{
    FLSignUpViewController *viewC = [[FLSignUpViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLSignUpViewController-568h":@"FLSignUpViewController" bundle:nil];
    
    [UIView transitionWithView:self.window duration:0.7 options:(UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent) animations:^{
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewC];
    } completion:nil];
    
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewC];
}

- (void) heartBeatCall{
    if (!timerActive) {
        timerActive=YES;
        callServiceTimer= [NSTimer scheduledTimerWithTimeInterval:500.0
                                                           target:self
                                                         selector:@selector(callService)
                                                         userInfo:nil
                                                          repeats:YES];
        
        
    }
}

- (void) stopHeartBeatCall{
    [callServiceTimer invalidate];
    callServiceTimer = nil;
    timerActive=NO;
}










#pragma mark - Chat

- (void)callService{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
        [webService heartbeatNotify:self];
    });
}

- (void)chatListen{
    
    if ([FLGlobalSettings sharedInstance].current_user_profile.uid!=nil) {
    
//    /////
//        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
////        [webServiceApi userChatList:self];
//        [webServiceApi userChatListForUser:self withUserID:@"146"];
//        //////
        
    //chat configure
    // self.client is a strong instance variable of class PTPusher
    self.client = [PTPusher pusherWithKey:PUSHER_KEY delegate:self encrypted:YES];
    
    // subscribe to channel and bind to event
    PTPusherChannel *chat_channel = [self.client subscribeToChannelNamed:[NSString stringWithFormat:@"%@-%@",PUSHER_CHANNEL_NAME_FOR_CHAT,[FLGlobalSettings sharedInstance].current_user_profile.uid]];
    [chat_channel bindToEventNamed:PUSHER_EVENT_NAME_FOR_CHAT handleWithBlock:^(PTPusherEvent *channelEvent) {
        NSLog(@"channelEvent.data %@",channelEvent.data);
//        po channelEvent.data
//        (id) $1 = 0x0aa71790 {
//            message = hiii;
//            "message_type" = private;
//            "receiver_id" = 147;
//            "sender_id" = 145;
//            "sender_name" = u31;
//        }
        
//        or
//        
//        channelEvent.data {
//            message = hi;
//            "message_type" = group;
//            "receiver_id" = 160;
//            "sender_id" = 164;
//            "sender_name" = u41;
//        }


        
        
        // channelEvent.data is a NSDictianary of the JSON object received
        if ([[channelEvent.data objectForKey:@"message_type"] isEqualToString:MSG_TYPE_PRIVATE])
        {
            NSString *message = [channelEvent.data objectForKey:@"message"];
            NSString *sender_id = [[channelEvent.data objectForKey:@"sender_id"] stringValue];
            NSString *sender_name = [channelEvent.data objectForKey:@"sender_name"];
            NSString *receiver_id = [channelEvent.data objectForKey:@"receiver_id"];
            
            NSLog(@"message received: %@", message);
            NSLog(@"sender_id received: %@", sender_id);
            NSLog(@"sender_name received: %@", sender_name);
//            [self updateChatTableWithPrivateChat:message withUID:sender_id withUserName:sender_name withMsgType:MSG_TYPE_PRIVATE];
//            [self updateChatTableWithPrivateChat:message withChatObjID:sender_id withChatObjName:sender_name withMsgType:MSG_TYPE_PRIVATE];
            
            
         
//            
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:RECEIVED_CHAT_UPDATE
//             object:self];//if we not use this we can't get chat object image
            //////////////////////////////////////////////////////////////
            //add object to chat babble table
            for (id obj in [FLGlobalSettings sharedInstance].chatBubbleObjArr)
            {
                FLChat *chatObj=obj;
                
                if ([[NSString stringWithFormat:@"%@",sender_id] isEqualToString:[NSString stringWithFormat:@"%@",chatObj.chatObj_id]] &&([chatObj.message_type isEqualToString:MSG_TYPE_PRIVATE]))
                {
                    
                    //////////////////////////////////////
                    NSDate *date = [NSDate date];
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    df.dateFormat = @"yyyy-MM-dd hh:mm:ss";
                    NSString *dateString = [df stringFromDate:date];
                    FLChatMessage *chatMsgObj=[[FLChatMessage alloc] init];
                    chatMsgObj.message=message;
                    chatMsgObj.chatDateTime=dateString;
                    chatMsgObj.username=sender_name;
                    chatMsgObj.userID=sender_id;
                    chatMsgObj.user_imageURL=chatObj.chatObj_image_url;
                    /////////////////////////////////////////
                    [chatObj.chatMessageArr addObject:chatMsgObj];
                    NSDictionary* dict = @{@"chatObj" :chatObj};
                    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_CHAT_FOR_USER
                                                                        object:self
                                                                      userInfo:dict];
                    return;
                }
            }
            
            //create new chat
            FLChat *chatObj=[[FLChat alloc] init];
            chatObj.chatObj_id=sender_id;
            chatObj.chatObjName=sender_name;
            chatObj.is_online=YES;
            chatObj.message_type=MSG_TYPE_PRIVATE;
            chatObj.chatMessageArr=[[NSMutableArray alloc] init];//updating existing obj
          
            //////////////////////////////////////
            NSDate *date = [NSDate date];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"yyyy-MM-dd hh:mm:ss";
            NSString *dateString = [df stringFromDate:date];
            FLChatMessage *chatMsgObj=[[FLChatMessage alloc] init];
            chatMsgObj.message=message;
            chatMsgObj.chatDateTime=dateString;
            chatMsgObj.username=sender_name;
            chatMsgObj.userID=sender_id;
            
            [chatObj.chatMessageArr addObject:chatMsgObj];
            /////////////////////////////////////////
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            [webServiceApi chatData:self withChatObj:chatObj];
     
            
                      /////////////////////////////////////////////////////////////////
        }
        else if ([[channelEvent.data objectForKey:@"message_type"] isEqualToString:MSG_TYPE_GROUP])
        {
          
            /////////////////////////////////////////////////////
            //////////////////////////////////////////////////////
            ////////////////////////////////////////////////////////
            NSString *message = [channelEvent.data objectForKey:@"message"];
            NSString *sender_id = [[channelEvent.data objectForKey:@"receiver_id"] stringValue];//group id
            NSString *send_user_name = [channelEvent.data objectForKey:@"sender_name"];//send user name
            NSString *send_user_id = [channelEvent.data objectForKey:@"sender_id"];
            
            NSLog(@"message received: %@", message);
            NSLog(@"sender_id received: %@", sender_id);
            NSLog(@"sender_name received: %@", send_user_name);
            //            [self updateChatTableWithPrivateChat:message withUID:sender_id withUserName:sender_name withMsgType:MSG_TYPE_PRIVATE];
            //            [self updateChatTableWithPrivateChat:message withChatObjID:sender_id withChatObjName:sender_name withMsgType:MSG_TYPE_PRIVATE];
            
            
            
            //
            //            [[NSNotificationCenter defaultCenter]
            //             postNotificationName:RECEIVED_CHAT_UPDATE
            //             object:self];//if we not use this we can't get chat object image
            //////////////////////////////////////////////////////////////
            //add object to chat babble table
            for (id obj in [FLGlobalSettings sharedInstance].chatBubbleObjArr)
            {
                FLChat *chatObj=obj;
                
                if ([[NSString stringWithFormat:@"%@",sender_id] isEqualToString:[NSString stringWithFormat:@"%@",chatObj.chatObj_id]] &&([chatObj.message_type isEqualToString:MSG_TYPE_GROUP]))
                {
                    
                    //////////////////////////////////////
                    NSDate *date = [NSDate date];
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    df.dateFormat = @"yyyy-MM-dd hh:mm:ss";
                    NSString *dateString = [df stringFromDate:date];
                    FLChatMessage *chatMsgObj=[[FLChatMessage alloc] init];
                    chatMsgObj.message=message;
                    chatMsgObj.chatDateTime=dateString;
                    chatMsgObj.username=send_user_name;
                    chatMsgObj.userID=send_user_id;
                    
                    for(FLChatMessage *msgObj in chatObj.chatMessageArr)
                    {
                        if ([[NSString stringWithFormat:@"%@",send_user_id] isEqualToString:[NSString stringWithFormat:@"%@",msgObj.userID]])
                        {
                            
                            chatMsgObj.user_imageURL=msgObj.user_imageURL;
                            [chatObj.chatMessageArr addObject:chatMsgObj];
                            NSDictionary* dict = @{@"chatObj" :chatObj};
                            [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_CHAT_FOR_GROUP
                                                                                object:self
                                                        userInfo:dict];
                            return;
                        }
                    }
                    
                    
                    [chatObj.chatMessageArr addObject:chatMsgObj];
                    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
                    [webServiceApi chatData:self withChatObj:chatObj];
                    return;
                }
            }
            
            //create new chat
            FLChat *chatObj=[[FLChat alloc] init];
            chatObj.chatObj_id=sender_id;
//            chatObj.chatObjName=sender_name;
//            chatObj.is_online=YES;
            chatObj.message_type=MSG_TYPE_GROUP;
            chatObj.chatMessageArr=[[NSMutableArray alloc] init];//updating existing obj
            
            //////////////////////////////////////
            NSDate *date = [NSDate date];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"yyyy-MM-dd hh:mm:ss";
            NSString *dateString = [df stringFromDate:date];
            FLChatMessage *chatMsgObj=[[FLChatMessage alloc] init];
            chatMsgObj.message=message;
            chatMsgObj.chatDateTime=dateString;
            chatMsgObj.username=send_user_name;
            chatMsgObj.userID=send_user_id;
            
            [chatObj.chatMessageArr addObject:chatMsgObj];
            /////////////////////////////////////////
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            [webServiceApi chatGroupData:self withChatObj:chatObj];
//            -(void)chatGroupData:(id)_delegate withChatObj:(FLChat *)chatObj
        }
    }];
        
        ////////////////////////////////////////////////
        ////////////////////////////////////////////////
        // subscribe to channel and bind to event
        PTPusherChannel *notification_channel = [self.client subscribeToChannelNamed:[NSString stringWithFormat:@"%@-%@",PUSHER_CHANNEL_NAME_FOR_NOTIFICATION,[FLGlobalSettings sharedInstance].current_user_profile.uid]];
        [notification_channel bindToEventNamed:PUSHER_EVENT_NAME_FOR_NOTIFICATION handleWithBlock:^(PTPusherEvent *channelEvent) {
            NSLog(@"channelEvent.data %@",channelEvent.data);
     
//            channelEvent.data {
//             "created_at" = "2014-01-04T08:01:28+00:00";
//                message = "Please accept my friend request";
//                "notification_id" = 66;
//                "notification_type" = "friend_request";
//                "sender_id" = 152;
//                "sender_name" = u35;
//            }
            
//            OR
            
//            channelEvent.data {
//                "created_at" = "2014-01-04T08:01:28+00:00";
//                id = 28;
//                message = "Please find me";
//                "notification_id" = 165;
//                "notification_type" = "find_me";
//                "sender_id" = 165;
//                "sender_name" = u42;
//            }
//          OR
//        {
//            "created_at" = "2014-01-05T13:50:09+00:00";
//            id = 72;
//            message = "You've received a gift";
//            "notification_id" = 10;
//            "notification_type" = "gift_received";
//            "sender_id" = 160;
//            "sender_name" = u40;
//        }
            
            FLNotication *notificationObj=[[FLNotication alloc] init];
            notificationObj.message=[channelEvent.data objectForKey:@"message"];
            notificationObj.notification_id=[channelEvent.data objectForKey:@"id"];
            notificationObj.notification_type=[channelEvent.data objectForKey:@"notification_type"];
            notificationObj.sender_id=[channelEvent.data objectForKey:@"sender_id"];
            notificationObj.sender_name=[channelEvent.data objectForKey:@"sender_name"];
            notificationObj.read_status=NO;
            notificationObj.receivedDate=[FLUtil getWebserviceDateFromString:[channelEvent.data objectForKey:@"created_at"]];
            [[FLGlobalSettings sharedInstance].notificationArr insertObject:notificationObj atIndex:0];//always add object to front of the array
            
            [self callNotificationService];
                      
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:RECEIVED_NEW_NOTIFICATION
//             object:self];
        }];
        
    }
}

- (void)callNotificationService{
    FLWebServiceApi *webservice =[[FLWebServiceApi alloc] init];
    [webservice getNotificationList:self];
}

//- (void)updateChatTableWithPrivateChat:(NSString *)message withChatObjID:(NSString *)chatObjID withChatObjName:(NSString *)chatObjName withMsgType:(NSString *)msgType{
//    NSMutableArray *chatArray=[FLGlobalSettings sharedInstance].chatArr;
//
//       for (int x=0; x<[chatArray count]; x++)//update existing chat object
//   {
//       FLChat *chatObj=[chatArray objectAtIndex:x];
//       
//       if ([[NSString stringWithFormat:@"%@",chatObj.chatObj_id] isEqualToString:[NSString stringWithFormat:@"%@",chatObjID]])
//       {
//           chatObj.chat_last_msg_obj=[[FLChatMessage alloc] init];//updating existing obj
//           chatObj.chat_last_msg_obj.message=message;
//           chatObj.chat_last_msg_obj.username=chatObjName;
//           chatObj.chat_last_msg_obj.userID=chatObjID;
//           //hemalasankas**
//           chatObj.chat_last_msg_obj.user_imageURL=@"";
//           NSDate *now =  [NSDate date];  // assign your date to "now"
//           NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//           dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
//           NSString *hrDateString = [dateFormatter stringFromDate:now];
//           chatObj.chat_last_msg_obj.chatDateTime=hrDateString;
//           
//           [[NSNotificationCenter defaultCenter]
//            postNotificationName:RECEIVED_CHAT_UPDATE
//            object:self];
//           return;
//       }
//   }
//    
//    FLChat *chatObj=[[FLChat alloc] init];
//    chatObj.chatObj_id=chatObjID;
//    chatObj.chatObjName=chatObjName;
//    chatObj.is_online=YES;
//    chatObj.message_type=msgType;
//    
//    //hemalasankas**
//    chatObj.chatObj_image_url=@"";
//    
//    [[FLGlobalSettings sharedInstance].chatBubbleObjArr addObject:chatObj];
//    
//    
//    //add new chat object
////    FLChat *chatObj=[[FLChat alloc] init];
////    chatObj.username=username;
////    chatObj.uid=uid;
////    //hemalasankas**
////    chatObj.image_url=@"profilePic.png";
////    chatObj.is_online=YES;
////    if (chatObj.chatMessageArr==nil)
////    {
////        chatObj.chatMessageArr=[[NSMutableArray alloc] init];
////    }
////    //**
////    [chatObj.chatMessageArr addObject:chatMsgObj];
////    
////    [[FLGlobalSettings sharedInstance].chatArr addObject:chatObj];
//    
//    //if added new chat object load all past chats from web service
////    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
////    [webService userChatListForUser:self withUserID:uid];
//    //**
////    [[NSNotificationCenter defaultCenter]
////     postNotificationName:RECEIVED_CHAT_UPDATE
////     object:self];
//    
//}

- (void)updateGroupChatTable:(NSString *)message withUID:(NSString *)uid withUserName:(NSString *)username withGroupID:(NSString *)groupID withMsgType:(NSString *)msgType{
////    NSMutableArray *chahatArray=[FLGlobalSettings sharedInstance].groupChatArr;
//    FLChatMessage *chatMsgObj=[[FLChatMessage alloc] init];
//    chatMsgObj.message=message;
//    //hemalasankas**
//    NSDate *now =  [NSDate date];  // assign your date to "now"
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
//    NSString *hrDateString = [dateFormatter stringFromDate:now];
//    chatMsgObj.chatDateTime=hrDateString;
//    chatMsgObj.is_me=NO;
//    chatMsgObj.seen=YES;
//    chatMsgObj.sender_id=uid;//add sender id for each chat
//    for (int x=0; x<[[FLGlobalSettings sharedInstance].chatArr count]; x++)//update existing chat object
//    {
//        FLChat *chatObj=[[FLGlobalSettings sharedInstance].chatArr objectAtIndex:x];
//        
//        
//        if ([[NSString stringWithFormat:@"%@",chatObj.uid] isEqualToString:[NSString stringWithFormat:@"%@",groupID]])
//        {
//            [chatObj.chatMessageArr addObject:chatMsgObj];
//            
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:RECEIVED_CHAT_UPDATE
//             object:self];
//            return;
//        }
//    }
//    //add new chat object
//      FLChat *chatObj=[[FLChat alloc] init];
//      chatObj.username=username;
//      chatObj.uid=groupID;
//    chatObj.message_type=msgType;
//      //hemalasankas**
//      chatObj.image_url=@"profilePic.png";
//      chatObj.is_online=YES;
//      if (chatObj.chatMessageArr==nil)
//      {
//          chatObj.chatMessageArr=[[NSMutableArray alloc] init];
//      }
//      //**
//      [chatObj.chatMessageArr addObject:chatMsgObj];
//   
//      [[FLGlobalSettings sharedInstance].chatArr addObject:chatObj];
//   
////    //if added new chat object load all past chats from web service
////    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
////    [webService userChatListForUser:self withUserID:uid];
//    //**
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:RECEIVED_CHAT_UPDATE
//         object:self];
}

- (void)chatForUserResult:(FLChat *)chatObj{
    [[FLGlobalSettings sharedInstance].chatArr addObject:chatObj];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:RECEIVED_CHAT_UPDATE
     object:self];
}

- (void)chatUnsuscribe{
    PTPusherChannel *channel = [self.client channelNamed:[NSString stringWithFormat:@"%@-%@",PUSHER_CHANNEL_NAME_FOR_CHAT,[FLGlobalSettings sharedInstance].current_user_profile.uid]];
    [channel unsubscribe];
    [[FLGlobalSettings sharedInstance].chatArr removeAllObjects];
    self.client=nil;
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIViewController *)draggingCoordinator:(CHDraggingCoordinator *)coordinator viewControllerForDraggableView:(CHDraggableView *)draggableView
{
    
    for (FLChat *currentChatObj in [FLGlobalSettings sharedInstance].chatBubbleObjArr)
    {
        if ([currentChatObj.chatObj_id isEqualToString:[NSString stringWithFormat:@"%i",draggableView.tag]] && [currentChatObj.message_type isEqualToString:draggableView.chatType])
        {
            if ([currentChatObj.message_type isEqualToString:MSG_TYPE_GROUP])
            {
                FLChatGroupBubbleViewController *chatView = [[FLChatGroupBubbleViewController alloc] initWithNibName:(IS_IPHONE_5) ? @"FLChatGroupBubbleViewController-568h" : @"FLChatGroupBubbleViewController" bundle:nil];
                chatView.currentChatObj =  currentChatObj;
                return chatView;
            }
            else
            {
                FLChatBubbleViewController *chatView = [[FLChatBubbleViewController alloc] initWithNibName:(IS_IPHONE_5) ? @"FLChatBubbleViewController-568h" : @"FLChatBubbleViewController" bundle:nil];
                chatView.currentChatObj =  currentChatObj;
                return chatView;
            }
        }        
    }
    return nil;
}


#pragma mark- FLWebServiceDelegate method
#pragma mark-

-(void)heartBeatResult:(NSString *)last_seen{

    NSLog(@"last_seen_at %@",last_seen);
}

-(void)notificationListResult:(NSMutableArray *)notificationArr{
    [[FLGlobalSettings sharedInstance].notificationArr removeAllObjects];
    [FLGlobalSettings sharedInstance].notificationArr=notificationArr;
    
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi getGiftAllReceivedItems:self];
}

-(void)giftReceivedAllListResult:(NSMutableArray *)receivedGiftArr{
    for(FLNotication *notificationObj in [FLGlobalSettings sharedInstance].notificationArr)
    {
    if([notificationObj.notification_type isEqualToString:@"gift_received"])
    {
    for(FLGift *giftObj in receivedGiftArr)
    {
      
            if ([[NSString stringWithFormat:@"%@",giftObj.gift_id] isEqualToString:[NSString stringWithFormat:@"%@",notificationObj.notification_id]])
            {
                notificationObj.notification_type=giftObj.gift_name;
                
            }
    }
    }
    }
    
//    for(FLNotication *notificationObj in [FLGlobalSettings sharedInstance].notificationArr)
//    {
//        NSLog(@"notificationObj.notification_type....... %@",notificationObj.notification_type);
//    }
    
       [[NSNotificationCenter defaultCenter]
                 postNotificationName:RECEIVED_NEW_NOTIFICATION
                 object:self];
}



-(void)chatDataResult:(FLChat *)chatObj
{
    //chat bubble
    //hemalasanka** currently use only 6 bubbles group and private chat
    
    if([[NSString stringWithFormat:@"%@",chatObj.message_type] isEqualToString:[NSString stringWithFormat:@"%@",MSG_TYPE_PRIVATE]])
    {
    int bubble_index = [FLGlobalSettings sharedInstance].chatBubbleObjArr.count;
    if (bubble_index <= MAX_CHAT_BUBBLE)
    {
//        ((FLChatMessage *)[chatObj.chatMessageArr lastObject]).user_imageURL=chatObj.chatObj_image_url;
        
        chatObj.chatObj_image_url=((FLChatMessage *)[chatObj.chatMessageArr lastObject]).user_imageURL;
        
        
        NSDictionary* dict = @{@"chatObj" :chatObj};
        [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_CHAT_FOR_USER
                                                            object:self
                                                          userInfo:dict];
        [[FLGlobalSettings sharedInstance].chatBubbleObjArr addObject:chatObj];
        bubble_index++;
        ///////////////////////////////////////////////////////////////////
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
        NSString *imgNameWithPath = [chatObj.chatObj_image_url stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
        NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
        
        
       //download profile picture
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:profilePicUrl];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if ( !error )
                                   {
                                       UIImage *image = [[UIImage alloc] initWithData:data];
                                       CHDraggableView *draggableView = [CHDraggableView draggableViewWithImage:image];
                                       
//                                       draggableView.tag=bubble_index;
                                       draggableView.tag=[chatObj.chatObj_id integerValue];
                                    
                                       draggableView.chatType=MSG_TYPE_PRIVATE;
                                       switch (bubble_index) {
                                           case 1:
                                               _draggingCoordinator1 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator1.delegate = self;
                                               _draggingCoordinator1.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator1;
                                               break;
                                           case 2:
                                               _draggingCoordinator2 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator2.delegate = self;
                                               _draggingCoordinator2.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator2;
                                               break;
                                           case 3:
                                               _draggingCoordinator3 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator3.delegate = self;
                                               _draggingCoordinator3.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator3;
                                               break;
                                           case 4:
                                               _draggingCoordinator4 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator4.delegate = self;
                                               _draggingCoordinator4.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator4;
                                               break;
                                           case 5:
                                               _draggingCoordinator5 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator5.delegate = self;
                                               _draggingCoordinator5.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator5;
                                               break;
                                           case 6:
                                               _draggingCoordinator6 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator6.delegate = self;
                                               _draggingCoordinator6.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator6;
                                               break;
                                           default:
                                               break;
                                       }
                                       [[[self.window subviews] objectAtIndex:0] addSubview:draggableView];
                                   }
                               }];
        ////////////////////////////////////////////////////////////
    }
    }
    else
    {
        NSDictionary* dict = @{@"chatObj" :chatObj};
        [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_CHAT_FOR_GROUP
                                                            object:self
                                                          userInfo:dict];
    }
}

-(void)chatGroupDataResult:(FLChat *)chatObj
{
    
   
    //chat bubble
    //hemalasanka** currently use only 6 bubbles group and private chat
    
    
    int bubble_index = [FLGlobalSettings sharedInstance].chatBubbleObjArr.count;
    if (bubble_index <= MAX_CHAT_BUBBLE)
    {
        NSDictionary* dict = @{@"chatObj" :chatObj};
        [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_CHAT_FOR_GROUP
                                                            object:self
                                                          userInfo:dict];
        [[FLGlobalSettings sharedInstance].chatBubbleObjArr addObject:chatObj];
        bubble_index++;
        ///////////////////////////////////////////////////////////////////
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
        NSString *imgNameWithPath = [chatObj.chatObj_image_url stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
        NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
        
        
        //download profile picture
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:profilePicUrl];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if ( !error )
                                   {
                                       UIImage *image = [[UIImage alloc] initWithData:data];
                                       CHDraggableView *draggableView = [CHDraggableView draggableViewWithImage:image];
                                       
                                       //                                       draggableView.tag=bubble_index;
                                       draggableView.tag=[chatObj.chatObj_id integerValue];
                                       
                                       draggableView.chatType=MSG_TYPE_GROUP;
                                       switch (bubble_index) {
                                           case 1:
                                               _draggingCoordinator1 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator1.delegate = self;
                                               _draggingCoordinator1.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator1;
                                               break;
                                           case 2:
                                               _draggingCoordinator2 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator2.delegate = self;
                                               _draggingCoordinator2.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator2;
                                               break;
                                           case 3:
                                               _draggingCoordinator3 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator3.delegate = self;
                                               _draggingCoordinator3.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator3;
                                               break;
                                           case 4:
                                               _draggingCoordinator4 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator4.delegate = self;
                                               _draggingCoordinator4.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator4;
                                               break;
                                           case 5:
                                               _draggingCoordinator5 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator5.delegate = self;
                                               _draggingCoordinator5.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator5;
                                               break;
                                           case 6:
                                               _draggingCoordinator6 = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
                                               _draggingCoordinator6.delegate = self;
                                               _draggingCoordinator6.snappingEdge = CHSnappingEdgeBoth;
                                               draggableView.delegate = _draggingCoordinator6;
                                               break;
                                           default:
                                               break;
                                       }
                                       [[[self.window subviews] objectAtIndex:0] addSubview:draggableView];
                                   }
                               }];
        ////////////////////////////////////////////////////////////
    }
}

#pragma mark- FLWebServiceDelegate Fail
#pragma mark-

-(void)unknownFailureCall{
    NSLog(@"unknownFailureCall");
}

-(void)requestFailCall:(NSString *)errorMsg{
    NSLog(@"requestFailCall %@",errorMsg);
}


@end


/*
 
 if ([FLGlobalSettings sharedInstance].current_user_profile.image!=nil && [[FLGlobalSettings sharedInstance].current_user_profile.image length]>0)
 {
 
 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
 FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
 //get profile pic name without "http://flingoo.s3.amazonaws.com/"
 NSArray* foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
 NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
 
 NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
 
 
 
 
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
 dispatch_async(queue, ^{
 
 NSData * imageData = [NSData dataWithContentsOfURL:profilePicUrl];
 dispatch_async(dispatch_get_main_queue(), ^{
 UIImage *image = [UIImage imageWithData:imageData];
 cell.imgProfilePic.image=image;
 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
 });
 });
 
 }
 
 */


