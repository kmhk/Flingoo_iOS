//
//  FLWebServiceApi.m
//  Flingoo
//
//  Created by Hemal on 11/12/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLWebServiceApi.h"
#import "AFNetworking.h"
#import "Config.h"
#import "FLAPIClient.h"
//#import "Reachability.h"
#import "FLGlobalSettings.h"
#import "FLMe.h"
#import "FLCreatedGroup.h"
#import "FLMeetpoint.h"
#import <AWSRuntime/AWSRuntime.h>
#import "FLUtilUserDefault.h"
#import "FLOtherProfile.h"
#import "FLRadarObject.h"
#import "FLChat.h"
#import "FLChatMessage.h"
#import "FLSetting.h"
#import "FLGiftItem.h"
#import "FLNotication.h"
#import "FLUtil.h"
#import "FLGift.h"
#import "FLCreditPlan.h"
#import "FLMembershipPlan.h"

typedef enum {
    CREATE_USER=1,
    CREATE_USER_FACEBOOK,
    SIGNIN_USER,
    FORGOT_PASSWORD,
    NETWORK_ERROR,
    PROFILE_UPDATE,
    CURRENT_USER,
    CURRENT_USER_PROFILE,
    SIGNOUT,
    PROFILE_SEARCH,
    USER_LOCATION,
    CREATE_FRIENDSHIP,
    LISTING_FRIENDSHIP,
    ACCEPT_FRIENDSHIP,
    REJECT_FRIENDSHIP,
    FRIENDSHIP_FRIEND_LIST,
    FAVOURITE_ADD_FRIENDSHIP,
    FAVOURITE_LISTING_FRIENDSHIP,
    FAVOURITE_REMOVE_FRIENDSHIP,
    GROUP_CREATE,
    GROUP_LIST_ALL,
    GROUP_SHOW,
    GROUP_UPDATE,
    GROUP_ADD_USER,
    GROUP_REMOVE_USER,
    GROUP_OWNED,
    MEET_POINT_CREATE,
    MEET_POINT_OWNED,
    MEET_POINT_LIST_ALL,
    TAXI_POINT_CREATE,
    RADAR_SEARCH,
    HEARTBEAT,
    USER_SHOW,
    STATUS_UPDATE,
    PROFILE_VISITORS,
    PROFILE_VISITS,
    CHAT_SEND,
    IMAGE_UPLOAD,
    CREATE_ALBUM,
    ALBUM_LIST,
    DELETE_ALBUM,
    ALBUM_PHOTO_UPLOAD,
    ALBUM_PHOTO_LIST,
    DELETE_PHOTO,
    INTERVIEW_QUSTION_LIST,
    INTERVIEW_QUESTION_UPDATE,
    USERS_ALBUM_LIST,
    USERS_ALBUM_PHOTO_LIST,
    PROFILE_PICTURE_ALBUM,
    MATCH_USERS,
    LOCATION_POINT_CREATE,
    LOCATION_POINT_CHECK_IN,
    LIKE_TO_USER,
    UNLIKE_TO_USER,
    LIKE_USER_LIST,
    BLOCK_USER,
    UNBLOCK_USER,
    IMAGE_UPLOAD_TO_DIR,
    PROFILE_PiCTURE_LIST,
    USER_CHATS,//List of recent conversations
    USER_CHATS_FOR_USERS,
    FINDME,
    MOMENT,
    GET_CREDITS,
    CREDIT_PLANS,
    GET_VIP_MEMBERSHIP_LIST,
    VIP_MEMBERSHIP_PLAN_LIST,
    SEND_PAYMENT,
    GIFT_ITEM_LIST,
    GIFT_KESSES_LIST,
    GIFT_DRINKS_LIST,
    GIFT_RECEIVED_ALL,
    GIFT_RECEIVED_KISSES,
    GIFT_RECEIVED_DRINKS,
    GIFT_SEND,
    USER_SETTING_LIST,
    USER_SETTING_UPDATE,
    NOTIFICATION_LIST,
    NOTIFICATION_UPDATE,
    EYE_CATCHER,
    EYE_CATCHER_PROFILE_LIST,
    CHAT_DATA,
    CHAT_GROUP_DATA,
    GROUP_CHAT_HISTORY,
    UPDATE_PASSWORD,
    BLOCKED_USERS
} RequestType;


@implementation FLWebServiceApi
@synthesize delegate;

#pragma mark -
#pragma mark - Requesting methods

-(void)createUser:(id)_delegate withUserData:(NSDictionary *)userData
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    NSDictionary *params = @{
                             @"user" : userData
                             };
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CREATE_USER] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CREATE_USER %@", JSON);
        [self requestFinished:JSON withType:CREATE_USER];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        
        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        NSLog(@"CREATE_USER requestFail %@",JSON);
        if (status_code==CREATE_USER_FAIL_STATUS_CODE)
            {
            [self requestFail:JSON withType:CREATE_USER];
            }
        else
            {
            [self unknownFailure];
            }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)createUserFB:(id)_delegate withUserData:(NSDictionary *)userData
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    NSDictionary *params = @{
                             @"user" : userData
                             };
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSLog(@"params %@",params);
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CREATE_USER_FACEBOOK] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        
        
        
        NSLog(@"CREATE_USER_FACEBOOK %@", JSON);
        /* //current response
         CREATE_USER_FACEBOOK {
         user =     {
         "auth_token" = "81oHs_c6pvLxNtnP7Y7U";
         email = "email1@gmail.com";
         success = 1;
         };
         }
         */
        
        NSDictionary *userRegistrationDic = [JSON objectForKey:@"user"];
        if ([[userRegistrationDic objectForKey:@"success"] boolValue])
            {
            [FLUtilUserDefault setUsername:[userData objectForKey:@"email"]];
            [FLUtilUserDefault setFBAuthToken:[userData objectForKey:@"access_token"]];
            [FLGlobalSettings sharedInstance].tempFacebookImgUrl=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=360&height=360",[userData objectForKey:@"access_token"]];
            }
        
        
        [self requestFinished:JSON withType:CREATE_USER_FACEBOOK];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        
        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==CREATE_USER_FAIL_STATUS_CODE)
        //        {
        NSLog(@"CREATE_USER_FACEBOOK requestFail %@",JSON);
        [self requestFail:JSON withType:CREATE_USER_FACEBOOK];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)signinUser:(id)_delegate withUserData:(NSDictionary *)userData
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    NSDictionary *params = @{
                             @"user" : userData
                             };
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_SIGNIN_USER] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"SIGNIN_USER %@", JSON);
        [self requestFinished:JSON withType:SIGNIN_USER];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        
        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        NSLog(@"SIGNIN_USER requestFail %@",JSON);
        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
            {
            [self requestFail:JSON withType:SIGNIN_USER];
            }
        else
            {
            [self unknownFailure];
            }
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)forgotPassword:(id)_delegate withEmail:(NSString *)emailAddress
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params = @{
                             @"email" : emailAddress
                             };
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_FORGOT_PASSWORD] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FORGOT_PASSWORD %@", JSON);
        [self requestFinished:JSON withType:FORGOT_PASSWORD];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        NSLog(@"FORGOT_PASSWORD requestFail %@",JSON);
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:FORGOT_PASSWORD];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)profileUpdate:(id)_delegate withUserData:(FLUserDetail *)userData
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    NSDictionary *params = @{
                             @"profile" : [userData getUserDetailJsonObj:userData]
                             };
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"PUT" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_PROFILE_UPDATE] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_UPDATE %@", JSON);
        [self requestFinished:JSON withType:PROFILE_UPDATE];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_UPDATE requestFail %@",JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:PROFILE_UPDATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)currentUser:(id)_delegate
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CURRNT_USER] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CURRENT_USER %@", JSON);
        [self requestFinished:JSON withType:CURRENT_USER];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CURRENT_USER requestFail %@",JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:CURRENT_USER];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

//-(void)currentUserProfileDetail:(id)_delegate//(PLEASE USE /users/me INSTEAD)
//{
//    self.delegate =_delegate;
//
//    if (![self isInternetAvailable])
//    {
//        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
//        return;
//    }
//
//    FLAPIClient *client = [FLAPIClient sharedClient];
//    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
//
//    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
//    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
//
//    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CURRNT_USER_PROFILE] parameters:nil];
//
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        // code for successful return goes here
//        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
//
//        NSLog(@"CURRENT_USER_PROFILE %@", JSON);
//        [self requestFinished:JSON withType:CURRENT_USER_PROFILE];
//
//        // do something with return data
//    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        // code for failed request goes here
//        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
//
//
//        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
//        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
//        //        {
//        [self requestFail:JSON withType:CURRENT_USER_PROFILE];
//        //        }
//        //        else
//        //        {
//        //            [self unknownFailure];
//        //        }
//
//
//        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
//
//        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
//        //        NSLog(@"testtest %@",test);
//        // do something on failure
//    }];
//
//    [operation start];
//}


-(void)signOutUser:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_SIGNOUT_USER] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"SIGNOUT %@", JSON);
        [self requestFinished:JSON withType:SIGNOUT];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"SIGNOUT requestFail %@", JSON);
        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        if (status_code==500)
            {
            [self requestFail:JSON withType:SIGNOUT];
            }
        else
            {
            [self unknownFailure];
            }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)profileSearch:(id)_delegate withUserData:(FLProfileSearch *)profileSearchData
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    //    NSLog(@"params %@",profileSearchData);
    //    NSDictionary *params =[[profileSearchData getProfileSearchJsonObj:profileSearchData] copy];
    NSDictionary *params =[profileSearchData getProfileSearchJsonObj:profileSearchData];
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_PROFILE_SEARCH] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_SEARCH %@", JSON);
        [self requestFinished:JSON withType:PROFILE_SEARCH];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_SEARCH requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:PROFILE_SEARCH];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)userLocationSet:(id)_delegate withUserData:(FLUserLocation *)userLocationData
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params =@{@"location" : [userLocationData getUserLocationJsonObj:userLocationData]};
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_SET_LOCATION] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_LOCATION %@", JSON);
        [self requestFinished:JSON withType:USER_LOCATION];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_LOCATION requestFail %@", JSON);
        
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:USER_LOCATION];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)createFriendship:(id)_delegate withUserData:(FLFriendship *)friendshipData
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params =@{@"friendship":[friendshipData getFriendshipJsonObj:friendshipData]};
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CREATE_FRIENDSHIPS] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CREATE_FRIENDSHIP %@", JSON);
        [self requestFinished:JSON withType:CREATE_FRIENDSHIP];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CREATE_FRIENDSHIP requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:CREATE_FRIENDSHIP];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)friendshipRequestListing:(id)_delegate//List of received pending friend requests for the current user
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_FRIENDSHIP_REQUESTS_LISTING] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"LISTING_FRIENDSHIP %@", JSON);
        [self requestFinished:JSON withType:LISTING_FRIENDSHIP];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"LISTING_FRIENDSHIP requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:LISTING_FRIENDSHIP];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)friendshipAccept:(id)_delegate withFriendshipId:(NSString *)friendshipId
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@%@/accept",WEBSERVICE_DOMAIN_URL,WEBSERVICE_FRIENDSHIP,friendshipId] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"ACCEPT_FRIENDSHIP %@", JSON);
        [self requestFinished:JSON withType:ACCEPT_FRIENDSHIP];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"ACCEPT_FRIENDSHIP requestFail %@", JSON);
        
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:ACCEPT_FRIENDSHIP];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)friendshipReject:(id)_delegate withFriendshipId:(NSString *)friendshipId
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@%@/reject",WEBSERVICE_DOMAIN_URL,WEBSERVICE_FRIENDSHIP,friendshipId] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"REJECT_FRIENDSHIP %@", JSON);
        [self requestFinished:JSON withType:REJECT_FRIENDSHIP];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"REJECT_FRIENDSHIP requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:REJECT_FRIENDSHIP];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)friendshipFriendList:(id)_delegate//List of accepted friendships for the current user
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CREATE_FRIENDSHIPS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FRIENDSHIP_FRIEND_LIST %@", JSON);
        [self requestFinished:JSON withType:FRIENDSHIP_FRIEND_LIST];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FRIENDSHIP_FRIEND_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:FRIENDSHIP_FRIEND_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)favouriteAdd:(id)_delegate withFriendshipId:(NSString *)friendshipId
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@%@/favourite",WEBSERVICE_DOMAIN_URL,WEBSERVICE_FRIENDSHIP,friendshipId] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FAVOURITE_ADD_FRIENDSHIP %@", JSON);
        [self requestFinished:JSON withType:FAVOURITE_ADD_FRIENDSHIP];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FAVOURITE_ADD_FRIENDSHIP requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:FAVOURITE_ADD_FRIENDSHIP];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)favouriteListing:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_FAVOURITE_LISTING_FRIENDSHIP] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FAVOURITE_LISTING_FRIENDSHIP %@", JSON);
        [self requestFinished:JSON withType:FAVOURITE_LISTING_FRIENDSHIP];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FAVOURITE_LISTING_FRIENDSHIP requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:FAVOURITE_LISTING_FRIENDSHIP];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)favouriteRemove:(id)_delegate withFriendshipId:(NSString *)friendshipId
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@%@/unfavourite",WEBSERVICE_DOMAIN_URL,WEBSERVICE_FRIENDSHIP,friendshipId] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FAVOURITE_REMOVE_FRIENDSHIP %@", JSON);
        [self requestFinished:JSON withType:FAVOURITE_REMOVE_FRIENDSHIP];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FAVOURITE_REMOVE_FRIENDSHIP requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:FAVOURITE_REMOVE_FRIENDSHIP];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)groupCreate:(id)_delegate withGroupObj:(FLGroup *)groupObj
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params = @{
                             @"group" : [groupObj getGroupJsonObj:groupObj]
                             };
    
    //    ///
    //    {
    //        group =     {
    //            description = "This is Test Group";
    //            "group_memberships_attributes" =         (
    //                                                      {
    //                                                          "user_id" = 26;
    //                                                      },
    //                                                      {
    //                                                          "user_id" = 27;
    //                                                      }
    //                                                      );
    //            image = "test.png";
    //            name = "Test Group12";
    //        };
    //    }
    //    ///
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GROUP] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_CREATE %@", JSON);
        if ([[JSON objectForKey:@"success"] boolValue])
            {
            
            [self requestFinished:groupObj withType:GROUP_CREATE];
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",JSON);
            }
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_CREATE requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GROUP_CREATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

//
-(void)showGroup:(id)_delegate withGroupId:(NSString *)groupId
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSLog(@"AUTH %@", [FLGlobalSettings sharedInstance].current_user.auth_token);
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@/%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GROUP,groupId] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_SHOW %@", JSON);
        [self requestFinished:JSON withType:GROUP_SHOW];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_SHOW requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GROUP_UPDATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}
//


-(void)groupUpdate:(id)_delegate withGroupObj:(FLGroup *)groupObj withGroupID:(NSString *)groupID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params = @{
                             @"group" : [groupObj getGroupJsonObj:groupObj]
                             };
    
    NSLog(@"GROUP TO SubMIT %@", params);
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"PUT" path:[NSString stringWithFormat:@"%@%@/%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GROUP,groupID] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_UPDATE %@", JSON);
        [self requestFinished:JSON withType:GROUP_UPDATE];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_UPDATE requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GROUP_UPDATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)groupUserUpdate:(id)_delegate withUserIDs:(NSArray *)userIDsArr withGroupID:(NSString *)groupID//not working
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    //    {
    //        "users": [{
    //            "user": { "id": 5}  //I create object like that
    //        }]
    //    }
    
    NSMutableArray *userArr=[[NSMutableArray alloc] init];
    for (id userID in userIDsArr)
        {
        NSDictionary *userDic=@{@"id" : userID};
        [userArr addObject:userDic];
        }
    
    NSDictionary *user=@{@"user" : userArr};
    NSArray *arr=[[NSArray alloc] initWithObjects:user, nil];
    NSDictionary *params = @{
                             @"users" : arr
                             };
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@/%@/add_users",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GROUP,groupID] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_ADD_USER %@", JSON);
        [self requestFinished:JSON withType:GROUP_ADD_USER];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_ADD_USER requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GROUP_ADD_USER];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)groupUserRemove:(id)_delegate withUserIDs:(NSArray *)userIDsArr withGroupID:(NSString *)groupID//not working
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    //    {
    //        "users": [{
    //            "user": { "id": 5}  //I create object like that
    //        }]
    //    }
    
    NSMutableArray *userArr=[[NSMutableArray alloc] init];
    for (id userID in userIDsArr)
        {
        NSDictionary *userDic=@{@"id" : userID};
        [userArr addObject:userDic];
        }
    
    NSDictionary *user=@{@"user" : userArr};
    NSArray *arr=[[NSArray alloc] initWithObjects:user, nil];
    NSDictionary *params = @{
                             @"users" : arr
                             };
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@/%@/remove_users",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GROUP,groupID] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_REMOVE_USER %@", JSON);
        [self requestFinished:JSON withType:GROUP_REMOVE_USER];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_REMOVE_USER requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GROUP_REMOVE_USER];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)groupsOwend:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GROUP_OWNED] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_OWNED %@", JSON);
        [self requestFinished:JSON withType:GROUP_OWNED];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_OWNED requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GROUP_OWNED];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)groupListAll:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GROUP] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_LIST_ALL %@", JSON);
        [self requestFinished:JSON withType:GROUP_LIST_ALL];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_LIST_ALL requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GROUP_LIST_ALL];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)meetPointCreate:(id)_delegate withMeetPointObj:(FLMeetpoint *)meetPointObj
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params = [meetPointObj getMeetPointJsonObj:meetPointObj];
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_MEET_POINT] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"MEET_POINT_CREATE %@", JSON);
        
        //            /////
        //            MEET_POINT_CREATE {
        //                message = "Meet point was successfully created";
        //                success = 1;
        //            }
        //            /////
        if ([[JSON objectForKey:@"success"] boolValue])
            {
            [self requestFinished:meetPointObj withType:MEET_POINT_CREATE];
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",JSON);
            }
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"MEET_POINT_CREATE requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:MEET_POINT_CREATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)meetPointOwend:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_MEET_POINT_OWNED] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"MEET_POINT_OWNED %@", JSON);
        [self requestFinished:JSON withType:MEET_POINT_OWNED];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"MEET_POINT_OWNED requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:MEET_POINT_OWNED];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)meetpointListAll:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_MEET_POINT] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"MEET_POINT_LIST_ALL %@", JSON);
        [self requestFinished:JSON withType:MEET_POINT_LIST_ALL];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"MEET_POINT_LIST_ALL requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:MEET_POINT_LIST_ALL];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)taxiPointCreate:(id)_delegate withGroupObj:(FLTaxiPoint *)taxipointObj
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params = @{
                             @"taxi_point" : [taxipointObj getTaxipointDic:taxipointObj]
                             };
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_TAXI_POINT_CREATE] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"TAXI_POINT_CREATE %@", JSON);
        [self requestFinished:JSON withType:TAXI_POINT_CREATE];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"TAXI_POINT_CREATE requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:TAXI_POINT_CREATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)radarSearch:(id)_delegate withRadar:(FLRadar *)userRadar
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params=[userRadar getRadarJsonObj:userRadar];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_RADAR_SEARCH] parameters:params];
    NSLog(@"params %@",params);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"RADAR_SEARCH %@", JSON);
        [self requestFinished:JSON withType:RADAR_SEARCH];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"RADAR_SEARCH requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:RADAR_SEARCH];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)heartbeatNotify:(id)_delegate
{
    self.delegate =_delegate;
    
    if ([FLGlobalSettings sharedInstance].current_user.auth_token==nil || [[FLGlobalSettings sharedInstance].current_user.auth_token length]==0) {
        return;
    }
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_HEARTBEAT] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"HEARTBEAT %@", JSON);
        [self requestFinished:JSON withType:HEARTBEAT];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"HEARTBEAT requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:HEARTBEAT];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
    
    
}


-(void)statusUpdate:(id)_delegate withStatusTxt:(NSString *)txt_status
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params = @{
                             @"status" : @{@"text" : txt_status}
                             };
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_STATUS_UPDATE] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"STATUS_UPDATE %@", JSON);
        [self requestFinished:JSON withType:STATUS_UPDATE];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"STATUS_UPDATE requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:STATUS_UPDATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)userShow:(id)_delegate withUserID:(NSString *)userID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USERS_SHOW,userID] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_SHOW %@", JSON);
        [self requestFinished:JSON withType:USER_SHOW];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_SHOW requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:USER_SHOW];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)profileVisitors:(id)_delegate
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_PROFILE_VISITORS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_VISITORS %@", JSON);
        [self requestFinished:JSON withType:PROFILE_VISITORS];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_VISITORS requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:PROFILE_VISITORS];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)profileVisits:(id)_delegate
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_PROFILE_VISITS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_VISITS %@", JSON);
        [self requestFinished:JSON withType:PROFILE_VISITS];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_VISITS requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:PROFILE_VISITS];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)chatSend:(id)_delegate withMessage:(NSString *)message withReceiverID:(NSString *)receiverID withType:(NSString *)message_type
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{
                             @"message" : @{@"text" : message,@"receiver" : receiverID, @"message_type": message_type}
                             };
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CHAT_SEND] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CHAT_SEND %@", JSON);
        [self requestFinished:JSON withType:CHAT_SEND];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CHAT_SEND requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:CHAT_SEND];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}




//-(void)uploadImage:(NSData *)imgData withDirectoryName:(NSString *)directoryName withImgExtention:(NSString *)imgExtention{
//
//
//    NSString *uuid = [[NSUUID UUID] UUIDString];
//    //    NSString *userId= [[FLGlobalSettings sharedInstance] current_user]!=nil?([[FLGlobalSettings sharedInstance] current_user]).userID:@"";//once create curent user object must have to give userID for that object
//    NSString *userId=@"26";
//    NSString *imgName=userId!=nil?[NSString stringWithFormat:@"%@-%@.%@",userId,uuid,imgExtention]:[NSString stringWithFormat:@"%@.%@",uuid,imgExtention];
//
//    //    NSString *imgName=@"101-223232-2323232-232323-54545454.png";
//
//
//
//    AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",WEBSERVICE_IMAGE_UPLOAD]]];
//    [client setDefaultHeader:@"access_key_id" value:S3_ACCESS_KEY_ID];
//    [client setDefaultHeader:@"secret_access_key" value:S3_SECRET_ACCESS_KEY];
//    [client setDefaultHeader:@"region" value:S3_REGION];
//    [client setDefaultHeader:@"bucket" value:S3_BUCKET];
//    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
//    [client setDefaultHeader:@"Accept" value:@"application/json"];
//    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
//    [client setDefaultHeader:@"Accept" value:@"application/vnd.flingoo.v1"];
//
//
//    //    NSString *str=[FLGlobalSettings sharedInstance].current_user.auth_token;
//    //    NSDictionary *dic=@{@"access_key_id":S3_ACCESS_KEY_ID,
//    //                         @"secret_access_key":S3_SECRET_ACCESS_KEY,
//    //                        @"region":S3_REGION,
//    //                        @"bucket":S3_BUCKET,
//    //    @"X-AUTH-TOKEN":str
//    //    };
//
//
//
//
//
//    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"PUT" path:[NSString stringWithFormat:@"/%@",directoryName] parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//        [formData appendPartWithFileData:imgData name:@"file" fileName:imgName mimeType:@"image/png"];
//    }];
//
//
//
//
//    //        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
//
//
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite){
//        CGFloat progress = (totalBytesWritten * 1.0)/ totalBytesExpectedToWrite;
//        NSLog(@"%f", progress);
//    }];
//
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *response = [operation responseString];
//        NSLog(@"response: [%@]",response);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if([operation.response statusCode] == 403){
//            NSLog(@"Upload Failed %@",operation.description);
//            return;
//        }
//        NSLog(@"error: %@", [operation error]);
//
//    }];
//
//    [operation start];
//}


-(void)uploadImage:(id)_delegate withImgObj:(FLImgObj *)imgObj
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (self.s3==nil)
        {
        self.s3 = [[AmazonS3Client alloc] initWithAccessKey:S3_ACCESS_KEY_ID withSecretKey:S3_SECRET_ACCESS_KEY];
        self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_EAST_1];
        }
    
    [self performSelectorInBackground:@selector(processBackgroundThreadUploadInBackground:)
                           withObject:imgObj];
    
}

- (void)processBackgroundThreadUploadInBackground:(FLImgObj *)imgObj
{
    
    // Upload image data.  Remember to set the content type.
    NSString *imageKey;
    if ([imgObj.folder_name isEqualToString:IMAGE_DIRECTORY_ALBUM]) {//upload album photos
        imageKey=[NSString stringWithFormat:@"%@%@/%@",imgObj.folder_name,imgObj.albumID,imgObj.imageName];
    }
    else//upload groups , profile pictures & meet point
        {
        imageKey=[NSString stringWithFormat:@"%@/%@",imgObj.folder_name,imgObj.imageName];
        }
    
    
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imageKey inBucket:S3_BUCKET];
    por.contentType = imgObj.imgContentType;
    por.data        = imgObj.imgData;
    
    // Put the image data into the specified s3 bucket and object.
    S3PutObjectResponse *putObjectResponse = [self.s3 putObject:por];
    //    [self performSelectorOnMainThread:@selector(showCheckErrorMessage:)
    //                           withObject:putObjectResponse.error
    //                        waitUntilDone:NO];
    if(putObjectResponse.error != nil)
        {
        NSLog(@"Image Upload Error: %@", putObjectResponse.error);
        [self requestFail:putObjectResponse.error withType:IMAGE_UPLOAD];
        }
    else
        {
        NSLog(@"The image was successfully uploaded.");
        //        if ([imgObj.folder_name isEqualToString:IMAGE_DIRECTORY_PROFILE]) {
        
        [self requestFinished:imgObj withType:IMAGE_UPLOAD];
        
        //            FLUserDetail *userDetail=[[FLUserDetail alloc] init];
        //            userDetail.imageNameProfile=imgObj.imageName;
        //            userDetail.full_name=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
        //             userDetail.birth_date=[FLGlobalSettings sharedInstance].current_user_profile.birth_date;
        //            [self profileUpdate:self withUserData:userDetail];
        
        
        //        }
        }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(NSURL *)getImageFromName:(NSString *)imgName
{
    
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return nil;
        }
    
    //        if (self.s3==nil)
    //        {
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:S3_ACCESS_KEY_ID withSecretKey:S3_SECRET_ACCESS_KEY];
    s3.endpoint = [AmazonEndpoints s3Endpoint:US_EAST_1];
    //        }
    
    // Set the content type so that the browser will treat the URL as an image.
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    override.contentType = @"image/jpeg";
    
    // Request a pre-signed URL to picture that has been uplaoded.
    S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
    gpsur.key                     = imgName;
    gpsur.bucket                  = S3_BUCKET;
    gpsur.expires                 = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 31536000];
    
    //        gpsur.expires                 = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600]; // Added an hour's worth of seconds to the current time.
    //    //max =>> 31536000
    gpsur.responseHeaderOverrides = override;
    
    // Get the URL
    NSError *error = nil;
    NSURL *url = [s3 getPreSignedURL:gpsur error:&error];
    NSLog(@"urlurl %@",url);
    
    return url;
    //        if(url == nil)
    //        {
    //            if(error != nil)
    //            {
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                    NSLog(@"Error: %@", error);
    //                    [self showAlertMessage:[error.userInfo objectForKey:@"message"] withTitle:@"Browser Error"];
    //                });
    //            }
    //        }
    //        else
    //        {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                // Display the URL in Safari
    //                [[UIApplication sharedApplication] openURL:url];
    //            });
    //        }
    
}



-(void)createAlbum:(id)_delegate withAlbumObj:(FLAlbum *)albumObj
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSDictionary *params =[albumObj getAlbumJsonObj:albumObj];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_ALBUM] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CREATE_ALBUM %@", JSON);
        
        /////////////////////////////
        
        
        
        if ([[JSON objectForKey:@"success"] boolValue])
            {
            albumObj.albumID=[JSON objectForKey:@"id"];
            albumObj.photoObjArr=[[NSMutableArray alloc] init];
            
            [self requestFinished:albumObj withType:CREATE_ALBUM];
            
            }
        
        
        /////////////////////////////
        
        
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CREATE_ALBUM requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:CREATE_ALBUM];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)albumList:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_ALBUM] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"ALBUM_LIST %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:ALBUM_LIST];
        
        /////////////////////////////
        
        
        
        
        
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"ALBUM_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:ALBUM_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)albumDelete:(id)_delegate withAlbumID:(NSString *)albumID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"%@%@/%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_ALBUM,albumID] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"DELETE_ALBUM %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:DELETE_ALBUM];
        
        /////////////////////////////
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"DELETE_ALBUM requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:DELETE_ALBUM];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)uploadAlbumImage:(id)_delegate withAlbumObj:(FLPhoto *)photoObj
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSDictionary *params =[photoObj getPhotoJsonObj:photoObj];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@/%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_ALBUM,photoObj.albumID,WENSERVICE_ALBUMPHOTO_UPLOAD] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"ALBUM_PHOTO_UPLOAD %@", JSON);
        
        /////////////////////////////
        
        
        
        
        if ([[JSON objectForKey:@"success"] boolValue])
            {
            
            photoObj.imgID=[JSON objectForKey:@"id"];
            
            [self requestFinished:photoObj withType:ALBUM_PHOTO_UPLOAD];
            
            }
        
        
        /////////////////////////////
        
        
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"ALBUM_PHOTO_UPLOAD requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:ALBUM_PHOTO_UPLOAD];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)albumPhotoList:(id)_delegate withAlbumID:(NSString *)albumID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@/%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_ALBUM,albumID] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"ALBUM_PHOTO_LIST %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:ALBUM_PHOTO_LIST];
        
        /////////////////////////////
        
        
        
        
        
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"ALBUM_PHOTO_LIST requestFail %@",JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:ALBUM_PHOTO_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)photoDelete:(id)_delegate withAlbumID:(NSString *)albumID withPhotoID:(NSString *)photoID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"%@%@/%@%@/%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_ALBUM,albumID,WENSERVICE_ALBUMPHOTO_UPLOAD,photoID] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"DELETE_PHOTO %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:DELETE_PHOTO];
        
        /////////////////////////////
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"DELETE_PHOTO requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:DELETE_PHOTO];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)interviewQuestionList:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WENSERVICE_INTERVIEW_QUESTIONS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"INTERVIEW_QUSTION_LIST %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:INTERVIEW_QUSTION_LIST];
        
        /////////////////////////////
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"INTERVIEW_QUSTION_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:INTERVIEW_QUSTION_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


//-(void)interviewQuestionUpdate:(id)_delegate withQuestionID:(int)questionID withOptionID:(int)optionID
-(void)interviewQuestionUpdate:(id)_delegate withQuestionObj:(FLMyDetail *)questionObj
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    NSDictionary *params = @{
                             @"question_option_id" : [NSNumber numberWithInt:questionObj.user_answer_index]
                             };
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"PUT" path:[NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN_URL,WENSERVICE_INTERVIEW_QUESTIONS_UPDATE,questionObj.questionKey] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"INTERVIEW_QUESTION_UPDATE %@", JSON);
        
        
        //        INTERVIEW_QUESTION_UPDATE {
        //            message = "Interview question updated";
        //            success = 1;
        //        }
        
        
        
        if ([JSON objectForKey:@"success"])
            {
            [self requestFinished:questionObj withType:INTERVIEW_QUESTION_UPDATE];
            }
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"INTERVIEW_QUESTION_UPDATE requestFail %@",JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:INTERVIEW_QUESTION_UPDATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)albumList:(id)_delegate withUserID:(NSString *)userID//FOR OTEHR USER
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USERS_SHOW,userID,WEBSERVICE_USERS_ALBUM] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USERS_ALBUM_LIST %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:USERS_ALBUM_LIST];
        
        /////////////////////////////
        
        
        
        
        
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USERS_ALBUM_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:USERS_ALBUM_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)usersAlbumPhotoList:(id)_delegate withUserID:(NSString *)userID withAlbumID:(NSString *)albumID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@%@%@/%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USERS_SHOW,userID,WEBSERVICE_USERS_ALBUM,albumID] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USERS_ALBUM_PHOTO_LIST %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:USERS_ALBUM_PHOTO_LIST];
        
        /////////////////////////////
        
        
        
        
        
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USERS_ALBUM_PHOTO_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:USERS_ALBUM_PHOTO_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)profilePicsList:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_PROFILE_PIC_ALBUM] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_PICTURE_ALBUM %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:PROFILE_PICTURE_ALBUM];
        
        /////////////////////////////
        
        
        
        
        
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_PICTURE_ALBUM requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:PROFILE_PICTURE_ALBUM];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)matchUsersList:(id)_delegate
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_MATCH_USERS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"MATCH_USERS %@", JSON);
        [self requestFinished:JSON withType:MATCH_USERS];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"MATCH_USERS requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:MATCH_USERS];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)locationPointCreate:(id)_delegate withLocationPointObj:(FLLocationPoint *)locationPointObj
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params = [locationPointObj getLocationPointJsonObj:locationPointObj];
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_LOCATION_POINT] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"LOCATION_POINT_CREATE %@", JSON);
        [self requestFinished:JSON withType:LOCATION_POINT_CREATE];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"LOCATION_POINT_CREATE requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:LOCATION_POINT_CREATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)locationCheckin:(id)_delegate withVenueID:(NSString *)venueID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@/%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_LOCATION_POINT,venueID,WEBSERVICE_LOCATION_POINT_CHECK_IN] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"LOCATION_POINT_CHECK_IN %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:LOCATION_POINT_CHECK_IN];
        
        /////////////////////////////
        
        
        
        
        
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"LOCATION_POINT_CHECK_IN requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:LOCATION_POINT_CHECK_IN];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)likeToUser:(id)_delegate withUserID:(NSString *)userID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USERS_SHOW,userID,WEBSERVICE_LIKE_TO_USER] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"LIKE_TO_USER %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:LIKE_TO_USER];
        
        /////////////////////////////
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"LIKE_TO_USER requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:LIKE_TO_USER];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)unlikeToUser:(id)_delegate withUserID:(NSString *)userID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USERS_SHOW,userID,WEBSERVICE_UNLIKE_TO_USER] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"UNLIKE_TO_USER %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:UNLIKE_TO_USER];
        
        /////////////////////////////
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"UNLIKE_TO_USER requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:UNLIKE_TO_USER];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)likeUsersList:(id)_delegate
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USERS_SHOW,WEBSERVICE_CURRENT_USER_LIKE_LIST] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"LIKE_USER_LIST %@", JSON);
        [self requestFinished:JSON withType:LIKE_USER_LIST];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"LIKE_USER_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:LIKE_USER_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)blockUser:(id)_delegate withUserID:(NSString *)userID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USERS_SHOW,userID,WEBSERVICE_BLOCK_USERS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"BLOCK_USER %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:BLOCK_USER];
        
        /////////////////////////////
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"BLOCK_USER requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:BLOCK_USER];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)unblockUser:(id)_delegate withUserID:(NSString *)userID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USERS_SHOW,userID,WEBSERVICE_UNBLOCK_USERS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"UNBLOCK_USER %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:UNBLOCK_USER];
        
        /////////////////////////////
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"UNBLOCK_USER requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:UNBLOCK_USER];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)imageUploadToDir:(id)_delegate withImageName:(NSString *)imageName//profile image upload
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    
    NSDictionary *params = @{
                             @"photo" : @{@"image" : imageName}
                             };
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_IMAGE_UPLOAD_TO_DIR] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"IMAGE_UPLOAD_TO_DIR %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:IMAGE_UPLOAD_TO_DIR];
        
        /////////////////////////////
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"UNBLOCK_USER requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:IMAGE_UPLOAD_TO_DIR];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)profilePicList:(id)_delegate
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_IMAGE_UPLOAD_TO_DIR] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_PiCTURE_LIST %@", JSON);
        [self requestFinished:JSON withType:PROFILE_PiCTURE_LIST];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"PROFILE_PiCTURE_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:PROFILE_PiCTURE_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)userChatList:(id)_delegate
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CHAT_SEND] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_CHATS %@", JSON);
        [self requestFinished:JSON withType:USER_CHATS];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_CHATS requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:USER_CHATS];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)userChatListForUser:(id)_delegate withUserID:(NSString *)userID
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@/%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CHAT_SEND,userID] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_CHATS_FOR_USERS %@", JSON);
        [self requestFinished:JSON withType:USER_CHATS_FOR_USERS];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_CHATS_FOR_USERS requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:USER_CHATS_FOR_USERS];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)findme:(id)_delegate withLat:(NSString *)userLatitude withLon:(NSString *)userLongitude
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    
    NSDictionary *params = @{
                             @"beacon" : @{@"latitude" : userLatitude,@"longitude" : userLongitude}
                             };
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_FINDME] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FINDME %@", JSON);
        
        /////////////////////////////
        
        [self requestFinished:JSON withType:FINDME];
        
        /////////////////////////////
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"FINDME requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:FINDME];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)momentList:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_MOMENT] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"MOMENT %@", JSON);
        
        [self requestFinished:JSON withType:MOMENT];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"MOMENT requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:MOMENT];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)creaditPlansList:(id)_delegate //Credits: List plans
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CREDIT_PLANS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CREDIT_PLANS %@", JSON);
        
        [self requestFinished:JSON withType:CREDIT_PLANS];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CREDIT_PLANS requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:CREDIT_PLANS];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)getVipMembershipList:(id)_delegate //VIP Membership: Get membership
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CURRNT_USER] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GET_VIP_MEMBERSHIP_LIST %@", JSON);
        
        [self requestFinished:JSON withType:GET_VIP_MEMBERSHIP_LIST];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GET_VIP_MEMBERSHIP_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GET_VIP_MEMBERSHIP_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)getVipMembershipPlanList:(id)_delegate //VIP Membership: List plans
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_VIP_MEMBERSHIP_PLANS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"VIP_MEMBERSHIP_PLAN_LIST %@", JSON);
        
        [self requestFinished:JSON withType:VIP_MEMBERSHIP_PLAN_LIST];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"VIP_MEMBERSHIP_PLAN_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:VIP_MEMBERSHIP_PLAN_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)sendPayment:(id)_delegate withLocationPointObj:(FLPayment *)paymentObj//Payment: Send payment
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params = [paymentObj getPaymentJsonObj:paymentObj];
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_PAYMENTS] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"SEND_PAYMENT %@", JSON);
        [self requestFinished:JSON withType:SEND_PAYMENT];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"SEND_PAYMENT requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:SEND_PAYMENT];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)getGiftItemAllList:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GIFT_ITEM] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_ITEM_LIST %@", JSON);
        
        [self requestFinished:JSON withType:GIFT_ITEM_LIST];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_ITEM_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GIFT_ITEM_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)getKissesList:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GIFT_KESSES] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_KESSES_LIST %@", JSON);
        
        [self requestFinished:JSON withType:GIFT_KESSES_LIST];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_KESSES_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GIFT_KESSES_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)getDrinksList:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GIFT_DRINKS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_DRINKS_LIST %@", JSON);
        
        [self requestFinished:JSON withType:GIFT_DRINKS_LIST];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_DRINKS_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GIFT_DRINKS_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)getGiftAllReceivedItems:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_RECEIVED_ALL_GIFT] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_RECEIVED_ALL %@", JSON);
        
        [self requestFinished:JSON withType:GIFT_RECEIVED_ALL];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_RECEIVED_ALL requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GIFT_RECEIVED_ALL];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)getGiftReceivedKisses:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_RECEIVED_GIFT_KISSES] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_RECEIVED_KISSES %@", JSON);
        
        [self requestFinished:JSON withType:GIFT_RECEIVED_KISSES];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_RECEIVED_KISSES requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GIFT_RECEIVED_KISSES];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)getGiftReceivedDrinks:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_RECEIVED_GIFT_DRINKS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_RECEIVED_DRINKS %@", JSON);
        
        [self requestFinished:JSON withType:GIFT_RECEIVED_DRINKS];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_RECEIVED_DRINKS requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GIFT_RECEIVED_DRINKS];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)giftSend:(id)_delegate withGiftItemID:(FLGiftItem *)giftObj withReceiverID:(NSNumber *)receiver_id
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    NSDictionary *params = @{
                             @"gift" : @{@"gift_item_id" : giftObj.item_id,@"receiver_id" : receiver_id}
                             };
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GIFT_SEND] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        
        
        NSLog(@"GIFT_SEND %@", JSON);
        
        //        GIFT_SEND {
        //            message = "Gift was successfully sent";
        //            success = 1;
        //        }
        
        if ([[JSON objectForKey:@"success"] boolValue])
            {
            [self requestFinished:giftObj withType:GIFT_SEND];
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",JSON);
            }
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GIFT_SEND requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:GIFT_SEND];
        
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}



-(void)getUserSettingsList:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USER_SETTING] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_SETTING_LIST %@", JSON);
        
        [self requestFinished:JSON withType:USER_SETTING_LIST];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_SETTING_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:USER_SETTING_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)settingUpdate:(id)_delegate withKey:(NSString *)key withValue:(NSNumber *)value
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    //    {
    //    "key": "facebook",
    //    "value": true
    //}
    
    NSDictionary *params=@{@"key" : key,@"value":value};
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USER_SETTING] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_SETTING_UPDATE %@", JSON);
        [self requestFinished:JSON withType:USER_SETTING_UPDATE];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"USER_SETTING_UPDATE requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:USER_SETTING_UPDATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)getNotificationList:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_NOTIFICATION_LIST] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"NOTIFICATION_LIST %@", JSON);
        
        [self requestFinished:JSON withType:NOTIFICATION_LIST];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"NOTIFICATION_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:NOTIFICATION_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)notificationUpdate:(id)_delegate withNotificationID:(NSString *)notificationID
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
        {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
        }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"PUT" path:[NSString stringWithFormat:@"%@%@/%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_NOTIFICATION_LIST,notificationID] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"NOTIFICATION_UPDATE %@", JSON);
        
        //////
        if ([[JSON objectForKey:@"success"] boolValue])
            {
            [self requestFinished:notificationID withType:NOTIFICATION_UPDATE];
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",JSON);
            }
        //////
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"NOTIFICATION_UPDATE requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:NOTIFICATION_UPDATE];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)createEyeCatcher:(id)_delegate
{
    self.delegate =_delegate;
    
    if ([FLGlobalSettings sharedInstance].current_user.auth_token==nil || [[FLGlobalSettings sharedInstance].current_user.auth_token length]==0) {
        return;
    }
    
    if (![self isInternetAvailable])
    {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
    }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_EYE_CATCHER] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"EYE_CATCHER %@", JSON);
        [self requestFinished:JSON withType:EYE_CATCHER];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"EYE_CATCHER requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:EYE_CATCHER];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
    
    
}

-(void)getEyeCatcherProfileList:(id)_delegate
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
    {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
    }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_EYE_CATCHER] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"EYE_CATCHER_PROFILE_LIST %@", JSON);
        
        [self requestFinished:JSON withType:EYE_CATCHER_PROFILE_LIST];
        
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"EYE_CATCHER_PROFILE_LIST requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:EYE_CATCHER_PROFILE_LIST];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}

-(void)chatData:(id)_delegate withChatObj:(FLChat *)chatObj
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
    {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
    }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_USERS_SHOW,((FLChatMessage *)[chatObj.chatMessageArr lastObject]).userID] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CHAT_DATA %@", JSON);
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *user_data=[JSON objectForKey:@"user"];
            NSDictionary *profile_data=[user_data objectForKey:@"profile"];
            NSString *profilePicName=[profile_data objectForKey:@"image"];
            ((FLChatMessage *)[chatObj.chatMessageArr lastObject]).user_imageURL=profilePicName;
            [self requestFinished:chatObj withType:CHAT_DATA];
        }
        else
        {
            NSLog(@"Unexpected Error Occered: responce---> %@",JSON);
        }
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CHAT_DATA requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:CHAT_DATA];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)chatGroupData:(id)_delegate withChatObj:(FLChat *)chatObj
{
    self.delegate =_delegate;
    if (![self isInternetAvailable])
    {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
    }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@/%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GROUP,chatObj.chatObj_id] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CHAT_GROUP_DATA %@", JSON);
//        [self requestFinished:JSON withType:CHAT_GROUP_DATA];
        
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *group_data=[JSON objectForKey:@"group"];
            
            chatObj.chatObj_image_url=[group_data objectForKey:@"image"];
            chatObj.chatObjName=[group_data objectForKey:@"name"];
            
            NSDictionary *owner_dic=[group_data objectForKey:@"owner"];
            if ([[NSString stringWithFormat:@"%@",[owner_dic objectForKey:@"id"]] isEqualToString:[NSString stringWithFormat:@"%@",((FLChatMessage *)[chatObj.chatMessageArr lastObject]).userID]])
            {
                NSDictionary *profile_dic=[owner_dic objectForKey:@"profile"];
                 ((FLChatMessage *)[chatObj.chatMessageArr lastObject]).user_imageURL=[profile_dic objectForKey:@"image"];
                [self requestFinished:chatObj withType:CHAT_GROUP_DATA];
                return;
            }
            else
            {
                if ([[group_data objectForKey:@"users"] isKindOfClass:[NSArray class]])
                {
                    NSArray *users_arr=[group_data objectForKey:@"users"];
                    for(id userObj in users_arr)
                    {
                        NSDictionary *user_dic=[userObj objectForKey:@"user"];
                        if ([[NSString stringWithFormat:@"%@",[user_dic objectForKey:@"id"]] isEqualToString:[NSString stringWithFormat:@"%@",((FLChatMessage *)[chatObj.chatMessageArr lastObject]).userID]])
                        {
                            NSDictionary *profile_dic=[user_dic objectForKey:@"profile"];
                            ((FLChatMessage *)[chatObj.chatMessageArr lastObject]).user_imageURL=[profile_dic objectForKey:@"image"];
                            [self requestFinished:chatObj withType:CHAT_GROUP_DATA];
                            return;
                        }
                    }
                }
            }

        }
        else
        {
            NSLog(@"Unexpected Error Occered: responce---> %@",JSON);
        }

        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CHAT_GROUP_DATA requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:CHAT_GROUP_DATA];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)userChatListForGroup:(id)_delegate withGrouID:(NSString *)groupID
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
    {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
    }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GROUP_CHAT_HISTORY,groupID] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_CHAT_HISTORY %@", JSON);
        [self requestFinished:JSON withType:GROUP_CHAT_HISTORY];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"GROUP_CHAT_HISTORY requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:GROUP_CHAT_HISTORY];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)updatePassword:(id)_delegate withCurrentPassword:(NSString *)current_password withNewPassword:(NSString *)newPassword
{
    self.delegate =_delegate;
    
    if ([FLGlobalSettings sharedInstance].current_user.auth_token==nil || [[FLGlobalSettings sharedInstance].current_user.auth_token length]==0) {
        return;
    }
    
    if (![self isInternetAvailable])
    {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
    }
    
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{
    @"user" : @{@"current_password" : current_password,@"password" : newPassword,@"password_confirmation" : newPassword}
    };
    
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_UPDATE_PASSWORD] parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"UPDATE_PASSWORD %@", JSON);
        [self requestFinished:JSON withType:UPDATE_PASSWORD];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"UPDATE_PASSWORD requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==500)
        //        {
        [self requestFail:JSON withType:UPDATE_PASSWORD];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}


-(void)blockedUserList:(id)_delegate
{
    self.delegate =_delegate;
    
    if (![self isInternetAvailable])
    {
        [self requestFail:@"No internet Connection" withType:NETWORK_ERROR];
        return;
    }
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_BLOCKED_USERS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"BLOCKED_USERS %@", JSON);
        [self requestFinished:JSON withType:BLOCKED_USERS];
        
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"BLOCKED_USERS requestFail %@", JSON);
        //        int status_code=[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        //        if (status_code==SIGNIN_USER_FAIL_STATUS_CODE)
        //        {
        [self requestFail:JSON withType:BLOCKED_USERS];
        //        }
        //        else
        //        {
        //            [self unknownFailure];
        //        }
        
        
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        //        NSString *test= [[JSON objectForKey:@"email"] objectAtIndex:0];
        //        NSLog(@"testtest %@",test);
        // do something on failure
    }];
    
    [operation start];
}



#pragma mark - AmazonServiceRequestDelegate


//- (void)processDelegateUpload:(NSData *)imageData
//{
//    // Upload image data.  Remember to set the content type.
//    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:@"PICTURE_NAME.png"
//                                                              inBucket:S3_BUCKET];
//    por.contentType = @"image/jpeg";
//    por.data = imageData;
//    por.delegate = self;
//
//    // Put the image data into the specified s3 bucket and object.
//    [self.s3 putObject:por];
//}

//-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
//{
//    [self showAlertMessage:@"The image was successfully uploaded." withTitle:@"Upload Completed"];
//
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//}
//
//-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
//{
//    NSLog(@"Error: %@", error);
//    [self showAlertMessage:error.description withTitle:@"Upload Error"];
//
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//}




//- (void)showCheckErrorMessage1:(NSError *)error
//{
//    if(error != nil)
//    {
//        NSLog(@"Error: %@", error);
//        [self showAlertMessage:[error.userInfo objectForKey:@"message"] withTitle:@"Upload Error"];
//    }
//    else
//    {
//        [self showAlertMessage:@"The image was successfully uploaded." withTitle:@"Upload Completed"];
//    }
//
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//}

//- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                         message:message
//                                                        delegate:nil
//                                               cancelButtonTitle:@"OK"
//                                               otherButtonTitles:nil] ;
//    [alertView show];
//}

- (void)showCheckErrorMessage:(NSError *)error
{
    if(error != nil)
        {
        NSLog(@"Error: %@", error);
        
        }
    else
        {
        //        [self showAlertMessage:@"The image was successfully uploaded." withTitle:@"Upload Completed"];
        NSLog(@"The image was successfully uploaded.");
        }
    
    
}

#pragma mark -
#pragma mark - AFNetworking responce methods

-(void)requestFinished:(id)jsonData withType:(int)type_int
{
    switch (type_int)
    {
        case GROUP_SHOW:{
            NSLog(@"GROUP JSON %@", jsonData);
            break;
        }
        
        case CREATE_USER:
        {
        //            CREATE_USER {
        //                user =     {
        //                    "auth_token" = "q-pVD28tFLfy4tkMVio3";
        //                    email = "test2@gmail.com";
        //                    success = 1;
        //                };
        //            }
        
        NSDictionary *userRegistrationDic = [jsonData objectForKey:@"user"];
        if ([[userRegistrationDic objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(createUserResult:)]) {
                NSLog(@"in 0");
                FLUser *currentUser=[[FLUser alloc] init];
                currentUser.auth_token=[userRegistrationDic objectForKey:@"auth_token"];
                currentUser.email=[userRegistrationDic objectForKey:@"email"];
                
                [delegate createUserResult:currentUser];
            }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case CREATE_USER_FACEBOOK:
        {
        //        ////////////////////////
        //            CREATE_USER_FACEBOOK {
        //                user =     {
        //                    "auth_token" = "81oHs_c6pvLxNtnP7Y7U";
        //                    email = "email1@gmail.com";
        //                    success = 1;
        //                };
        //            }
        //        ///////////////////////
        NSDictionary *userRegistrationDic = [jsonData objectForKey:@"user"];
        if ([[userRegistrationDic objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(signinUserResult:)]) {
                NSLog(@"in 0");
                FLUser *user=[[FLUser alloc] init];
                user.auth_token=[userRegistrationDic objectForKey:@"auth_token"];
                user.email=[userRegistrationDic objectForKey:@"email"];
                
                [delegate signinUserResult:user];
            }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case SIGNIN_USER:
        {
        //            SIGNIN_USER {
        //                "auth_token" = "BXXs3Mncv-a3v-iStR66";
        //                email = "a1@gmail.com";
        //                success = 1;
        //            }
        
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(signinUserResult:)])
                {
                FLUser *user=[[FLUser alloc] init];
                user.auth_token=[jsonData objectForKey:@"auth_token"];
                user.email=[jsonData objectForKey:@"email"];
                [delegate signinUserResult:user];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case FORGOT_PASSWORD:
        {
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(forgetPasswodResult:)])
                {
                [delegate forgetPasswodResult:[jsonData objectForKey:@"message"]];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case PROFILE_UPDATE:
        {
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(profileUpdateResult:)])
                {
                //                    FLUser *user=[[FLUser alloc] init];
                //                    user.auth_token=[jsonData objectForKey:@"auth_token"];
                //                    user.email=[jsonData objectForKey:@"email"];
                [delegate profileUpdateResult:@"Profile updated"];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case CURRENT_USER:
        {
        //                    CURRENT_USER {
        //            user =     {
        //                "" = "";
        //                "credits_remaining" = 0;
        //                email = "u40@gmail.com";
        //                id = 160;
        //                "interview_questions" =         (
        //                                                 {
        //                                                     "interview_question" =                 {
        //                                                         "question_id" = 1;
        //                                                         "question_option_id" = "";
        //                                                     };
        //                                                 },
        //                                                 {
        //                                                     "interview_question" =                 {
        //                                                         "question_id" = 2;
        //                                                         "question_option_id" = "";
        //                                                     };
        //                                                 },
        //                                                 {
        //                                                     "interview_question" =                 {
        //                                                         "question_id" = 3;
        //                                                         "question_option_id" = "";
        //                                                     };
        //                                                 },
        //                                                 {
        //                                                     "interview_question" =                 {
        //                                                         "question_id" = 4;
        //                                                         "question_option_id" = "";
        //                                                     };
        //                                                 },
        //                                                 {
        //                                                     "interview_question" =                 {
        //                                                         "question_id" = 5;
        //                                                         "question_option_id" = "";
        //                                                     };
        //                                                 },
        //                                                 {
        //                                                     "interview_question" =                 {
        //                                                         "question_id" = 6;
        //                                                         "question_option_id" = "";
        //                                                     };
        //                                                 },
        //                                                 {
        //                                                     "interview_question" =                 {
        //                                                         "question_id" = 7;
        //                                                         "question_option_id" = "";
        //                                                     };
        //                                                 },
        //                                                 {
        //                                                     "interview_question" =                 {
        //                                                         "question_id" = 8;
        //                                                         "question_option_id" = "";
        //                                                     };
        //                                                 },
        //                                                 {
        //                                                     "interview_question" =                 {
        //                                                         "question_id" = 9;
        //                                                         "question_option_id" = "";
        //                                                     };
        //                                                 }
        //                                                 );
        //                "last_seen_at" = "2013-12-26T17:31:08Z";
        //                location =         {
        //                    latitude = "6.921623";
        //                    longitude = "79.85377";
        //                };
        //                profile =         {
        //                    age = 33;
        //                    "birth_date" = "1980-10-20";
        //                    "body_art" = "";
        //                    children = "";
        //                    ethnicity = "";
        //                    "eye_color" = "";
        //                    figure = "";
        //                    "full_name" = u40;
        //                    gender = male;
        //                    "hair_color" = "";
        //                    "hair_length" = "";
        //                    height = "";
        //                    id = 117;
        //                    image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                    income = "";
        //                    "living_situation" = "";
        //                    "looking_for" = male;
        //                    "looking_for_age_max" = 43;
        //                    "looking_for_age_min" = 0;
        //                    "mobile_number" = "";
        //                    orientation = "";
        //                    profession = "";
        //                    "relationship_status" = "";
        //                    religion = "";
        //                    smoker = "";
        //                    training = "";
        //                    "user_id" = 160;
        //                    weight = "";
        //                    "who_looking_for" = male;
        //                };
        //                status = "";
        //                "visitor_count" = 1;
        //            };
        //        }
        
        
        
        
        if ([jsonData objectForKey:@"user"])
            {
            NSMutableDictionary *user_data=[jsonData objectForKey:@"user"];
            FLProfile *profileObj=[[FLProfile alloc] init];
            profileObj.email=[user_data objectForKey:@"email"];
            profileObj.credits_remaining=[user_data objectForKey:@"credits_remaining"];
            NSArray *interviewQuestionArr=[user_data objectForKey:@"interview_questions"];
            if (profileObj.interviewQuestionsArr==nil) {
                profileObj.interviewQuestionsArr=[[NSMutableArray alloc] init];
            }
            for (id interviewQuestion in interviewQuestionArr)
                {
                NSDictionary *myDetailObj=[interviewQuestion objectForKey:@"interview_question"];
                FLMyDetail *myDetail=[[FLMyDetail alloc] init];
                myDetail.questionKey=[myDetailObj objectForKey:@"question_id"];
                if ([[myDetailObj objectForKey:@"question_option_id"] isEqual:@""])
                    {
                    myDetail.user_answer_index=(-1);
                    }
                else
                    {
                    myDetail.user_answer_index=[[myDetailObj objectForKey:@"question_option_id"] integerValue];
                    }
                [profileObj.interviewQuestionsArr addObject:myDetail];
                }
            
            
            profileObj.uid=[user_data objectForKey:@"id"];
            profileObj.status_txt=[user_data objectForKey:@"status"];
            
            
            if ([[user_data objectForKey:@"location"] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *user_location_data=[user_data objectForKey:@"location"];
                profileObj.latitude=[user_location_data objectForKey:@"latitude"];
                profileObj.longitude=[user_location_data objectForKey:@"longitude"];
            }
            
            NSMutableDictionary *profile_data=[user_data objectForKey:@"profile"];
            profileObj.age=[profile_data objectForKey:@"age"];
            profileObj.birth_date=[profile_data objectForKey:@"birth_date"];
            profileObj.body_art=[profile_data objectForKey:@"body_art"];
            profileObj.children=[profile_data objectForKey:@"children"];
            profileObj.ethnicity=[profile_data objectForKey:@"ethnicity"];
            profileObj.eye_color=[profile_data objectForKey:@"eye_color"];
            profileObj.figure=[profile_data objectForKey:@"figure"];
            profileObj.full_name=[profile_data objectForKey:@"full_name"];
            
            
            
            profileObj.gender=[profile_data objectForKey:@"gender"];
            profileObj.hair_color=[profile_data objectForKey:@"hair_color"];
            profileObj.hair_length=[profile_data objectForKey:@"hair_length"];
            profileObj.height=[profile_data objectForKey:@"height"];
            profileObj.image=[profile_data objectForKey:@"image"];
            profileObj.income=[profile_data objectForKey:@"income"];
            profileObj.living_situation=[profile_data objectForKey:@"living_situation"];
            profileObj.mobile_number=[profile_data objectForKey:@"mobile_number"];
            profileObj.orientation=[profile_data objectForKey:@"orientation"];
            profileObj.profession=[profile_data objectForKey:@"profession"];
            profileObj.religion=[profile_data objectForKey:@"religion"];
            profileObj.smoker=[profile_data objectForKey:@"smoker"];
            profileObj.training=[profile_data objectForKey:@"training"];
            //                profileObj.user_id=[profile_data objectForKey:@"user_id"];//not in this service
            profileObj.weight=[profile_data objectForKey:@"weight"];
            profileObj.relationship_status=[profile_data objectForKey:@"relationship_status"];
            profileObj.looking_for=[profile_data objectForKey:@"looking_for"];
            profileObj.who_looking_for=[profile_data objectForKey:@"who_looking_for"];
            profileObj.looking_for_age_min=[profile_data objectForKey:@"looking_for_age_min"];
            profileObj.looking_for_age_max=[profile_data objectForKey:@"looking_for_age_max"];
            
            if ([delegate respondsToSelector:@selector(currentUserResult:)])
                {
                [delegate currentUserResult:profileObj];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case CURRENT_USER_PROFILE://(PLEASE USE /users/me INSTEAD)==>(DEPRICETED)
        {
        //            CURRENT_USER_PROFILE {
        //                user =     {
        //                    email = "a1@gmail.com";
        //                    id = 29;
        //                    location =         {
        //                        latitude = "6.921623";
        //                        longitude = "79.85377";
        //                    };
        //                    profile =         {
        //                        age = "";
        //                        "body_art" = "";
        //                        children = "";
        //                        ethnicity = "";
        //                        "eye_color" = "";
        //                        figure = "";
        //                        "full_name" = "";
        //                        gender = "";
        //                        "hair_color" = "";
        //                        "hair_length" = "";
        //                        height = "";
        //                        id = 8;
        //                        image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                        income = "";
        //                        "living_situation" = "";
        //                        "looking_for" = "";
        //                        orientation = "";
        //                        profession = "";
        //                        "relationship_status" = "";
        //                        religion = "";
        //                        smoker = "";
        //                        training = "";
        //                        "user_id" = 29;
        //                        weight = "";
        //                        "who_looking_for" = "";
        //                    };
        //                    status = "";
        //                };
        //            }
        
        if ([jsonData objectForKey:@"user"])
            {
            NSMutableDictionary *profile_data=[jsonData objectForKey:@"profile"];
            FLProfile *profileObj=[[FLProfile alloc] init];
            profileObj.age=[profile_data objectForKey:@"age"];
            profileObj.body_art=[profile_data objectForKey:@"body_art"];
            profileObj.children=[profile_data objectForKey:@"children"];
            profileObj.ethnicity=[profile_data objectForKey:@"ethnicity"];
            profileObj.eye_color=[profile_data objectForKey:@"eye_color"];
            profileObj.figure=[profile_data objectForKey:@"figure"];
            profileObj.full_name=[profile_data objectForKey:@"full_name"];
            
            
            
            profileObj.gender=[profile_data objectForKey:@"gender"];
            profileObj.hair_color=[profile_data objectForKey:@"hair_color"];
            profileObj.hair_length=[profile_data objectForKey:@"hair_length"];
            profileObj.height=[profile_data objectForKey:@"height"];
            profileObj.uid=[profile_data objectForKey:@"id"];
            profileObj.image=[profile_data objectForKey:@"image"];
            profileObj.income=[profile_data objectForKey:@"income"];
            profileObj.living_situation=[profile_data objectForKey:@"living_situation"];
            //                profileObj.mobile_number=[profile_data objectForKey:@"mobile_number"];
            profileObj.orientation=[profile_data objectForKey:@"orientation"];
            profileObj.profession=[profile_data objectForKey:@"profession"];
            profileObj.religion=[profile_data objectForKey:@"religion"];
            profileObj.smoker=[profile_data objectForKey:@"smoker"];
            profileObj.training=[profile_data objectForKey:@"training"];
            //                profileObj.user_id=[profile_data objectForKey:@"user_id"];//not in this service
            profileObj.weight=[profile_data objectForKey:@"weight"];
            profileObj.relationship_status=[profile_data objectForKey:@"relationship_status"];
            
            
            if ([delegate respondsToSelector:@selector(currentUserProfileResult:)])
                {
                [delegate currentUserProfileResult:profileObj];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        
        case SIGNOUT:
        {
        //            SIGNOUT {
        //                message = "User signed out successfully";
        //                success = 1;
        //            }
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(signOutUserResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate signOutUserResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case PROFILE_SEARCH:
        {
        //            ////
        //            PROFILE_SEARCH (
        //                            {
        //                                user =         {
        //                                    email = "u1@gmail.com";
        //                                    id = 35;
        //                                    "is_friend" = 0;
        //                                    "is_online" = 1;
        //                                    location =             {
        //                                        latitude = "6.921623";
        //                                        longitude = "79.85377";
        //                                    };
        //                                    profile =             {
        //                                        age = 0;
        //                                        "body_art" = "";
        //                                        children = "";
        //                                        ethnicity = "";
        //                                        "eye_color" = "";
        //                                        figure = "";
        //                                        "full_name" = U1;
        //                                        gender = "";
        //                                        "hair_color" = "";
        //                                        "hair_length" = "";
        //                                        height = "";
        //                                        id = 14;
        //                                        image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                        income = "";
        //                                        "living_situation" = "";
        //                                        "looking_for" = "";
        //                                        orientation = "";
        //                                        profession = "";
        //                                        "relationship_status" = "";
        //                                        religion = "";
        //                                        smoker = "";
        //                                        training = "";
        //                                        "user_id" = 35;
        //                                        weight = 0;
        //                                        "who_looking_for" = "";
        //                                    };
        //                                    status = "";
        //                                };
        //                            },
        //                            {
        //                                user =         {
        //                                    email = "a1@gmail.com";
        //                                    id = 29;
        //                                    "is_friend" = 0;
        //                                    "is_online" = 0;
        //                                    location =             {
        //                                        latitude = "6.921623";
        //                                        longitude = "79.85377";
        //                                    };
        //                                    profile =             {
        //                                        age = 0;
        //                                        "body_art" = piercing;
        //                                        children = "no_children";
        //                                        ethnicity = european;
        //                                        "eye_color" = blue;
        //                                        figure = slim;
        //                                        "full_name" = "test 66";
        //                                        gender = "";
        //                                        "hair_color" = black;
        //                                        "hair_length" = bald;
        //                                        height = "";
        //                                        id = 8;
        //                                        image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                        income = "no_income";
        //                                        "living_situation" = alone;
        //                                        "looking_for" = "";
        //                                        orientation = heterosexual;
        //                                        profession = "job_seeker";
        //                                        "relationship_status" = "";
        //                                        religion = spiritual;
        //                                        smoker = smoker;
        //                                        training = "not_finished";
        //                                        "user_id" = 29;
        //                                        weight = 31;
        //                                        "who_looking_for" = "";
        //                                    };
        //                                    status = "";
        //                                };
        //                            }
        //                            )
        //            ////
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *projectObjArr=[[NSMutableArray alloc] init];
            for (id data in jsonData)
                {
                if ([data isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *user_data=[data objectForKey:@"user"];
                    FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
                    profileObj.email=[user_data objectForKey:@"email"];
                    profileObj.uid=[user_data objectForKey:@"id"];
                    profileObj.is_friend=[user_data objectForKey:@"is_friend"];
                    profileObj.is_online=[user_data objectForKey:@"is_online"];
                    profileObj.status_txt=[user_data objectForKey:@"status"];
                    
                    NSDictionary *location_data=[user_data objectForKey:@"location"];
                    profileObj.longitude=[location_data objectForKey:@"longitude"];
                    profileObj.latitude=[location_data objectForKey:@"latitude"];
                    
                    NSDictionary *profile_data=[user_data objectForKey:@"profile"];
                    profileObj.age=[profile_data objectForKey:@"age"];
                    profileObj.body_art=[profile_data objectForKey:@"body_art"];
                    profileObj.children=[profile_data objectForKey:@"children"];
                    profileObj.ethnicity=[profile_data objectForKey:@"ethnicity"];
                    profileObj.eye_color=[profile_data objectForKey:@"eye_color"];
                    profileObj.figure=[profile_data objectForKey:@"figure"];
                    profileObj.full_name=[profile_data objectForKey:@"full_name"];
                    profileObj.gender=[profile_data objectForKey:@"gender"];
                    profileObj.hair_color=[profile_data objectForKey:@"hair_color"];
                    profileObj.hair_length=[profile_data objectForKey:@"hair_length"];
                    profileObj.height=[profile_data objectForKey:@"height"];
                    profileObj.image=[profile_data objectForKey:@"image"];
                    profileObj.income=[profile_data objectForKey:@"income"];
                    profileObj.living_situation=[profile_data objectForKey:@"living_situation"];
                    profileObj.looking_for=[profile_data objectForKey:@"looking_for"];
                    //                        profileObj.mobile_number=[profile_data objectForKey:@"mobile_number"];
                    profileObj.orientation=[profile_data objectForKey:@"orientation"];
                    profileObj.profession=[profile_data objectForKey:@"profession"];
                    profileObj.relationship_status=[profile_data objectForKey:@"relationship_status"];
                    profileObj.religion=[profile_data objectForKey:@"religion"];
                    profileObj.smoker=[profile_data objectForKey:@"smoker"];
                    profileObj.training=[profile_data objectForKey:@"training"];
                    //                        profileObj.user_id=[profile_data objectForKey:@"user_id"];
                    profileObj.weight=[profile_data objectForKey:@"weight"];
                    profileObj.who_looking_for=[profile_data objectForKey:@"who_looking_for"];
                    profileObj.looking_for_age_min=[profile_data objectForKey:@"looking_for_age_min"];
                    profileObj.looking_for_age_max=[profile_data objectForKey:@"looking_for_age_max"];
                    [projectObjArr addObject:profileObj];
                    }
                }
            
            if ([delegate respondsToSelector:@selector(profileSearchResult:)])
                {
                [delegate profileSearchResult:projectObjArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case USER_LOCATION:
        {
        //            USER_LOCATION {
        //                message = "Location was successfully created";
        //                success = 1;
        //            }
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(userLocationSetResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate userLocationSetResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        
        case CREATE_FRIENDSHIP:
        {
        //            ///
        //            CREATE_FRIENDSHIP {
        //                message = "Your friend request has been sent";
        //                success = 1;
        //            }
        //            ///
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(createFriendshipResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate createFriendshipResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case LISTING_FRIENDSHIP:
        {
        //            ////////////
        //            LISTING_FRIENDSHIP (
        //                                {
        //                                    friendship =         {
        //                                        "created_at" = "2013-11-30T16:44:09Z";
        //                                        id = 12;
        //                                        status = pending;
        //                                        user =             {
        //                                            email = "u1@gmail.com";
        //                                            id = 35;
        //                                            profile =                 {
        //                                                age = "";
        //                                                "body_art" = "";
        //                                                children = "";
        //                                                ethnicity = "";
        //                                                "eye_color" = "";
        //                                                figure = "";
        //                                                "full_name" = U1;
        //                                                gender = "";
        //                                                "hair_color" = "";
        //                                                "hair_length" = "";
        //                                                height = "";
        //                                                id = 14;
        //                                                image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                                income = "";
        //                                                "living_situation" = "";
        //                                                "looking_for" = "";
        //                                                orientation = "";
        //                                                profession = "";
        //                                                "relationship_status" = "";
        //                                                religion = "";
        //                                                smoker = "";
        //                                                training = "";
        //                                                "user_id" = 35;
        //                                                weight = "";
        //                                                "who_looking_for" = "";
        //                                            };
        //                                            status = "";
        //                                        };
        //                                    };
        //                                }
        //                                )
        //
        //            /////////////
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *projectObjArr=[[NSMutableArray alloc] init];
            for (id data in jsonData)
                {
                if ([data isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *friendship_data=[data objectForKey:@"friendship"];
                    FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
                    profileObj.created_at=[friendship_data objectForKey:@"created_at"];
                    
                    profileObj.status=[friendship_data objectForKey:@"status"];
                   if ([[friendship_data objectForKey:@"status"] isEqualToString:@"accepted"])
                   {
                       profileObj.is_friend=[NSNumber numberWithInt:1];
                   }
                   else
                   {
                       profileObj.is_friend=[NSNumber numberWithInt:0];
                   }
                        
                    profileObj.friendship_id=[friendship_data objectForKey:@"id"];
                    NSDictionary *user_data=[friendship_data objectForKey:@"user"];
                    
                    profileObj.uid=[user_data objectForKey:@"id"];
                    
                    profileObj.email=[user_data objectForKey:@"email"];
                    profileObj.status_txt=[user_data objectForKey:@"status"];
                    
                    NSDictionary *profile_data=[user_data objectForKey:@"profile"];
                    profileObj.age=[profile_data objectForKey:@"age"];
                    profileObj.body_art=[profile_data objectForKey:@"body_art"];
                    profileObj.children=[profile_data objectForKey:@"children"];
                    profileObj.ethnicity=[profile_data objectForKey:@"ethnicity"];
                    profileObj.eye_color=[profile_data objectForKey:@"eye_color"];
                    profileObj.figure=[profile_data objectForKey:@"figure"];
                    profileObj.full_name=[profile_data objectForKey:@"full_name"];
                    profileObj.gender=[profile_data objectForKey:@"gender"];
                    profileObj.hair_color=[profile_data objectForKey:@"hair_color"];
                    profileObj.hair_length=[profile_data objectForKey:@"hair_length"];
                    profileObj.height=[profile_data objectForKey:@"height"];
                    profileObj.image=[profile_data objectForKey:@"image"];
                    profileObj.income=[profile_data objectForKey:@"income"];
                    profileObj.living_situation=[profile_data objectForKey:@"living_situation"];
                    profileObj.looking_for=[profile_data objectForKey:@"looking_for"];
                    profileObj.orientation=[profile_data objectForKey:@"orientation"];
                    profileObj.profession=[profile_data objectForKey:@"profession"];
                    profileObj.relationship_status=[profile_data objectForKey:@"relationship_status"];
                    profileObj.religion=[profile_data objectForKey:@"religion"];
                    profileObj.smoker=[profile_data objectForKey:@"smoker"];
                    profileObj.training=[profile_data objectForKey:@"training"];
                    profileObj.weight=[profile_data objectForKey:@"weight"];
                    profileObj.who_looking_for=[profile_data objectForKey:@"who_looking_for"];
                    profileObj.looking_for_age_min=[profile_data objectForKey:@"looking_for_age_min"];
                    profileObj.looking_for_age_max=[profile_data objectForKey:@"looking_for_age_max"];
                    [projectObjArr addObject:profileObj];
                    }
                }
            
            if ([delegate respondsToSelector:@selector(profileFriendshipSearchResult:)])
                {
                [delegate profileFriendshipSearchResult:projectObjArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        
        case ACCEPT_FRIENDSHIP:
        {
        //////
        //            ACCEPT_FRIENDSHIP {
        //                message = "Friend request has been accepted";
        //                success = 1;
        //            }
        /////
        
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(friendshipAcceptResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate friendshipAcceptResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case REJECT_FRIENDSHIP:
        {
        //            /////
        //            REJECT_FRIENDSHIP {
        //                message = "Friend request has been rejected";
        //                success = 1;
        //            }
        //            /////
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(friendshipRejectResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate friendshipRejectResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case FRIENDSHIP_FRIEND_LIST:
        {
        //            ////////////
        //            LISTING_FRIENDSHIP (
        //                                {
        //                                    friendship =         {
        //                                        "created_at" = "2013-11-30T16:44:09Z";
        //                                        id = 12;
        //                                        status = pending;
        //                                        user =             {
        //                                            email = "u1@gmail.com";
        //                                            id = 35;
        //                                            profile =                 {
        //                                                age = "";
        //                                                "body_art" = "";
        //                                                children = "";
        //                                                ethnicity = "";
        //                                                "eye_color" = "";
        //                                                figure = "";
        //                                                "full_name" = U1;
        //                                                gender = "";
        //                                                "hair_color" = "";
        //                                                "hair_length" = "";
        //                                                height = "";
        //                                                id = 14;
        //                                                image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                                income = "";
        //                                                "living_situation" = "";
        //                                                "looking_for" = "";
        //                                                orientation = "";
        //                                                profession = "";
        //                                                "relationship_status" = "";
        //                                                religion = "";
        //                                                smoker = "";
        //                                                training = "";
        //                                                "user_id" = 35;
        //                                                weight = "";
        //                                                "who_looking_for" = "";
        //                                            };
        //                                            status = "";
        //                                        };
        //                                    };
        //                                }
        //                                )
        //
        //            /////////////
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *projectObjArr=[[NSMutableArray alloc] init];
            for (id data in jsonData)
                {
                if ([data isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *friendship_data=[data objectForKey:@"friendship"];
                    FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
                    profileObj.created_at=[friendship_data objectForKey:@"created_at"];
                    profileObj.status=[friendship_data objectForKey:@"status"];
                   
                        if ([[friendship_data objectForKey:@"status"] isEqualToString:@"accepted"])
                        {
                            profileObj.is_friend=[NSNumber numberWithInt:1];
                        }
                        else
                        {
                            profileObj.is_friend=[NSNumber numberWithInt:0];
                        }
                        
                    profileObj.friendship_id=[friendship_data objectForKey:@"id"];
                    
                    NSDictionary *user_data=[friendship_data objectForKey:@"user"];
                    profileObj.uid=[user_data objectForKey:@"id"];
                    
                    profileObj.email=[user_data objectForKey:@"email"];
                    profileObj.status_txt=[user_data objectForKey:@"status"];
                    
                    NSDictionary *profile_data=[user_data objectForKey:@"profile"];
                    profileObj.age=[profile_data objectForKey:@"age"];
                    profileObj.body_art=[profile_data objectForKey:@"body_art"];
                    profileObj.children=[profile_data objectForKey:@"children"];
                    profileObj.ethnicity=[profile_data objectForKey:@"ethnicity"];
                    profileObj.eye_color=[profile_data objectForKey:@"eye_color"];
                    profileObj.figure=[profile_data objectForKey:@"figure"];
                    profileObj.full_name=[profile_data objectForKey:@"full_name"];
                    profileObj.gender=[profile_data objectForKey:@"gender"];
                    profileObj.hair_color=[profile_data objectForKey:@"hair_color"];
                    profileObj.hair_length=[profile_data objectForKey:@"hair_length"];
                    profileObj.height=[profile_data objectForKey:@"height"];
                    profileObj.image=[profile_data objectForKey:@"image"];
                    profileObj.income=[profile_data objectForKey:@"income"];
                    profileObj.living_situation=[profile_data objectForKey:@"living_situation"];
                    profileObj.looking_for=[profile_data objectForKey:@"looking_for"];
                    profileObj.orientation=[profile_data objectForKey:@"orientation"];
                    profileObj.profession=[profile_data objectForKey:@"profession"];
                    profileObj.relationship_status=[profile_data objectForKey:@"relationship_status"];
                    profileObj.religion=[profile_data objectForKey:@"religion"];
                    profileObj.smoker=[profile_data objectForKey:@"smoker"];
                    profileObj.training=[profile_data objectForKey:@"training"];
                    profileObj.weight=[profile_data objectForKey:@"weight"];
                    profileObj.who_looking_for=[profile_data objectForKey:@"who_looking_for"];
                    profileObj.looking_for_age_min=[profile_data objectForKey:@"looking_for_age_min"];
                    profileObj.looking_for_age_max=[profile_data objectForKey:@"looking_for_age_max"];
                    [projectObjArr addObject:profileObj];
                    }
                }
            NSLog(@"profileFriendshipFriendListResult in");
            if ([delegate respondsToSelector:@selector(profileFriendshipFriendListResult:)])
                {
                NSLog(@"profileFriendshipFriendListResult out");
                [delegate profileFriendshipFriendListResult:projectObjArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        
        case FAVOURITE_ADD_FRIENDSHIP:
        {
        //            /////
        //            FAVOURITE_ADD_FRIENDSHIP {
        //                message = "Friend added to favourites";
        //                success = 1;
        //            }
        //            /////
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(addFavouriteResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate addFavouriteResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case FAVOURITE_LISTING_FRIENDSHIP:
        {
        
        
        /////////////////////////////////////////////////////////
        
        
        //            FAVOURITE_LISTING_FRIENDSHIP (
        //                                          {
        //                                              friendship =         {
        //                                                  "created_at" = "2013-12-16T18:07:40Z";
        //                                                  id = 52;
        //                                                  "is_favourite" = 1;
        //                                                  status = accepted;
        //                                                  user =             {
        //                                                      email = "u21@gmail.com";
        //                                                      id = 121;
        //                                                      "last_seen_at" = "2013-12-16T17:58:33Z";
        //                                                      location =                 {
        //                                                          latitude = "6.921623";
        //                                                          longitude = "79.85377";
        //                                                      };
        //                                                      profile =                 {
        //                                                          age = 33;
        //                                                          "body_art" = "";
        //                                                          children = "";
        //                                                          ethnicity = "";
        //                                                          "eye_color" = "";
        //                                                          figure = "";
        //                                                          "full_name" = U21;
        //                                                          gender = male;
        //                                                          "hair_color" = "";
        //                                                          "hair_length" = "";
        //                                                          height = "";
        //                                                          id = 78;
        //                                                          image = "http://flingoo.s3.amazonaws.com/profiles/121-414C097C-20AE-4641-9F53-0EE96B9620C0.jpg";
        //                                                          income = "";
        //                                                          "living_situation" = "";
        //                                                          "looking_for" = male;
        //                                                          "looking_for_age_max" = 60;
        //                                                          "looking_for_age_min" = 17;
        //                                                          orientation = "";
        //                                                          profession = "";
        //                                                          "relationship_status" = "";
        //                                                          religion = "";
        //                                                          smoker = "";
        //                                                          training = "";
        //                                                          "user_id" = 121;
        //                                                          weight = "";
        //                                                          "who_looking_for" = male;
        //                                                      };
        //                                                      status = "";
        //                                                  };
        //                                              };
        //                                          },
        //                                          {
        //                                              friendship =         {
        //                                                  "created_at" = "2013-12-16T18:34:53Z";
        //                                                  id = 54;
        //                                                  "is_favourite" = 1;
        //                                                  status = accepted;
        //                                                  user =             {
        //                                                      email = "u23@gmail.com";
        //                                                      id = 123;
        //                                                      "last_seen_at" = "2013-12-15T14:13:07Z";
        //                                                      location =                 {
        //                                                          latitude = "6.921623";
        //                                                          longitude = "79.85377";
        //                                                      };
        //                                                      profile =                 {
        //                                                          age = 33;
        //                                                          "body_art" = "";
        //                                                          children = "";
        //                                                          ethnicity = "";
        //                                                          "eye_color" = "";
        //                                                          figure = "";
        //                                                          "full_name" = u23;
        //                                                          gender = male;
        //                                                          "hair_color" = "";
        //                                                          "hair_length" = "";
        //                                                          height = "";
        //                                                          id = 80;
        //                                                          image = "http://flingoo.s3.amazonaws.com/profiles/123-A0BCEED6-C40E-47E7-AA93-3D398850EEE4.jpg";
        //                                                          income = "";
        //                                                          "living_situation" = "";
        //                                                          "looking_for" = male;
        //                                                          "looking_for_age_max" = 60;
        //                                                          "looking_for_age_min" = 17;
        //                                                          orientation = "";
        //                                                          profession = "";
        //                                                          "relationship_status" = "";
        //                                                          religion = "";
        //                                                          smoker = "";
        //                                                          training = "";
        //                                                          "user_id" = 123;
        //                                                          weight = "";
        //                                                          "who_looking_for" = male;
        //                                                      };
        //                                                      status = "";
        //                                                  };
        //                                              };
        //                                          }
        //                                          )
        //
        //
        
        
        
        
        ////////////////////////////////////////////////////////////////////
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *favoritesObjArr=[[NSMutableArray alloc] init];
            for (id data in jsonData)
                {
                if ([data isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *friendship_data=[data objectForKey:@"friendship"];
                    FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
                    profileObj.created_at=[friendship_data objectForKey:@"created_at"];
                    profileObj.status=[friendship_data objectForKey:@"status"];
                 
                        if ([[friendship_data objectForKey:@"status"] isEqualToString:@"accepted"])
                        {
                            profileObj.is_friend=[NSNumber numberWithInt:1];
                        }
                        else
                        {
                            profileObj.is_friend=[NSNumber numberWithInt:0];
                        }
                        
                    profileObj.friendship_id=[friendship_data objectForKey:@"id"];
                    
                    NSDictionary *user_data=[friendship_data objectForKey:@"user"];
                    profileObj.uid=[user_data objectForKey:@"id"];
                    
                    profileObj.email=[user_data objectForKey:@"email"];
                    profileObj.status_txt=[user_data objectForKey:@"status"];
                    
                    NSDictionary *profile_data=[user_data objectForKey:@"profile"];
                    profileObj.age=[profile_data objectForKey:@"age"];
                    profileObj.body_art=[profile_data objectForKey:@"body_art"];
                    profileObj.children=[profile_data objectForKey:@"children"];
                    profileObj.ethnicity=[profile_data objectForKey:@"ethnicity"];
                    profileObj.eye_color=[profile_data objectForKey:@"eye_color"];
                    profileObj.figure=[profile_data objectForKey:@"figure"];
                    profileObj.full_name=[profile_data objectForKey:@"full_name"];
                    profileObj.gender=[profile_data objectForKey:@"gender"];
                    profileObj.hair_color=[profile_data objectForKey:@"hair_color"];
                    profileObj.hair_length=[profile_data objectForKey:@"hair_length"];
                    profileObj.height=[profile_data objectForKey:@"height"];
                    profileObj.image=[profile_data objectForKey:@"image"];
                    profileObj.income=[profile_data objectForKey:@"income"];
                    profileObj.living_situation=[profile_data objectForKey:@"living_situation"];
                    profileObj.looking_for=[profile_data objectForKey:@"looking_for"];
                    profileObj.orientation=[profile_data objectForKey:@"orientation"];
                    profileObj.profession=[profile_data objectForKey:@"profession"];
                    profileObj.relationship_status=[profile_data objectForKey:@"relationship_status"];
                    profileObj.religion=[profile_data objectForKey:@"religion"];
                    profileObj.smoker=[profile_data objectForKey:@"smoker"];
                    profileObj.training=[profile_data objectForKey:@"training"];
                    profileObj.weight=[profile_data objectForKey:@"weight"];
                    profileObj.who_looking_for=[profile_data objectForKey:@"who_looking_for"];
                    profileObj.looking_for_age_min=[profile_data objectForKey:@"looking_for_age_min"];
                    profileObj.looking_for_age_max=[profile_data objectForKey:@"looking_for_age_max"];
                    [favoritesObjArr addObject:profileObj];
                    }
                }
            NSLog(@"profileFriendshipFriendListResult in");
            if ([delegate respondsToSelector:@selector(faveritesListResult:)])
                {
                NSLog(@"profileFriendshipFriendListResult out");
                [delegate faveritesListResult:favoritesObjArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        ////////////////////////////////////////////////////////////////////
        
        break;
        }
        case FAVOURITE_REMOVE_FRIENDSHIP:
        {
        //            /////
        //            FAVOURITE_REMOVE_FRIENDSHIP {
        //                message = "Friend added to favourites";
        //                success = 1;
        //            }
        //
        //            /////
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(signOutUserResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate removeFavouriteResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case GROUP_CREATE:
        {
        //            /////
        //            GROUP_CREATE {
        //                message = "Group was successfully created";
        //                success = 1;
        //            }
        //            ////
        
        FLGroup *groupObj=(FLGroup *)jsonData;
        
        if ([delegate respondsToSelector:@selector(groupCreateResult:)])
            {
            [delegate groupCreateResult:groupObj];
            }
        
        break;
        }
        case GROUP_UPDATE:
        {
        //            ///
        //            GROUP_UPDATE {
        //                message = "Group was successfully updated ";
        //                success = 1;
        //            }
        //            ///
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(groupUpdateResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate groupUpdateResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case GROUP_ADD_USER://not complite(seems not working)
        {
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(groupUpdateResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate groupUpdateResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case GROUP_OWNED:        {
            //            ///
            //            GROUP_OWNED (
            //                         {
            //                             group =         {
            //                                 "created_at" = "2013-11-30T17:00:26Z";
            //                                 description = "This is Test Group";
            //                                 id = 5;
            //                                 image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
            //                                 name = "Test Group1";
            //                             };
            //                         }
            //                         )
            //
            //            ///
            if ([jsonData isKindOfClass:[NSArray class]])
                {
                NSMutableArray *createdGroupArr=[[NSMutableArray alloc] init];
                for (id mainObj in jsonData) {
                    
                    if ([mainObj isKindOfClass:[NSDictionary class]])
                        {
                        NSDictionary *obj=[mainObj objectForKey:@"group"];
                        FLCreatedGroup *createdGroup=[[FLCreatedGroup alloc] init];
                        createdGroup.created_at=[obj objectForKey:@"created_at"];
                        createdGroup.description=[obj objectForKey:@"description"];
                        createdGroup.group_id=[obj objectForKey:@"id"];
                        createdGroup.image=[obj objectForKey:@"image"];
                        createdGroup.name=[obj objectForKey:@"name"];
                        [createdGroupArr addObject:createdGroup];
                        }
                }
                if ([delegate respondsToSelector:@selector(groupOwnedResult:)])
                    {
                    [delegate groupOwnedResult:createdGroupArr];
                    }
                }
            else
                {
                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
                }
            break;
        }
        case GROUP_LIST_ALL:
        {
        //            ///////////
        //            GROUP_LIST_ALL (
        //                            {
        //                                group =         {
        //                                    "created_at" = "2013-12-01T06:54:29Z";
        //                                    description = "This is Test Group";
        //                                    id = 7;
        //                                    image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                    latitude = "";
        //                                    longitude = "";
        //                                    name = "Test Group122";
        //                                    owner =             {
        //                                        "full_name" = "";
        //                                        id = 29;
        //                                    };
        //                                };
        //                            },
        //                            {
        //                                group =         {
        //                                    "created_at" = "2013-12-01T06:20:38Z";
        //                                    description = "This is Test Group";
        //                                    id = 6;
        //                                    image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                    latitude = "";
        //                                    longitude = "";
        //                                    name = "Test Group12";
        //                                    owner =             {
        //                                        "full_name" = "";
        //                                        id = 29;
        //                                    };
        //                                };
        //                            },
        //                            {
        //                                group =         {
        //                                    "created_at" = "2013-11-30T17:00:26Z";
        //                                    description = "This is Test Group";
        //                                    id = 5;
        //                                    image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                    latitude = "";
        //                                    longitude = "";
        //                                    name = "Test Group1";
        //                                    owner =             {
        //                                        "full_name" = "";
        //                                        id = 29;
        //                                    };
        //                                };
        //                            },
        //                            {
        //                                group =         {
        //                                    "created_at" = "2013-11-29T16:31:10Z";
        //                                    description = "This is Test Group";
        //                                    id = 4;
        //                                    image = "http://flingoo.s3.amazonaws.com/groups/test.png";
        //                                    latitude = "";
        //                                    longitude = "";
        //                                    name = "Test Group1";
        //                                    owner =             {
        //                                        "full_name" = "";
        //                                        id = 27;
        //                                    };
        //                                };
        //                            },
        //                            {
        //                                group =         {
        //                                    "created_at" = "2013-11-23T10:58:21Z";
        //                                    description = "This is Test Group";
        //                                    id = 3;
        //                                    image = "http://flingoo.s3.amazonaws.com/groups/test.png";
        //                                    latitude = "";
        //                                    longitude = "";
        //                                    name = "Test Group1";
        //                                    owner =             {
        //                                        "full_name" = "";
        //                                        id = 26;
        //                                    };
        //                                };
        //                            },
        //                            {
        //                                group =         {
        //                                    "created_at" = "2013-11-23T10:54:16Z";
        //                                    description = "This is Test Group";
        //                                    id = 2;
        //                                    image = "http://flingoo.s3.amazonaws.com/groups/test.png";
        //                                    latitude = "";
        //                                    longitude = "";
        //                                    name = "Test Group1";
        //                                    owner =             {
        //                                        "full_name" = "";
        //                                        id = 26;
        //                                    };
        //                                };
        //                            },
        //                            {
        //                                group =         {
        //                                    "created_at" = "2013-11-23T10:44:48Z";
        //                                    description = "This is Test Group";
        //                                    id = 1;
        //                                    image = "http://flingoo.s3.amazonaws.com/groups/test.png";
        //                                    latitude = "";
        //                                    longitude = "";
        //                                    name = "Test Group";
        //                                    owner =             {
        //                                        "full_name" = "";
        //                                        id = 26;
        //                                    };
        //                                };
        //                            }
        //                            )
        //
        //            ////////////
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *createdGroupArr=[[NSMutableArray alloc] init];
            for (id mainObj in jsonData) {
                
                if ([mainObj isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *obj=[mainObj objectForKey:@"group"];
                    FLCreatedGroup *createdGroup=[[FLCreatedGroup alloc] init];
                    createdGroup.created_at=[obj objectForKey:@"created_at"];
                    createdGroup.description=[obj objectForKey:@"description"];
                    createdGroup.group_id=[obj objectForKey:@"id"];
                    createdGroup.image=[obj objectForKey:@"image"];
                    createdGroup.latitude=[obj objectForKey:@"latitude"];
                    createdGroup.longitude=[obj objectForKey:@"longitude"];
                    createdGroup.name=[obj objectForKey:@"name"];
                    NSDictionary *owner_dic=[obj objectForKey:@"owner"];
                    if ([owner_dic isKindOfClass:[NSDictionary class]]) {
                        createdGroup.owner_full_name=[owner_dic objectForKey:@"full_name"];
                        createdGroup.owner_user_id=[owner_dic objectForKey:@"id"];
                    }
                    [createdGroupArr addObject:createdGroup];
                    }
            }
            
            
            if ([delegate respondsToSelector:@selector(groupListResult:)])
                {
                [delegate groupListResult:createdGroupArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case MEET_POINT_CREATE:
        {
        //            /////
        //            MEET_POINT_CREATE {
        //                message = "Meet point was successfully created";
        //                success = 1;
        //            }
        //            /////
        //            if ([[jsonData objectForKey:@"success"] boolValue])
        //            {
        //                if ([delegate respondsToSelector:@selector(meetPointCreateResult:)])
        //                {
        //                    NSString *str=[jsonData objectForKey:@"message"];
        //                    [delegate meetPointCreateResult:str];
        //                }
        //            }
        //            else
        //            {
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        
        FLMeetpoint *meetPointObj=(FLMeetpoint *)jsonData;
        if ([delegate respondsToSelector:@selector(meetPointCreateResult:)])
            {
            [delegate meetPointCreateResult:meetPointObj];
            }
        
        break;
        }
        case MEET_POINT_OWNED:
        {
        //            ////
        //            MEET_POINT_OWNED (
        //                              {
        //                                  "meet_point" =         {
        //                                      "created_at" = "2013-11-30T17:15:29Z";
        //                                      "date_time" = "";
        //                                      description = "";
        //                                      id = 5;
        //                                      image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                      latitude = "";
        //                                      longitude = "";
        //                                      name = "";
        //                                  };
        //                              }
        //                              )
        //
        //            ////
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *meetpointArr=[[NSMutableArray alloc] init];
            for (id mainObj in jsonData) {
                
                if ([mainObj isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *obj=[mainObj objectForKey:@"meet_point"];
                    FLMeetpoint *meetpointObj=[[FLMeetpoint alloc] init];
                    meetpointObj.created_at=[obj objectForKey:@"created_at"];
                    meetpointObj.date_time=[obj objectForKey:@"date_time"];
                    meetpointObj.description=[obj objectForKey:@"description"];
                    meetpointObj.point_id=[obj objectForKey:@"id"];
                    meetpointObj.image=[obj objectForKey:@"image"];
                    meetpointObj.latitude=[obj objectForKey:@"latitude"];
                    meetpointObj.longitude=[obj objectForKey:@"longitude"];
                    meetpointObj.name=[obj objectForKey:@"name"];
                    [meetpointArr addObject:meetpointObj];
                    }
            }
            if ([delegate respondsToSelector:@selector(meetpointOwnedResult:)])
                {
                [delegate meetpointOwnedResult:meetpointArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        
        case MEET_POINT_LIST_ALL://incomplete implementation(not working)
        {
        //            if ([jsonData isKindOfClass:[NSArray class]])
        //            {
        //                NSMutableArray *meetpointArr=[[NSMutableArray alloc] init];
        //                for (id mainObj in jsonData) {
        //
        //                    if ([mainObj isKindOfClass:[NSDictionary class]])
        //                    {
        //                        NSDictionary *obj=[mainObj objectForKey:@"meet_point"];
        //                        FLMeetpoint *meetpointObj=[[FLMeetpoint alloc] init];
        //                        meetpointObj.created_at=[obj objectForKey:@"created_at"];
        //                        meetpointObj.date_time=[obj objectForKey:@"date_time"];
        //                        meetpointObj.description=[obj objectForKey:@"description"];
        //                        meetpointObj.point_id=[obj objectForKey:@"id"];
        //                        meetpointObj.image=[obj objectForKey:@"image"];
        //                        meetpointObj.latitude=[obj objectForKey:@"latitude"];
        //                        meetpointObj.longitude=[obj objectForKey:@"longitude"];
        //                        meetpointObj.name=[obj objectForKey:@"name"];
        //                        [meetpointArr addObject:meetpointObj];
        //                    }
        //                }
        //                if ([delegate respondsToSelector:@selector(meetpointOwnedResult:)])
        //                {
        //                    [delegate meetpointOwnedResult:meetpointArr];
        //                }
        //            }
        //            else
        //            {
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        break;
        }
        case TAXI_POINT_CREATE:
        {
        //            ////
        //            TAXI_POINT_CREATE {
        //                message = "Taxi point was successfully created";
        //                success = 1;
        //            }
        //            ////
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(taxipointCreateResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate taxipointCreateResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case RADAR_SEARCH:
        {
        
        //            RADAR_SEARCH {
        //                groups =     (
        //                              {
        //                                  group =             {
        //                                      description = "Testing <3";
        //                                      id = 34;
        //                                      "is_owner" = 0;
        //                                      latitude = "6.84174409";
        //                                      longitude = "79.98115147";
        //                                      name = "Test Group";
        //                                  };
        //                              },
        //                              {
        //                                  group =             {
        //                                      description = "Test group";
        //                                      id = 35;
        //                                      "is_owner" = 0;
        //                                      latitude = "6.921623";
        //                                      longitude = "79.85377";
        //                                      name = "Test Group 1";
        //                                  };
        //                              }
        //                              );
        //                "location_points" =     (
        //                );
        //                "meet_points" =     (
        //                                     {
        //                                         "meet_point" =             {
        //                                             "created_at" = "2013-12-27T14:15:35Z";
        //                                             "date_time" = "";
        //                                             description = tttt;
        //                                             id = 27;
        //                                             image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                             "is_owner" = 0;
        //                                             latitude = 0;
        //                                             longitude = 0;
        //                                             name = testttt;
        //                                         };
        //                                     },
        //                                     {
        //                                         "meet_point" =             {
        //                                             "created_at" = "2013-12-28T08:34:35Z";
        //                                             "date_time" = "";
        //                                             description = test;
        //                                             id = 28;
        //                                             image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                             "is_owner" = 0;
        //                                             latitude = "47.7036593071553";
        //                                             longitude = "9.254383184015751";
        //                                             name = test;
        //                                         };
        //                                     }
        //                                     );
        //                "taxi_points" =     (
        //                );
        //                users =     (
        //                             {
        //                                 user =             {
        //                                     email = "tablet@kodagoda.com";
        //                                     id = 157;
        //                                     "is_friend" = 0;
        //                                     "is_online" = 0;
        //                                     "last_seen_at" = "2013-12-28T15:03:58Z";
        //                                     location =                 {
        //                                         latitude = "6.54239888459125";
        //                                         longitude = "80.1599943637848";
        //                                     };
        //                                     profile =                 {
        //                                         age = 27;
        //                                         "body_art" = "";
        //                                         children = "";
        //                                         ethnicity = "";
        //                                         "eye_color" = "";
        //                                         figure = "";
        //                                         "full_name" = "Tablet User";
        //                                         gender = female;
        //                                         "hair_color" = "";
        //                                         "hair_length" = "";
        //                                         height = "";
        //                                         id = 114;
        //                                         image = "http://flingoo.s3.amazonaws.com/profiles/157-71320300-75dd-4b24-bb48-73ebf407270c.jpg";
        //                                         income = "";
        //                                         "living_situation" = "";
        //                                         "looking_for" = men;
        //                                         "looking_for_age_max" = 60;
        //                                         "looking_for_age_min" = 17;
        //                                         orientation = "";
        //                                         profession = "";
        //                                         "relationship_status" = "";
        //                                         religion = "";
        //                                         smoker = "";
        //                                         training = "";
        //                                         "user_id" = 157;
        //                                         weight = "";
        //                                         "who_looking_for" = both;
        //                                     };
        //                                     status = "";
        //                                 };
        //                             },
        //                             {
        //                                 user =             {
        //                                     email = "micromax@kodagoda.com";
        //                                     id = 169;
        //                                     "is_friend" = 0;
        //                                     "is_online" = 0;
        //                                     "last_seen_at" = "2013-12-27T16:30:54Z";
        //                                     location =                 {
        //                                         latitude = "6.54326425879614";
        //                                         longitude = "80.15623424202199";
        //                                     };
        //                                     profile =                 {
        //                                         age = 28;
        //                                         "body_art" = "";
        //                                         children = "";
        //                                         ethnicity = "";
        //                                         "eye_color" = "";
        //                                         figure = "";
        //                                         "full_name" = "Micro Max";
        //                                         gender = female;
        //                                         "hair_color" = "";
        //                                         "hair_length" = "";
        //                                         height = "";
        //                                         id = 126;
        //                                         image = "http://flingoo.s3.amazonaws.com/profiles/169-9e36fa6e-9627-47db-a928-b0799a11a856.jpg";
        //                                         income = "";
        //                                         "living_situation" = "";
        //                                         "looking_for" = men;
        //                                         "looking_for_age_max" = 60;
        //                                         "looking_for_age_min" = 17;
        //                                         orientation = "";
        //                                         profession = "";
        //                                         "relationship_status" = "";
        //                                         religion = "";
        //                                         smoker = "";
        //                                         training = "";
        //                                         "user_id" = 169;
        //                                         weight = "";
        //                                         "who_looking_for" = both;
        //                                     };
        //                                     status = "";
        //                                 };
        //                             }
        //                             );
        //            }
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]])
            {
            NSMutableArray *radarObjArr=[[NSMutableArray alloc] init];
            NSLog(@"RADAR RESPONSE %@", radarObjArr);
            //group object
            id groupsArr=[jsonData objectForKey:@"groups"];
            if ([groupsArr isKindOfClass:[NSArray class]])
                {
                for (id groupObj in groupsArr)
                    {
                    if ([groupObj isKindOfClass:[NSDictionary class]])
                        {
                        NSDictionary *groupDic=[groupObj objectForKey:@"group"];
                        
                        
                        FLRadarObject *radarObj=[[FLRadarObject alloc] init];
                        radarObj.desc = [groupDic objectForKey:@"description"];
                        radarObj.radarID=[groupDic objectForKey:@"id"];
                        radarObj.latitude=[groupDic objectForKey:@"latitude"];
                        radarObj.longitude=[groupDic objectForKey:@"longitude"];
                        radarObj.name=[groupDic objectForKey:@"name"];
                        radarObj.radarType =TYPE_GROUP;
                        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[radarObj.latitude floatValue] longitude:[radarObj.longitude floatValue]];
                        [radarObj setLocation:loc];
                        [radarObjArr addObject:radarObj];
                        }
                    }
                }
            
            //meet_points object
            id meet_pointsArr=[jsonData objectForKey:@"meet_points"];
            if ([meet_pointsArr isKindOfClass:[NSArray class]])
                {
                for (id meet_pointObj in meet_pointsArr)
                    {
                    if ([meet_pointObj isKindOfClass:[NSDictionary class]])
                        {
                        NSDictionary *meet_pointDic=[meet_pointObj objectForKey:@"meet_point"];
                        
                        
                        FLRadarObject *radarObj=[[FLRadarObject alloc] init];
                        radarObj.created_at=[meet_pointDic objectForKey:@"created_at"];
                        radarObj.date_time=[meet_pointDic objectForKey:@"date_time"];
                        radarObj.desc = [meet_pointDic objectForKey:@"description"];
                        radarObj.radarID=[meet_pointDic objectForKey:@"id"];
                        radarObj.image=[meet_pointDic objectForKey:@"image"];
                        radarObj.latitude=[meet_pointDic objectForKey:@"latitude"];
                        radarObj.longitude=[meet_pointDic objectForKey:@"longitude"];
                        radarObj.name=[meet_pointDic objectForKey:@"name"];
                        radarObj.radarType =TYPE_MEET_POINT;
                        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[radarObj.latitude floatValue] longitude:[radarObj.longitude floatValue]];
                        [radarObj setLocation:loc];
                        [radarObjArr addObject:radarObj];
                        }
                    }
                }
            
            //taxi_points object
            id taxi_pointsArr=[jsonData objectForKey:@"taxi_points"];
            if ([taxi_pointsArr isKindOfClass:[NSArray class]])
                {
                for (id taxi_pointObj in taxi_pointsArr)
                    {
                    if ([taxi_pointObj isKindOfClass:[NSDictionary class]])
                        {
                        NSDictionary *taxi_pointDic=[taxi_pointObj objectForKey:@"taxi_point"];
                        
                        
                        FLRadarObject *radarObj=[[FLRadarObject alloc] init];
                        radarObj.created_at=[taxi_pointDic objectForKey:@"created_at"];
                        radarObj.destination_address=[taxi_pointDic objectForKey:@"destination_address"];
                        radarObj.destination_latitude=[taxi_pointDic objectForKey:@"destination_latitude"];
                        radarObj.destination_longitude=[taxi_pointDic objectForKey:@"destination_longitude"];
                        radarObj.radarID=[taxi_pointDic objectForKey:@"id"];
                        radarObj.no_of_seats=[[taxi_pointDic objectForKey:@"no_of_seats"] intValue];
                        radarObj.start_address=[taxi_pointDic objectForKey:@"start_address"];
                        radarObj.start_latitude=[taxi_pointDic objectForKey:@"start_latitude"];
                        radarObj.start_longitude=[taxi_pointDic objectForKey:@"start_longitude"];
                        radarObj.start_time=[taxi_pointDic objectForKey:@"start_time"];
                        radarObj.radarType =TYPE_TAXI_POINT;
                        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[radarObj.start_latitude floatValue] longitude:[radarObj.start_longitude floatValue]];
                        [radarObj setLocation:loc];
                        [radarObjArr addObject:radarObj];
                        }
                    }
                }
            
            //taxi_points object
            id user_pointsArr=[jsonData objectForKey:@"users"];
            if ([user_pointsArr isKindOfClass:[NSArray class]])
                {
                for (id user_pointObj in user_pointsArr)
                    {
                    if ([user_pointObj isKindOfClass:[NSDictionary class]])
                        {
                        NSDictionary *user_pointDic=[user_pointObj objectForKey:@"user"];
                        
                        
                        FLOtherProfile *userObj=[[FLOtherProfile alloc] init];
                        FLRadarObject *radarObj=[[FLRadarObject alloc] init];
                        
                        userObj.email=[user_pointDic objectForKey:@"email"];
                        userObj.uid=[user_pointDic objectForKey:@"id"];
                        userObj.is_friend=[user_pointDic objectForKey:@"is_friend"];
                        userObj.is_online=[user_pointDic objectForKey:@"is_online"];
                        userObj.last_seen_at=[user_pointDic objectForKey:@"last_seen_at"];
                        if ([[user_pointDic objectForKey:@"location"] isKindOfClass:[NSDictionary class]])
                            {
                            NSDictionary *locationDic=[user_pointDic objectForKey:@"location"];
                            userObj.latitude=[locationDic objectForKey:@"latitude"];
                            userObj.longitude=[locationDic objectForKey:@"longitude"];
                            
                            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[locationDic objectForKey:@"latitude"] floatValue] longitude:[[locationDic objectForKey:@"longitude"] floatValue]];
                            [radarObj setLocation:loc];
                            
                            }
                        
                        if ([[user_pointDic objectForKey:@"profile"] isKindOfClass:[NSDictionary class]])
                            {
                            NSDictionary *profileDic=[user_pointDic objectForKey:@"profile"];
                            userObj.age=[profileDic objectForKey:@"age"];
                            userObj.body_art=[profileDic objectForKey:@"body_art"];
                            userObj.children=[profileDic objectForKey:@"children"];
                            userObj.ethnicity=[profileDic objectForKey:@"ethnicity"];
                            userObj.eye_color=[profileDic objectForKey:@"eye_color"];
                            userObj.figure=[profileDic objectForKey:@"figure"];
                            userObj.full_name=[profileDic objectForKey:@"full_name"];
                            userObj.gender=[profileDic objectForKey:@"gender"];
                            userObj.hair_color=[profileDic objectForKey:@"hair_color"];
                            userObj.hair_length=[profileDic objectForKey:@"hair_length"];
                            userObj.height=[profileDic objectForKey:@"height"];
                            userObj.image=[profileDic objectForKey:@"image"];
                            userObj.income=[profileDic objectForKey:@"income"];
                            userObj.living_situation=[profileDic objectForKey:@"living_situation"];
                            userObj.looking_for=[profileDic objectForKey:@"looking_for"];
                            userObj.looking_for_age_max=[profileDic objectForKey:@"looking_for_age_max"];
                            userObj.looking_for_age_min=[profileDic objectForKey:@"looking_for_age_min"];
                            userObj.orientation=[profileDic objectForKey:@"orientation"];
                            userObj.profession=[profileDic objectForKey:@"profession"];
                            userObj.relationship_status=[profileDic objectForKey:@"relationship_status"];
                            userObj.religion=[profileDic objectForKey:@"religion"];
                            userObj.smoker=[profileDic objectForKey:@"smoker"];
                            userObj.training=[profileDic objectForKey:@"training"];
                            userObj.weight=[profileDic objectForKey:@"weight"];
                            userObj.religion=[profileDic objectForKey:@"who_looking_for"];
                            
                            }
                        
                        
                        userObj.status=[user_pointDic objectForKey:@"status"];
                            
                        radarObj.userObj=userObj;
                        [radarObjArr addObject:radarObj];
                        }
                    }
                }
            
            
            //                    for (int x=0; x<[radarObjArr count]; x++)
            //                    {
            //                        FLRadarObject *obj=[radarObjArr objectAtIndex:x];
            //                        NSLog(@"obj.description %@",obj.description);
            //                        NSLog(@"obj.radarID %@",obj.radarID);
            //                        NSLog(@"obj.name %@",obj.name);
            //                        NSLog(@"/////////////");
            //                         NSLog(@"obj.image %@",obj.image);
            //
            //                        NSLog(@"/////////////");
            //                         NSLog(@"obj.start_address %@",obj.start_address);
            //                    }
            
            
            if ([delegate respondsToSelector:@selector(radarSearchResult:)])
                {
                [delegate  radarSearchResult:radarObjArr];
                }
            
            
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        break;
        }
        case HEARTBEAT:
        {
        //           ///
        //            HEARTBEAT {
        //                "last_seen_at" = "2013-11-30T17:43:17Z";
        //                message = OK;
        //                success = 1;
        //            }
        //            ///
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(heartBeatResult:)])
                {
                NSString *str=[jsonData objectForKey:@"last_seen_at"];
                [delegate  heartBeatResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case STATUS_UPDATE:
        {
        /////////////////
        //            STATUS_UPDATE {
        //                message = "Status was successfully created";
        //                success = 1;
        //            }
        /////////////////
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(statusUpdateResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  statusUpdateResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case PROFILE_VISITORS:
        {
        
        //            PROFILE_VISITORS (
        //                              {
        //                                  user =         {
        //                                      id = 123;
        //                                      "is_friend" = 0;
        //                                      "is_online" = 0;
        //                                      "last_seen_at" = "2013-12-15T14:13:07Z";
        //                                      location =             {
        //                                          latitude = "6.921623";
        //                                          longitude = "79.85377";
        //                                      };
        //                                      profile =             {
        //                                          "full_name" = u23;
        //                                          image = "http://flingoo.s3.amazonaws.com/profiles/123-A0BCEED6-C40E-47E7-AA93-3D398850EEE4.jpg";
        //                                      };
        //                                      status = "";
        //                                  };
        //                              },
        //                              {
        //                                  user =         {
        //                                      id = 122;
        //                                      "is_friend" = 0;
        //                                      "is_online" = 0;
        //                                      "last_seen_at" = "2013-12-16T07:41:00Z";
        //                                      location =             {
        //                                          latitude = "6.921623";
        //                                          longitude = "79.85377";
        //                                      };
        //                                      profile =             {
        //                                          "full_name" = U22;
        //                                          image = "http://flingoo.s3.amazonaws.com/profiles/122-0675AF28-AB0C-460C-AD7C-E24D6DE6B186.jpg";
        //                                      };
        //                                      status = "";
        //                                  };
        //                              }
        //                              )
        
        
        
        
        /////////////////////////////////////////////////////////
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *profileVisitorsArr=[[NSMutableArray alloc] init];
            for(id users in jsonData)
                {
                if ([users isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *userDic=[users objectForKey:@"user"];
                    FLOtherProfile *otherProfile=[[FLOtherProfile alloc] init];
                    otherProfile.uid=[userDic objectForKey:@"id"];
                    otherProfile.is_friend=[userDic objectForKey:@"is_friend"];
                    otherProfile.is_online=[userDic objectForKey:@"is_online"];
                    otherProfile.last_seen_at=[userDic objectForKey:@"last_seen_at"];
                    otherProfile.status=[userDic objectForKey:@"status"];
                        if ([[userDic objectForKey:@"location"] isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *userDic_location=[userDic objectForKey:@"location"];
                            otherProfile.longitude=[userDic_location objectForKey:@"longitude"];
                            otherProfile.latitude=[userDic_location objectForKey:@"latitude"];
                        }
                    NSDictionary *userDic_profile=[userDic objectForKey:@"profile"];
                    otherProfile.full_name=[userDic_profile objectForKey:@"full_name"];
                    otherProfile.image=[userDic_profile objectForKey:@"image"];
                    
                    
                    [profileVisitorsArr addObject:otherProfile];
                    
                    }
                }
            
            if ([delegate respondsToSelector:@selector(profileVisitorsResult:)])
                {
                [delegate  profileVisitorsResult:profileVisitorsArr];
                }
            
            
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        break;
        
        /////////////////////////////////////////////////////////
        
        }
        case PROFILE_VISITS:
        {
        
        //            PROFILE_VISITORS (
        //                              {
        //                                  user =         {
        //                                      id = 123;
        //                                      "is_friend" = 0;
        //                                      "is_online" = 0;
        //                                      "last_seen_at" = "2013-12-15T14:13:07Z";
        //                                      location =             {
        //                                          latitude = "6.921623";
        //                                          longitude = "79.85377";
        //                                      };
        //                                      profile =             {
        //                                          "full_name" = u23;
        //                                          image = "http://flingoo.s3.amazonaws.com/profiles/123-A0BCEED6-C40E-47E7-AA93-3D398850EEE4.jpg";
        //                                      };
        //                                      status = "";
        //                                  };
        //                              },
        //                              {
        //                                  user =         {
        //                                      id = 122;
        //                                      "is_friend" = 0;
        //                                      "is_online" = 0;
        //                                      "last_seen_at" = "2013-12-16T07:41:00Z";
        //                                      location =             {
        //                                          latitude = "6.921623";
        //                                          longitude = "79.85377";
        //                                      };
        //                                      profile =             {
        //                                          "full_name" = U22;
        //                                          image = "http://flingoo.s3.amazonaws.com/profiles/122-0675AF28-AB0C-460C-AD7C-E24D6DE6B186.jpg";
        //                                      };
        //                                      status = "";
        //                                  };
        //                              }
        //                              )
        
        
        
        
        /////////////////////////////////////////////////////////
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *profileVisitsArr=[[NSMutableArray alloc] init];
            for(id users in jsonData)
                {
                if ([users isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *userDic=[users objectForKey:@"user"];
                    FLOtherProfile *otherProfile=[[FLOtherProfile alloc] init];
                    otherProfile.uid=[userDic objectForKey:@"id"];
                    otherProfile.is_friend=[userDic objectForKey:@"is_friend"];
                    otherProfile.is_online=[userDic objectForKey:@"is_online"];
                    otherProfile.last_seen_at=[userDic objectForKey:@"last_seen_at"];
                    otherProfile.status=[userDic objectForKey:@"status"];
                    
                    NSDictionary *userDic_location=[userDic objectForKey:@"location"];
                    otherProfile.longitude=[userDic_location objectForKey:@"longitude"];
                    otherProfile.latitude=[userDic_location objectForKey:@"latitude"];
                    
                    NSDictionary *userDic_profile=[userDic objectForKey:@"profile"];
                    otherProfile.full_name=[userDic_profile objectForKey:@"full_name"];
                    otherProfile.image=[userDic_profile objectForKey:@"image"];
                    
                    
                    [profileVisitsArr addObject:otherProfile];
                    
                    }
                }
            
            if ([delegate respondsToSelector:@selector(profileVisitsResult:)])
                {
                [delegate  profileVisitsResult:profileVisitsArr];
                }
            
            
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        break;
        
        /////////////////////////////////////////////////////////
        
        }
        
        case IMAGE_UPLOAD:
        {
        FLImgObj *imgObj=(FLImgObj *)jsonData;
        ////////////////////////////////////////
        if ([imgObj.folder_name isEqualToString:IMAGE_DIRECTORY_PROFILE])
            {
            if ([delegate respondsToSelector:@selector(profileImageUploaded:)])
                {
                [delegate  profileImageUploaded:imgObj];
                }
            }
        else if ([imgObj.folder_name isEqualToString:IMAGE_DIRECTORY_GROUP])
            {
            if ([delegate respondsToSelector:@selector(groupImageUploaded:)])
                {
                [delegate  groupImageUploaded:imgObj];
                }
            }
        else if ([imgObj.folder_name isEqualToString:IMAGE_DIRECTORY_MEETPOINT])
            {
            if ([delegate respondsToSelector:@selector(meetPointImageUploaded:)])
                {
                [delegate  meetPointImageUploaded:imgObj];
                }
            }
        else if ([imgObj.folder_name isEqualToString:IMAGE_DIRECTORY_ALBUM])
            {
            if ([delegate respondsToSelector:@selector(albumImageUploaded:)])
                {
                [delegate  albumImageUploaded:imgObj];
                }
            }
        break;
        }
        
        case CHAT_SEND:
        {
        
        //            {
        //                "success": true,
        //                "message": "Message sent"
        //            }
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(statusUpdateResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  chatSendResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        
        case USER_SHOW:
        {
        //            //////////
        //            USER_SHOW {
        //                user =     {
        //                    email = "u17@gmail.com";
        //                    id = 114;
        //                    "interview_questions" =         (
        //                                                     {
        //                                                         "interview_question" =                 {
        //                                                             "question_id" = 1;
        //                                                             "question_option_id" = "";
        //                                                         };
        //                                                     },
        //                                                     {
        //                                                         "interview_question" =                 {
        //                                                             "question_id" = 2;
        //                                                             "question_option_id" = "";
        //                                                         };
        //                                                     },
        //                                                     {
        //                                                         "interview_question" =                 {
        //                                                             "question_id" = 3;
        //                                                             "question_option_id" = "";
        //                                                         };
        //                                                     },
        //                                                     {
        //                                                         "interview_question" =                 {
        //                                                             "question_id" = 4;
        //                                                             "question_option_id" = "";
        //                                                         };
        //                                                     },
        //                                                     {
        //                                                         "interview_question" =                 {
        //                                                             "question_id" = 5;
        //                                                             "question_option_id" = "";
        //                                                         };
        //                                                     },
        //                                                     {
        //                                                         "interview_question" =                 {
        //                                                             "question_id" = 6;
        //                                                             "question_option_id" = "";
        //                                                         };
        //                                                     },
        //                                                     {
        //                                                         "interview_question" =                 {
        //                                                             "question_id" = 7;
        //                                                             "question_option_id" = "";
        //                                                         };
        //                                                     },
        //                                                     {
        //                                                         "interview_question" =                 {
        //                                                             "question_id" = 8;
        //                                                             "question_option_id" = "";
        //                                                         };
        //                                                     },
        //                                                     {
        //                                                         "interview_question" =                 {
        //                                                             "question_id" = 9;
        //                                                             "question_option_id" = "";
        //                                                         };
        //                                                     }
        //                                                     );
        //                    "is_friend" = 0;
        //                    "is_online" = 0;
        //                    "last_seen_at" = "2013-11-24T05:07:16Z";
        //                    location =         {
        //                        latitude = "6.921623";
        //                        longitude = "79.85377";
        //                    };
        //                    profile =         {
        //                        age = 24;
        //                        "body_art" = "";
        //                        children = "";
        //                        ethnicity = "";
        //                        "eye_color" = "";
        //                        figure = "";
        //                        "full_name" = U17;
        //                        gender = male;
        //                        "hair_color" = "";
        //                        "hair_length" = "";
        //                        height = "";
        //                        id = 71;
        //                        image = "http://flingoo.s3.amazonaws.com/profiles/114-45470BB1-B438-45F9-9CF3-B6B4D8E251A1.jpg";
        //                        income = "";
        //                        "living_situation" = "";
        //                        "looking_for" = male;
        //                        "looking_for_age_max" = 60;
        //                        "looking_for_age_min" = 17;
        //                        orientation = "";
        //                        profession = "";
        //                        "relationship_status" = "";
        //                        religion = "";
        //                        smoker = "";
        //                        training = "";
        //                        "user_id" = 114;
        //                        weight = "";
        //                        "who_looking_for" = male;
        //                    };
        //                    status = "";
        //                };
        //            }
        //            //////////
        
        
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]])
            {
            
            NSDictionary *user_data=[jsonData objectForKey:@"user"];
            FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
            profileObj.email=[user_data objectForKey:@"email"];
            profileObj.uid=[user_data objectForKey:@"id"];
            
            
            
            NSArray *interviewQuestionArr=[user_data objectForKey:@"interview_questions"];
            if (profileObj.interviewQuestionsArr==nil) {
                profileObj.interviewQuestionsArr=[[NSMutableArray alloc] init];
            }
            for (id interviewQuestion in interviewQuestionArr)
                {
                NSDictionary *myDetailObj=[interviewQuestion objectForKey:@"interview_question"];
                FLMyDetail *myDetail=[[FLMyDetail alloc] init];
                myDetail.questionKey=[myDetailObj objectForKey:@"question_id"];
                if ([[myDetailObj objectForKey:@"question_option_id"] isEqual:@""])
                    {
                    myDetail.user_answer_index=(-1);
                    }
                else
                    {
                    myDetail.user_answer_index=[[myDetailObj objectForKey:@"question_option_id"] integerValue];
                    }
                [profileObj.interviewQuestionsArr addObject:myDetail];
                }
            
            
            
            
            
            profileObj.is_friend=[user_data objectForKey:@"is_friend"];
            profileObj.is_online=[user_data objectForKey:@"is_online"];
            profileObj.last_seen_at=[user_data objectForKey:@"last_seen_at"];
            profileObj.status_txt=[user_data objectForKey:@"status"];
            
            NSDictionary *location_data=[user_data objectForKey:@"location"];
            profileObj.longitude=[location_data objectForKey:@"longitude"];
            profileObj.latitude=[location_data objectForKey:@"latitude"];
            
            NSDictionary *profile_data=[user_data objectForKey:@"profile"];
            profileObj.age=[profile_data objectForKey:@"age"];
            profileObj.body_art=[profile_data objectForKey:@"body_art"];
            profileObj.children=[profile_data objectForKey:@"children"];
            profileObj.ethnicity=[profile_data objectForKey:@"ethnicity"];
            profileObj.eye_color=[profile_data objectForKey:@"eye_color"];
            profileObj.figure=[profile_data objectForKey:@"figure"];
            profileObj.full_name=[profile_data objectForKey:@"full_name"];
            profileObj.gender=[profile_data objectForKey:@"gender"];
            profileObj.hair_color=[profile_data objectForKey:@"hair_color"];
            profileObj.hair_length=[profile_data objectForKey:@"hair_length"];
            profileObj.height=[profile_data objectForKey:@"height"];
            profileObj.image=[profile_data objectForKey:@"image"];
            profileObj.income=[profile_data objectForKey:@"income"];
            profileObj.living_situation=[profile_data objectForKey:@"living_situation"];
            profileObj.looking_for=[profile_data objectForKey:@"looking_for"];
            //                        profileObj.mobile_number=[profile_data objectForKey:@"mobile_number"];
            profileObj.orientation=[profile_data objectForKey:@"orientation"];
            profileObj.profession=[profile_data objectForKey:@"profession"];
            profileObj.relationship_status=[profile_data objectForKey:@"relationship_status"];
            profileObj.religion=[profile_data objectForKey:@"religion"];
            profileObj.smoker=[profile_data objectForKey:@"smoker"];
            profileObj.training=[profile_data objectForKey:@"training"];
            //                        profileObj.user_id=[profile_data objectForKey:@"user_id"];
            profileObj.weight=[profile_data objectForKey:@"weight"];
            profileObj.who_looking_for=[profile_data objectForKey:@"who_looking_for"];
            profileObj.looking_for_age_min=[profile_data objectForKey:@"looking_for_age_min"];
            profileObj.looking_for_age_max=[profile_data objectForKey:@"looking_for_age_max"];
            
            if ([delegate respondsToSelector:@selector(userShowResult:)])
                {
                [delegate userShowResult:profileObj];
                }
            
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        case CREATE_ALBUM:
        {
        
        //            CREATE_ALBUM {
        //                id = 47;
        //                message = "Album was successfully created";
        //                success = 1;
        //            }
        
        
        if ([delegate respondsToSelector:@selector(albumCreateResult:)])
            {
            FLAlbum *albumObj=(FLAlbum *)jsonData;
            [delegate  albumCreateResult:albumObj];
            }
        
        break;
        }
        case ALBUM_LIST:
        {
        
        //            ALBUM_LIST (
        //                        {
        //                            album =         {
        //                                "cover_image" = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                "created_at" = "2013-12-23T17:19:50Z";
        //                                id = 160;
        //                                moments = 0;
        //                                "photo_count" = 1;
        //                                profile = 0;
        //                                title = "test album 1";
        //                            };
        //                        },
        //                        {
        //                            album =         {
        //                                "cover_image" = "";
        //                                "created_at" = "2013-12-23T16:18:44Z";
        //                                id = 156;
        //                                moments = 1;
        //                                "photo_count" = 0;
        //                                profile = 0;
        //                                title = Moments;
        //                            };
        //                        }
        //                        )
        
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSArray *jsonArr=(NSArray *)jsonData;
            NSMutableArray *albumArr=[[NSMutableArray alloc] init];
            for(id album in jsonArr)
                {
                if ([album isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *albumDic=[album objectForKey:@"album"];
                    FLAlbum *albumObj=[[FLAlbum alloc] init];
                    albumObj.title=[albumDic objectForKey:@"title"];
                    albumObj.moments=[[albumDic objectForKey:@"moments"] intValue];
                    albumObj.albumID=[albumDic objectForKey:@"id"];
                    albumObj.created_at=[albumDic objectForKey:@"created_at"];
                    albumObj.cover_image=[albumDic objectForKey:@"cover_image"];
                    albumObj.photo_count=[[albumDic objectForKey:@"photo_count"] intValue];
                    [albumArr addObject:albumObj];
                    }
                }
            
            if ([delegate respondsToSelector:@selector(albumListResult:)])
                {
                [delegate  albumListResult:albumArr];
                }
            }
        
        
        
        break;
        }
        case DELETE_ALBUM:
        {
        
        
        //            DELETE_ALBUM {
        //                message = "Album was successfully deleted ";
        //                success = 1;
        //            }
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(albumDeleteResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  albumDeleteResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        case ALBUM_PHOTO_LIST:
        {
        
        //            ALBUM_PHOTO_LIST {
        //                album =     {
        //                    "created_at" = "2013-12-14T15:30:35Z";
        //                    id = 54;
        //                    moments = 0;
        //                    photos =         (
        //                                      {
        //                                          photo =                 {
        //                                              "created_at" = "2013-12-14T18:39:19Z";
        //                                              id = 4;
        //                                              image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                              title = "";
        //                                          };
        //                                      },
        //                                      {
        //                                          photo =                 {
        //                                              "created_at" = "2013-12-14T18:38:28Z";
        //                                              id = 3;
        //                                              image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                              title = "";
        //                                          };
        //                                      },
        //                                      {
        //                                          photo =                 {
        //                                              "created_at" = "2013-12-14T18:24:43Z";
        //                                              id = 2;
        //                                              image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                              title = "";
        //                                          };
        //                                      }
        //                                      );
        //                    title = "test album2";
        //                };
        //            }
        
        if ([jsonData isKindOfClass:[NSDictionary class]])
            {
            NSDictionary *jsonDic=(NSDictionary *)[jsonData objectForKey:@"album"];
            
            NSArray *photosDetailsDic= (NSArray *)[jsonDic objectForKey:@"photos"];
            
            NSMutableArray *photoArr=[[NSMutableArray alloc] init];
            for(id photos in photosDetailsDic)
                {
                if ([photos isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *photoDic=[photos objectForKey:@"photo"];
                    FLPhoto *photoObj=[[FLPhoto alloc] init];
                    photoObj.title=[photoDic objectForKey:@"title"];
                    photoObj.created_at=[photoDic objectForKey:@"created_at"];
                    photoObj.imgID=[photoDic objectForKey:@"id"];
                    photoObj.imgURL=[photoDic objectForKey:@"image"];
                    [photoArr addObject:photoObj];
                    }
                }
            
            if ([delegate respondsToSelector:@selector(albumPhotoListResult:)])
                {
                [delegate  albumPhotoListResult:photoArr];
                }
            
            
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        case ALBUM_PHOTO_UPLOAD:
        {
        
        
        //        ALBUM_PHOTO_UPLOAD {
        //            id = 2;
        //            message = "Photo was successfully created";
        //            success = 1;
        //        }
        
        
        if ([delegate respondsToSelector:@selector(albumPhotoUploadedResult:)])
            {
            FLPhoto *photoObj=(FLPhoto *)jsonData;
            [delegate  albumPhotoUploadedResult:photoObj];
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        
        case DELETE_PHOTO:
        {
        
        //            DELETE_PHOTO {
        //                message = "Photo was successfully deleted ";
        //                success = 1;
        //            }
        
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(deletePhotoResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  deletePhotoResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        
        case INTERVIEW_QUSTION_LIST:
        {
        
        //    INTERVIEW_QUSTION_LIST (
        //    {
        //    question =         {
        //        id = 1;
        //        options =             (
        //                               {
        //                                   option =                     {
        //                                       id = 1;
        //                                       title = "Nice people for chats";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 2;
        //                                       title = "Amazing chats";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 3;
        //                                       title = "Affair, adventure";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 4;
        //                                       title = "A Permanent relationship";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 5;
        //                                       title = "New friends";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 6;
        //                                       title = "Partner for hobby and leisure";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 7;
        //                                       title = "Whatever happens";
        //                                   };
        //                               }
        //                               );
        //        ordering = 0;
        //        title = "What are you looking for?";
        //    };
        //    },
        //    {
        //    question =         {
        //        id = 2;
        //        options =             (
        //                               {
        //                                   option =                     {
        //                                       id = 8;
        //                                       title = "Faithfulness is highest";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 9;
        //                                       title = "I try to be faithful";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 10;
        //                                       title = "A simple slip is ok";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 11;
        //                                       title = "Mental faithfulness is what is important ";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 12;
        //                                       title = "Faithfulness doesn't correspond with relationship ";
        //                                   };
        //                               }
        //                               );
        //        ordering = 0;
        //        title = "How important is faithfulness to you?";
        //    };
        //    },
        //    {
        //    question =         {
        //        id = 3;
        //        options =             (
        //        );
        //        ordering = 0;
        //        title = "How do you imagine the first date?";
        //    };
        //    },
        //    {
        //    question =         {
        //        id = 4;
        //        options =             (
        //                               {
        //                                   option =                     {
        //                                       id = 13;
        //                                       title = "Intelligence and Education";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 14;
        //                                       title = "Attractive and well-groomed";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 15;
        //                                       title = "Financial Security, Job success";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 16;
        //                                       title = "Children and Family are important";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 17;
        //                                       title = "Romance and Faithfullness";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 18;
        //                                       title = "Sense of Humor";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 19;
        //                                       title = "Desire of Adventure";
        //                                   };
        //                               }
        //                               );
        //        ordering = 0;
        //        title = "What do you look for in a partner?";
        //    };
        //    },
        //    {
        //    question =         {
        //        id = 5;
        //        options =             (
        //                               {
        //                                   option =                     {
        //                                       id = 20;
        //                                       title = "Sexy behind";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 21;
        //                                       title = "Fit body";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 22;
        //                                       title = "Tattoos and piercing";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 23;
        //                                       title = "Funny and charming";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 24;
        //                                       title = "Self-confident";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 25;
        //                                       title = Success;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 26;
        //                                       title = Interlligent;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 27;
        //                                       title = "Full lips";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 28;
        //                                       title = "Positive charisma";
        //                                   };
        //                               }
        //                               );
        //        ordering = 0;
        //        title = "What turns you on?";
        //    };
        //    },
        //    {
        //    question =         {
        //        id = 6;
        //        options =             (
        //                               {
        //                                   option =                     {
        //                                       id = 29;
        //                                       title = "Embarracing tattoos";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 30;
        //                                       title = "Ribbed underwear";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 31;
        //                                       title = Sloppiness;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 32;
        //                                       title = "Baby fat";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 33;
        //                                       title = "Nagging and bickering";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 35;
        //                                       title = "Bad Manners";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 36;
        //                                       title = "Lack of Interlligence";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 37;
        //                                       title = "Excessive use of alcholol ";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 34;
        //                                       title = "Talking about their ex";
        //                                   };
        //                               }
        //                               );
        //        ordering = 0;
        //        title = "What turns you off?";
        //    };
        //    },
        //    {
        //    question =         {
        //        id = 7;
        //        options =             (
        //                               {
        //                                   option =                     {
        //                                       id = 38;
        //                                       title = "Hanging out with friends";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 39;
        //                                       title = "Woking out at the gym";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 40;
        //                                       title = "Partying and dancing";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 41;
        //                                       title = "Being a couch potato";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 42;
        //                                       title = "Going shopping";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 43;
        //                                       title = Gambling;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 44;
        //                                       title = "Lots of variety";
        //                                   };
        //                               }
        //                               );
        //        ordering = 0;
        //        title = "How do you spend your free time?";
        //    };
        //    },
        //    {
        //    question =         {
        //        id = 8;
        //        options =             (
        //                               {
        //                                   option =                     {
        //                                       id = 45;
        //                                       title = "At a bar";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 46;
        //                                       title = "On the couch";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 47;
        //                                       title = "Out with friends";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 48;
        //                                       title = "With Family";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 49;
        //                                       title = "At a party or club";
        //                                   };
        //                               }
        //                               );
        //        ordering = 0;
        //        title = "What are you up to on a Saturday night?";
        //    };
        //    },
        //    {
        //    question =         {
        //        id = 9;
        //        options =             (
        //                               {
        //                                   option =                     {
        //                                       id = 50;
        //                                       title = Black;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 51;
        //                                       title = "R 'n' B";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 52;
        //                                       title = "Hip Hop";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 53;
        //                                       title = Soul;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 54;
        //                                       title = Funk;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 55;
        //                                       title = Goa;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 56;
        //                                       title = Hardstyle;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 57;
        //                                       title = Dubstep;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 58;
        //                                       title = Dance;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 59;
        //                                       title = House;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 60;
        //                                       title = Electro;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 61;
        //                                       title = Pop;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 62;
        //                                       title = "Chart Music";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 63;
        //                                       title = Party;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 64;
        //                                       title = Hits;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 65;
        //                                       title = Gothic;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 66;
        //                                       title = Darkwave;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 67;
        //                                       title = "Rock Indie";
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 68;
        //                                       title = Metal;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 69;
        //                                       title = Classical;
        //                                   };
        //                               },
        //                               {
        //                                   option =                     {
        //                                       id = 70;
        //                                       title = Random;
        //                                   };
        //                               }
        //                               );
        //        ordering = 0;
        //        title = "What's on your playlist?";
        //    };
        //    }
        //    )
        
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSArray *jsonArr=(NSArray *)jsonData;
            NSMutableArray *questionsArr=[[NSMutableArray alloc] init];
            for(id question in jsonArr)
                {
                if ([question isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *questionDic=[question objectForKey:@"question"];
                    FLMyDetail *myDetailObj=[[FLMyDetail alloc] init];
                    myDetailObj.question=[questionDic objectForKey:@"title"];
                    myDetailObj.questionKey=[questionDic objectForKey:@"id"];
                    NSDictionary *optionsDic=[questionDic objectForKey:@"options"];
                    NSMutableArray *answers_arr=[[NSMutableArray alloc] init];
                    NSMutableArray *answers_key_arr=[[NSMutableArray alloc] init];
                    for(id option in optionsDic)
                        {
                        NSDictionary *optionDic=[option objectForKey:@"option"];
                        [answers_arr addObject:[optionDic objectForKey:@"title"]];
                        [answers_key_arr addObject:[optionDic objectForKey:@"id"]];
                        }
                    myDetailObj.answers_arr= [NSArray arrayWithArray:answers_arr];
                    myDetailObj.answers_key_arr= [NSArray arrayWithArray:answers_key_arr];
                    [questionsArr addObject:myDetailObj];
                    }
                }
            
            if ([delegate respondsToSelector:@selector(interviewQuestionsResult:)])
                {
                [delegate interviewQuestionsResult:questionsArr];
                }
            }
        
        
        break;
        }
        
        case INTERVIEW_QUESTION_UPDATE:
        {
        
        
        if ([delegate respondsToSelector:@selector(interviewQuestionUpdateResult:)])
            {
            [delegate  interviewQuestionUpdateResult:jsonData];
            }
        
        break;
        }
        case USERS_ALBUM_LIST:
        {
        
        //            USERS_ALBUM_LIST (
        //                              {
        //                                  album =         {
        //                                      "cover_image" = "http://flingoo.s3.amazonaws.com/albums/160/152-96EFA596-A5CE-4FA4-ABCA-6523580BB021.jpg";
        //                                      "created_at" = "2013-12-23T17:19:50Z";
        //                                      id = 160;
        //                                      moments = 0;
        //                                      "photo_count" = 5;
        //                                      profile = 0;
        //                                      title = "test album 1";
        //                                  };
        //                              },
        //                              {
        //                                  album =         {
        //                                      "cover_image" = "http://flingoo.s3.amazonaws.com/profiles/152-3C8BCB4F-469B-44A9-B54E-C4A80F733AC5.jpg";
        //                                      "created_at" = "2013-12-23T16:18:44Z";
        //                                      id = 157;
        //                                      moments = 0;
        //                                      "photo_count" = 5;
        //                                      profile = 1;
        //                                      title = Profile;
        //                                  };
        //                              },
        //                              {
        //                                  album =         {
        //                                      "cover_image" = "http://flingoo.s3.amazonaws.com/albums/156/152-93BB6CA8-0804-4BD6-9945-D158B9F797BF.jpg";
        //                                      "created_at" = "2013-12-23T16:18:44Z";
        //                                      id = 156;
        //                                      moments = 1;
        //                                      "photo_count" = 1;
        //                                      profile = 0;
        //                                      title = Moments;
        //                                  };
        //                              }
        //                              )
        
        
        
        
        
        
        
        //            if ([delegate respondsToSelector:@selector(albumPhotoUploadedResult:)])
        //            {
        //                FLPhoto *photoObj=(FLPhoto *)jsonData;
        //                [delegate  albumPhotoUploadedResult:photoObj];
        //            }
        //            else
        //            {
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSArray *jsonArr=(NSArray *)jsonData;
            NSMutableArray *albumArr=[[NSMutableArray alloc] init];
            for(id album in jsonArr)
                {
                if ([album isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *albumDic=[album objectForKey:@"album"];
                    FLAlbum *albumObj=[[FLAlbum alloc] init];
                    albumObj.title=[albumDic objectForKey:@"title"];
                    albumObj.moments=[[albumDic objectForKey:@"moments"] intValue];
                    albumObj.albumID=[albumDic objectForKey:@"id"];
                    albumObj.created_at=[albumDic objectForKey:@"created_at"];
                    albumObj.cover_image=[albumDic objectForKey:@"cover_image"];
                    albumObj.photo_count=[[albumDic objectForKey:@"photo_count"] intValue];
                    
                    [albumArr addObject:albumObj];
                    }
                }
            
            if ([delegate respondsToSelector:@selector(albumListResult:)])
                {
                [delegate  albumListResult:albumArr];
                }
            }
        
        
        break;
        }
        case USERS_ALBUM_PHOTO_LIST:
        {
        //            USERS_ALBUM_PHOTO_LIST (
        //                                    {
        //                                        album =         {
        //                                            "created_at" = "2013-12-15T14:02:23Z";
        //                                            id = 88;
        //                                            moments = 0;
        //                                            photos =             (
        //                                                                  {
        //                                                                      photo =                     {
        //                                                                          "created_at" = "2013-12-15T14:02:44Z";
        //                                                                          id = 17;
        //                                                                          image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                                                          title = "";
        //                                                                      };
        //                                                                  },
        //                                                                  {
        //                                                                      photo =                     {
        //                                                                          "created_at" = "2013-12-15T14:02:35Z";
        //                                                                          id = 16;
        //                                                                          image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                                                          title = "";
        //                                                                      };
        //                                                                  }
        //                                                                  );
        //                                            profile = 0;
        //                                            title = "test album u22 1";
        //                                        };
        //                                    }
        //                                    )
        
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSDictionary *tempDic=[jsonData objectAtIndex:0];
            NSDictionary *jsonDic=(NSDictionary *)[tempDic objectForKey:@"album"];
            
            NSArray *photosDetailsDic= (NSArray *)[jsonDic objectForKey:@"photos"];
            
            NSMutableArray *photoArr=[[NSMutableArray alloc] init];
            for(id photos in photosDetailsDic)
                {
                if ([photos isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *photoDic=[photos objectForKey:@"photo"];
                    FLPhoto *photoObj=[[FLPhoto alloc] init];
                    photoObj.title=[photoDic objectForKey:@"title"];
                    photoObj.created_at=[photoDic objectForKey:@"created_at"];
                    photoObj.imgID=[photoDic objectForKey:@"id"];
                    photoObj.imgURL=[photoDic objectForKey:@"image"];
                    [photoArr addObject:photoObj];
                    }
                }
            
            if ([delegate respondsToSelector:@selector(albumPhotoListResult:)])
                {
                [delegate  albumPhotoListResult:photoArr];
                }
            
            
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        
        break;
        }
        case PROFILE_PICTURE_ALBUM:
        {
        
        
        
        
        break;
        }
        case MATCH_USERS:
        {
        ////////////////////////////////////////////////////////////
        //            MATCH_USERS (
        //                         {
        //                             user =         {
        //                                 id = 120;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-11-24T05:07:16Z";
        //                                 location =             {
        //                                     latitude = "6.8880635";
        //                                     longitude = "79.89219009999999";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = "Harsha Kodagoda";
        //                                     image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                 };
        //                                 status = y4rheheh;
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 115;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-11-24T05:07:16Z";
        //                                 location =             {
        //                                     latitude = "6.88775109";
        //                                     longitude = "79.89188323";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = david;
        //                                     image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                 };
        //                                 status = hallo;
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 124;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-11-24T05:07:16Z";
        //                                 location =             {
        //                                     latitude = "6.89987578";
        //                                     longitude = "79.87854254";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = "";
        //                                     image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                 };
        //                                 status = "";
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 119;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-12-15T11:58:47Z";
        //                                 location =             {
        //                                     latitude = "6.88336526";
        //                                     longitude = "79.89708892";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = "";
        //                                     image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                 };
        //                                 status = "";
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 121;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-12-15T21:39:54Z";
        //                                 location =             {
        //                                     latitude = "6.921623";
        //                                     longitude = "79.85377";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = U21;
        //                                     image = "http://flingoo.s3.amazonaws.com/profiles/121-D1FF43E3-01B6-4ED1-9979-30AD75B28470.jpg";
        //                                 };
        //                                 status = "";
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 117;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-11-24T05:07:16Z";
        //                                 location =             {
        //                                     latitude = "6.921623";
        //                                     longitude = "79.85377";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = "U!8";
        //                                     image = "http://flingoo.s3.amazonaws.com/profiles/117-641C2650-4E4C-4838-9640-E1834ED3E2DC.jpg";
        //                                 };
        //                                 status = "";
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 112;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-11-24T05:07:16Z";
        //                                 location =             {
        //                                     latitude = "6.88801134754396";
        //                                     longitude = "79.89239781832509";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = "Randika R";
        //                                     image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                 };
        //                                 status = "";
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 118;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-12-15T18:19:31Z";
        //                                 location =             {
        //                                     latitude = "6.921623";
        //                                     longitude = "79.85377";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = U20;
        //                                     image = "http://flingoo.s3.amazonaws.com/profiles/118-80DBA860-E277-4288-9785-85B74E6F3F2B.jpg";
        //                                 };
        //                                 status = "";
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 113;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-12-15T21:38:42Z";
        //                                 location =             {
        //                                     latitude = "6.90972762";
        //                                     longitude = "79.96445026000001";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = u101;
        //                                     image = "http://flingoo.s3.amazonaws.com/profiles/113-3AA4EBE7-8349-44B9-9D39-3EEAB731F290.jpg";
        //                                 };
        //                                 status = hello;
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 122;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-11-24T05:07:16Z";
        //                                 location =             {
        //                                     latitude = "6.921623";
        //                                     longitude = "79.85377";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = U22;
        //                                     image = "http://flingoo.s3.amazonaws.com/profiles/122-0675AF28-AB0C-460C-AD7C-E24D6DE6B186.jpg";
        //                                 };
        //                                 status = "";
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 114;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-11-24T05:07:16Z";
        //                                 location =             {
        //                                     latitude = "6.921623";
        //                                     longitude = "79.85377";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = U17;
        //                                     image = "http://flingoo.s3.amazonaws.com/profiles/114-45470BB1-B438-45F9-9CF3-B6B4D8E251A1.jpg";
        //                                 };
        //                                 status = "";
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 116;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-11-24T05:07:16Z";
        //                                 location =             {
        //                                     latitude = "6.88765776315686";
        //                                     longitude = "79.8921242911422";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = alex86;
        //                                     image = "http://flingoo.s3.amazonaws.com/fallback/default.gif";
        //                                 };
        //                                 status = "";
        //                             };
        //                         },
        //                         {
        //                             user =         {
        //                                 id = 123;
        //                                 "is_friend" = 0;
        //                                 "is_online" = 0;
        //                                 "last_seen_at" = "2013-12-15T14:13:07Z";
        //                                 location =             {
        //                                     latitude = "6.921623";
        //                                     longitude = "79.85377";
        //                                 };
        //                                 profile =             {
        //                                     "full_name" = u23;
        //                                     image = "http://flingoo.s3.amazonaws.com/profiles/123-A0BCEED6-C40E-47E7-AA93-3D398850EEE4.jpg";
        //                                 };
        //                                 status = "";
        //                             };
        //                         }
        //                         )
        
        
        ///////////////////////////////////////////////////////////
        
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *matchsArr=[[NSMutableArray alloc] init];
            for(id users in jsonData)
                {
                if ([users isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *userDic=[users objectForKey:@"user"];
                    FLOtherProfile *otherProfile=[[FLOtherProfile alloc] init];
                    otherProfile.uid=[userDic objectForKey:@"id"];
                    otherProfile.is_friend=[userDic objectForKey:@"is_friend"];
                    otherProfile.is_online=[userDic objectForKey:@"is_online"];
                    otherProfile.last_seen_at=[userDic objectForKey:@"last_seen_at"];
                    otherProfile.status=[userDic objectForKey:@"status"];
                    
                    NSDictionary *userDic_location=[userDic objectForKey:@"location"];
                    if ([userDic_location isKindOfClass:[NSDictionary class]]) {
                        otherProfile.longitude=[userDic_location objectForKey:@"longitude"];
                        otherProfile.latitude=[userDic_location objectForKey:@"latitude"];
                    }
                    
                    NSDictionary *userDic_profile=[userDic objectForKey:@"profile"];
                    otherProfile.full_name=[userDic_profile objectForKey:@"full_name"];
                    otherProfile.image=[userDic_profile objectForKey:@"image"];
                    
                    
                    [matchsArr addObject:otherProfile];
                    
                    }
                }
            
            if ([delegate respondsToSelector:@selector(matchListResult:)])
                {
                [delegate  matchListResult:matchsArr];
                }
            
            
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        break;
        
        }
        case LOCATION_POINT_CREATE:
        {
        
        //            LOCATION_POINT_CREATE {
        //                message = "Location point was successfully created";
        //                success = 1;
        //            }
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(locationPointCreateResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  locationPointCreateResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        
        
        break;
        }
        
        case LOCATION_POINT_CHECK_IN://have to handle reponse
        {
        
        
        
        break;
        }
        case LIKE_TO_USER://have to handle reponse
        {
        
        //            LIKE_TO_USER {
        //                message = "User liked successfully";
        //                success = 1;
        //            }
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(likeToUserResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  likeToUserResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        
        break;
        }
        case UNLIKE_TO_USER://have to handle reponse
        {
        //            UNLIKE_TO_USER {
        //                message = "User unliked successfully";
        //                success = 1;
        //            }
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(unlikeToUserResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  unlikeToUserResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        case LIKE_USER_LIST:
        {
        
        //            LIKE_USER_LIST (
        //                            {
        //                                user =         {
        //                                    id = 122;
        //                                    "is_friend" = 0;
        //                                    "is_online" = 0;
        //                                    "last_seen_at" = "2013-12-16T07:41:00Z";
        //                                    location =             {
        //                                        latitude = "6.921623";
        //                                        longitude = "79.85377";
        //                                    };
        //                                    profile =             {
        //                                        "full_name" = U22;
        //                                        image = "http://flingoo.s3.amazonaws.com/profiles/122-0675AF28-AB0C-460C-AD7C-E24D6DE6B186.jpg";
        //                                    };
        //                                    status = "";
        //                                };
        //                            },
        //                            {
        //                                user =         {
        //                                    id = 123;
        //                                    "is_friend" = 0;
        //                                    "is_online" = 0;
        //                                    "last_seen_at" = "2013-12-15T14:13:07Z";
        //                                    location =             {
        //                                        latitude = "6.921623";
        //                                        longitude = "79.85377";
        //                                    };
        //                                    profile =             {
        //                                        "full_name" = u23;
        //                                        image = "http://flingoo.s3.amazonaws.com/profiles/123-A0BCEED6-C40E-47E7-AA93-3D398850EEE4.jpg";
        //                                    };
        //                                    status = "";
        //                                };
        //                            }
        //                            )
        
        
        
        
        ///////////////////////////////////////////////////////////
        
        
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *likeUsersArr=[[NSMutableArray alloc] init];
            for(id users in jsonData)
                {
                if ([users isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *userDic=[users objectForKey:@"user"];
                    FLOtherProfile *otherProfile=[[FLOtherProfile alloc] init];
                    otherProfile.uid=[userDic objectForKey:@"id"];
                    otherProfile.is_friend=[userDic objectForKey:@"is_friend"];
                    otherProfile.is_online=[userDic objectForKey:@"is_online"];
                    otherProfile.last_seen_at=[userDic objectForKey:@"last_seen_at"];
                    otherProfile.status=[userDic objectForKey:@"status"];
                    
                    NSDictionary *userDic_location=[userDic objectForKey:@"location"];
                    otherProfile.longitude=[userDic_location objectForKey:@"longitude"];
                    otherProfile.latitude=[userDic_location objectForKey:@"latitude"];
                    
                    NSDictionary *userDic_profile=[userDic objectForKey:@"profile"];
                    otherProfile.full_name=[userDic_profile objectForKey:@"full_name"];
                    otherProfile.image=[userDic_profile objectForKey:@"image"];
                    
                    
                    [likeUsersArr addObject:otherProfile];
                    
                    }
                }
            
            if ([delegate respondsToSelector:@selector(likeUserListResult:)])
                {
                [delegate  likeUserListResult:likeUsersArr];
                }
            
            
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        break;
        
        }
        case BLOCK_USER://have to handle reponse
        {
        //            UNLIKE_TO_USER {
        //                message = "User unliked successfully";
        //                success = 1;
        //            }
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(blockUserResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  blockUserResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        case UNBLOCK_USER://have to handle reponse
        {
        //            UNLIKE_TO_USER {
        //                message = "User unliked successfully";
        //                success = 1;
        //            }
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(unblockUserResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  unblockUserResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        
        
        case IMAGE_UPLOAD_TO_DIR:
        {
        
        //            IMAGE_UPLOAD_TO_DIR {
        //                id = 48;
        //                message = "Profile image was successfully created";
        //                success = 1;
        //            }
        
        
        
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(profilePicUploaded:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  profilePicUploaded:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        case PROFILE_PiCTURE_LIST:
        {
        
        //            PROFILE_PiCTURE_LIST {
        //                album =     {
        //                    "created_at" = "2013-12-23T16:18:44Z";
        //                    id = 157;
        //                    photos =         (
        //                                      {
        //                                          photo =                 {
        //                                              "created_at" = "2013-12-23T16:18:48Z";
        //                                              id = 52;
        //                                              image = "http://flingoo.s3.amazonaws.com/profiles/152-791D9E8F-4131-437B-A3C9-E42627A9EFB6.jpg";
        //                                              title = "";
        //                                          };
        //                                      },
        //                                      {
        //                                          photo =                 {
        //                                              "created_at" = "2013-12-23T16:59:46Z";
        //                                              id = 54;
        //                                              image = "http://flingoo.s3.amazonaws.com/profiles/152-3B20118B-C79E-492E-B46C-6BFC8DC718F9.jpg";
        //                                              title = "";
        //                                          };
        //                                      },
        //                                      {
        //                                          photo =                 {
        //                                              "created_at" = "2013-12-23T17:00:00Z";
        //                                              id = 55;
        //                                              image = "http://flingoo.s3.amazonaws.com/profiles/152-FBD7CEC1-E514-494B-98BF-842521311297.jpg";
        //                                              title = "";
        //                                          };
        //                                      }
        //                                      );
        //                    profile = 1;
        //                    title = Profile;
        //                };
        //            }
        
        
        
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]])
            {
            //                NSDictionary *tempDic=[jsonData objectAtIndex:0];
            NSDictionary *jsonDic=(NSDictionary *)[jsonData objectForKey:@"album"];
            
            NSArray *photosDetailsDic= (NSArray *)[jsonDic objectForKey:@"photos"];
            
            NSMutableArray *photoArr=[[NSMutableArray alloc] init];
            for(id photos in photosDetailsDic)
                {
                if ([photos isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *photoDic=[photos objectForKey:@"photo"];
                    FLPhoto *photoObj=[[FLPhoto alloc] init];
                    photoObj.title=[photoDic objectForKey:@"title"];
                    photoObj.created_at=[photoDic objectForKey:@"created_at"];
                    photoObj.imgID=[photoDic objectForKey:@"id"];
                    photoObj.imgURL=[photoDic objectForKey:@"image"];
                    [photoArr addObject:photoObj];
                    }
                }
            
            if ([delegate respondsToSelector:@selector(profilePicListResult:)])
                {
                [delegate  profilePicListResult:photoArr];
                }
            
            
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        break;
        }
        case USER_CHATS://have to handle reponse
        {
        
        
//            USER_CHATS (
//                        {
//                            message =         {
//                                body = "hi hi22";
//                                group =             {
//                                    description = "Test group h 3 description";
//                                    id = 60;
//                                    image = "http://flingoo.s3.amazonaws.com/groups/219-BFBAB101-CAED-4FAE-AE2A-00A7B4860D2A.jpg";
//                                    "image_128x128" = "http://flingoo.s3.amazonaws.com/groups/image128x128_219-BFBAB101-CAED-4FAE-AE2A-00A7B4860D2A.jpg";
//                                    "image_256x256" = "http://flingoo.s3.amazonaws.com/groups/image256x256_219-BFBAB101-CAED-4FAE-AE2A-00A7B4860D2A.jpg";
//                                    latitude = "6.91011264";
//                                    longitude = "79.96513742";
//                                    name = "TestGroup H3";
//                                };
//                                id = 769;
//                                "message_type" = group;
//                                opened = 0;
//                            };
//                        },
//                        {
//                            message =         {
//                                body = vv;
//                                id = 753;
//                                "message_type" = private;
//                                opened = 0;
//                                user =             {
//                                    id = 221;
//                                    "is_favourite" = 0;
//                                    "is_friend" = 1;
//                                    "is_online" = 0;
//                                    "last_seen_at" = "2014-01-19T19:21:35Z";
//                                    location =                 {
//                                        distance = "2.36";
//                                        latitude = "6.90262316";
//                                        longitude = "79.88237439";
//                                    };
//                                    profile =                 {
//                                        age = 33;
//                                        "full_name" = u52;
//                                        image = "http://flingoo.s3.amazonaws.com/profiles/221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                        "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                        "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                    };
//                                    status = "";
//                                };
//                            };
//                        },
//                        {
//                            message =         {
//                                body = cc;
//                                id = 726;
//                                "message_type" = private;
//                                opened = 0;
//                                user =             {
//                                    id = 222;
//                                    "is_favourite" = 0;
//                                    "is_friend" = 1;
//                                    "is_online" = 0;
//                                    "last_seen_at" = "2014-01-19T18:54:15Z";
//                                    location =                 {
//                                        distance = "2.27";
//                                        latitude = "6.89984116";
//                                        longitude = "79.87850793";
//                                    };
//                                    profile =                 {
//                                        age = 33;
//                                        "full_name" = u53;
//                                        image = "http://flingoo.s3.amazonaws.com/profiles/222-C8578EF1-0C5A-44A2-BDEA-5A2E952586B4.jpg";
//                                        "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_222-C8578EF1-0C5A-44A2-BDEA-5A2E952586B4.jpg";
//                                        "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_222-C8578EF1-0C5A-44A2-BDEA-5A2E952586B4.jpg";
//                                    };
//                                    status = "";
//                                };
//                            };
//                        },
//                        {
//                            message =         {
//                                body = vb;
//                                id = 712;
//                                "message_type" = private;
//                                opened = 0;
//                                user =             {
//                                    id = 220;
//                                    "is_favourite" = 0;
//                                    "is_friend" = 0;
//                                    "is_online" = 0;
//                                    "last_seen_at" = "2014-01-19T11:37:57Z";
//                                    location =                 {
//                                        distance = 0;
//                                        latitude = "6.921623";
//                                        longitude = "79.85377";
//                                    };
//                                    profile =                 {
//                                        age = 33;
//                                        "full_name" = u51;
//                                        image = "http://flingoo.s3.amazonaws.com/profiles/220-ABC6C579-34E4-4381-A50A-745CEF7BA194.jpg";
//                                        "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_220-ABC6C579-34E4-4381-A50A-745CEF7BA194.jpg";
//                                        "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_220-ABC6C579-34E4-4381-A50A-745CEF7BA194.jpg";
//                                    };
//                                    status = "";
//                                };
//                            };
//                        }
//                        )

        
        
        ///////////////////////////////////////////////////////////
    
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            NSMutableArray *chatArr=[[NSMutableArray alloc] init];
            for(id message in jsonData)
                {
                if ([message isKindOfClass:[NSDictionary class]])
                    {
                    
                    NSDictionary *messageDic=[message objectForKey:@"message"];
                    FLChat *chatObj=[[FLChat alloc] init];    
                      FLChatMessage *chat_last_msg_obj=[[FLChatMessage alloc] init];//updating existing obj    
                        chat_last_msg_obj.message=[messageDic objectForKey:@"body"];
                        
                        chat_last_msg_obj.seen=[[messageDic objectForKey:@"opened"] boolValue];
                        
                        if ([[messageDic objectForKey:@"message_type"] isEqualToString:@"private"])
                        {
                            chatObj.message_type=MSG_TYPE_PRIVATE;
                            
                            NSDictionary *userDic=[messageDic objectForKey:@"user"];
                            chatObj.chatObj_id=[userDic objectForKey:@"id"];
                            chatObj.is_online=[[userDic objectForKey:@"is_online"] boolValue];
                            
                            NSDictionary *profileDic=[userDic objectForKey:@"profile"];
                            chatObj.chatObjName=[profileDic objectForKey:@"full_name"];
                            
                            chatObj.chatObj_image_url=[profileDic objectForKey:@"image"];
                            
                            chat_last_msg_obj.username=[profileDic objectForKey:@"full_name"];
                            chat_last_msg_obj.userID=[userDic objectForKey:@"id"];
                            
                            chat_last_msg_obj.user_imageURL=[profileDic objectForKey:@"image"];
                            //hemalasankas**
                            NSDate *now =  [NSDate date];  // assign your date to "now"
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
                            NSString *hrDateString = [dateFormatter stringFromDate:now];
                            chat_last_msg_obj.chatDateTime=hrDateString;
                            chatObj.chat_last_msg_obj=chat_last_msg_obj;

                        }
                        else
                        {
                            chatObj.message_type=MSG_TYPE_GROUP;
                            
                            NSDictionary *groupDic=[messageDic objectForKey:@"group"];
                            chatObj.chatObj_id=[groupDic objectForKey:@"id"];
                            chatObj.chatObjName=[groupDic objectForKey:@"name"];
                            chatObj.chatObj_image_url=[groupDic objectForKey:@"image"];
                            
                            //hemalasankas**
                            NSDate *now =  [NSDate date];  // assign your date to "now"
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
                            NSString *hrDateString = [dateFormatter stringFromDate:now];
                            chat_last_msg_obj.chatDateTime=hrDateString;
                            chatObj.chat_last_msg_obj=chat_last_msg_obj;
                        }
                    [chatArr addObject:chatObj];
                    }
                }
            
            if ([delegate respondsToSelector:@selector(userChatsResult:)])
                {
                [delegate  userChatsResult:chatArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case USER_CHATS_FOR_USERS://have to handle reponse
        {
        
        //            USER_CHATS_FOR_USERS {
        //                user =     {
        //                    id = 146;
        //                    "is_friend" = 0;
        //                    "is_online" = 0;
        //                    "last_seen_at" = "2013-12-23T16:02:49Z";
        //                    location =         {
        //                        latitude = "6.90077266";
        //                        longitude = "79.87896185";
        //                    };
        //                    messages =         (
        //                                        {
        //                                            message =                 {
        //                                                body = aaatest;
        //                                                "created_at" = "2013-12-24T16:19:11Z";
        //                                                id = 111;
        //                                                "receiver_id" = 147;
        //                                                "receiver_name" = u33;
        //                                                "sender_id" = 146;
        //                                                "sender_name" = u32;
        //                                                "time_ago" = "less than a minute ago";
        //                                            };
        //                                        },
        //                                        {
        //                                            message =                 {
        //                                                body = hhhhhtest;
        //                                                "created_at" = "2013-12-24T16:17:40Z";
        //                                                id = 110;
        //                                                "receiver_id" = 147;
        //                                                "receiver_name" = u33;
        //                                                "sender_id" = 146;
        //                                                "sender_name" = u32;
        //                                                "time_ago" = "2 minutes ago";
        //                                            };
        //                                        },
        //                                        {
        //                                            message =                 {
        //                                                body = gg;
        //                                                "created_at" = "2013-12-23T20:49:21Z";
        //                                                id = 106;
        //                                                "receiver_id" = 146;
        //                                                "receiver_name" = u32;
        //                                                "sender_id" = 147;
        //                                                "sender_name" = u33;
        //                                                "time_ago" = "about 20 hours ago";
        //                                            };
        //                                        },
        //                                        {
        //                                            message =                 {
        //                                                body = ff;
        //                                                "created_at" = "2013-12-23T20:49:18Z";
        //                                                id = 105;
        //                                                "receiver_id" = 146;
        //                                                "receiver_name" = u32;
        //                                                "sender_id" = 147;
        //                                                "sender_name" = u33;
        //                                                "time_ago" = "about 20 hours ago";
        //                                            };
        //                                        },
        //                                        {
        //                                            message =                 {
        //                                                body = hj;
        //                                                "created_at" = "2013-12-23T20:49:13Z";
        //                                                id = 104;
        //                                                "receiver_id" = 147;
        //                                                "receiver_name" = u33;
        //                                                "sender_id" = 146;
        //                                                "sender_name" = u32;
        //                                                "time_ago" = "about 20 hours ago";
        //                                            };
        //                                        },
        //                                        {
        //                                            message =                 {
        //                                                body = ee;
        //                                                "created_at" = "2013-12-23T20:49:10Z";
        //                                                id = 103;
        //                                                "receiver_id" = 147;
        //                                                "receiver_name" = u33;
        //                                                "sender_id" = 146;
        //                                                "sender_name" = u32;
        //                                                "time_ago" = "about 20 hours ago";
        //                                            };
        //                                        },
        //                                        {
        //                                            message =                 {
        //                                                body = dd;
        //                                                "created_at" = "2013-12-23T20:48:58Z";
        //                                                id = 102;
        //                                                "receiver_id" = 146;
        //                                                "receiver_name" = u32;
        //                                                "sender_id" = 147;
        //                                                "sender_name" = u33;
        //                                                "time_ago" = "about 20 hours ago";
        //                                            };
        //                                        }
        //                                        );
        //                    profile =         {
        //                        "full_name" = u32;
        //                        image = "http://flingoo.s3.amazonaws.com/profiles/146-4F6325FA-A59D-483F-B3B1-916787812D42.jpg";
        //                    };
        //                    status = "";
        //                };
        //            }
        
        
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]])
            {
            NSDictionary *jsonDic=(NSDictionary *)[jsonData objectForKey:@"user"];
            NSDictionary *profileDic=(NSDictionary *)[jsonDic objectForKey:@"profile"];
            NSString *other_user_image_url=[profileDic objectForKey:@"image"];
            //                NSMutableArray *chatMessageArr=[[NSMutableArray alloc] init];
            NSMutableArray *msgTempArr=[[NSMutableArray alloc] init];
            if([[jsonDic objectForKey:@"messages"] isKindOfClass:[NSArray class]])
                {
                
                NSArray *messagesDic= [jsonDic objectForKey:@"messages"];
                for(id message in messagesDic)
                    {
                    if ([message isKindOfClass:[NSDictionary class]])
                        {
                        NSDictionary *messageDic=[message objectForKey:@"message"];
                        FLChatMessage *msgObj=[[FLChatMessage alloc] init];
                        
                        msgObj.message=[messageDic objectForKey:@"body"];
                        msgObj.chatDateTime=[messageDic objectForKey:@"created_at"];
                        msgObj.userID=[messageDic objectForKey:@"sender_id"];
                        msgObj.username=[messageDic objectForKey:@"sender_name"];
                        
                        if ([[NSString stringWithFormat:@"%@",msgObj.userID] isEqualToString:[NSString stringWithFormat:@"%@",[FLGlobalSettings sharedInstance].current_user_profile.uid]])//current user
                            {
                            msgObj.user_imageURL=[FLGlobalSettings sharedInstance].current_user_profile.image;
                            }
                        else
                            {
                            msgObj.user_imageURL=other_user_image_url;
                            }
                        
                        //                        msgObj.seen=YES;
                        [msgTempArr addObject:msgObj];
                        }
                    }
                
                //                 [chatObj.chatMessageArr addObject:msgObj];
                }
            if ([delegate respondsToSelector:@selector(chatForUserResult:)])
                {
                NSMutableArray *chatMessageArr=[[[msgTempArr reverseObjectEnumerator] allObjects] mutableCopy];//reverse all chat objects
                
                [delegate  chatForUserResult:chatMessageArr];
                }
            
            
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        break;
        }
        
        case FINDME:
        {
        
        //            FINDME {
        //                message = "Beacon was successfully created";
        //                success = 1;
        //            }
        
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(findMeResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  findMeResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        case MOMENT:
        {
        
        //            MOMENT {
        //                moments =     (
        //                               {
        //                                   moment =             {
        //                                       image = "http://flingoo.s3.amazonaws.com/albums/175/160-1C821E42-CCB7-4029-901C-C09276D9A3AB.jpg";
        //                                       user =                 {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-06T16:07:49Z";
        //                                           location =                     {
        //                                               latitude = "6.921623";
        //                                               longitude = "79.85377";
        //                                           };
        //                                           profile =                     {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   moment =             {
        //                                       image = "http://flingoo.s3.amazonaws.com/albums/177/160-46564B42-5556-4050-9811-DBAA6AC52331.jpg";
        //                                       user =                 {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-06T16:07:49Z";
        //                                           location =                     {
        //                                               latitude = "6.921623";
        //                                               longitude = "79.85377";
        //                                           };
        //                                           profile =                     {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   moment =             {
        //                                       image = "http://flingoo.s3.amazonaws.com/albums/196/170-511b56d6-45a5-4bc2-b41e-63a04ff4606a.jpg";
        //                                       user =                 {
        //                                           id = 170;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 0;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2013-12-30T04:21:34Z";
        //                                           location =                     {
        //                                               latitude = "6.40157754847253";
        //                                               longitude = "80.3071852773428";
        //                                           };
        //                                           profile =                     {
        //                                               "full_name" = "LG Nexus4";
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/170-acf8e5cc-2074-4b79-82e7-b69fd21371e0.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   moment =             {
        //                                       image = "http://flingoo.s3.amazonaws.com/albums/198/171-D2EA80CE-81C0-4027-B8C1-0EBF46564D4E.jpg";
        //                                       user =                 {
        //                                           id = 171;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 0;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-06T16:59:07Z";
        //                                           location =                     {
        //                                               latitude = "4.17209603";
        //                                               longitude = "73.51725698";
        //                                           };
        //                                           profile =                     {
        //                                               "full_name" = "Chamira Prasad";
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/171-AEE6EC30-DEAE-4231-8011-6BF419C0FDDE.jpg";
        //                                           };
        //                                           status = "testing flingoo ";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   moment =             {
        //                                       image = "http://flingoo.s3.amazonaws.com/albums/212/178-23861828-4919-465F-B6AA-40242817BE5D.jpg";
        //                                       user =                 {
        //                                           id = 178;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 0;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-07T18:14:34Z";
        //                                           location =                     {
        //                                               latitude = "6.91011264";
        //                                               longitude = "79.96513742";
        //                                           };
        //                                           profile =                     {
        //                                               "full_name" = "Prasad de Zoysa";
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/178-277E4C2B-8A9A-464C-8A17-8CB8BA8773D0.jpg";
        //                                           };
        //                                           status = "hello hello";
        //                                       };
        //                                   };
        //                               }
        //                               );
        //            }
        
        ////////////////////////////////////////////////////////////new one
//            MOMENT {
//                moments =     (
//                               {
//                                   moment =             {
//                                       image =                 {
//                                           "image_path" =                     {
//                                               image128x128 =                         {
//                                                   url = "http://flingoo.s3.amazonaws.com/albums/261/image128x128_201-847FD0CE-C8AE-46F9-AEFE-35F82A320787.jpg";
//                                               };
//                                               image256x256 =                         {
//                                                   url = "http://flingoo.s3.amazonaws.com/albums/261/image256x256_201-847FD0CE-C8AE-46F9-AEFE-35F82A320787.jpg";
//                                               };
//                                               url = "http://flingoo.s3.amazonaws.com/albums/261/201-847FD0CE-C8AE-46F9-AEFE-35F82A320787.jpg";
//                                           };
//                                       };
//                                       user =                 {
//                                           id = 201;
//                                           "is_favourite" = 0;
//                                           "is_friend" = 0;
//                                           "is_online" = 1;
//                                           "last_seen_at" = "2014-01-14T13:04:46Z";
//                                           location =                     {
//                                               latitude = "6.83787397";
//                                               longitude = "79.9157735";
//                                           };
//                                           profile =                     {
//                                               "full_name" = "Randika Rathugama";
//                                               image = "";
//                                           };
//                                           status = "that's a leopard ";
//                                       };
//                                   };
//                               }
//                               );
//            }

        /////////////////////////////////////////////////////////////
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]])
            {
            NSMutableArray *momentsObjArr=[[NSMutableArray alloc] init];
            NSArray *momentsArr=(NSArray *)[jsonData objectForKey:@"moments"];
            for(id moment in momentsArr)
                {
                FLRadarObject *radarObj=[[FLRadarObject alloc] init];
                NSDictionary *momentDic=[moment objectForKey:@"moment"];
                    
                
                    
//                    NSDictionary *imageDic=[momentDic objectForKey:@"image"];
//                    NSDictionary *image_pathDic=[imageDic objectForKey:@"image_path"];
//                     NSDictionary *image128x128Dic=[image_pathDic objectForKey:@"image128x128"];
//                    radarObj.image=[image128x128Dic objectForKey:@"url"];
                    
                    radarObj.image=[momentDic objectForKey:@"image"];
                    
                    
                    
                radarObj.radarType = TYPE_MOMENT;
                
                NSDictionary *momentUserDic=[momentDic objectForKey:@"user"];
                FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
                profileObj.uid=[momentUserDic objectForKey:@"id"];
                profileObj.is_favourite=[momentUserDic objectForKey:@"is_favourite"];
                profileObj.is_friend=[momentUserDic objectForKey:@"is_friend"];
                profileObj.is_online=[momentUserDic objectForKey:@"is_online"];
                profileObj.last_seen_at=[momentUserDic objectForKey:@"last_seen_at"];
                
                NSDictionary *profileUserDic=[momentUserDic objectForKey:@"profile"];
                profileObj.full_name=[profileUserDic objectForKey:@"full_name"];
                profileObj.image=[profileUserDic objectForKey:@"image"];
                profileObj.status=[momentUserDic objectForKey:@"status"];
                
                radarObj.userObj=profileObj;
                
                NSDictionary *locationUserDic=[momentUserDic objectForKey:@"location"];
                radarObj.location = [[CLLocation alloc] initWithLatitude:[[locationUserDic objectForKey:@"latitude"] floatValue] longitude:[[locationUserDic objectForKey:@"longitude"] floatValue]];
                //                    NSLog(@"radarObjradarObj %@",radarObj);
                [momentsObjArr addObject:radarObj];
                }
            
            if ([delegate respondsToSelector:@selector(momentListResult:)])
                {
                [delegate  momentListResult:momentsObjArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        case GET_CREDITS:
        {
        
        //            FINDME {
        //                message = "Beacon was successfully created";
        //                success = 1;
        //            }
        
        
        //            if ([[jsonData objectForKey:@"success"] boolValue])
        //            {
        //                if ([delegate respondsToSelector:@selector(findMeResult:)])
        //                {
        //                    NSString *str=[jsonData objectForKey:@"message"];
        //                    [delegate  findMeResult:str];
        //                }
        //            }
        //            else
        //            {
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        
        break;
        }
        case CREDIT_PLANS:
        {
        
//            CREDIT_PLANS (
//                          {
//                              "credit_plan" =         {
//                                  amount = "0.99";
//                                  description = "";
//                                  id = 1;
//                                  name = "250 Credits";
//                                  points = 250;
//                              };
//                          },
//                          {
//                              "credit_plan" =         {
//                                  amount = "1.99";
//                                  description = "Save 10%";
//                                  id = 2;
//                                  name = "525 Credits";
//                                  points = 525;
//                              };
//                          },
//                          {
//                              "credit_plan" =         {
//                                  amount = "3.99";
//                                  description = "Save 20%";
//                                  id = 3;
//                                  name = "1200 Credits";
//                                  points = 1200;
//                              };
//                          }
//                          )

            
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSMutableArray *creditPlanArr=[[NSMutableArray alloc] init];
                for(id credit_plan in jsonData)
                {
                    if ([credit_plan isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *credit_planDic=[credit_plan objectForKey:@"credit_plan"];
                        FLCreditPlan *creditPlanObj=[[FLCreditPlan alloc] init];
                        creditPlanObj.credit_plan_id=[credit_planDic objectForKey:@"id"];
                        creditPlanObj.amount=[credit_planDic objectForKey:@"amount"];
                        creditPlanObj.description=[credit_planDic objectForKey:@"description"];
                        creditPlanObj.name=[credit_planDic objectForKey:@"name"];
                        creditPlanObj.points=[[credit_planDic objectForKey:@"points"] intValue];
                       [creditPlanArr addObject:creditPlanObj];
                    }
                }
                
                if ([delegate respondsToSelector:@selector(creditPlanResult:)])
                {
                    [delegate  creditPlanResult:creditPlanArr];
                }                
            }
            else
            {
                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
            break;
        }
        
        case GET_VIP_MEMBERSHIP_LIST:
        {
        
        //            FINDME {
        //                message = "Beacon was successfully created";
        //                success = 1;
        //            }
        
        
        //            if ([[jsonData objectForKey:@"success"] boolValue])
        //            {
        //                if ([delegate respondsToSelector:@selector(findMeResult:)])
        //                {
        //                    NSString *str=[jsonData objectForKey:@"message"];
        //                    [delegate  findMeResult:str];
        //                }
        //            }
        //            else
        //            {
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        
        break;
        }
        case VIP_MEMBERSHIP_PLAN_LIST:
        {
//            VIP_MEMBERSHIP_PLAN_LIST (
//                                      {
//                                          "membership_plan" =         {
//                                              amount = "4.99";
//                                              description = "";
//                                              id = 1;
//                                              name = "1 Month";
//                                              term = 1;
//                                          };
//                                      },
//                                      {
//                                          "membership_plan" =         {
//                                              amount = "11.99";
//                                              description = "3,99$ a Month Save 20%";
//                                              id = 2;
//                                              name = "3 Month";
//                                              term = 3;
//                                          };
//                                      },
//                                      {
//                                          "membership_plan" =         {
//                                              amount = "17.99";
//                                              description = "2,99$ a Month Save 40%";
//                                              id = 3;
//                                              name = "6 Month";
//                                              term = 6;
//                                          };
//                                      },
//                                      {
//                                          "membership_plan" =         {
//                                              amount = "29.99";
//                                              description = "2,49$ a Month Save 50%";
//                                              id = 4;
//                                              name = "12 Month";
//                                              term = 12;
//                                          };
//                                      }
//                                      )
            

        
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSMutableArray *membershipPlanArr=[[NSMutableArray alloc] init];
                for(id membership_plan in jsonData)
                {
                    if ([membership_plan isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *membership_planDic=[membership_plan objectForKey:@"membership_plan"];
                        FLMembershipPlan *membershipPlanObj=[[FLMembershipPlan alloc] init];
                        membershipPlanObj.membership_plan_id=[membership_planDic objectForKey:@"id"];
                        membershipPlanObj.amount=[membership_planDic objectForKey:@"amount"];
                        membershipPlanObj.description=[membership_planDic objectForKey:@"description"];
                        membershipPlanObj.name=[membership_planDic objectForKey:@"name"];
                        membershipPlanObj.term=[[membership_planDic objectForKey:@"term"] intValue];
                        [membershipPlanArr addObject:membershipPlanObj];
                    }
                }
                
                if ([delegate respondsToSelector:@selector(membershipPlanResult:)])
                {
                    [delegate  membershipPlanResult:membershipPlanArr];
                }
            }
            else
            {
                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
            break;
        }
        
        case SEND_PAYMENT:
        {
        
        //            SEND_PAYMENT {
        //                message = "Payment was successfully created";
        //                success = 1;
        //            }
        
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(sendPaymentResult:)])
                {
                NSString *str=[jsonData objectForKey:@"message"];
                [delegate  sendPaymentResult:str];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        
        case GIFT_ITEM_LIST:
        {
        //            GIFT_ITEM_LIST (
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 10;
        //                                    id = 5;
        //                                    image = "";
        //                                    "item_type" = kiss;
        //                                    name = "Vampire Kiss";
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 5;
        //                                    id = 12;
        //                                    image = "";
        //                                    "item_type" = drink;
        //                                    name = "Soft Drink";
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 5;
        //                                    id = 10;
        //                                    image = "";
        //                                    "item_type" = drink;
        //                                    name = Shot;
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 10;
        //                                    id = 11;
        //                                    image = "";
        //                                    "item_type" = drink;
        //                                    name = "Long Drink";
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 5;
        //                                    id = 8;
        //                                    image = "";
        //                                    "item_type" = drink;
        //                                    name = "Latte Macchiato";
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 1;
        //                                    id = 1;
        //                                    image = "";
        //                                    "item_type" = kiss;
        //                                    name = Kiss;
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 5;
        //                                    id = 6;
        //                                    image = "";
        //                                    "item_type" = kiss;
        //                                    name = "Gentleman Kiss";
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 5;
        //                                    id = 3;
        //                                    image = "";
        //                                    "item_type" = kiss;
        //                                    name = "Fruity Kiss";
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 5;
        //                                    id = 7;
        //                                    image = "";
        //                                    "item_type" = drink;
        //                                    name = Espresso;
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 5;
        //                                    id = 2;
        //                                    image = "";
        //                                    "item_type" = kiss;
        //                                    name = "Diamond Kiss";
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 5;
        //                                    id = 9;
        //                                    image = "";
        //                                    "item_type" = drink;
        //                                    name = Cocktail;
        //                                };
        //                            },
        //                            {
        //                                "gift_item" =         {
        //                                    "credits_required" = 5;
        //                                    id = 4;
        //                                    image = "";
        //                                    "item_type" = kiss;
        //                                    name = "Candy Kiss";
        //                                };
        //                            }
        //                            )
        
        NSMutableArray *giftArr=[[NSMutableArray alloc] init];
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            for(id giftItems in jsonData)
                {
                if ([giftItems isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *gift_itemDic=[giftItems objectForKey:@"gift_item"];
                    
                    FLGiftItem *giftObj=[[FLGiftItem alloc] init];
                    
                    giftObj.credits_required=[gift_itemDic objectForKey:@"credits_required"];
                    giftObj.item_id=[gift_itemDic objectForKey:@"id"];
                    giftObj.image=[gift_itemDic objectForKey:@"image"];
                    giftObj.item_type=[gift_itemDic objectForKey:@"item_type"];
                    giftObj.name=[gift_itemDic objectForKey:@"name"];
                    [giftArr addObject:giftObj];
                    }
                }
            if ([delegate respondsToSelector:@selector(giftItemListResult:)])
                {
                [delegate  giftItemListResult:giftArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        break;
        }
        case GIFT_KESSES_LIST:
        {
        
        
        //            if ([[jsonData objectForKey:@"success"] boolValue])
        //            {
        //                if ([delegate respondsToSelector:@selector(sendPaymentResult:)])
        //                {
        //                    NSString *str=[jsonData objectForKey:@"message"];
        //                    [delegate  sendPaymentResult:str];
        //                }
        //            }
        //            else
        //            {
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        
        break;
        }
        case GIFT_DRINKS_LIST:
        {
        
        
        //            if ([[jsonData objectForKey:@"success"] boolValue])
        //            {
        //                if ([delegate respondsToSelector:@selector(sendPaymentResult:)])
        //                {
        //                    NSString *str=[jsonData objectForKey:@"message"];
        //                    [delegate  sendPaymentResult:str];
        //                }
        //            }
        //            else
        //            {
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        
        break;
        }
        case GIFT_SEND:
        {
        
        //            GIFT_SEND {
        //                message = "Gift was successfully sent";
        //                success = 1;
        //            }
        
        FLGiftItem *giftItem=(FLGiftItem *)jsonData;
        if ([delegate respondsToSelector:@selector(giftSendResult::)])
            {
            [delegate  giftSendResult:giftItem:@"Gift was successfully sent"];
            }
        
        break;
        }
        case GIFT_RECEIVED_ALL:
        {
        
        
        
        //            GIFT_RECEIVED_ALL (
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-08T19:39:47Z";
        //                                       "gift_item" =             {
        //                                           id = 1;
        //                                           "item_type" = kiss;
        //                                           name = Kiss;
        //                                       };
        //                                       id = 44;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-08T19:21:12Z";
        //                                       "gift_item" =             {
        //                                           id = 1;
        //                                           "item_type" = kiss;
        //                                           name = Kiss;
        //                                       };
        //                                       id = 43;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-08T19:19:45Z";
        //                                       "gift_item" =             {
        //                                           id = 1;
        //                                           "item_type" = kiss;
        //                                           name = Kiss;
        //                                       };
        //                                       id = 42;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-08T19:19:18Z";
        //                                       "gift_item" =             {
        //                                           id = 1;
        //                                           "item_type" = kiss;
        //                                           name = Kiss;
        //                                       };
        //                                       id = 41;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-08T18:58:53Z";
        //                                       "gift_item" =             {
        //                                           id = 4;
        //                                           "item_type" = kiss;
        //                                           name = "Candy Kiss";
        //                                       };
        //                                       id = 40;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-08T18:56:52Z";
        //                                       "gift_item" =             {
        //                                           id = 2;
        //                                           "item_type" = kiss;
        //                                           name = "Diamond Kiss";
        //                                       };
        //                                       id = 39;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T14:13:00Z";
        //                                       "gift_item" =             {
        //                                           id = 10;
        //                                           "item_type" = drink;
        //                                           name = Shot;
        //                                       };
        //                                       id = 16;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T13:55:13Z";
        //                                       "gift_item" =             {
        //                                           id = 2;
        //                                           "item_type" = kiss;
        //                                           name = "Diamond Kiss";
        //                                       };
        //                                       id = 15;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T13:55:10Z";
        //                                       "gift_item" =             {
        //                                           id = 6;
        //                                           "item_type" = kiss;
        //                                           name = "Gentleman Kiss";
        //                                       };
        //                                       id = 14;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T13:55:05Z";
        //                                       "gift_item" =             {
        //                                           id = 5;
        //                                           "item_type" = kiss;
        //                                           name = "Vampire Kiss";
        //                                       };
        //                                       id = 13;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T13:54:02Z";
        //                                       "gift_item" =             {
        //                                           id = 1;
        //                                           "item_type" = kiss;
        //                                           name = Kiss;
        //                                       };
        //                                       id = 12;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T13:52:32Z";
        //                                       "gift_item" =             {
        //                                           id = 1;
        //                                           "item_type" = kiss;
        //                                           name = Kiss;
        //                                       };
        //                                       id = 11;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T13:50:09Z";
        //                                       "gift_item" =             {
        //                                           id = 11;
        //                                           "item_type" = drink;
        //                                           name = "Long Drink";
        //                                       };
        //                                       id = 10;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T13:49:48Z";
        //                                       "gift_item" =             {
        //                                           id = 8;
        //                                           "item_type" = drink;
        //                                           name = "Latte Macchiato";
        //                                       };
        //                                       id = 9;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T09:56:56Z";
        //                                       "gift_item" =             {
        //                                           id = 10;
        //                                           "item_type" = drink;
        //                                           name = Shot;
        //                                       };
        //                                       id = 8;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T09:56:29Z";
        //                                       "gift_item" =             {
        //                                           id = 1;
        //                                           "item_type" = kiss;
        //                                           name = Kiss;
        //                                       };
        //                                       id = 7;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T09:56:02Z";
        //                                       "gift_item" =             {
        //                                           id = 5;
        //                                           "item_type" = kiss;
        //                                           name = "Vampire Kiss";
        //                                       };
        //                                       id = 6;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2014-01-05T07:07:09Z";
        //                                       "gift_item" =             {
        //                                           id = 5;
        //                                           "item_type" = kiss;
        //                                           name = "Vampire Kiss";
        //                                       };
        //                                       id = 5;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2013-12-31T18:44:51Z";
        //                                       "gift_item" =             {
        //                                           id = 1;
        //                                           "item_type" = kiss;
        //                                           name = Kiss;
        //                                       };
        //                                       id = 3;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "created_at" = "2013-12-31T18:43:56Z";
        //                                       "gift_item" =             {
        //                                           id = 1;
        //                                           "item_type" = kiss;
        //                                           name = Kiss;
        //                                       };
        //                                       id = 2;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   gift =         {
        //                                       "" = "";
        //                                       "created_at" = "2013-12-31T18:16:53Z";
        //                                       id = 1;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               }
        //                               )
        
        
        NSMutableArray *receivedGiftArr=[[NSMutableArray alloc] init];
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            for(id giftItems in jsonData)
                {
                if ([giftItems isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *gift_Dic=[giftItems objectForKey:@"gift"];
                    
                    FLGift *giftObj=[[FLGift alloc] init];
                    giftObj.created_at=[FLUtil getWebserviceDateFromString:[gift_Dic objectForKey:@"created_at"]];
                    
                    NSDictionary *gift_ItemDic=[gift_Dic objectForKey:@"gift_item"];
                    giftObj.gift_id=[gift_Dic objectForKey:@"id"];
                    giftObj.gift_type=[gift_ItemDic objectForKey:@"item_type"];
                    giftObj.gift_name=[gift_ItemDic objectForKey:@"name"];
                    
                    NSDictionary *user_Dic=[gift_Dic objectForKey:@"user"];
                    giftObj.sender_id=[user_Dic objectForKey:@"id"];
                    giftObj.sender_is_friend=[user_Dic objectForKey:@"is_friend"];
                    giftObj.sender_is_online=[user_Dic objectForKey:@"is_online"];
                    
                    NSDictionary *user_profle_Dic=[user_Dic objectForKey:@"profile"];
                    giftObj.sender_full_name=[user_profle_Dic objectForKey:@"full_name"];
                    giftObj.sender_image=[user_profle_Dic objectForKey:@"image"];
                    
                    [receivedGiftArr addObject:giftObj];
                    }
                }
            
            if ([delegate respondsToSelector:@selector(giftReceivedAllListResult:)])
                {
                [delegate  giftReceivedAllListResult:receivedGiftArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        
        break;
        }
        case GIFT_RECEIVED_KISSES:
        {
        
        
        //            if ([[jsonData objectForKey:@"success"] boolValue])
        //            {
        //                if ([delegate respondsToSelector:@selector(sendPaymentResult:)])
        //                {
        //                    NSString *str=[jsonData objectForKey:@"message"];
        //                    [delegate  sendPaymentResult:str];
        //                }
        //            }
        //            else
        //            {
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        
        break;
        }
        case GIFT_RECEIVED_DRINKS:
        {
        
        
        //            if ([[jsonData objectForKey:@"success"] boolValue])
        //            {
        //                if ([delegate respondsToSelector:@selector(sendPaymentResult:)])
        //                {
        //                    NSString *str=[jsonData objectForKey:@"message"];
        //                    [delegate  sendPaymentResult:str];
        //                }
        //            }
        //            else
        //            {
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        
        break;
        }
        
        case USER_SETTING_LIST:
        {
        //            USER_SETTING_LIST {
        //                facebook = 1;
        //                "ghost_mode" = 1;
        //                highlighted = 1;
        //                "location_tracking" = 1;
        //                messages = 1;
        //                radar = 1;
        //            }
        
        
        //                        if ([[jsonData objectForKey:@"success"] boolValue])
        //                        {
        FLSetting *user_setting=[[FLSetting alloc] init];
        user_setting.facebook=[[jsonData objectForKey:@"facebook"] boolValue];
        user_setting.ghost_mode=[[jsonData objectForKey:@"ghost_mode"] boolValue];
        user_setting.highlighted=[[jsonData objectForKey:@"highlighted"] boolValue];
        user_setting.location_tracking=[[jsonData objectForKey:@"location_tracking"] boolValue];
        user_setting.messages=[[jsonData objectForKey:@"messages"] boolValue];
        user_setting.radar=[[jsonData objectForKey:@"radar"] boolValue];
        
        if ([delegate respondsToSelector:@selector(userSettingListResult:)])
            {
            [delegate  userSettingListResult:user_setting];
            }
        //                        }
        //                        else
        //                        {
        //                            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //                        }
        
        break;
        }
        
        case USER_SETTING_UPDATE:
        {
        //            USER_SETTING_UPDATE {
        //                facebook = 0;
        //                message = "Settings updated";
        //                success = 1;
        //            }
        
        
        if ([[jsonData objectForKey:@"success"] boolValue])
            {
            if ([delegate respondsToSelector:@selector(settingsUpdatedResult:)])
                {
                NSString *key;
                NSNumber *value;
                if ([jsonData containsObject:@"facebook"]) {
                    key=@"facebook";
                    value=[jsonData objectForKey:@"facebook"];
                }
                else if ([jsonData containsObject:@"ghost_mode"])
                    {
                    key=@"ghost_mode";
                    value=[jsonData objectForKey:@"ghost_mode"];
                    }
                else if ([jsonData containsObject:@"highlighted"])
                    {
                    key=@"highlighted";
                    value=[jsonData objectForKey:@"highlighted"];
                    }
                else if ([jsonData containsObject:@"location_tracking"])
                    {
                    key=@"location_tracking";
                    value=[jsonData objectForKey:@"location_tracking"];
                    }
                else if ([jsonData containsObject:@"messages"])
                    {
                    key=@"messages";
                    value=[jsonData objectForKey:@"messages"];
                    }
                else if ([jsonData containsObject:@"radar"])
                    {
                    key=@"radar";
                    value=[jsonData objectForKey:@"radar"];
                    }
                
                if (key!=nil) {
                    if ([delegate respondsToSelector:@selector(settingsUpdatedResult::)])
                        {
                        [delegate  settingsUpdatedResult:key:value];
                        }
                }
                
                
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        
        case NOTIFICATION_LIST:
        {
        
        
        //            NOTIFICATION_LIST (
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-08T19:39:47Z";
        //                                       id = 149;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 44;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-08T19:21:12Z";
        //                                       id = 148;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 43;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-08T19:19:45Z";
        //                                       id = 147;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 42;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-08T19:19:18Z";
        //                                       id = 146;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 41;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-08T18:58:53Z";
        //                                       id = 145;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 40;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-08T18:56:52Z";
        //                                       id = 144;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 39;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T17:31:26Z";
        //                                       id = 132;
        //                                       message = "Please find me";
        //                                       "notification_id" = 160;
        //                                       "notification_type" = "find_me";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T15:38:19Z";
        //                                       id = 127;
        //                                       message = "Please find me";
        //                                       "notification_id" = 160;
        //                                       "notification_type" = "find_me";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T15:37:29Z";
        //                                       id = 122;
        //                                       message = "Please find me";
        //                                       "notification_id" = 160;
        //                                       "notification_type" = "find_me";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T15:37:26Z";
        //                                       id = 117;
        //                                       message = "Please find me";
        //                                       "notification_id" = 160;
        //                                       "notification_type" = "find_me";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T15:37:24Z";
        //                                       id = 112;
        //                                       message = "Please find me";
        //                                       "notification_id" = 160;
        //                                       "notification_type" = "find_me";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T15:37:21Z";
        //                                       id = 107;
        //                                       message = "Please find me";
        //                                       "notification_id" = 160;
        //                                       "notification_type" = "find_me";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T15:36:47Z";
        //                                       id = 102;
        //                                       message = "Please find me";
        //                                       "notification_id" = 160;
        //                                       "notification_type" = "find_me";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T15:36:43Z";
        //                                       id = 97;
        //                                       message = "Please find me";
        //                                       "notification_id" = 160;
        //                                       "notification_type" = "find_me";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T14:13:00Z";
        //                                       id = 78;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 16;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 1;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T13:55:13Z";
        //                                       id = 77;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 15;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 1;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T13:55:10Z";
        //                                       id = 76;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 14;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 1;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T13:55:05Z";
        //                                       id = 75;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 13;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 1;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T13:54:02Z";
        //                                       id = 74;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 12;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T13:52:32Z";
        //                                       id = 73;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 11;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 1;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T13:50:09Z";
        //                                       id = 72;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 10;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T13:49:48Z";
        //                                       id = 71;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 9;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T09:56:56Z";
        //                                       id = 70;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 8;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T09:56:29Z";
        //                                       id = 69;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 7;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T09:56:02Z";
        //                                       id = 68;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 6;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 0;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               },
        //                               {
        //                                   notification =         {
        //                                       "created_at" = "2014-01-05T07:07:09Z";
        //                                       id = 66;
        //                                       message = "You've received a gift";
        //                                       "notification_id" = 5;
        //                                       "notification_type" = "gift_received";
        //                                       "read_status" = 1;
        //                                       user =             {
        //                                           id = 160;
        //                                           "is_favourite" = 0;
        //                                           "is_friend" = 1;
        //                                           "is_online" = 0;
        //                                           "last_seen_at" = "2014-01-08T19:21:54Z";
        //                                           location =                 {
        //                                               latitude = "6.89983362";
        //                                               longitude = "79.87855981";
        //                                           };
        //                                           profile =                 {
        //                                               "full_name" = u40;
        //                                               image = "http://flingoo.s3.amazonaws.com/profiles/160-C727331E-5AAE-4BDF-AC4B-891B93185DB3.jpg";
        //                                           };
        //                                           status = "";
        //                                       };
        //                                   };
        //                               }
        //                               )
        
        
        
        
        
        
        NSMutableArray *notificationArr=[[NSMutableArray alloc] init];
        if ([jsonData isKindOfClass:[NSArray class]])
            {
            for(id notificationItems in jsonData)
                {
                if ([notificationItems isKindOfClass:[NSDictionary class]])
                    {
                    NSDictionary *notification_itemDic=[notificationItems objectForKey:@"notification"];
                    
                    FLNotication *notificationObj=[[FLNotication alloc] init];
                    notificationObj.message=[notification_itemDic objectForKey:@"message"];
                    notificationObj.notification_id=[notification_itemDic objectForKey:@"notification_id"];
                    notificationObj.notification_type=[notification_itemDic objectForKey:@"notification_type"];
                    notificationObj.read_status=[[notification_itemDic objectForKey:@"read_status"] boolValue];
                    notificationObj.receivedDate=[FLUtil getWebserviceDateFromString:[notification_itemDic objectForKey:@"created_at"]];
                    
                    NSDictionary *user_Dic=[notification_itemDic objectForKey:@"user"];
                    notificationObj.sender_id=[user_Dic objectForKey:@"id"];
                    
                    NSDictionary *location_Dic=[user_Dic objectForKey:@"location"];
                        if ([location_Dic isKindOfClass:[NSDictionary class]])
                        {
                            notificationObj.latitude=[location_Dic objectForKey:@"latitude"];
                            notificationObj.longitude=[location_Dic objectForKey:@"longitude"];
                        }
                    NSDictionary *profile_Dic=[user_Dic objectForKey:@"profile"];
                    notificationObj.sender_name=[profile_Dic objectForKey:@"full_name"];
                    
                    notificationObj.sender_profile_pic=[profile_Dic objectForKey:@"image"];
                    [notificationArr addObject:notificationObj];
                    }
                }
            if ([delegate respondsToSelector:@selector(notificationListResult:)])
                {
                [delegate  notificationListResult:notificationArr];
                }
            }
        else
            {
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        break;
        }
        case NOTIFICATION_UPDATE:
        {
        
        //            NOTIFICATION_UPDATE {
        //                message = "Notification marked as read";
        //                success = 1;
        //            }
        
        NSString *notificationID=jsonData;
        if ([delegate respondsToSelector:@selector(notificationUpdatedResult:)])
            {
            [delegate  notificationUpdatedResult:notificationID];
            }
        
        break;
        }
        case EYE_CATCHER:
        {
            
//            EYE_CATCHER {
//                message = "Profile was successfully highlighted";
//                success = 1;
//            }

            
            if ([[jsonData objectForKey:@"success"] boolValue])
            {
                if ([delegate respondsToSelector:@selector(createEyeCatcherResult:)])
                {
                    NSString *str=[jsonData objectForKey:@"message"];
                    [delegate  createEyeCatcherResult:str];
                }
            }
            else
            {
                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
            
            break;
        }
        case EYE_CATCHER_PROFILE_LIST:
        {
            

//            EYE_CATCHER_PROFILE_LIST (
//                                      {
//                                          user =         {
//                                              id = 200;
//                                              "is_favourite" = 0;
//                                              "is_friend" = 0;
//                                              "is_online" = 1;
//                                              "last_seen_at" = "2014-01-13T18:55:23Z";
//                                              location =             {
//                                                  latitude = "6.921623";
//                                                  longitude = "79.85377";
//                                              };
//                                              profile =             {
//                                                  "full_name" = u40;
//                                                  image = "";
//                                              };
//                                              status = "";
//                                          };
//                                      }
//                                      )
            

            
            
            /////////////////////////////////////////////////////////
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSMutableArray *eyeCatcherProfilesArr=[[NSMutableArray alloc] init];
                for(id users in jsonData)
                {
                    if ([users isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *userDic=[users objectForKey:@"user"];
                        FLOtherProfile *otherProfile=[[FLOtherProfile alloc] init];
                        otherProfile.uid=[userDic objectForKey:@"id"];
                        otherProfile.is_friend=[userDic objectForKey:@"is_friend"];
                        otherProfile.is_online=[userDic objectForKey:@"is_online"];
                        otherProfile.is_favourite=[userDic objectForKey:@"is_favourite"];
                        otherProfile.last_seen_at=[userDic objectForKey:@"last_seen_at"];
                        otherProfile.status=[userDic objectForKey:@"status"];
                        
                        NSDictionary *userDic_location=[userDic objectForKey:@"location"];
                        otherProfile.longitude=[userDic_location objectForKey:@"longitude"];
                        otherProfile.latitude=[userDic_location objectForKey:@"latitude"];
                        
                        NSDictionary *userDic_profile=[userDic objectForKey:@"profile"];
                        otherProfile.full_name=[userDic_profile objectForKey:@"full_name"];
                        otherProfile.image=[userDic_profile objectForKey:@"image"];
                        
                        
                        [eyeCatcherProfilesArr addObject:otherProfile];
                        
                    }
                }
                
                if ([delegate respondsToSelector:@selector(eyeCatcherProfileListResult:)])
                {
                    [delegate  eyeCatcherProfileListResult:eyeCatcherProfilesArr];
                }
                
                
            }
            else
            {
                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
            

            
            break;
        }
            
        case CHAT_DATA:
        {
            //            //////////
            //            USER_SHOW {
            //                user =     {
            //                    email = "u17@gmail.com";
            //                    id = 114;
            //                    "interview_questions" =         (
            //                                                     {
            //                                                         "interview_question" =                 {
            //                                                             "question_id" = 1;
            //                                                             "question_option_id" = "";
            //                                                         };
            //                                                     },
            //                                                     {
            //                                                         "interview_question" =                 {
            //                                                             "question_id" = 2;
            //                                                             "question_option_id" = "";
            //                                                         };
            //                                                     },
            //                                                     {
            //                                                         "interview_question" =                 {
            //                                                             "question_id" = 3;
            //                                                             "question_option_id" = "";
            //                                                         };
            //                                                     },
            //                                                     {
            //                                                         "interview_question" =                 {
            //                                                             "question_id" = 4;
            //                                                             "question_option_id" = "";
            //                                                         };
            //                                                     },
            //                                                     {
            //                                                         "interview_question" =                 {
            //                                                             "question_id" = 5;
            //                                                             "question_option_id" = "";
            //                                                         };
            //                                                     },
            //                                                     {
            //                                                         "interview_question" =                 {
            //                                                             "question_id" = 6;
            //                                                             "question_option_id" = "";
            //                                                         };
            //                                                     },
            //                                                     {
            //                                                         "interview_question" =                 {
            //                                                             "question_id" = 7;
            //                                                             "question_option_id" = "";
            //                                                         };
            //                                                     },
            //                                                     {
            //                                                         "interview_question" =                 {
            //                                                             "question_id" = 8;
            //                                                             "question_option_id" = "";
            //                                                         };
            //                                                     },
            //                                                     {
            //                                                         "interview_question" =                 {
            //                                                             "question_id" = 9;
            //                                                             "question_option_id" = "";
            //                                                         };
            //                                                     }
            //                                                     );
            //                    "is_friend" = 0;
            //                    "is_online" = 0;
            //                    "last_seen_at" = "2013-11-24T05:07:16Z";
            //                    location =         {
            //                        latitude = "6.921623";
            //                        longitude = "79.85377";
            //                    };
            //                    profile =         {
            //                        age = 24;
            //                        "body_art" = "";
            //                        children = "";
            //                        ethnicity = "";
            //                        "eye_color" = "";
            //                        figure = "";
            //                        "full_name" = U17;
            //                        gender = male;
            //                        "hair_color" = "";
            //                        "hair_length" = "";
            //                        height = "";
            //                        id = 71;
            //                        image = "http://flingoo.s3.amazonaws.com/profiles/114-45470BB1-B438-45F9-9CF3-B6B4D8E251A1.jpg";
            //                        income = "";
            //                        "living_situation" = "";
            //                        "looking_for" = male;
            //                        "looking_for_age_max" = 60;
            //                        "looking_for_age_min" = 17;
            //                        orientation = "";
            //                        profession = "";
            //                        "relationship_status" = "";
            //                        religion = "";
            //                        smoker = "";
            //                        training = "";
            //                        "user_id" = 114;
            //                        weight = "";
            //                        "who_looking_for" = male;
            //                    };
            //                    status = "";
            //                };
            //            }
            //            //////////
            
                FLChat *chatObj=(FLChat *)jsonData;
                if ([delegate respondsToSelector:@selector(chatDataResult:)])
                {
                    [delegate chatDataResult:chatObj];
                }
                
            break;
        }
        case CHAT_GROUP_DATA:
        {
            ////////////////////////////////////////////////
//            CHAT_GROUP_DATA {
//                group =     {
//                    "created_at" = "2014-01-19T11:50:27Z";
//                    description = "TestGroupH 2 | This is test group h 2 | 219-05AA94EF-D7F3-49F5-8A56-E44B416EE095.jpg | (\n    221,\n    224,\n    222\n)";
//                    id = 59;
//                    image = "http://flingoo.s3.amazonaws.com/groups/219-05AA94EF-D7F3-49F5-8A56-E44B416EE095.jpg";
//                    "image_128x128" = "http://flingoo.s3.amazonaws.com/groups/image128x128_219-05AA94EF-D7F3-49F5-8A56-E44B416EE095.jpg";
//                    "image_256x256" = "http://flingoo.s3.amazonaws.com/groups/image256x256_219-05AA94EF-D7F3-49F5-8A56-E44B416EE095.jpg";
//                    name = "TestGroupH 2";
//                    owner =         {
//                        id = 219;
//                        "is_favourite" = 0;
//                        "is_friend" = 0;
//                        "is_online" = 1;
//                        "last_seen_at" = "2014-01-19T13:18:24Z";
//                        location =             {
//                            distance = 0;
//                            latitude = "6.921623";
//                            longitude = "79.85377";
//                        };
//                        profile =             {
//                            age = 33;
//                            "full_name" = u50;
//                            image = "http://flingoo.s3.amazonaws.com/profiles/219-27A99EDC-2486-46F7-9E83-F9A8DA45A908.jpg";
//                            "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_219-27A99EDC-2486-46F7-9E83-F9A8DA45A908.jpg";
//                            "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_219-27A99EDC-2486-46F7-9E83-F9A8DA45A908.jpg";
//                        };
//                        status = "";
//                    };
//                    users =         (
//                                     {
//                                         user =                 {
//                                             id = 221;
//                                             "is_favourite" = 0;
//                                             "is_friend" = 1;
//                                             "is_online" = 1;
//                                             "last_seen_at" = "2014-01-19T13:23:54Z";
//                                             location =                     {
//                                                 distance = "2.21";
//                                                 latitude = "6.90070058";
//                                                 longitude = "79.87822776";
//                                             };
//                                             profile =                     {
//                                                 age = 33;
//                                                 "full_name" = u52;
//                                                 image = "http://flingoo.s3.amazonaws.com/profiles/221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                                 "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                                 "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                             };
//                                             status = "";
//                                         };
//                                     },
//                                     {
//                                         user =                 {
//                                             id = 224;
//                                             "is_favourite" = 0;
//                                             "is_friend" = 1;
//                                             "is_online" = 0;
//                                             "last_seen_at" = "2013-11-24T05:07:16Z";
//                                             location = "";
//                                             profile =                     {
//                                                 age = 33;
//                                                 "full_name" = u54;
//                                                 image = "http://flingoo.s3.amazonaws.com/profiles/224-6A4A7B75-30D7-42DC-9662-736523C97569.jpg";
//                                                 "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_224-6A4A7B75-30D7-42DC-9662-736523C97569.jpg";
//                                                 "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_224-6A4A7B75-30D7-42DC-9662-736523C97569.jpg";
//                                             };
//                                             status = "";
//                                         };
//                                     },
//                                     {
//                                         user =                 {
//                                             id = 222;
//                                             "is_favourite" = 0;
//                                             "is_friend" = 1;
//                                             "is_online" = 0;
//                                             "last_seen_at" = "2013-11-24T05:07:16Z";
//                                             location = "";
//                                             profile =                     {
//                                                 age = 33;
//                                                 "full_name" = u53;
//                                                 image = "http://flingoo.s3.amazonaws.com/profiles/222-C8578EF1-0C5A-44A2-BDEA-5A2E952586B4.jpg";
//                                                 "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_222-C8578EF1-0C5A-44A2-BDEA-5A2E952586B4.jpg";
//                                                 "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_222-C8578EF1-0C5A-44A2-BDEA-5A2E952586B4.jpg";
//                                             };
//                                             status = "";
//                                         };
//                                     }
//                                     );
//                };
//            }
            ////////////////////////////////////////////////////

     
            FLChat *chatObj=(FLChat *)jsonData;
            if ([delegate respondsToSelector:@selector(chatGroupDataResult:)])
            {
                [delegate chatGroupDataResult:chatObj];
            }
            break;
        }
            
        case GROUP_CHAT_HISTORY://have to handle reponse
        {
            
//            GROUP_CHAT_HISTORY {
//                group =     {
//                    description = "Test group h 3 description";
//                    id = 60;
//                    image = "http://flingoo.s3.amazonaws.com/groups/219-BFBAB101-CAED-4FAE-AE2A-00A7B4860D2A.jpg";
//                    "image_128x128" = "http://flingoo.s3.amazonaws.com/groups/image128x128_219-BFBAB101-CAED-4FAE-AE2A-00A7B4860D2A.jpg";
//                    "image_256x256" = "http://flingoo.s3.amazonaws.com/groups/image256x256_219-BFBAB101-CAED-4FAE-AE2A-00A7B4860D2A.jpg";
//                    latitude = "6.91011264";
//                    longitude = "79.96513742";
//                    messages =         (
//                                        {
//                                            message =                 {
//                                                body = "h u";
//                                                "created_at" = "2014-01-20T19:15:48Z";
//                                                id = 831;
//                                                "receiver_id" = 60;
//                                                "receiver_name" = "TestGroup H3";
//                                                "sender_id" = 219;
//                                                "sender_name" = u50;
//                                                "time_ago" = "about 21 hours ago";
//                                            };
//                                        },
//            {
//                                            message =                 {
//                                                body = hi;
//                                                "created_at" = "2014-01-20T17:27:02Z";
//                                                id = 773;
//                                                "receiver_id" = 60;
//                                                "receiver_name" = "TestGroup H3";
//                                                "sender_id" = 221;
//                                                "sender_name" = u52;
//                                                "time_ago" = "about 23 hours ago";
//                                            };
//                                        },
//                                        {
//                                            message =                 {
//                                                body = "hi hi22";
//                                                "created_at" = "2014-01-20T14:23:10Z";
//                                                id = 769;
//                                                "receiver_id" = 60;
//                                                "receiver_name" = "TestGroup H3";
//                                                "sender_id" = 219;
//                                                "sender_name" = u50;
//                                                "time_ago" = "1 day ago";
//                                            };
//                                        },
//                                        {
//                                            message =                 {
//                                                body = "hi hi";
//                                                "created_at" = "2014-01-20T14:22:58Z";
//                                                id = 768;
//                                                "receiver_id" = 60;
//                                                "receiver_name" = "TestGroup H3";
//                                                "sender_id" = 219;
//                                                "sender_name" = u50;
//                                                "time_ago" = "1 day ago";
//                                            };
//                                        }
//                                        );
//                    name = "TestGroup H3";
//                    users =         (
//                                     {
//                                         user =                 {
//                                             id = 219;
//                                             "is_favourite" = 0;
//                                             "is_friend" = 0;
//                                             "is_online" = 0;
//                                             "last_seen_at" = "2014-01-21T15:32:16Z";
//                                             location =                     {
//                                                 distance = 0;
//                                                 latitude = "6.921623";
//                                                 longitude = "79.85377";
//                                             };
//                                             profile =                     {
//                                                 age = 33;
//                                                 "full_name" = u50;
//                                                 image = "http://flingoo.s3.amazonaws.com/profiles/219-27A99EDC-2486-46F7-9E83-F9A8DA45A908.jpg";
//                                                 "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_219-27A99EDC-2486-46F7-9E83-F9A8DA45A908.jpg";
//                                                 "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_219-27A99EDC-2486-46F7-9E83-F9A8DA45A908.jpg";
//                                             };
//                                             status = "";
//                                         };
//                                     },
//                                     {
//                                         user =                 {
//                                             id = 220;
//                                             "is_favourite" = 0;
//                                             "is_friend" = 0;
//                                             "is_online" = 0;
//                                             "last_seen_at" = "2014-01-19T11:37:57Z";
//                                             location =                     {
//                                                 distance = 0;
//                                                 latitude = "6.921623";
//                                                 longitude = "79.85377";
//                                             };
//                                             profile =                     {
//                                                 age = 33;
//                                                 "full_name" = u51;
//                                                 image = "http://flingoo.s3.amazonaws.com/profiles/220-ABC6C579-34E4-4381-A50A-745CEF7BA194.jpg";
//                                                 "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_220-ABC6C579-34E4-4381-A50A-745CEF7BA194.jpg";
//                                                 "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_220-ABC6C579-34E4-4381-A50A-745CEF7BA194.jpg";
//                                             };
//                                             status = "";
//                                         };
//                                     },
//                                     {
//                                         user =                 {
//                                             id = 208;
//                                             "is_favourite" = 0;
//                                             "is_friend" = 0;
//                                             "is_online" = 0;
//                                             "last_seen_at" = "2014-01-19T19:45:38Z";
//                                             location =                     {
//                                                 distance = "3.76";
//                                                 latitude = "6.88536849";
//                                                 longitude = "79.89460937";
//                                             };
//                                             profile =                     {
//                                                 age = 27;
//                                                 "full_name" = Amol;
//                                                 image = "http://flingoo.s3.amazonaws.com/profiles/208-7047be56-d81f-4635-86da-1c55a5bc2ff5.jpg";
//                                                 "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_208-7047be56-d81f-4635-86da-1c55a5bc2ff5.jpg";
//                                                 "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_208-7047be56-d81f-4635-86da-1c55a5bc2ff5.jpg";
//                                             };
//                                             status = hiiiii;
//                                         };
//                                     },
//                                     {
//                                         user =                 {
//                                             id = 222;
//                                             "is_favourite" = 0;
//                                             "is_friend" = 1;
//                                             "is_online" = 0;
//                                             "last_seen_at" = "2014-01-21T14:56:52Z";
//                                             location =                     {
//                                                 distance = 0;
//                                                 latitude = "6.921623";
//                                                 longitude = "79.85377";
//                                             };
//                                             profile =                     {
//                                                 age = 33;
//                                                 "full_name" = u53;
//                                                 image = "http://flingoo.s3.amazonaws.com/profiles/222-C8578EF1-0C5A-44A2-BDEA-5A2E952586B4.jpg";
//                                                 "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_222-C8578EF1-0C5A-44A2-BDEA-5A2E952586B4.jpg";
//                                                 "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_222-C8578EF1-0C5A-44A2-BDEA-5A2E952586B4.jpg";
//                                             };
//                                             status = "";
//                                         };
//                                     },
//                                     {
//                                         user =                 {
//                                             id = 224;
//                                             "is_favourite" = 0;
//                                             "is_friend" = 1;
//                                             "is_online" = 0;
//                                             "last_seen_at" = "2013-11-24T05:07:16Z";
//                                             location = "";
//                                             profile =                     {
//                                                 age = 33;
//                                                 "full_name" = u54;
//                                                 image = "http://flingoo.s3.amazonaws.com/profiles/224-6A4A7B75-30D7-42DC-9662-736523C97569.jpg";
//                                                 "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_224-6A4A7B75-30D7-42DC-9662-736523C97569.jpg";
//                                                 "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_224-6A4A7B75-30D7-42DC-9662-736523C97569.jpg";
//                                             };
//                                             status = "";
//                                         };
//                                     },
//                                     {
//                                         user =                 {
//                                             id = 221;
//                                             "is_favourite" = 0;
//                                             "is_friend" = 1;
//                                             "is_online" = 0;
//                                             "last_seen_at" = "2014-01-20T17:43:11Z";
//                                             location =                     {
//                                                 distance = "2.34";
//                                                 latitude = "6.90203557";
//                                                 longitude = "79.88154111";
//                                             };
//                                             profile =                     {
//                                                 age = 33;
//                                                 "full_name" = u52;
//                                                 image = "http://flingoo.s3.amazonaws.com/profiles/221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                                 "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                                 "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                             };
//                                             status = "";
//                                         };
//                                     }
//                                     );
//                };
//            }

            
            
            
            
            if ([jsonData isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *jsonDic=(NSDictionary *)[jsonData objectForKey:@"group"];
//                NSDictionary *messageDic=(NSDictionary *)[jsonDic objectForKey:@"messages"];
//                NSString *other_user_image_url=[messageDic objectForKey:@"image"];
//                //                NSMutableArray *chatMessageArr=[[NSMutableArray alloc] init];
                NSMutableArray *msgTempArr=[[NSMutableArray alloc] init];
                NSMutableArray *userTempArr=[[NSMutableArray alloc] init];
                
                if([[jsonDic objectForKey:@"users"] isKindOfClass:[NSArray class]])
                {
                    NSArray *userArr= [jsonDic objectForKey:@"users"];
                    for(id user in userArr)
                    {
                        if ([user isKindOfClass:[NSDictionary class]])
                        {
                            NSDictionary *userDic=[user objectForKey:@"user"];
                            FLOtherProfile *userObj=[[FLOtherProfile alloc] init];
                            userObj.uid=[userDic objectForKey:@"id"];
                            NSDictionary *profileDic=[userDic objectForKey:@"profile"];
                            userObj.image=[profileDic objectForKey:@"image"];
                            [userTempArr addObject:userObj];
                        }
                    }
                }
                
                
                if([[jsonDic objectForKey:@"messages"] isKindOfClass:[NSArray class]])
                {
                    NSArray *messagesArr= [jsonDic objectForKey:@"messages"];
                    for(id message in messagesArr)
                    {
                        if ([message isKindOfClass:[NSDictionary class]])
                        {
                            NSDictionary *messageDic=[message objectForKey:@"message"];
                            FLChatMessage *msgObj=[[FLChatMessage alloc] init];
                            
                            msgObj.message=[messageDic objectForKey:@"body"];
                            msgObj.chatDateTime=[messageDic objectForKey:@"created_at"];
                            msgObj.userID=[messageDic objectForKey:@"sender_id"];
                            msgObj.username=[messageDic objectForKey:@"sender_name"];
                            
                            for(FLOtherProfile *userObj in userTempArr)
                            {
                                                              
                                if ([[NSString stringWithFormat:@"%@",userObj.uid] isEqualToString:[NSString stringWithFormat:@"%@",msgObj.userID]]) {
                                    
                                    msgObj.user_imageURL=userObj.image;
                                    break;
                                }
                            }
                                                      
                            [msgTempArr addObject:msgObj];
                        }
                    }
                }
            
                
                if ([delegate respondsToSelector:@selector(chatForGroupResult:)])
                {
                    NSMutableArray *chatMessageArr=[[[msgTempArr reverseObjectEnumerator] allObjects] mutableCopy];//reverse all chat objects
                    
                    [delegate  chatForGroupResult:chatMessageArr];
                }
                
            }
            else
            {
                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
            
            
            break;
        }
        case UPDATE_PASSWORD:
        {
            
//            UPDATE_PASSWORD {
//                message = "Your password has been updated successfully. ";
//                success = 1;
//            }
            
            
            if ([[jsonData objectForKey:@"success"] boolValue])
            {
                if ([delegate respondsToSelector:@selector(updatePasswordResult:)])
                {
                    NSString *str=[jsonData objectForKey:@"message"];
                    [delegate  updatePasswordResult:str];
                }
            }
            else
            {
                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
            
            break;
        }
            
            
        case BLOCKED_USERS:
        {
//            BLOCKED_USERS (
//                           {
//                               user =         {
//                                   id = 221;
//                                   "is_favourite" = 0;
//                                   "is_friend" = 0;
//                                   "is_online" = 0;
//                                   "last_seen_at" = "2014-01-20T17:43:11Z";
//                                   location =             {
//                                       distance = "2.27";
//                                       latitude = "6.89986337";
//                                       longitude = "79.87849862";
//                                   };
//                                   profile =             {
//                                       age = 33;
//                                       "full_name" = u52;
//                                       image = "http://flingoo.s3.amazonaws.com/profiles/221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                       "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                       "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_221-DAD17563-D78E-4152-82EA-79C9F575DE2B.jpg";
//                                   };
//                                   status = "";
//                               };
//                           },
//                           {
//                               user =         {
//                                   id = 220;
//                                   "is_favourite" = 0;
//                                   "is_friend" = 0;
//                                   "is_online" = 0;
//                                   "last_seen_at" = "2014-01-23T18:05:01Z";
//                                   location =             {
//                                       distance = "2.27";
//                                       latitude = "6.89989036";
//                                       longitude = "79.87852226";
//                                   };
//                                   profile =             {
//                                       age = 33;
//                                       "full_name" = u51;
//                                       image = "http://flingoo.s3.amazonaws.com/profiles/220-ABC6C579-34E4-4381-A50A-745CEF7BA194.jpg";
//                                       "image_128x128" = "http://flingoo.s3.amazonaws.com/profiles/image128x128_220-ABC6C579-34E4-4381-A50A-745CEF7BA194.jpg";
//                                       "image_256x256" = "http://flingoo.s3.amazonaws.com/profiles/image256x256_220-ABC6C579-34E4-4381-A50A-745CEF7BA194.jpg";
//                                   };
//                                   status = "";
//                               };
//                           }
//                           )
            
            ///////////////////////////////////////////////////////////
            
            
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSMutableArray *blockUsersArr=[[NSMutableArray alloc] init];
                for(id users in jsonData)
                {
                    if ([users isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *userDic=[users objectForKey:@"user"];
                        FLOtherProfile *otherProfile=[[FLOtherProfile alloc] init];
                        otherProfile.uid=[userDic objectForKey:@"id"];
                        otherProfile.is_favourite=[userDic objectForKey:@"is_favourite"];
                        otherProfile.is_friend=[userDic objectForKey:@"is_friend"];
                        otherProfile.is_online=[userDic objectForKey:@"is_online"];
                        otherProfile.last_seen_at=[userDic objectForKey:@"last_seen_at"];
                        otherProfile.status=[userDic objectForKey:@"status"];
                        
                        NSDictionary *userDic_location=[userDic objectForKey:@"location"];
                        otherProfile.longitude=[userDic_location objectForKey:@"longitude"];
                        otherProfile.latitude=[userDic_location objectForKey:@"latitude"];
                        
                        NSDictionary *userDic_profile=[userDic objectForKey:@"profile"];
                        otherProfile.full_name=[userDic_profile objectForKey:@"full_name"];
                        otherProfile.image=[userDic_profile objectForKey:@"image"];
                        otherProfile.age=[userDic_profile objectForKey:@"age"];
                        
                        [blockUsersArr addObject:otherProfile];
                        
                    }
                }
                if ([delegate respondsToSelector:@selector(blockedUsersListResult:)])
                {
                    [delegate  blockedUsersListResult:blockUsersArr];
                }
            }
            else
            {
                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
            
            
            break;
            
        }

    }
}

#pragma mark -
#pragma mark - Fail methods

-(void)requestFail:(id)jsonData withType:(int)type_int
{
    
    switch (type_int)
    {
        
        case CREATE_USER:
        {
        NSString *errorMsg;
        if ([[[jsonData objectForKey:@"email"] objectAtIndex:0] isEqualToString:@"has already been taken"])
            {
            errorMsg=@"User email already taken";
            }
        else
            {
            errorMsg=@"Unknown Error";
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:errorMsg];
            }
        //////////////////
        
        break;
        }
        case SIGNIN_USER:
        {
        NSString *errorMsg;
        if (![[jsonData objectForKey:@"success"] boolValue])
            {
            errorMsg=@"Email or password incorrect";
            }
        else
            {
            errorMsg=@"Unknown Error";
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:errorMsg];
            }
        break;
        }
        case PROFILE_UPDATE:
        {
        
        //            PROFILE_UPDATE {
        //                message = "Profile updated";
        //                success = 1;
        //            }
        
        NSString *errorMsg;
        if ([jsonData objectForKey:@"error"])
            {
            errorMsg=@"Undefined method";
            }
        else
            {
            errorMsg=@"Unknown Error";
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:errorMsg];
            }
        
        break;
        }
        case CURRENT_USER:
        {
        NSString *errorMsg;
        if ([jsonData objectForKey:@"errors"])
            {
            errorMsg=@"Invalid login credentials";
            }
        else
            {
            errorMsg=@"Unknown Error";
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:errorMsg];
            }
        break;
        }
        case CURRENT_USER_PROFILE:
        {
        NSString *errorMsg;
        if ([jsonData objectForKey:@"errors"])
            {
            errorMsg=@"Invalid login credentials";
            }
        else
            {
            errorMsg=@"Unknown Error";
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:errorMsg];
            }
        break;
        }
        case SIGNOUT:
        {
        NSString *errorMsg;
        if ([[jsonData objectForKey:@"status"] isEqualToString:@"500"])
            {
            errorMsg=@"Undefined Authentication Token";
            }
        else
            {
            errorMsg=@"Unknown Error";
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:errorMsg];
            }
        break;
        }
        case PROFILE_SEARCH:
        {
        NSString *errorMsg;
        if ([jsonData objectForKey:@"success"])
            {
            errorMsg=@"User locations not found, please set your location first";
            }
        else
            {
            errorMsg=@"Unknown Error";
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:errorMsg];
            }
        break;
        }
        case USER_LOCATION:
        {
        NSString *errorMsg;
        if ([jsonData objectForKey:@"errors"])
            {
            errorMsg=@"Unknown Error";
            }
        else
            {
            errorMsg=@"Unknown Error";
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:errorMsg];
            }
        break;
        }
        case CREATE_FRIENDSHIP:
        {
        NSString *errorMsg;
        if ([jsonData objectForKey:@"errors"])
            {
            errorMsg=@"Unknown Error";
            }
        else
            {
            errorMsg=@"Unknown Error";
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:errorMsg];
            }
        break;
        }
        case LISTING_FRIENDSHIP:
        {
        NSString *errorMsg;
        if ([jsonData objectForKey:@"errors"])
            {
            errorMsg=@"Unknown Error";
            }
        else
            {
            errorMsg=@"Unknown Error";
            NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:errorMsg];
            }
        break;
        }
        case IMAGE_UPLOAD:
        {
        //            NSString *errorMsg;
        //            if ([jsonData objectForKey:@"errors"])
        //            {
        //                errorMsg=@"Unknown Error";
        //            }
        //            else
        //            {
        //                errorMsg=@"Unknown Error";
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:(NSString *)jsonData];
            }
        break;
        }
        case CREATE_ALBUM:
        {
        //            NSString *errorMsg;
        //            if ([jsonData objectForKey:@"errors"])
        //            {
        //                errorMsg=@"Unknown Error";
        //            }
        //            else
        //            {
        //                errorMsg=@"Unknown Error";
        //                NSLog(@"Unexpected Error Occered: responce---> %@",jsonData);
        //            }
        
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:(NSString *)jsonData];
            }
        break;
        }
            
        case UPDATE_PASSWORD:
        {
            if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
                [delegate requestFailCall:[jsonData objectForKey:@"message"]];
            }
            break;
        }
          
        case NETWORK_ERROR:
        {
        if ([delegate respondsToSelector:@selector(requestFailCall:)])
            {
            [delegate requestFailCall:jsonData];
            }
        break;
        }
    }
    
}


-(void)unknownFailure //unexpected failer
{
    NSLog(@"out 0");
    if ([delegate respondsToSelector:@selector(unknownFailureCall)])
        {
        if ([delegate respondsToSelector:@selector(unknownFailureCall)])
            {
            [delegate unknownFailureCall];
            }
        }
}

#pragma mark -
#pragma mark - Network avalilability checking methods

-(BOOL)isInternetAvailable
{
    //hemalasankas**
    //    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    //    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    //    if (internetStatus != NotReachable)
    //    {
    return YES;
    //    }
    //    else
    //    {
    //        return NO;
    //    }
}



@end
