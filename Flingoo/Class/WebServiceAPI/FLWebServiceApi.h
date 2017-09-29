//
//  FLWebServiceApi.h
//  Flingoo
//
//  Created by Hemal on 11/12/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLWebServiceDelegate.h"
#import "FLUserDetail.h"
#import "FLProfileSearch.h"
#import "FLUserLocation.h"
#import "FLFriendship.h"
#import "FLProfile.h"
#import "FLGroup.h"
#import "FLTaxiPoint.h"
#import "FLRadarItem.h"
#import <AWSS3/AWSS3.h>
#import "FLImgObj.h"
#import "FLAlbum.h"
#import "FLPhoto.h"
#import "FLMeetpoint.h"
#import "FLLocationPoint.h"
#import "FLMyDetail.h"
#import "FLPayment.h"
#import <CoreLocation/CoreLocation.h>

@class FLPhoto;
@interface FLWebServiceApi : NSObject<AmazonServiceRequestDelegate>
@property(nonatomic,weak) id<FLWebServiceDelegate> delegate;
-(void)createUser:(id)_delegate withUserData:(id)userData;
-(void)createUserFB:(id)_delegate withUserData:(NSDictionary *)userData;
-(void)signinUser:(id)_delegate withUserData:(NSDictionary *)userData;
-(void)forgotPassword:(id)_delegate withEmail:(NSString *)emailAddress;
-(void)currentUser:(id)_delegate;
//-(void)currentUserProfileDetail:(id)_delegate;
-(void)signOutUser:(id)_delegate;
-(void)profileUpdate:(id)_delegate withUserData:(FLUserDetail *)userData;
-(void)profileSearch:(id)_delegate withUserData:(FLProfileSearch *)profileSearchData;
-(void)userLocationSet:(id)_delegate withUserData:(FLUserLocation *)userLocationData;
-(void)createFriendship:(id)_delegate withUserData:(FLFriendship *)friendshipData;
-(void)friendshipRequestListing:(id)_delegate;
-(void)friendshipAccept:(id)_delegate withFriendshipId:(NSString *)friendshipId;
-(void)friendshipReject:(id)_delegate withFriendshipId:(NSString *)friendshipId;
-(void)friendshipFriendList:(id)_delegate;
-(void)favouriteAdd:(id)_delegate withFriendshipId:(NSString *)friendshipId;
-(void)favouriteListing:(id)_delegate;
-(void)favouriteRemove:(id)_delegate withFriendshipId:(NSString *)friendshipId;
-(void)showGroup:(id)_delegate withGroupId:(NSString *)groupId;
-(void)groupCreate:(id)_delegate withGroupObj:(FLGroup *)groupObj;
-(void)groupUpdate:(id)_delegate withGroupObj:(FLGroup *)groupObj withGroupID:(NSString *)groupID;
-(void)groupUserUpdate:(id)_delegate withUserIDs:(NSArray *)userIDsArr withGroupID:(NSString *)groupID;
-(void)groupUserRemove:(id)_delegate withUserIDs:(NSArray *)userIDsArr withGroupID:(NSString *)groupID;
-(void)groupsOwend:(id)_delegate;
-(void)groupListAll:(id)_delegate;
-(void)meetPointCreate:(id)_delegate withMeetPointObj:(FLMeetpoint *)meetPointObj;
-(void)meetPointOwend:(id)_delegate;
-(void)meetpointListAll:(id)_delegate;
-(void)taxiPointCreate:(id)_delegate withGroupObj:(FLTaxiPoint *)taxipointObj;
-(void)radarSearch:(id)_delegate withRadar:(FLRadar *)userRadar;
-(void)heartbeatNotify:(id)_delegate;
-(void)statusUpdate:(id)_delegate withStatusTxt:(NSString *)txt_status;
-(void)userShow:(id)_delegate withUserID:(NSString *)userID;
-(void)profileVisitors:(id)_delegate;
-(void)profileVisits:(id)_delegate;
-(void)chatSend:(id)_delegate withMessage:(NSString *)message withReceiverID:(NSString *)receiverID withType:(NSString *)message_type;
-(void)createAlbum:(id)_delegate withAlbumObj:(FLAlbum *)albumObj;
-(void)albumList:(id)_delegate;
-(void)albumDelete:(id)_delegate withAlbumID:(NSString *)albumID;
-(void)uploadAlbumImage:(id)_delegate withAlbumObj:(FLPhoto *)photoObj;
-(void)albumPhotoList:(id)_delegate withAlbumID:(NSString *)albumID;
-(void)photoDelete:(id)_delegate withAlbumID:(NSString *)albumID withPhotoID:(NSString *)photoID;
-(void)interviewQuestionList:(id)_delegate;
-(void)interviewQuestionUpdate:(id)_delegate withQuestionObj:(FLMyDetail *)questionObj;
-(void)albumList:(id)_delegate withUserID:(NSString *)userID;
-(void)usersAlbumPhotoList:(id)_delegate withUserID:(NSString *)userID withAlbumID:(NSString *)albumID;
-(void)profilePicsList:(id)_delegate;
-(void)matchUsersList:(id)_delegate;
-(void)locationPointCreate:(id)_delegate withLocationPointObj:(FLLocationPoint *)locationPointObj;
-(void)locationCheckin:(id)_delegate withVenueID:(NSString *)venueID;
-(void)likeToUser:(id)_delegate withUserID:(NSString *)userID;
-(void)unlikeToUser:(id)_delegate withUserID:(NSString *)userID;
-(void)likeUsersList:(id)_delegate;
-(void)unblockUser:(id)_delegate withUserID:(NSString *)userID;
-(void)blockUser:(id)_delegate withUserID:(NSString *)userID;
-(void)imageUploadToDir:(id)_delegate withImageName:(NSString *)imageName;
-(void)profilePicList:(id)_delegate;
-(void)userChatListForUser:(id)_delegate withUserID:(NSString *)userID;
-(void)userChatList:(id)_delegate;
-(void)findme:(id)_delegate withLat:(NSString *)userLatitude withLon:(NSString *)userLongitude;
-(void)momentList:(id)_delegate;
-(void)getUserSettingsList:(id)_delegate;
-(void)settingUpdate:(id)_delegate withKey:(NSString *)key withValue:(NSNumber *)value;

//Payments
-(void)creaditPlansList:(id)_delegate;
-(void)getVipMembershipList:(id)_delegate;
-(void)getVipMembershipPlanList:(id)_delegate;
-(void)sendPayment:(id)_delegate withLocationPointObj:(FLPayment *)paymentObj;

//Gift
-(void)getGiftItemAllList:(id)_delegate;
-(void)getKissesList:(id)_delegate;
-(void)getDrinksList:(id)_delegate;
-(void)giftSend:(id)_delegate withGiftItemID:(FLGiftItem *)giftObj withReceiverID:(NSNumber *)receiver_id;
-(void)getGiftAllReceivedItems:(id)_delegate;
-(void)getGiftReceivedKisses:(id)_delegate;
-(void)getGiftReceivedDrinks:(id)_delegate;

//notification
-(void)getNotificationList:(id)_delegate;
-(void)notificationUpdate:(id)_delegate withNotificationID:(NSString *)notificationID;

//image upload
-(void)uploadImage:(id)_delegate withImgObj:(FLImgObj *)imgObj;
//- (void)processBackgroundThreadUpload:(NSData *)imageData;
-(NSURL *)getImageFromName:(NSString *)imgName;
@property (nonatomic, retain) AmazonS3Client *s3;

//Eye Catcher
-(void)createEyeCatcher:(id)_delegate;
-(void)getEyeCatcherProfileList:(id)_delegate;

//get chat data
-(void)chatData:(id)_delegate withChatObj:(FLChat *)chatObj;
-(void)chatGroupData:(id)_delegate withChatObj:(FLChat *)chatObj;
-(void)userChatListForGroup:(id)_delegate withGrouID:(NSString *)groupID;

//change Password
-(void)updatePassword:(id)_delegate withCurrentPassword:(NSString *)current_password withNewPassword:(NSString *)newPassword;

-(void)blockedUserList:(id)_delegate;
@end
