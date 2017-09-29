//
//  BaseViewController.h
//  NewSructure
//
//  Created by Thilina Hewagama on 11/29/13.
//  Copyright (c) 2013 Thilina Hewagama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftPanelViewController.h"
#import "RightPanelViewController.h"
#import "FLFindMeViewController.h"
#import "FLFFriendsViewController.h"
#import "FLVIPUpgradeViewController.h"
#import "FLNotificationViewController.h"
#import "FLFFriendRequestsViewController.h"
#import "FLFUnfriendedViewController.h"
#import "FLChatRequestsViewController.h"
#import "FLChatScreenViewController.h"
#import "FLProfileVisitorsViewController.h"
#import "FLProfileVisitsViewController.h"
#import "FLFreeCreditsViewController.h"
#import "FLBuyCreditsViewController.h"
#import "FLVIPMembershipsViewController.h"
#import "FLFAddFriendsViewController.h"
#import "FLBlockedPeopleViewController.h"
#import "FLSendGiftsViewController.h"
#import "FLShowGiftsViewController.h"

#import "FLFFriendRequestsViewController.h"
#import "FLFindPeopleViewController.h"
#import "FLEyeCatcherViewController.h"
#import "FLAdvancedSearchViewController.h"
#import "FLFavouritsViewController.h"
#import "FLMyFansViewController.h"
#import "FLMyGiftsViewController.h"
#import "FLMyChatViewController.h"
#import "FLMatchesViewController.h"
#import "FLLikeYouViewController.h"
#import "FLDoYouLikeViewController.h"
#import "FLMapViewController.h"
#import "FLMFOverviewViewController.h"

#import "FLMFPhotoGalleryViewController.h"
#import "FLMFDetailsViewController.h"
#import "FLProfileViewController.h"
#import "FLMFPhotosViewController.h"
#import "FLRadarViewController.h"

#import "FLSettingsViewController.h"

//group chat
#import "FLGroupChatScreenViewController.h"

@interface BaseViewController : UIViewController

@property(nonatomic, strong) LeftPanelViewController *leftPanelViewController;
@property(nonatomic, strong) RightPanelViewController *rightPanelViewController;
//@property(nonatomic, strong) ProfileViewController *profileViewController;



//other views
@property(nonatomic, strong) FLFindMeViewController *findMeViewController;
@property(nonatomic, strong) FLFFriendsViewController *friendsViewController;

@property(nonatomic, strong) FLVIPUpgradeViewController *vipUpgradeViewController;
@property(nonatomic, strong) FLVIPMembershipsViewController *vipMembershipViewController;

@property(nonatomic, strong) FLNotificationViewController *notificationViewController;
@property(nonatomic, strong) FLFFriendRequestsViewController *friendRequestsViewController;
@property(nonatomic, strong) FLFUnfriendedViewController *unfriendedViewController;

@property(nonatomic, strong) FLProfileVisitorsViewController *profileVisitorsViewController;
@property(nonatomic, strong) FLProfileVisitsViewController *profileVisitsViewController;

//earn
@property(nonatomic, strong) FLFreeCreditsViewController *freeCreditsViewController;
@property(nonatomic, strong) FLBuyCreditsViewController *buyCreditsViewController;

//favourites
@property(nonatomic, strong) FLFAddFriendsViewController *addFriendsViewController;

//setings
@property(nonatomic, strong) FLBlockedPeopleViewController *blockedPeopleViewComtroller;

//send gifts
@property(nonatomic, strong) FLShowGiftsViewController *showGiftsViewController;
@property(nonatomic, strong) FLSendGiftsViewController *sendGiftsViewController;

//find people
@property(nonatomic, strong) FLFindPeopleViewController *findPeopleViewController;
@property(nonatomic, strong) FLEyeCatcherViewController *eyeCatcherViewCobtroller;
@property(nonatomic, strong) FLAdvancedSearchViewController *advancedSearchViewController;

@property(nonatomic, strong) FLFavouritsViewController *favouritesViewController;
@property(nonatomic, strong) FLMyFansViewController *myFansViewController;

//notifications
@property(nonatomic, strong) FLMyGiftsViewController *myGiftsViewController;

//chat
@property(nonatomic, strong) FLChatRequestsViewController *chatRequestViewController;
@property(nonatomic, strong) FLChatScreenViewController *chatScreenViewController;

@property(nonatomic, strong) FLMyChatViewController *myChatViewController;

//group chat
@property(nonatomic, strong) FLGroupChatScreenViewController *groupChatScreenViewController;


//match

@property(nonatomic, strong) FLMatchesViewController *matcheViewController;
@property(nonatomic, strong) FLLikeYouViewController *likeYouViewController;

@property(nonatomic, strong) FLDoYouLikeViewController *doYouLikeViewController;

@property(nonatomic, strong) FLMapViewController *mapViewController;

@property(nonatomic, strong) FLMFOverviewViewController *overiVwViewController;

@property(nonatomic, strong) FLMFPhotoGalleryViewController *mfPhotoGalleryVeiwController;
@property(nonatomic, strong) FLMFDetailsViewController *mfDetailViewController;


@property(nonatomic, strong) FLProfileViewController *profileViewController;

@property(nonatomic, strong) FLMFPhotosViewController *photosViewController;

@property(nonatomic, strong) FLRadarViewController *radarViewController;



//settings
//@property(nonatomic, strong) FLSettingsViewController *settingsViewController;
@property(nonatomic, strong) UINavigationController *settingsViewController;


//
-(void) showFindMeViewController:(BOOL) show;
-(void) showFriendsViewController:(BOOL) show;

-(void) showVIPUpgradeViewController:(BOOL) show;
-(void) showVIPMembershipViewController:(BOOL) show;

-(void) showNotificationViewController:(BOOL) show;
-(void) showFriendRequests:(BOOL) show;
-(void) showUnfriendedViewController:(BOOL) show;

-(void) showProfileVisitorsViewController:(BOOL) show;
-(void) showProfileVisitsViewController:(BOOL) show;

-(void) showFreeCreditsViewController:(BOOL) show;
-(void) showBuyCreditsViewController:(BOOL) show;

-(void) showAddFriendsViewController:(BOOL) show;

-(void) showBlockedPeopleViewController:(BOOL) show;


-(void) showSendGiftsViewController:(BOOL) show;
//-(void) showShowGiftsViewController:(BOOL) show;

//find people
-(void) showFindPeopleViewController:(BOOL) show;
-(void) showEyeCatcherViewController:(BOOL) show;
-(void) showAdvancedSearchViewController:(BOOL) show;

-(void) showFavouritesViewController:(BOOL) show;
-(void) showMyFansViewController:(BOOL) show;

//notifications
-(void) showMyGiftsViewController:(BOOL) show;

//chat
-(void) showChatRequestViewController:(BOOL) show;
-(void) showChatScreenViewController:(BOOL) show param:(id)param;
-(void) showGroupChatScreenViewController:(BOOL) show param:(id)param;
-(void) showMyChatViewController:(BOOL) show;

//match
-(void) showDoYouLikeViewController:(BOOL) show;
-(void) showMatchesViewController:(BOOL) show;
-(void) showLikeYouViewController:(BOOL) show;
-(void) showProfileViewCOntroller:(BOOL) show param:(id) param;

-(void) showMapViewController:(BOOL) show coordinates:(NSData *) coordinates;

//My Profileview
-(void) showMyProfileViewController:(BOOL) show;
-(void) showMyProfileDetailViewController:(BOOL) show param:(id) param;
-(void) showMyProfilePhotoGalleryViewController:(BOOL) show  param:(id) param;

-(void) showPhotosViewController:(BOOL) show param:(id) param;


//radar

-(void) showRadarViewController:(BOOL) show;





//settings
-(void) showSettingsViewController:(BOOL) show;




@end
