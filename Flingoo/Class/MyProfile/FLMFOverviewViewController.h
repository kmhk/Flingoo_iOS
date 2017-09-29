//
//  FLMFOverviewViewController.h
//  Flingoo
//
//  Created by Hemal on 11/15/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHSlideController.h"
#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLMFOverviewViewController : FLParentSliderViewController<CHSlideControllerDelegate,FLWebServiceDelegate,MBProgressHUDDelegate>
{

//    IBOutlet UIImageView *imgProfilePic;
    IBOutlet UILabel *lblStatus;
    IBOutlet UIView *viewVisitos;
    BOOL isShowingKeyBord;
    IBOutlet UITextField *txtStatusUpdate;
    IBOutlet UIButton *btnRecievedGift;
    IBOutlet UIButton *btnMyFans;
    IBOutlet UIButton *btnBecomeVIP;
    IBOutlet UIButton *btnAddStatus;
    BOOL isViewVisitorsVisible;
    IBOutlet UIButton *btnNoOfVisitors;
    
    IBOutlet UIScrollView *scrollVwVisitors;
    IBOutlet UIButton *btnPhotoGallery;
    IBOutlet UIButton *btnDetail;
    IBOutlet UIImageView *imgProfilePic;
   
    IBOutlet UILabel *lblGenderAge_iPad;
    IBOutlet UILabel *lblFullName_iPad;
    MBProgressHUD *HUD;
}
- (IBAction)reciGifClicked:(id)sender;
- (IBAction)myFansClicked:(id)sender;
- (IBAction)becomeVIPClicked:(id)sender;
- (IBAction)statusChangeClicked:(id)sender;
- (IBAction)visitorsClicked:(id)sender;

@property(weak, nonatomic) IBOutlet UIView *profilePictureViewContainer;

@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;
- (IBAction)photoGalleryClicked:(id)sender;
- (IBAction)detailClicked:(id)sender;

@end
