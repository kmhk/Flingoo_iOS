//
//  Config.h
//  Flingoo
//
//  Created by Hemal on 11/11/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#ifndef Flingoo_Config_h
#define Flingoo_Config_h

#pragma-mark Facebook
//Facebook
#define FACEBOOK_APP_KEY                @"595000953899640"

#pragma-mark Webservice domain
//Webservice domain
#define WEBSERVICE_DOMAIN_URL           @"http://flingoo-api.herokuapp.com"

//#define WEBSERVICE_DOMAIN_URL              @"http://stag.api.flingoo.com"//http://api.flingoo.com

#define WEBSERVICE_CREATE_USER                     @"/api/users"

#define WEBSERVICE_CREATE_USER_FACEBOOK                     @"/api/users/auth/facebook"

#define WEBSERVICE_SIGNIN_USER                     @"/api/users/sign_in"

#define WEBSERVICE_SIGNOUT_USER                    @"/api/users/sign_out"

#define WEBSERVICE_CURRNT_USER                    @"/api/users/me"

#define WEBSERVICE_CURRNT_USER_PROFILE            @"/api/profiles/me"

#define WEBSERVICE_PROFILE_UPDATE                   @"/api/profiles"

#define WEBSERVICE_PROFILE_SEARCH                   @"/api/profiles/search"

#define WEBSERVICE_SET_LOCATION                   @"/api/locations"

#define WEBSERVICE_CREATE_FRIENDSHIPS               @"/api/friendships"

#define WEBSERVICE_FRIENDSHIP_REQUESTS_LISTING       @"/api/friendships/requests"

#define WEBSERVICE_FRIENDSHIP                       @"/api/friendships/"

#define WEBSERVICE_FAVOURITE_LISTING_FRIENDSHIP      @"/api/friendships/favourites"

#define WEBSERVICE_GROUP         @"/api/groups"

#define WEBSERVICE_GROUP_OWNED               @"/api/groups/owned"

#define WEBSERVICE_MEET_POINT                 @"/api/meet_points"

#define WEBSERVICE_MEET_POINT_OWNED           @"/api/meet_points/owned"

#define WEBSERVICE_TAXI_POINT_CREATE            @"/api/taxi_points"

#define WEBSERVICE_RADAR_SEARCH                @"/api/radar"

#define WEBSERVICE_HEARTBEAT             @"/api/heartbeat/notify"

#define WEBSERVICE_STATUS_UPDATE             @"/api/statuses"

#define WEBSERVICE_USERS_SHOW             @"/api/users/"

#define WEBSERVICE_PROFILE_VISITORS         @"/api/users/visitors"

#define WEBSERVICE_PROFILE_VISITS            @"/api/users/visits"

#define WEBSERVICE_IMAGE_UPLOAD         @"http://flingoo_test.s3.amazonaws.com"

#define WEBSERVICE_FORGOT_PASSWORD      @"/api/users/forgot_password"

#define WEBSERVICE_CHAT_SEND            @"/api/messages"

#define WEBSERVICE_ALBUM                @"/api/albums"

#define WENSERVICE_ALBUMPHOTO_UPLOAD          @"/photos"

#define WENSERVICE_INTERVIEW_QUESTIONS     @"/api/questions"

#define WENSERVICE_INTERVIEW_QUESTIONS_UPDATE     @"/api/interview_questions/" 

#define WEBSERVICE_USERS_ALBUM             @"/albums"

#define WEBSERVICE_PROFILE_PIC_ALBUM    @"/api/albums/profile"

#define  WEBSERVICE_MATCH_USERS   @"/api/match"

#define  WEBSERVICE_LOCATION_POINT         @"/api/location_points"

#define  WEBSERVICE_LOCATION_POINT_CHECK_IN  @"/checkin"

#define  WEBSERVICE_LIKE_TO_USER    @"/like"

#define  WEBSERVICE_UNLIKE_TO_USER    @"/unlike"

#define WEBSERVICE_CURRENT_USER_LIKE_LIST @"/likes"

#define WEBSERVICE_BLOCK_USERS      @"/block"

#define WEBSERVICE_UNBLOCK_USERS    @"/unblock"

#define WEBSERVICE_FINDME       @"/api/beacons"

#define WEBSERVICE_MOMENT  @"/api/moments"

#define WEBSERVICE_CREDIT_PLANS       @"/api/credit_plans"

#define WEBSERVICE_VIP_MEMBERSHIP_PLANS         @"/api/membership_plans"

#define WEBSERVICE_PAYMENTS     @"/api/payments"

#define WEBSERVICE_GIFT_ITEM     @"/api/gift_items"

#define WEBSERVICE_GIFT_KESSES         @"/api/gift_items/kisses"

#define WEBSERVICE_GIFT_DRINKS      @"/api/gift_items/drinks"

#define WEBSERVICE_GIFT_SEND          @"/api/gifts"

//Gift: All Received Gifts
#define WEBSERVICE_RECEIVED_ALL_GIFT  @"/api/gifts"

#define WEBSERVICE_RECEIVED_GIFT_KISSES    @"/api/gifts/kisses"

#define WEBSERVICE_RECEIVED_GIFT_DRINKS    @"/api/gifts/drinks"

#define WEBSERVICE_EYE_CATCHER    @"/api/profile_highlights"

#define WEBSERVICE_GROUP_CHAT_HISTORY       @"/api/messages/group/"


#pragma-mark Image upload
//Image upload
#define S3_ACCESS_KEY_ID                @"AKIAIJ6V3NHQDUZZLUTQ"

#define S3_SECRET_ACCESS_KEY           @"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"

#define S3_REGION                      @"us-east-1"

#define S3_BUCKET                       @"flingoo"

#define IMAGE_DIRECTORY_PROFILE         @"profiles"

#define IMAGE_DIRECTORY_GROUP           @"groups"

#define IMAGE_DIRECTORY_MEETPOINT           @"meetpoint"

#define IMAGE_DIRECTORY_ALBUM           @"albums/"

#define IMAGE_DIRECTORY_CHAT           @"chat"

#define WEBSERVICE_IMAGE_UPLOAD_TO_DIR        @"/api/profile_images"

#define WEBSERVICE_USER_SETTING @"/api/settings"

#define WEBSERVICE_NOTIFICATION_LIST        @"/api/notifications"

#define WEBSERVICE_UPDATE_PASSWORD     @"/api/users/update_password"

#define WEBSERVICE_BLOCKED_USERS      @"/api/users/blocked_users"

#pragma-mark Webservice status code
//Webservice status code
#define CREATE_USER_FAIL_STATUS_CODE    422

#define SIGNIN_USER_FAIL_STATUS_CODE    401

//Pusher chat
#pragma-mark Pusher chat

#define PUSHER_KEY              @"604774e9119a186084f7"

#define PUSHER_CHANNEL_NAME_FOR_CHAT     @"flingoo-chat"
#define PUSHER_EVENT_NAME_FOR_CHAT		@"message-received"



//Pusher notification
#pragma-mark Pusher notification

#define PUSHER_CHANNEL_NAME_FOR_NOTIFICATION     @"flingoo-notification"
#define PUSHER_EVENT_NAME_FOR_NOTIFICATION		@"notification-received"


#pragma-mark NSNotification
//NSNotification
#define RECEIVED_CHAT_UPDATE     @"ReceivedChatUpdate"//update common chat table

#define RECEIVED_CHAT_FOR_USER     @"ReceivedChatForUser"//update individual chat screen

#define RECEIVED_CHAT_FOR_GROUP     @"ReceivedChatForGroup"//update individual chat screen

#define PROFILE_PICTURE_UPLOADED     @"ProfilePicUploaded"

#define RECEIVED_NEW_NOTIFICATION     @"ReceivedNotificationUpdate"

//#define RECEIVED_GROUP_CHAT_UPDATE     @"ReceivedGropuChatUpdate"

#define SETTING_CHANGED             @"SettingsChanged"

#define PROFILE_UPDATED    @"ProfileUpdated" //currently consider profile update only username

//profile select me or other profile
#define MY_PROFILE     @"MyProfile"
#define OTHER_PROFILE     @"OtherProfile"

#define UNWANTED_IMG_URL_PART @"http://flingoo.s3.amazonaws.com/"

#define DEFUALT_PROFILE_PIC_URL @"http://flingoo.s3.amazonaws.com/fallback/default.gif"



//date format from webservice

#define DATE_FORMAT_FORM_WEBSERVICE     @"yyyy-MM-dd'T'HH:mm:ssZZZZZ"

//message types
#define MSG_TYPE_GROUP  @"group"
#define MSG_TYPE_PRIVATE   @"private"


#endif
