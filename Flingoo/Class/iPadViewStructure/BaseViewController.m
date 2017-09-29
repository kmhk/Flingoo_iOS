//
//  BaseViewController.m
//  NewSructure
//
//  Created by Thilina Hewagama on 11/29/13.
//  Copyright (c) 2013 Thilina Hewagama. All rights reserved.
//

#import "BaseViewController.h"
#import "FLUtilUserDefault.h"
#import "FLUtil.h"
#import "FLAppDelegate.h"
#import "FLGlobalSettings.h"
#import "Macros.h"
#import "Config.h"


#define MIDDLE_PANEL_IDENTIFIER_TAG 887
#define RIGHT_PANEL_IDENTIFIER_TAG 888

#define LEFT_PANEL_FRAME CGRectMake(0, 0, 268, 748)
#define RIGHT_PANEL_FRAME CGRectMake(268, 0, 756, 748)

#define LEFT_OVERLAY_FRAME CGRectMake(0, 44, 320, 704)
#define MIDDLE_OVERLAY_ORIGIN CGPointMake(268, 44)
#define RIGHT_OVERLAY_ORIGIN CGPointMake(588, 44)

#define MIDDLE_PANEL_FRAME CGRectMake(268,44,320,724)


@interface BaseViewController ()<MBProgressHUDDelegate, UIScrollViewDelegate>{
    MBProgressHUD *HUD;
}

@property(nonatomic, weak) UIScrollView *currentMidScrollView;
@property(nonatomic, weak) UIScrollView *currentRightMidScrollView;
@property(nonatomic, assign) int scrollController;

@property(nonatomic, assign) BOOL isDecelerate;

@end

@implementation BaseViewController





#pragma mark - Initialize 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}





#pragma mark - View Lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Add Base classes
    
    self.leftPanelViewController = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
    self.rightPanelViewController = [[RightPanelViewController alloc] initWithNibName:@"RightPanelViewController" bundle:nil];
    
    self.leftPanelViewController.view.frame = LEFT_PANEL_FRAME;
    self.rightPanelViewController.view.frame = RIGHT_PANEL_FRAME;
    
    [self.view addSubview:self.leftPanelViewController.view];
    [self.view addSubview:self.rightPanelViewController.view];
    
    [self.rightPanelViewController dropShadow];
    
    [self.rightPanelViewController setRightPanelTitle:@"   "];
    
    
    
    __block BaseViewController *base = self;
    [self.leftPanelViewController setCommunicator:^(NSDictionary *dict){
        
        //handle all show commands
        id command = [dict objectForKey:RemoteAction];
        if(command){
            
            NSLog(@"command: %@", command);
            
            
            if([command isEqualToString:kRemoteActionShowFindMe]){
                [base showFindMeViewController:YES];
            }else [base showFindMeViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowFriends]){
                [base showFriendsViewController:YES];
            }else [base showFriendsViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowVip]){
                [base showVIPUpgradeViewController:YES];
            }else [base showVIPUpgradeViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowNotifications]){
                [base showNotificationViewController:YES];
            }else [base showNotificationViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowFriendRequests]){
                [base showFriendRequests:YES];
            }else [base showFriendRequests:NO];
            
            if([command isEqualToString:kRemoteActionShowUnfriended]){
                [base showUnfriendedViewController:YES];
            }else [base showUnfriendedViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowChatRequest]){
                [base showChatRequestViewController:YES];
            }else [base showChatRequestViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowChatScreen]){
                [base showChatScreenViewController:YES param:nil];
            }else [base showChatScreenViewController:NO param:nil];
            
            if([command isEqualToString:kRemoteActionShowChatGroupScreen]){
                [base showGroupChatScreenViewController:YES param:nil];
            }else [base showGroupChatScreenViewController:NO param:nil];
            
            if([command isEqualToString:kRemoteActionShowMyChat]){
                [base showMyChatViewController:YES];
            }else [base showMyChatViewController:NO];
            
            
            if([command isEqualToString:kRemoteActionShowProfileVisits]){
                [base showProfileVisitsViewController:YES];
            }else [base showProfileVisitsViewController:NO];
            
            
            if([command isEqualToString:kRemoteActionShowProfileVisitors]){
                [base showProfileVisitorsViewController:YES];
            }else [base showProfileVisitorsViewController:NO];
            
            
            if([command isEqualToString:kRemoteActionShowFreeCredits]){
                [base showFreeCreditsViewController:YES];
            }else [base showFreeCreditsViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowAddFriends]){
                [base showAddFriendsViewController:YES];
            }else [base showAddFriendsViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowBlockedPeople]){
                [base showBlockedPeopleViewController:YES];
            }else [base showBlockedPeopleViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowSendGifts]){
                [base showSendGiftsViewController:YES];
            }else [base showSendGiftsViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowEyeCatcher]){
                [base showEyeCatcherViewController:YES];
            }else [base showEyeCatcherViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowFindPeople]){
                [base showFindPeopleViewController:YES];
            }else [base showFindPeopleViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowAdvancedSearch]){
                [base showAdvancedSearchViewController:YES];
            }else [base showAdvancedSearchViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowFavourites]){
                [base showFavouritesViewController:YES];
            }else [base showFavouritesViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowMyFans]){
                [base showMyFansViewController:YES];
            }else [base showMyFansViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowMyGifts]){
                [base showMyGiftsViewController:YES];
            }else [base showMyGiftsViewController:NO];
            
            if([command isEqualToString:kRemoteActionMyProfile]){
                [base showMyProfileViewController:YES];
            }else [base showMyProfileViewController:NO];
            /////
            if([command isEqualToString:kRemoteActionShowMatches]){
                [base showMatchesViewController:YES];
            }else [base showMatchesViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowLikeYou]){
                [base showLikeYouViewController:YES];
            }else [base showLikeYouViewController:NO];
            
            if([command isEqualToString:kRemoteActionShowDoYouLike]){
                [base showDoYouLikeViewController:YES];
            }else{
                [base showDoYouLikeViewController:NO];
            }
            
            if([command isEqualToString:kRemoteActionShowProfile]){
                //you don't have to pass object from here
            }else{
                [base showProfileViewCOntroller:NO param:nil];
            }
            
            if([command isEqualToString:kRemoteActionSettings]){
                [base showSettingsViewController:YES];
            }else{
                [base showSettingsViewController:NO];
            }
            
            
            if([command isEqualToString:kRemoteActionSignOut]){
                [base signOutActionRequestReceived];
            }
            
        }
        
        //handle all other commands
        
    }];
    
    //add Profile
    //    self.profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    //    [self.profileViewController setCommunicator:^(NSDictionary *dict){
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I am base class" message:[NSString stringWithFormat:@"I got a message from profile: %@", dict] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    //        [alert show];
    //    }];
    //
    //
    //    self.profileViewController.view.frame = MIDDLE_PANEL_FRAME;
    //    [self addAsScrollableContent:self.profileViewController];
    
    [self showRadarViewController:YES];
}

- (void) addAsScrollableContent:(HTViewController *) htViewController initiallyHidden:(BOOL) hidden{
    
    CGRect frame = htViewController.view.frame;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    frame.origin.x = 0;
    frame.origin.y = 0;

    
    //    scrollView.alpha = 0;
    //    scrollView.tag = htViewController.view.tag;
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(frame.size.width+1, frame.size.height)];
    [scrollView setClipsToBounds:NO];
    [scrollView setDelaysContentTouches:YES];
    htViewController.view.frame = frame;
    
    if(MIDDLE_OVERLAY_ORIGIN.x == scrollView.frame.origin.x && MIDDLE_OVERLAY_ORIGIN.y == scrollView.frame.origin.y){
        scrollView.tag = MIDDLE_PANEL_IDENTIFIER_TAG;
    }
    
    if(RIGHT_OVERLAY_ORIGIN.x == scrollView.frame.origin.x && RIGHT_OVERLAY_ORIGIN.y == scrollView.frame.origin.y){
        scrollView.tag = RIGHT_PANEL_IDENTIFIER_TAG;
    }
    
    scrollView.delegate = self;
    
    [scrollView addSubview:htViewController.view];
    if(hidden) scrollView.alpha =  0.1f;
    [self.view addSubview:scrollView];
    [htViewController setParentScrollView:scrollView];
}

- (void) identifyScrollviews{
    self.currentMidScrollView = (UIScrollView *)[self.view viewWithTag:MIDDLE_PANEL_IDENTIFIER_TAG];
    self.currentRightMidScrollView = (UIScrollView *)[self.view viewWithTag:RIGHT_PANEL_IDENTIFIER_TAG];
}










#pragma mark - ScrollView

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isDecelerate = NO;
    [self identifyScrollviews];
    
    if(scrollView.tag == MIDDLE_PANEL_IDENTIFIER_TAG || scrollView.tag == RIGHT_PANEL_IDENTIFIER_TAG){
        self.scrollController = scrollView.tag;
    }else{
        self.scrollController = -1;
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.currentMidScrollView && self.currentRightMidScrollView){
        if(self.scrollController == MIDDLE_PANEL_IDENTIFIER_TAG){
            [self.currentRightMidScrollView setContentOffset:self.currentMidScrollView.contentOffset];
        }else if(self.scrollController == RIGHT_PANEL_IDENTIFIER_TAG){
            
            //move right
            
            CGFloat midX = self.currentMidScrollView.contentOffset.x;
            CGFloat rightX = self.currentRightMidScrollView.contentOffset.x;

            if(rightX<midX){
                if(self.isDecelerate==NO)[self.currentMidScrollView setContentOffset:self.currentRightMidScrollView.contentOffset];
            }else{
                if(self.isDecelerate==YES){
                    if(self.currentRightMidScrollView.contentOffset.x>0) return;
                    [self.currentMidScrollView setContentOffset:self.currentRightMidScrollView.contentOffset];
                }
            }
        }
    }
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.isDecelerate = decelerate;
}








#pragma mark - Show Views


#pragma mark - VIP

-(void) showVIPUpgradeViewController:(BOOL) show{
    
    if(show){
        if(self.vipUpgradeViewController==nil){
            self.vipUpgradeViewController = [[FLVIPUpgradeViewController alloc] initWithNibName:@"FLVIPUpgradeViewController-iPad" bundle:nil];
            [self.vipUpgradeViewController dropShadow];
        }
        //ignore invalid requests
        if(self.vipUpgradeViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"VIP Upgrade"];
        
        CGRect frame = self.vipUpgradeViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.vipUpgradeViewController.view.frame = frame;
        
        NSLog(@"BEFORE");
        [self addAsScrollableContent:self.vipUpgradeViewController initiallyHidden:YES];
        NSLog(@"AFTER");
        [self showVIPMembershipViewController:YES];
    }else{
        
        if(self.vipUpgradeViewController.parentScrollView.superview){
            [self showVIPMembershipViewController:NO];
            [CATransaction setCompletionBlock:^{
                [self.vipUpgradeViewController.parentScrollView removeFromSuperview];
                self.vipUpgradeViewController = nil;
            }];
            [self.vipUpgradeViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.vipUpgradeViewController = nil;
        }
    }
    
}

-(void) showVIPMembershipViewController:(BOOL) show{
    
    if(show){
        //buy credits
        if(self.vipMembershipViewController==nil){
            self.vipMembershipViewController = [[FLVIPMembershipsViewController alloc] initWithNibName:@"FLVIPMembershipsViewController-iPad" bundle:nil];
            [self.vipMembershipViewController dropShadow];
        }
        
        //ignore invalid requests
        if(self.vipMembershipViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame2 = self.vipMembershipViewController.view.frame;
        frame2.origin = RIGHT_OVERLAY_ORIGIN;
        self.vipMembershipViewController.view.frame = frame2;
        [self addAsScrollableContent:self.vipMembershipViewController initiallyHidden:YES];
    }else{
        
        if(self.vipMembershipViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.vipMembershipViewController.parentScrollView removeFromSuperview];
                self.vipMembershipViewController = nil;
            }];
            [self.vipMembershipViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.vipMembershipViewController = nil;
        }
    }
    
}





#pragma mark - Find Me

-(void) showFindMeViewController:(BOOL) show{
    
    if(show){
        if(self.findMeViewController==nil){
            self.findMeViewController = [[FLFindMeViewController alloc] initWithNibName:@"FLFindMeViewController-iPad" bundle:nil];
            [self.findMeViewController dropShadow];
        }
        [self.rightPanelViewController.view addSubview:self.findMeViewController.view];
        [self.rightPanelViewController setRightPanelTitle:@"Choose a Location"];
    }else{
        
        if(self.findMeViewController.view.superview){
            [self.findMeViewController.view removeFromSuperview];
            self.findMeViewController = nil;
        }else{
            self.findMeViewController = nil;
        }
    }
    
}




#pragma mark - Notifications

-(void) showNotificationViewController:(BOOL) show{
    
    if(show){
        if(self.notificationViewController==nil){
            self.notificationViewController = [[FLNotificationViewController alloc] initWithNibName:@"FLNotificationViewController-iPad" bundle:nil];
            
            __block BaseViewController *baseViewController = self;
            
            [self.notificationViewController setCommunicator:^(NSDictionary *dict){
                NSString *command = [dict objectForKey:RemoteAction];
                if(command){
                    if([command isEqualToString:kRemoteActionShowMap]){
                        if([dict objectForKey:@"coordinates"]){
                            NSData *data = [dict objectForKey:@"coordinates"];
                            [baseViewController showMapViewController:YES coordinates:data];
                        }else{
                            
                            [baseViewController showMapViewController:YES coordinates:nil];
                        }
                    }else if([command isEqualToString:kRemoteActionShowMyGifts]){
                        [baseViewController showMyGiftsViewController:YES];
                        [baseViewController showNotificationViewController:NO];
                    }else if([command isEqualToString:kRemoteActionShowChatRequest]){
                        [baseViewController showChatRequestViewController:YES];
                        [baseViewController showNotificationViewController:NO];
                    }else if([command isEqualToString:kRemoteActionShowFriendRequests]){
                        [baseViewController showFriendRequests:YES];
                        [baseViewController showNotificationViewController:NO];
                    }
                }
            }];
            
            [self.notificationViewController dropShadow];
        }
        
        //ignore invalid requests
        if(self.notificationViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame = self.notificationViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.notificationViewController.view.frame = frame;
        [self addAsScrollableContent:self.notificationViewController initiallyHidden:YES];
    }else{
        
        if(self.notificationViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.notificationViewController.parentScrollView removeFromSuperview];
                self.notificationViewController = nil;
            }];
            [self.notificationViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
            [self showMapViewController:NO coordinates:nil];
        }else{
            self.notificationViewController = nil;
        }
    }
    
}

-(void) showMapViewController:(BOOL) show coordinates:(NSData *) coordinates{
    if(show){
        if(self.mapViewController==nil){
            self.mapViewController = [[FLMapViewController alloc] initWithNibName:@"FLMapViewController-iPad" bundle:nil];
            [self.mapViewController dropShadow];
        }
        
        if(coordinates){
            NSData *data = coordinates;
            CLLocationCoordinate2D coordinate;
            [data getBytes:&coordinate length:sizeof(coordinate)];
            [self.mapViewController setDestinationCoordinates:data];
        }else{
            [self.mapViewController setDestinationCoordinates:nil];
        }
        
        //ignore invalid requests
        if(self.mapViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame = self.mapViewController.view.frame;
        frame.origin = RIGHT_OVERLAY_ORIGIN;
        self.mapViewController.view.frame = frame;
        
        [self addAsScrollableContent:self.mapViewController initiallyHidden:YES];
        
        NSLog(@"map frame: %@", NSStringFromCGRect(self.mapViewController.parentScrollView.frame));
    }else{
        
        if(self.mapViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.mapViewController.parentScrollView removeFromSuperview];
                self.mapViewController = nil;
            }];
            [self.mapViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.mapViewController = nil;
        }
    }
}
/*
 
 NSData *data = [dict objectForKey:@"coordinates"];
 CLLocationCoordinate2D coordinate;
 [data getBytes:&coordinate length:sizeof(coordinate)];
 
 */




#pragma mark - Contacts

-(void) showFriendsViewController:(BOOL) show{
    
    if(show){
        if(self.friendsViewController == nil){
            self.friendsViewController = [[FLFFriendsViewController alloc] initWithNibName:@"FLFFriendsViewController-iPad" bundle:nil];
            [self.friendsViewController dropShadow];
            
            __block BaseViewController *baseViewController = self;
            
            [self.friendsViewController setCommunicator:^(NSDictionary *dict){
                NSString *command = [dict objectForKey:RemoteAction];
                
                if(command){
                    if([command isEqualToString:kRemoteActionShowFriendRequests]){
                        [baseViewController showFriendRequests:YES];
                        [baseViewController showFriendsViewController:NO];
                    }else if([command isEqualToString:kRemoteActionShowProfile]){
                        
                        [baseViewController showProfileViewCOntroller:YES param:(NSDictionary *)[dict objectForKey:@"ClickAction"]];
                        
                        [baseViewController showFriendsViewController:NO];
                        
                    }
                }
                
                /*
                 
                 if([command isEqualToString:kRemoteActionShowProfile]){
                 [baseViewController showProfileViewCOntroller:YES param:(NSDictionary *)[dict objectForKey:@"ClickAction"]];
                 
                 */
                
            }];
            
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Friends"];
        
        //ignore invalid requests
        if(self.friendsViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame = self.friendsViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.friendsViewController.view.frame = frame;
        [self addAsScrollableContent:self.friendsViewController initiallyHidden:YES];
    }else{
        
        if(self.friendsViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.friendsViewController.parentScrollView removeFromSuperview];
                self.friendsViewController = nil;
            }];
            [self.friendsViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.friendsViewController = nil;
        }
    }
    
}

-(void) showFriendRequests:(BOOL) show{
    
    if(show){
        if(self.friendRequestsViewController==nil){
            self.friendRequestsViewController = [[FLFFriendRequestsViewController alloc] initWithNibName:@"FLFFriendRequestsViewController-iPad" bundle:nil];
            [self.friendRequestsViewController dropShadow];
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Friend Requests"];
        
        //ignore invalid requests
        if(self.friendRequestsViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame = self.friendRequestsViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.friendRequestsViewController.view.frame = frame;
        [self addAsScrollableContent:self.friendRequestsViewController initiallyHidden:YES];
    }else{
        
        if(self.friendRequestsViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.friendRequestsViewController.parentScrollView removeFromSuperview];
                self.friendRequestsViewController = nil;
            }];
            [self.friendRequestsViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.friendRequestsViewController = nil;
        }
        
    }
    
}

-(void) showUnfriendedViewController:(BOOL) show{
    
    if(show){
        if(self.unfriendedViewController==nil){
            self.unfriendedViewController = [[FLFUnfriendedViewController alloc] initWithNibName:@"FLFUnfriendedViewController-iPad" bundle:nil];
            [self.unfriendedViewController dropShadow];
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Unfriended"];
        
        //ignore invalid requests
        if(self.unfriendedViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame = self.unfriendedViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.unfriendedViewController.view.frame = frame;
        [self addAsScrollableContent:self.unfriendedViewController initiallyHidden:YES];
    }else{
        
        if(self.unfriendedViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.unfriendedViewController.parentScrollView removeFromSuperview];
                self.unfriendedViewController = nil;
            }];
            [self.unfriendedViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.unfriendedViewController = nil;
        }
    }
    
}

-(void) showAddFriendsViewController:(BOOL) show{
    
    if(show){
        //free credits
        if(self.addFriendsViewController==nil){
            self.addFriendsViewController = [[FLFAddFriendsViewController alloc] initWithNibName:@"FLFAddFriendsViewController-iPad" bundle:nil];
            [self.addFriendsViewController dropShadow];
        }
        
        //ignore invalid requests
        if(self.addFriendsViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame = self.addFriendsViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.addFriendsViewController.view.frame = frame;
        [self addAsScrollableContent:self.addFriendsViewController initiallyHidden:YES];
    }else{
        if(self.blockedPeopleViewComtroller.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.blockedPeopleViewComtroller.parentScrollView removeFromSuperview];
                self.blockedPeopleViewComtroller = nil;
            }];
            [self.blockedPeopleViewComtroller.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.blockedPeopleViewComtroller = nil;
        }
    }
    
}

-(void) showBlockedPeopleViewController:(BOOL) show{
    
    if(show){
        //buy credits
        if(self.blockedPeopleViewComtroller==nil){
            self.blockedPeopleViewComtroller = [[FLBlockedPeopleViewController alloc] initWithNibName:@"FLBlockedPeopleViewController-iPad" bundle:nil];
            //[self.blockedPeopleViewComtroller dropShadow];
            [self.blockedPeopleViewComtroller dropShadow];
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Blocked People"];
        
        //ignore invalid requests
        if(self.blockedPeopleViewComtroller.parentScrollView.superview){
            return;
        }
        
        CGRect frame2 = self.blockedPeopleViewComtroller.view.frame;
        frame2.origin = MIDDLE_OVERLAY_ORIGIN;
        self.blockedPeopleViewComtroller.view.frame = frame2;
        [self addAsScrollableContent:self.blockedPeopleViewComtroller initiallyHidden:YES];
    }else{
        if(self.blockedPeopleViewComtroller.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.blockedPeopleViewComtroller.parentScrollView removeFromSuperview];
                self.blockedPeopleViewComtroller = nil;
            }];
            [self.blockedPeopleViewComtroller.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.blockedPeopleViewComtroller = nil;
        }
    }
    
}






#pragma mark - Chat

-(void) showChatRequestViewController:(BOOL) show{
    if(show){
        if(self.chatRequestViewController==nil){
            self.chatRequestViewController = [[FLChatRequestsViewController alloc] initWithNibName:@"FLChatRequestsViewController-iPad" bundle:nil];
            //            NSDictionary *dic=param;
            
            
            __block BaseViewController *baseViewController = self;
            [self.chatRequestViewController setCommunicator:^(NSDictionary *dict){
                NSDictionary *paramDic=@{@"ClickedIndex" : [dict objectForKey:@"ClickedIndex"]};
                NSString *command = [dict objectForKey:RemoteAction];
                if(command){
                    if([command isEqualToString:kRemoteActionShowChatScreen]){
                        [baseViewController showChatScreenViewController:YES param:paramDic];
                    }
                }
            }];
            
            
            [self.chatRequestViewController dropShadow];
        }
        //ignore invalid requests
        if(self.chatRequestViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Chat Requests"];
        
        CGRect frame = self.chatRequestViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.chatRequestViewController.view.frame = frame;
        [self addAsScrollableContent:self.chatRequestViewController initiallyHidden:YES];
    }else{
        
        if(self.chatRequestViewController.parentScrollView.superview){
            
            if(self.chatScreenViewController.parentScrollView.superview){
                [self showChatScreenViewController:NO param:nil];
            }
            
            [CATransaction setCompletionBlock:^{
                [self.chatRequestViewController.parentScrollView removeFromSuperview];
                self.chatRequestViewController = nil;
                
            }];
            [self.chatRequestViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.chatRequestViewController = nil;
        }
    }
    
}

-(void) showMyChatViewController:(BOOL) show;{
    if(show){
        if(self.myChatViewController==nil){
            self.myChatViewController = [[FLMyChatViewController alloc] initWithNibName:@"FLMyChatViewController-iPad" bundle:nil];
            [self.myChatViewController dropShadow];
            
            __block BaseViewController *baseViewController = self;
            
            [self.myChatViewController setCommunicator:^(NSDictionary *dict){
//                NSDictionary *paramDic=@{@"ClickedIndex" : [dict objectForKey:@"ClickedIndex"]};
                
                NSDictionary *paramDic=@{@"ClickedChatObject" : [dict objectForKey:@"ClickedChatObject"]};
                //detect chat type
                
                NSString *command = [dict objectForKey:RemoteAction];
                    if(command){
                        if([command isEqualToString:kRemoteActionShowChatScreen]){
                            [baseViewController showChatScreenViewController:YES param:paramDic];
                        }else if ([command isEqualToString:kRemoteActionShowChatGroupScreen]){
                            [baseViewController showGroupChatScreenViewController:YES param:paramDic];
                        }
                    }
                
            }];
            
        }
        //ignore invalid requests
        if(self.myChatViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"My Chat"];
        
        CGRect frame = self.myChatViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.myChatViewController.view.frame = frame;
        [self addAsScrollableContent:self.myChatViewController initiallyHidden:YES];
    }else{
        
        if(self.myChatViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.myChatViewController.parentScrollView removeFromSuperview];
                self.myChatViewController = nil;
                [self hideChatScreen];
            }];
            [self.myChatViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.myChatViewController = nil;
        }
    }
}

-(void) hideChatScreen{
    if(self.myChatViewController.parentScrollView.superview && self.chatRequestViewController.parentScrollView.superview){
        [self showChatScreenViewController:NO param:nil];
    }
}

-(void) showChatScreenViewController:(BOOL) show param:(id)param{
    
    if(show){
        //        if(self.chatScreenViewController==nil){
        self.chatScreenViewController = [[FLChatScreenViewController alloc] initWithNibName:@"FLChatScreenViewController-iPad" bundle:nil];
        NSDictionary *dic=param;
        self.chatScreenViewController.currentChatObj= [dic objectForKey:@"ClickedChatObject"];
        [self.chatScreenViewController dropShadow];
        //        }
        //ignore invalid requests
        if(self.chatScreenViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Friend's Name"];
        
        CGRect frame = self.chatScreenViewController.view.frame;
        frame.origin = RIGHT_OVERLAY_ORIGIN;
        self.chatScreenViewController.view.frame = frame;
        [self addAsScrollableContent:self.chatScreenViewController initiallyHidden:YES];
    }else{
        
        if(self.chatScreenViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.chatScreenViewController.parentScrollView removeFromSuperview];
                self.chatScreenViewController = nil;
            }];
            [self.chatScreenViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.chatScreenViewController = nil;
        }
    }
    
}

-(void) showGroupChatScreenViewController:(BOOL) show param:(id)param;{
    if(show){
        //        if(self.groupChatScreenViewController==nil){
        self.groupChatScreenViewController = [[FLGroupChatScreenViewController alloc] initWithNibName:@"FLGroupChatScreenViewController-iPad" bundle:nil];
        NSDictionary *dic=param;
        self.groupChatScreenViewController.currentChatObj= [dic objectForKey:@"ClickedChatObject"];
        [self.groupChatScreenViewController dropShadow];
        //        }
        //ignore invalid requests
        if(self.groupChatScreenViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Friend's Name"];
        
        CGRect frame = self.chatScreenViewController.view.frame;
        frame.origin = RIGHT_OVERLAY_ORIGIN;
        self.groupChatScreenViewController.view.frame = frame;
        [self addAsScrollableContent:self.groupChatScreenViewController initiallyHidden:YES];
        
    }else{
        
        if(self.groupChatScreenViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.groupChatScreenViewController.parentScrollView removeFromSuperview];
                self.groupChatScreenViewController = nil;
            }];
            [self.groupChatScreenViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.groupChatScreenViewController = nil;
        }
    }
}





#pragma mark - Profile Visitors

-(void) showProfileVisitorsViewController:(BOOL) show{
    
    if(show){
        if(self.profileVisitorsViewController==nil){
            self.profileVisitorsViewController = [[FLProfileVisitorsViewController alloc] initWithNibName:@"FLProfileVisitorsViewController-iPad" bundle:nil];
            [self.profileVisitorsViewController dropShadow];
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Profile Visitors"];
        
        //ignore invalid requests
        if(self.profileVisitorsViewController.parentScrollView.superview){
            return;
        }
        
        //set up communicator
        __block BaseViewController *baseViewController = self;
        [self.profileVisitorsViewController setCommunicator:^(NSDictionary *dict){
            
            NSLog(@"LOG: %@", dict);
            NSString *command = [dict objectForKey:RemoteAction];
            
            if(command){
                
                if([command isEqualToString:kRemoteActionShowProfile]){
                    [baseViewController showProfileViewCOntroller:YES param:(NSDictionary *)[dict objectForKey:@"ClickAction"]];
                    [baseViewController showMyProfileViewController:NO];
                    
                }
            }
            
            NSString *navigationTitle = [dict objectForKey:RemoteNavigationTitleUpdate];
            if(navigationTitle){
                [[baseViewController rightPanelViewController] setRightPanelTitle:navigationTitle];
            }
            
        }];
        
        
        CGRect frame = self.profileVisitorsViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.profileVisitorsViewController.view.frame = frame;
        [self addAsScrollableContent:self.profileVisitorsViewController initiallyHidden:YES];
    }else{
        
        if(self.profileVisitorsViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.profileVisitorsViewController.parentScrollView removeFromSuperview];
                self.profileVisitorsViewController = nil;
            }];
            [self.profileVisitorsViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.profileVisitorsViewController = nil;
        }
    }
    
}

-(void) showProfileVisitsViewController:(BOOL) show{
    
    if(show){
        if(self.profileVisitsViewController==nil){
            self.profileVisitsViewController = [[FLProfileVisitsViewController alloc] initWithNibName:@"FLProfileVisitsViewController-iPad" bundle:nil];
            [self.profileVisitsViewController dropShadow];
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Profile Visits"];
        
        //ignore invalid requests
        if(self.profileVisitsViewController.parentScrollView.superview){
            return;
        }
        
        //set up communicator
        __block BaseViewController *baseViewController = self;
        [self.profileVisitsViewController setCommunicator:^(NSDictionary *dict){
            
            NSLog(@"LOG: %@", dict);
            NSString *command = [dict objectForKey:RemoteAction];
            
            if(command){
                
                if([command isEqualToString:kRemoteActionShowProfile]){
                    [baseViewController showProfileViewCOntroller:YES param:(NSDictionary *)[dict objectForKey:@"ClickAction"]];
                    [baseViewController showMyProfileViewController:NO];
                    
                }
            }
            
            NSString *navigationTitle = [dict objectForKey:RemoteNavigationTitleUpdate];
            if(navigationTitle){
                [[baseViewController rightPanelViewController] setRightPanelTitle:navigationTitle];
            }
            
        }];
        
        CGRect frame = self.profileVisitsViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.profileVisitsViewController.view.frame = frame;
        [self addAsScrollableContent:self.profileVisitsViewController initiallyHidden:YES];
    }else{
        
        if(self.profileVisitsViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.profileVisitsViewController.parentScrollView removeFromSuperview];
                self.profileVisitsViewController = nil;
            }];
            [self.profileVisitsViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.profileVisitsViewController = nil;
        }
    }
    
}






#pragma mark - Credits

-(void) showFreeCreditsViewController:(BOOL) show{
    if(show){
        //free credits
        if(self.freeCreditsViewController==nil){
            self.freeCreditsViewController = [[FLFreeCreditsViewController alloc] initWithNibName:@"FLFreeCreditsViewController-iPad" bundle:nil];
            [self.freeCreditsViewController dropShadow];
        }
        
        //ignore invalid requests
        if(self.freeCreditsViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Earn Credits"];
        
        CGRect frame = self.freeCreditsViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.freeCreditsViewController.view.frame = frame;
        [self addAsScrollableContent:self.freeCreditsViewController initiallyHidden:YES];
        [self showBuyCreditsViewController:YES];
    }else{
        if(self.freeCreditsViewController.parentScrollView.superview){
            [self showBuyCreditsViewController:NO];
            [CATransaction setCompletionBlock:^{
                [self.freeCreditsViewController.parentScrollView removeFromSuperview];
                self.freeCreditsViewController = nil;
            }];
            [self.freeCreditsViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.freeCreditsViewController = nil;
        }
    }
    
}

-(void) showBuyCreditsViewController:(BOOL) show{
    
    if(show){
        //buy credits
        if(self.buyCreditsViewController==nil){
            self.buyCreditsViewController = [[FLBuyCreditsViewController alloc] initWithNibName:@"FLBuyCreditsViewController-iPad" bundle:nil];
            [self.buyCreditsViewController dropShadow];
        }
        
        //ignore invalid requests
        if(self.buyCreditsViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame2 = self.buyCreditsViewController.view.frame;
        frame2.origin = RIGHT_OVERLAY_ORIGIN;
        self.buyCreditsViewController.view.frame = frame2;
        [self addAsScrollableContent:self.buyCreditsViewController initiallyHidden:YES];
    }else{
        if(self.buyCreditsViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.buyCreditsViewController.parentScrollView removeFromSuperview];
                self.buyCreditsViewController = nil;
            }];
            [self.buyCreditsViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.buyCreditsViewController = nil;
        }
    }
    
}





#pragma mark - Gifts

-(void) showSendGiftsViewController:(BOOL) show{
    
    if(show){
        if(self.sendGiftsViewController==nil){
            self.sendGiftsViewController = [[FLSendGiftsViewController alloc] initWithNibName:@"FLSendGiftsViewController-iPad" bundle:nil];
            
            __block BaseViewController *baseViewController = self;
            [self.sendGiftsViewController setCommunicator:^(NSDictionary *dict){
                if([dict objectForKey:RemoteAction]){
                    NSString *action = [dict objectForKey:RemoteAction];
                    
                    //show drinks
                    if([action isEqualToString:kRemoteActionShowDrinkGifts]){
                        [baseViewController showGiftsViewControllerWithDrinks];
                        
                        //show kisses
                    }else if([action isEqualToString:kRemoteActionShowKissGifts]){
                        [baseViewController showGiftsViewControllerWithKisses];
                        
                    }
                }
            }];
            
            [self.sendGiftsViewController dropShadow];
        }
        
        //ignore invalid requests
        if(self.sendGiftsViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Send Gifts"];
        
        CGRect frame = self.sendGiftsViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.sendGiftsViewController.view.frame = frame;
        [self addAsScrollableContent:self.sendGiftsViewController initiallyHidden:YES];
        
    }else{
        if(self.sendGiftsViewController.parentScrollView.superview){
            [self hideGiftsViewController];
            [CATransaction setCompletionBlock:^{
                [self.sendGiftsViewController.parentScrollView removeFromSuperview];
                self.sendGiftsViewController = nil;
            }];
            [self.sendGiftsViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.sendGiftsViewController = nil;
        }
    }
    
}

-(void) showGiftsViewControllerWithKisses{
    if(self.showGiftsViewController==nil){
        
        self.showGiftsViewController = [[FLShowGiftsViewController alloc] initWithNibName:@"FLShowGiftsViewController-iPad" bundle:nil giftTableType:kGiftTableTypeKiss];
        
        [self.showGiftsViewController dropShadow];
        
    }else{
        [self.showGiftsViewController setGiftType:kGiftTableTypeKiss];
    }
    [self.rightPanelViewController setRightPanelTitle:@" "];
    
    //ignore invalid requests
    if(self.showGiftsViewController.parentScrollView.superview){
        return;
    }
    
    CGRect frame2 = self.showGiftsViewController.view.frame;
    frame2.origin = RIGHT_OVERLAY_ORIGIN;
    self.showGiftsViewController.view.frame = frame2;
    [self addAsScrollableContent:self.showGiftsViewController initiallyHidden:YES];
}

-(void) showGiftsViewControllerWithDrinks{
    
    if(self.showGiftsViewController==nil){
        
        self.showGiftsViewController = [[FLShowGiftsViewController alloc] initWithNibName:@"FLShowGiftsViewController-iPad" bundle:nil giftTableType:kGiftTableTypeDrink];
        
        [self.showGiftsViewController dropShadow];
        
    }else{
        [self.showGiftsViewController setGiftType:kGiftTableTypeDrink];
    }
    
    [self.rightPanelViewController setRightPanelTitle:@" "];
    
    //ignore invalid requests
    if(self.showGiftsViewController.parentScrollView.superview){
        return;
    }
    
    CGRect frame2 = self.showGiftsViewController.view.frame;
    frame2.origin = RIGHT_OVERLAY_ORIGIN;
    self.showGiftsViewController.view.frame = frame2;
    [self addAsScrollableContent:self.showGiftsViewController initiallyHidden:YES];
}

-(void) hideGiftsViewController{
    if(self.showGiftsViewController.parentScrollView.superview){
        [CATransaction setCompletionBlock:^{
            [self.showGiftsViewController.parentScrollView removeFromSuperview];
            self.showGiftsViewController = nil;
        }];
        [self.showGiftsViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
    }else{
        self.showGiftsViewController = nil;
    }
}







//find people
#pragma mark - Find People

-(void) showFindPeopleViewController:(BOOL) show{
    
    if(show){
        if(self.findPeopleViewController==nil){
            self.findPeopleViewController = [[FLFindPeopleViewController alloc] initWithNibName:@"FLFindPeopleViewController-iPad" bundle:nil];
            [self.findPeopleViewController dropShadow];
            
            __block BaseViewController *baseViewController = self;
            [self.findPeopleViewController setCommunicator:^(NSDictionary *dict){
                NSString *command = [dict objectForKey:RemoteAction];
                NSLog(@"dict: %@", dict);
                if(command){
                    if([command isEqualToString:kRemoteActionShowEyeCatcher]){
                        [baseViewController showEyeCatcherViewController:YES];
                        [baseViewController showFindPeopleViewController:NO];
                    }
                }
                
                if(command){
                    if([command isEqualToString:kRemoteActionShowProfile]){
                        
                        [baseViewController showProfileViewCOntroller:YES param:(NSDictionary *)[dict objectForKey:@"ClickAction"]];
                        
                    }
                }
                
                NSString *navigationTitle = [dict objectForKey:RemoteNavigationTitleUpdate];
                if(navigationTitle){
                    [[baseViewController rightPanelViewController] setRightPanelTitle:navigationTitle];
                }
                
                
            }];
            
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Near By"];
        
        //ignore invalid requests
        if(self.findPeopleViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame = self.findPeopleViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.findPeopleViewController.view.frame = frame;
        [self addAsScrollableContent:self.findPeopleViewController initiallyHidden:YES];
    }else{
        
        if(self.findPeopleViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.findPeopleViewController.parentScrollView removeFromSuperview];
                self.findPeopleViewController = nil;
            }];
            [self.findPeopleViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.findPeopleViewController = nil;
        }
    }
    
}

-(void) showEyeCatcherViewController:(BOOL) show{
    
    if(show){
        if(self.eyeCatcherViewCobtroller==nil){
            self.eyeCatcherViewCobtroller = [[FLEyeCatcherViewController alloc] initWithNibName:@"FLEyeCatcherViewController-iPad" bundle:nil];
            [self.eyeCatcherViewCobtroller dropShadow];
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Eye Catcher"];
        
        //ignore invalid requests
        if(self.eyeCatcherViewCobtroller.parentScrollView.superview){
            return;
        }
        
        CGRect frame = self.eyeCatcherViewCobtroller.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.eyeCatcherViewCobtroller.view.frame = frame;
        [self addAsScrollableContent:self.eyeCatcherViewCobtroller initiallyHidden:YES];
    }else{
        if(self.eyeCatcherViewCobtroller.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.eyeCatcherViewCobtroller.parentScrollView removeFromSuperview];
                self.eyeCatcherViewCobtroller = nil;
            }];
            [self.eyeCatcherViewCobtroller.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.eyeCatcherViewCobtroller = nil;
        }
    }
    
}

-(void) showAdvancedSearchViewController:(BOOL) show{
    
    if(show){
        if(self.advancedSearchViewController==nil){
            self.advancedSearchViewController = [[FLAdvancedSearchViewController alloc] initWithNibName:@"FLAdvancedSearchViewController-iPad" bundle:nil];
            [self.advancedSearchViewController dropShadow];
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Advanced Search"];
        
        //ignore invalid requests
        if(self.advancedSearchViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame = self.advancedSearchViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.advancedSearchViewController.view.frame = frame;
        [self addAsScrollableContent:self.advancedSearchViewController initiallyHidden:YES];
    }else{
        
        if(self.advancedSearchViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.advancedSearchViewController.parentScrollView removeFromSuperview];
                self.advancedSearchViewController = nil;
            }];
            [self.advancedSearchViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.advancedSearchViewController = nil;
        }
    }
}

/*
 
 NSDictionary *actionDic=@{@"Profile":OTHER_PROFILE,@"ProfileObject":profileObj};
 NSDictionary *dict = @{RemoteAction:kRemoteActionShowProfile,@"ClickAction":actionDic};
 
 */




#pragma mark - My Profile

-(void) showMyProfileViewController:(BOOL) show{
    
    if(show){
        if(self.overiVwViewController==nil){
            self.overiVwViewController = [[FLMFOverviewViewController alloc] initWithNibName:@"FLMFOverviewViewController-iPad" bundle:nil];
            [self.overiVwViewController dropShadow];
            
            //define object specific communicator methods
            
            [self.rightPanelViewController setRightPanelTitle:@" "];
            
            __block BaseViewController *baseViewController = self;
            
            [self.overiVwViewController setCommunicator:^(NSDictionary *dict){
                
                NSLog(@"LOG: %@", dict);
                NSString *command = [dict objectForKey:RemoteAction];
                
                if(command){
                    if([command isEqualToString:kRemoteActionMyProfileDetails]){
                        [baseViewController showMyProfileDetailViewController:YES param:(NSDictionary *)[dict objectForKey:@"ClickAction"]];
                    }else if ([command isEqualToString:kRemoteActionMyProfilePhotoGallery]){
                        NSDictionary *actionDic = [dict objectForKey:@"info"];
                        [baseViewController showMyProfilePhotoGalleryViewController:YES param:actionDic];
                    }else if([command isEqualToString:kRemoteActionShowProfileVisitors]){
                        [baseViewController showProfileVisitorsViewController:YES];
                        [baseViewController showMyProfileViewController:NO];
                    }else if([command isEqualToString:kRemoteActionShowProfile]){
                        [baseViewController showProfileViewCOntroller:YES param:(NSDictionary *)[dict objectForKey:@"ClickAction"]];
                        [baseViewController showMyProfileViewController:NO];
                    }
                }
                
                NSString *navigationTitle = [dict objectForKey:RemoteNavigationTitleUpdate];
                if(navigationTitle){
                    [[baseViewController rightPanelViewController] setRightPanelTitle:navigationTitle];
                }
                
            }];
            
        }
        
        //ignore invalid requests
        if(self.overiVwViewController.parentScrollView.superview){
            return;
        }
        
//        [self.rightPanelViewController setRightPanelTitle:@"Received Gifts"];
        
        CGRect frame = self.overiVwViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.overiVwViewController.view.frame = frame;
        [self addAsScrollableContent:self.overiVwViewController initiallyHidden:YES];
    }
    else{
        
        if(self.overiVwViewController!=nil){
            
            if(self.overiVwViewController.parentScrollView.superview){
                
                [self showMyProfileDetailViewController:NO param:nil];
                [self showMyProfilePhotoGalleryViewController:NO param:nil];
                [CATransaction setCompletionBlock:^{
                    [self.overiVwViewController.parentScrollView removeFromSuperview];
                    self.overiVwViewController = nil;
                }];
                [self.overiVwViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
            }
            else{
                self.overiVwViewController = nil;
            }
        }
    }
}

-(void) showMyProfileDetailViewController:(BOOL) show param:(id) param{
    if(show){
        if(self.mfDetailViewController==nil){
            
            
            NSDictionary *dic=param;
            // do your stuff here
            
            id profile = [dic objectForKey:@"Profile"];
            id profileObject = [dic objectForKey:@"ProfileObject"];
            
            self.mfDetailViewController = [[FLMFDetailsViewController alloc] initWithNibName:@"FLMFDetailsViewController-iPad" bundle:nil profile:profile withProfileObj:profileObject];
            
            [self.mfDetailViewController dropShadow];
        }
        
        //        [self.rightPanelViewController setRightPanelTitle:@"MyFans"];
        
        [self showMyProfilePhotoGalleryViewController:NO param:nil];
        
        //ignore invalid requests
        if(self.mfDetailViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame2 = self.mfDetailViewController.view.frame;
        frame2.origin = RIGHT_OVERLAY_ORIGIN;
        self.mfDetailViewController.view.frame = frame2;
        [self addAsScrollableContent:self.mfDetailViewController initiallyHidden:YES];
    }else{
        
        if(self.mfDetailViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.mfDetailViewController.parentScrollView removeFromSuperview];
                self.mfDetailViewController = nil;
            }];
            [self.mfDetailViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.mfDetailViewController = nil;
        }
        
    }
}

-(void) showMyProfilePhotoGalleryViewController:(BOOL) show  param:(id) param;{
    if(show){
        
        //                        NSDictionary *actionDic=@{@"Profile":MY_PROFILE,@"ProfileObject":[NSNull null]};
        
        NSString *profile = @"";
        FLOtherProfile *profileObject = nil;
        
        if(param){
            NSDictionary *actionDesc = (NSDictionary *)param;
            profile = [actionDesc objectForKey:@"Profile"];
            
            if(![[NSNull null] isEqual:[actionDesc objectForKey:@"ProfileObject"]]){ //if not null
                profileObject = (FLOtherProfile *)[actionDesc objectForKey:@"ProfileObject"];
            }
        }
        
        if(self.mfPhotoGalleryVeiwController==nil){
            self.mfPhotoGalleryVeiwController = [[FLMFPhotoGalleryViewController alloc] initWithNibName:@"FLMFPhotoGalleryViewController-iPad" bundle:nil profile:profile withProfileObj:profileObject];
            [self.mfPhotoGalleryVeiwController dropShadow];
        }
        
        __block BaseViewController *context = self;
        
        [self.mfPhotoGalleryVeiwController setCommunicator:^(NSDictionary *dict){
            
            NSLog(@"LOG: %@", dict);
            NSString *command = [dict objectForKey:RemoteAction];
            NSString *info = [dict objectForKey:@"info"];
            if(command && info){
                if([command isEqualToString:kRemoteActionShowPhotoViewController]){
                    [context showPhotosViewController:YES param:info];
                }
            }
            
        }];
        
        //        [self.rightPanelViewController setRightPanelTitle:@"MyFans"];
        
        [self showMyProfileDetailViewController:NO param:nil];
        
        //ignore invalid requests
        if(self.mfPhotoGalleryVeiwController.parentScrollView.superview){
            return;
        }
        
        CGRect frame2 = self.mfPhotoGalleryVeiwController.view.frame;
        frame2.origin = RIGHT_OVERLAY_ORIGIN;
        self.mfPhotoGalleryVeiwController.view.frame = frame2;
        [self addAsScrollableContent:self.mfPhotoGalleryVeiwController initiallyHidden:YES];
    }else{
        
        if(self.mfPhotoGalleryVeiwController.parentScrollView.superview){
            
            //if photos view controller are visible, remove it
            [self showPhotosViewController:NO param:nil];
            
            [CATransaction setCompletionBlock:^{
                [self.mfPhotoGalleryVeiwController.parentScrollView removeFromSuperview];
                self.mfPhotoGalleryVeiwController = nil;
            }];
            [self.mfPhotoGalleryVeiwController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.mfPhotoGalleryVeiwController = nil;
        }
        
    }
}





-(void)showPhotosViewController:(BOOL)show param:(id)param{
    if(show){
        
        
        NSLog(@"param:%@",param);
        NSDictionary *moreInfo = (NSDictionary *) param;
        
        
//         NSDictionary *moreInfo = @{@"profileObj":(profileObject)?profileObject:[NSNull null], @"albumObj":(album)?album:[NSNull null], @"profile": self.profile};
        
   
        
        if(self.photosViewController==nil){
            self.photosViewController = [[FLMFPhotosViewController alloc] initWithNibName:@"FLMFPhotosViewController-iPad" bundle:nil profile:[moreInfo objectForKey:@"profile"]];
//            [self.photosViewController dropShadow];
        }
        
        if(![[moreInfo objectForKey:@"profileObj"] isEqual:[NSNull null]]){
            self.photosViewController.profileObj = (FLOtherProfile *) [moreInfo objectForKey:@"profileObj"];
        }
        
        if(![[moreInfo objectForKey:@"albumObj"] isEqual:[NSNull null]]){
            self.photosViewController.albumObj = (FLAlbum *) [moreInfo objectForKey:@"albumObj"];
        }
        [self.photosViewController dropShadow];
        
        //        [self.rightPanelViewController setRightPanelTitle:@"MyFans"];
        
//        [self showMyProfileDetailViewController:NO param:nil];
        
        //ignore invalid requests
        if(self.photosViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame2 = self.photosViewController.view.frame;
        frame2.origin = RIGHT_OVERLAY_ORIGIN;
        self.photosViewController.view.frame = frame2;
        [self addAsScrollableContent:self.photosViewController initiallyHidden:YES];
    }else{
        
        if(self.photosViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.photosViewController.parentScrollView removeFromSuperview];
                self.photosViewController = nil;
            }];
            [self.photosViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.photosViewController = nil;
        }
        
    }
}





#pragma mark - Favourites

-(void) showFavouritesViewController:(BOOL) show{
    
    if(show){
        if(self.favouritesViewController==nil){
            self.favouritesViewController = [[FLFavouritsViewController alloc] initWithNibName:@"FLFavouritsViewController-iPad" bundle:nil];
            [self.favouritesViewController dropShadow];
            
            __block BaseViewController *baseViewController = self;
            [self.favouritesViewController setCommunicator:^(NSDictionary *dict){
                NSString *command = [dict objectForKey:RemoteAction];
                if([command isEqualToString:kRemoteActionShowMyFans]){
                    [baseViewController showMyFansViewController:YES];
                }
            }];
            
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Favourites"];
        
        //ignore invalid requests
        if(self.favouritesViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame = self.favouritesViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.favouritesViewController.view.frame = frame;
        [self addAsScrollableContent:self.favouritesViewController initiallyHidden:YES];
        //        [self showMyFansViewController:YES];
    }else{
        
        if(self.favouritesViewController.parentScrollView.superview){
            [self showMyFansViewController:NO];
            [CATransaction setCompletionBlock:^{
                [self.favouritesViewController.parentScrollView removeFromSuperview];
                self.favouritesViewController = nil;
            }];
            [self.favouritesViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.favouritesViewController = nil;
        }
    }
    
}

-(void) showMyFansViewController:(BOOL) show{
    
    if(show){
        if(self.myFansViewController==nil){
            self.myFansViewController = [[FLMyFansViewController alloc] initWithNibName:@"FLMyFansViewController-iPad" bundle:nil];
            [self.myFansViewController dropShadow];
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"MyFans"];
        
        //ignore invalid requests
        if(self.myFansViewController.parentScrollView.superview){
            return;
        }
        
        CGRect frame2 = self.myFansViewController.view.frame;
        frame2.origin = RIGHT_OVERLAY_ORIGIN;
        self.myFansViewController.view.frame = frame2;
        [self addAsScrollableContent:self.myFansViewController initiallyHidden:YES];
    }else{
        
        if(self.myFansViewController.parentScrollView.superview){
            [CATransaction setCompletionBlock:^{
                [self.myFansViewController.parentScrollView removeFromSuperview];
                self.myFansViewController = nil;
            }];
            [self.myFansViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
        }else{
            self.myFansViewController = nil;
        }
        
    }
    
}

-(void) showMyGiftsViewController:(BOOL) show{
    if(show){
        if(self.myGiftsViewController==nil){
            self.myGiftsViewController = [[FLMyGiftsViewController alloc] initWithNibName:@"FLMyGiftsViewController-iPad" bundle:nil];
            [self.myGiftsViewController dropShadow];
        }
        
        //ignore invalid requests
        if(self.myGiftsViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Received Gifts"];
        
        CGRect frame = self.myGiftsViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.myGiftsViewController.view.frame = frame;
        [self addAsScrollableContent:self.myGiftsViewController initiallyHidden:YES];
    }else{
        if(self.myGiftsViewController!=nil){
            if(self.myGiftsViewController.parentScrollView.superview){
                [CATransaction setCompletionBlock:^{
                    [self.myGiftsViewController.parentScrollView removeFromSuperview];
                    self.myGiftsViewController = nil;
                }];
                [self.myGiftsViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"diappear"];
            }else{
                self.myGiftsViewController = nil;
            }
        }
    }
}







#pragma mark - Matches

-(void) showDoYouLikeViewController:(BOOL)show{
    if(show){
        if(self.doYouLikeViewController==nil){
            self.doYouLikeViewController = [[FLDoYouLikeViewController alloc] initWithNibName:@"FLDoYouLikeViewController-iPad" bundle:nil];
            [self.doYouLikeViewController dropShadow];
            
            __block BaseViewController *baseViewController = self;
            
            //add internal communacation
            [self.doYouLikeViewController setCommunicator:^(NSDictionary *dict){
                
                NSLog(@"%@", dict);
                
                NSString *command = [dict objectForKey:RemoteAction];
                if(command){
                    if([command isEqualToString:kRemoteActionShowProfile]){
                        [baseViewController showProfileViewCOntroller:YES param:(NSDictionary *)[dict objectForKey:@"ClickAction"]];
                        [baseViewController showDoYouLikeViewController:NO];
                    }
                }
                
            }];
            
        }
        [self.rightPanelViewController.view addSubview:self.doYouLikeViewController.view];
        [self.rightPanelViewController setRightPanelTitle:@"Find Me"];
    }else{
        
        if(self.doYouLikeViewController.view.superview){
            [self.doYouLikeViewController.view removeFromSuperview];
            self.doYouLikeViewController = nil;
        }else{
            self.doYouLikeViewController = nil;
        }
    }
    
}

/*
 
 __block BaseViewController *baseViewController = self;
 
 [self.myChatViewController setCommunicator:^(NSDictionary *dict){
 NSString *command = [dict objectForKey:RemoteAction];
 if(command){
 if([command isEqualToString:kRemoteActionShowChatScreen]){
 [baseViewController showChatScreenViewController:YES];
 }
 }
 }];
 
 */

-(void) showProfileViewCOntroller:(BOOL) show param:(id) param{
    if(show){
        if(self.profileViewController==nil){
            
            id profile = [param objectForKey:@"Profile"];
            id profileObject = [param objectForKey:@"ProfileObject"];
            
            self.profileViewController = [[FLProfileViewController alloc] initWithNibName:@"FLProfileViewController-iPad" bundle:nil profile:profile withProfileObj:profileObject];
            [self.profileViewController dropShadow];
            
            //define object specific communicator methods
            
            [self.rightPanelViewController setRightPanelTitle:@" "];
            
            __block BaseViewController *baseViewController = self;
            
            [self.profileViewController setCommunicator:^(NSDictionary *dict){
                
                NSLog(@"DICT: %@", dict);
                
                NSString *command = [dict objectForKey:RemoteAction];
                if(command){
                    if([command isEqualToString:kRemoteActionMyProfileDetails]){
                        [baseViewController showMyProfileDetailViewController:YES param:(NSDictionary *)[dict objectForKey:@"ClickAction"]];
                    }else if ([command isEqualToString:kRemoteActionMyProfilePhotoGallery]){
                        NSDictionary *actionDic = [dict objectForKey:@"info"];
                        [baseViewController showMyProfilePhotoGalleryViewController:YES param:actionDic];
                    }else if([command isEqualToString:kRemoteActionShowChatScreen]){
                        [baseViewController showChatScreenViewController:YES param:@{@"ClickedChatObject":[dict objectForKey:@"ClickedChatObject"]}];
                    }else if([command isEqualToString:kRemoteActionShowChatGroupScreen]){
                        [baseViewController showGroupChatScreenViewController:YES param:@{@"ClickedChatObject":[dict objectForKey:@"ClickedChatObject"]}];
                    }
                }
                
                NSString *navigationTitle = [dict objectForKey:RemoteNavigationTitleUpdate];
                if(navigationTitle){
                    [[baseViewController rightPanelViewController] setRightPanelTitle:navigationTitle];
                }
                
            }];
        }
        
        //ignore invalid requests
        if(self.profileViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Profile"];
        
        CGRect frame = self.profileViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.profileViewController.view.frame = frame;
        [self addAsScrollableContent:self.profileViewController initiallyHidden:YES];
    }else{
        if(self.profileViewController!=nil){
            if(self.profileViewController.parentScrollView.superview){
                [self showMyProfileDetailViewController:NO param:nil];
                [self showMyProfilePhotoGalleryViewController:NO param:nil];
                [self hideChatScreen];
                [CATransaction setCompletionBlock:^{
                    [self.profileViewController.parentScrollView removeFromSuperview];
                    self.profileViewController = nil;
                }];
                [self.profileViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"dis"];
            }else{
                self.profileViewController = nil;
            }
        }
    }
}



-(void) showMatchesViewController:(BOOL) show;{
    if(show){
        if(self.matcheViewController==nil){
            self.matcheViewController = [[FLMatchesViewController alloc] initWithNibName:@"FLMatchesViewController-iPad" bundle:nil];
            [self.matcheViewController dropShadow];
        }
        
        //ignore invalid requests
        if(self.matcheViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Matches"];
        
        CGRect frame = self.matcheViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.matcheViewController.view.frame = frame;
        [self addAsScrollableContent:self.matcheViewController initiallyHidden:YES];
    }else{
        if(self.matcheViewController!=nil){
            if(self.matcheViewController.parentScrollView.superview){
                [CATransaction setCompletionBlock:^{
                    [self.matcheViewController.parentScrollView removeFromSuperview];
                    self.matcheViewController = nil;
                }];
                [self.matcheViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"dis"];
            }else{
                self.matcheViewController = nil;
            }
        }
    }
}

-(void) showLikeYouViewController:(BOOL) show;{
    if(show){
        if(self.likeYouViewController==nil){
            self.likeYouViewController = [[FLLikeYouViewController alloc] initWithNibName:@"FLLikeYouViewController-iPad" bundle:nil];
            [self.likeYouViewController dropShadow];
        }
        
        //ignore invalid requests
        if(self.likeYouViewController.parentScrollView.superview){
            return;
        }
        
        [self.rightPanelViewController setRightPanelTitle:@"Like You"];
        
        CGRect frame = self.likeYouViewController.view.frame;
        frame.origin = MIDDLE_OVERLAY_ORIGIN;
        self.likeYouViewController.view.frame = frame;
        [self addAsScrollableContent:self.likeYouViewController initiallyHidden:YES];
    }else{
        if(self.likeYouViewController!=nil){
            if(self.likeYouViewController.parentScrollView.superview){
                [CATransaction setCompletionBlock:^{
                    [self.likeYouViewController.parentScrollView removeFromSuperview];
                    self.likeYouViewController = nil;
                }];
                [self.likeYouViewController.parentScrollView.layer addAnimation:[FLUtil disappearAnimation] forKey:@"dis"];
            }else{
                self.likeYouViewController = nil;
            }
        }
    }
}





-(void) showRadarViewController:(BOOL) show;{
    self.radarViewController = [[FLRadarViewController alloc] initWithNibName:@"FLRadarViewController-iPad" bundle:nil];
    [self.rightPanelViewController.view addSubview:self.radarViewController.view];
    [self.rightPanelViewController setRightPanelTitle:@"Choose a Location"];
}





-(void) showSettingsViewController:(BOOL) show;{
    if(show){
        if(self.settingsViewController==nil){
            self.settingsViewController = [[UINavigationController alloc] initWithRootViewController:[[FLSettingsViewController alloc] initWithNibName:@"FLSettingsViewController-iPad" bundle:nil]];
        }
        
        __block BaseViewController *baseViewController = self;
        
        
        
        [[[self.settingsViewController viewControllers] objectAtIndex:0] setCommunicator:^(NSDictionary *dict){
            NSString *command = [dict objectForKey:RemoteAction];
            NSLog(@"-%@-", command);
            if(command){
                if([command isEqualToString:kShowRightBackButton]){
                    [baseViewController showRightPanelBackButton];
                }else if([command isEqualToString:kHideRightBackButton]){
                    [baseViewController hideRightPanelBackButton];
                }
            }
        }];
        
        self.settingsViewController.view.frame = LEFT_OVERLAY_FRAME;
//        self.settingsViewController.view.frame = frame;
        [self.rightPanelViewController.view addSubview:self.settingsViewController.view];
    }else{
        [self hideRightPanelBackButton];
        [self.settingsViewController.view removeFromSuperview];
        self.settingsViewController = nil;
    }
}





#pragma mark - Sign Out

-(void) signOutActionRequestReceived{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sign_out", nil) message:NSLocalizedString(@"log_off", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex !=0)
    {
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        // Set the hud to display with a color
        //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        HUD.delegate = self;
        HUD.labelText = @"Sign Out...";
        HUD.square = YES;
        [HUD show:YES];
        FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
        [webSeviceApi signOutUser:self];
    }
    
    
}







#pragma mark - Show/Hide navigation

-(void) hideRightPanelBackButton{
    [self.rightPanelViewController hideBackButton];
}

-(void) showRightPanelBackButton{
    [self.rightPanelViewController showBackbutton];
}











#pragma mark- FLWebServiceDelegate methods
#pragma mark-

-(void)signOutUserResult:(NSString *)message{
    NSLog(@"signOutUserResult");
    [FLUtilUserDefault removeAllUserData];
    FLAppDelegate *appDelegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopHeartBeatCall];
    [appDelegate chatUnsuscribe];
    [HUD hide:YES];
    
    
    [appDelegate showSignUpView];
    
}











#pragma mark- FLWebServiceDelegate Fail
#pragma mark-

-(void)unknownFailureCall{
    [HUD hide:YES];
    [self showValidationAlert:@"Unknown Error"];
}

-(void)requestFailCall:(NSString *)errorMsg{
    [HUD hide:YES];
    [self showValidationAlert:errorMsg];
}

-(void)showValidationAlert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}












@end
