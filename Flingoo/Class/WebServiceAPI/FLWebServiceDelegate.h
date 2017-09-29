//
//  FLWebServiceDelegate.h
//  Flingoo
//
//  Created by Hemal on 11/12/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLUser.h"
#import "FLMe.h"
#import "FLProfile.h"
#import "FLOtherProfile.h"
#import "FLImgObj.h"
#import "FLAlbum.h"
#import "FLPhoto.h"
#import "FLMyDetail.h"
#import "FLChat.h"
#import "FLMeetpoint.h"
#import "FLSetting.h"
#import "FLGroup.h"
#import "FLGiftItem.h"

@protocol FLWebServiceDelegate <NSObject>
@optional
-(void)createUserResult:(FLUser *)current_user;
-(void)signinUserResult:(FLUser *)current_user;
-(void)profileUpdateResult:(NSString *)msg;
-(void)forgetPasswodResult:(NSString *)msg;
-(void)currentUserResult:(FLProfile *)me;
-(void)signOutUserResult:(NSString *)message;
-(void)userLocationSetResult:(NSString *)message;
-(void)profileFriendshipFriendListResult:(NSMutableArray *)profileObjArr;
-(void)createFriendshipResult:(NSString *)message;
-(void)profileSearchResult:(NSMutableArray *)profileObjArr;
-(void)currentUserProfileResult:(FLProfile *)profileObj;
-(void)groupCreateResult:(FLGroup *)msg;
-(void)groupUpdateResult:(NSString *)msg;
-(void)groupOwnedResult:(NSMutableArray *)createdGroupsArr;
-(void)groupListResult:(NSMutableArray *)createdGroupsArr;
-(void)meetpointOwnedResult:(NSMutableArray *)meetpointArr;
-(void)taxipointCreateResult:(NSString *)msg;
-(void)heartBeatResult:(NSString *)last_seen;
-(void)profileFriendshipSearchResult:(NSMutableArray *)projectObjArr;
-(void)statusUpdateResult:(NSString *)str;
-(void)friendshipAcceptResult:(NSString *)str;
-(void)friendshipRejectResult:(NSString *)str;
-(void)radarSearchMeetPointResult:(NSMutableArray *)meetPointObjArr;
-(void)radarSearchGroupResult:(NSMutableArray *)meetPointObjArr;
-(void)radarSearchTaxiPointResult:(NSMutableArray *)meetPointObjArr;
-(void)removeFavouriteResult:(NSString *)str;
-(void)addFavouriteResult:(NSString *)str;
-(void)userShowResult:(FLOtherProfile *)profileObj;
-(void)chatSendResult:(NSString *)str;
-(void)albumCreateResult:(FLAlbum *)albumObj;
-(void)albumListResult:(NSMutableArray *)albumListArr;
-(void)albumDeleteResult:(NSString *)msg;
-(void)albumPhotoListResult:(NSMutableArray *)photoObjArr;
-(void)albumPhotoUploadedResult:(FLPhoto *)photoObj;
-(void)deletePhotoResult:(NSString *)str;
-(void)matchListResult:(NSMutableArray *)matchsArr;
-(void)locationPointCreateResult:(NSString *)str;
-(void)likeToUserResult:(NSString *)str;
-(void)unlikeToUserResult:(NSString *)str;
-(void)likeUserListResult:(NSMutableArray *)likeUserArr;
-(void)profileVisitorsResult:(NSMutableArray *)profileVisitorsArr;
-(void)profileVisitsResult:(NSMutableArray *)profileVisitsArr;
-(void)faveritesListResult:(NSMutableArray *)favoritesObjArr;
-(void)blockUserResult:(NSString *)str;
-(void)unblockUserResult:(NSString *)str;
-(void)interviewQuestionsResult:(NSMutableArray *)questionsArr;
-(void)radarSearchResult:(NSMutableArray *)radarObjArr;
-(void)interviewQuestionUpdateResult:(FLMyDetail *)myDetailObj;
-(void)profilePicUploaded:(NSString *)str;
-(void)profilePicListResult:(NSMutableArray *)photoArr;
-(void)chatForUserResult:(NSMutableArray *)chatMessageArr;
-(void)userChatsResult:(NSMutableArray *)chatArr;
-(void)findMeResult:(NSString *)str;
-(void)meetPointCreateResult:(FLMeetpoint *)meetPointObj;
-(void)sendPaymentResult:(NSString *)str;
-(void)userSettingListResult:(FLSetting *)settingObj;
-(void)settingsUpdatedResult:(NSString *)key:(NSNumber *)value;

-(void)giftItemListResult:(NSMutableArray *)giftArr;
-(void)giftSendResult:(FLGiftItem *)giftObject:(NSString *)msg;
-(void)giftReceivedAllListResult:(NSMutableArray *)receivedGiftArr;

//image upload
-(void)profileImageUploaded:(FLImgObj *)profileObj;
-(void)albumImageUploaded:(FLImgObj *)imgObj;
-(void)groupImageUploaded:(FLImgObj *)groupImgObj;
-(void)meetPointImageUploaded:(FLImgObj *)meetPointObj;

//notification
-(void)notificationListResult:(NSMutableArray *)notificationArr;
-(void)notificationUpdatedResult:(NSString *)notificationID;

//movent list
-(void)momentListResult:(NSMutableArray *)momentsObjArr;

-(void)createEyeCatcherResult:(NSString *)str;
-(void)eyeCatcherProfileListResult:(NSMutableArray *)eyeCatcherProfilesArr;

//payment
-(void)creditPlanResult:(NSMutableArray *)creditPlanArr;
-(void)membershipPlanResult:(NSMutableArray *)membershipPlanArr;

//chat data
-(void)chatDataResult:(FLChat *)chatObj;
-(void)chatGroupDataResult:(FLChat *)chatObj;
-(void)chatForGroupResult:(NSMutableArray *)chatMessageArr;

//password updated
-(void)updatePasswordResult:(NSString *)str;

-(void)blockedUsersListResult:(NSMutableArray *)blockUsersArr;

@required
-(void)requestFailCall:(NSString *)errorMsg;
-(void)unknownFailureCall;
@end
