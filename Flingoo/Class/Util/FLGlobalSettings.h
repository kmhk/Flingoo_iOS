//
//  FLGlobalSettings.h
//  Flingoo
//
//  Created by Hemal on 11/14/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLUser.h"
#import "FLProfile.h"
#import "FLSetting.h"

@interface FLGlobalSettings : NSObject
+(FLGlobalSettings *)sharedInstance;
@property(nonatomic,strong) FLUser *current_user;
@property(nonatomic,strong) FLProfile *current_user_profile;

//chat list array
@property(nonatomic,strong) NSMutableArray *chatArr;//store only one chat message object in chat array

//group chat list array
//@property(nonatomic,strong) NSMutableArray *groupChatArr;

//Match list array
@property(nonatomic,strong) NSMutableArray *matchListArr;

//initial interview question list array
@property(nonatomic,strong) NSMutableArray *interviewQuestionListArr;

//all notification array
@property(nonatomic,strong) NSMutableArray *notificationArr;

//Profile visitors
@property(nonatomic,strong) NSMutableArray *profileVisitorsArr;

//currnt user settings object
@property(nonatomic,strong) FLSetting *settingObj;

//chat bubble obj arr
@property(nonatomic,strong) NSMutableArray *chatBubbleObjArr;

//temp value
@property(nonatomic,strong) NSString *tempFacebookImgUrl;

@property(nonatomic,strong) NSString *tempAddress;


@end
