//
//  FLGlobalSettings.m
//  Flingoo
//
//  Created by Hemal on 11/14/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLGlobalSettings.h"

@implementation FLGlobalSettings
@synthesize current_user;
@synthesize current_user_profile;
@synthesize chatArr;
@synthesize matchListArr;
@synthesize interviewQuestionListArr;
@synthesize notificationArr;
@synthesize tempFacebookImgUrl;
@synthesize tempAddress;
//@synthesize groupChatArr;
@synthesize profileVisitorsArr;
@synthesize settingObj;
@synthesize chatBubbleObjArr;

+(FLGlobalSettings *)sharedInstance
{
    static FLGlobalSettings *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FLGlobalSettings alloc] init];
            
    });
    return _sharedInstance;
}

@end
