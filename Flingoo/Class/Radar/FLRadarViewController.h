//
//  FLRadarViewController.h
//  Flingoo
//
//  Created by Prasad De Zoysa on 11/26/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UISliderGestureRecongnizer.h"
#import "FLUtil.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "FLFriendView.h"
#import "AHDescriptionViewController.h"
#import "FLGroup.h"
#import "FLWebServiceApi.h"
#import "FLWebServiceDelegate.h"
#import "MBProgressHUD.h"
#import "FLProfilePicView.h"
#import "FLMapViewController.h"
#import "FLButtonWithRadarItem.h"
#import "FLProfileUserView.h"
#import "CLImageEditor.h"
#import "SSIndicatorLabel.h"
#import "FLWebServiceBlocks.h"


@class FLRadar;

@interface FLRadarViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate,CLLocationManagerDelegate, /*FriendButtonDelegate, */FLWebServiceDelegate, UIActionSheetDelegate, FLLocationSelectDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate>{
    
    //Group points
//    NSMutableArray *friendsArray;
    BOOL inDrag;
    UIView *objectToDrag;
    CGPoint _originalPosition;
    CGPoint _originalOutsidePosition;
    MBProgressHUD *HUD;
    
    //Date picker
    UIDatePicker *theDatePicker;
    NSDate *selectedDatePickerDate;
    UIActionSheet *actionSheet;
    UIPopoverController *popOver;
    UIView *popoverView;
    
    CLLocation *currentLocation;
    
    //Panaroma
    CMMotionManager *motionManager;
    float xValue;
}

@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (strong, nonatomic) UIPanGestureRecognizer *panGroup;
@property (strong, nonatomic) IBOutlet UIScrollView *scrRadar;
@property (strong, nonatomic) IBOutlet UIView *viewRadarBase;
@property (strong, nonatomic) IBOutlet UIView *viewRadarFront;
@property (strong, nonatomic) IBOutlet UIView *viewRadarBack;
@property (strong, nonatomic) IBOutlet UIView *viewGroupAddFriends;
@property (strong, nonatomic) IBOutlet UIImageView *imgBeamFront;
@property (strong, nonatomic) IBOutlet UIImageView *imgBeamBack;
@property (strong, nonatomic) IBOutlet UIView *viewFrontRadarSet;
@property (strong, nonatomic) IBOutlet UIView *viewBackRadarSet;
@property (strong, nonatomic) IBOutlet UIButton *btnUserProfilePic;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserProfileRadar;
@property (strong, nonatomic) IBOutlet UISlider *sldDistanceFilter;
@property (strong, nonatomic) IBOutlet UIButton *btnGroupPoint;
@property (strong, nonatomic) IBOutlet UIButton *btnHomePoint;
@property (strong, nonatomic) IBOutlet UIButton *btnMeetPoint;
@property (strong, nonatomic) IBOutlet UIButton *btnTaxiPoint;
@property (strong, nonatomic) IBOutlet UISliderGestureRecongnizer *sldGesture;
@property (strong, nonatomic) IBOutlet SSIndicatorLabel *viewRadarLoadingMessage;

@property (strong, nonatomic) IBOutlet UIView *viewControlPanel;
@property (strong, nonatomic) IBOutlet UIImageView *imgRedLayer;
@property (strong, nonatomic) IBOutlet UIImageView *imgSlidingRedLayer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrPanaroma;


//Groups

//@property (strong, nonatomic) IBOutlet UIView *viewGroupAddFriends;
@property (assign) BOOL isGroupCreating;
@property (assign) BOOL isGroupUpdating;
@property (assign) BOOL isMeetingCreating;
@property (assign) BOOL isMeetingUpdating;
@property (strong, nonatomic) IBOutlet UIScrollView *scrFriends;
@property (strong, nonatomic) IBOutlet UIImageView *imgDragToNote;
@property (strong, nonatomic) IBOutlet UIView *viewGroupComposer;
@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (strong, nonatomic) NSMutableArray *friendItemsArray;
@property (strong, nonatomic) NSMutableArray *selectedGroupFriends;
@property (strong, nonatomic) NSMutableArray *selectedGroupDelButton;
@property (assign, nonatomic) BOOL inDragView;
@property (strong, nonatomic) IBOutlet UITextField *txtGroupName;
@property (strong, nonatomic) IBOutlet UITextField *txtGroupDesc;
@property (strong, nonatomic) IBOutlet FLProfilePicView *imgGroupOwnerProfilePic;
@property (strong, nonatomic) IBOutlet UIScrollView *scrGroupMembers;
@property (strong, nonatomic) IBOutlet UIScrollView *scrViewGroupMembers;
@property (strong, nonatomic) IBOutlet UIImageView *imgGroupPicture;
@property (strong, nonatomic) FLGroup *selectedGroup;


//View
@property (strong, nonatomic) IBOutlet UIView *viewGroupPreview;
@property (strong, nonatomic) IBOutlet UIImageView *imgGroupPic;
@property (strong, nonatomic) IBOutlet UILabel *lblGroupName;
@property (strong, nonatomic) IBOutlet UITextView *txtVGroupDesc;
@property (strong, nonatomic) IBOutlet FLProfilePicView *imgOwnerPic;


//End groups


//Meet point
@property (strong, nonatomic) NSMutableArray *selectedMeetingFriends;
@property (strong, nonatomic) NSMutableArray *selectedMeetingDelButton;

@property (strong, nonatomic) IBOutlet UIView *viewMeetingComposer;
@property (strong, nonatomic) IBOutlet FLProfilePicView *imgMeetingOwnerProfilePic;
@property (strong, nonatomic) IBOutlet UIScrollView *scrMeetingMembers;
@property (strong, nonatomic) IBOutlet UITextField *txtMeetingName;
@property (strong, nonatomic) IBOutlet UITextField *txtMeetingDesc;
@property (strong, nonatomic) NSDate *selectedMeetingDate;
@property (strong, nonatomic) FLMapViewController *map;
@property (strong, nonatomic) CLLocation *selectedLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnEditGroup;

//View
@property (strong, nonatomic) IBOutlet UIView *ViewMeetingPreview;
@property (strong, nonatomic) IBOutlet UILabel *lblMeetingName;
@property (strong, nonatomic) IBOutlet UITextView *txtVMeetingDesc;
@property (strong, nonatomic) IBOutlet UIImageView *imgMeetingPic;
@property (strong, nonatomic) IBOutlet FLProfilePicView *imgMeetingOwnerPic;


//End meet point

//Profiles

@property (strong, nonatomic) IBOutlet UIView *viewProfileList;
@property (strong, nonatomic) IBOutlet UIScrollView *scrProfileList;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePicRadar;


//End profiles

//Radar properties
@property (nonatomic, assign) BOOL turnedLeft;
@property (nonatomic, assign) BOOL turnedRight;
@property (nonatomic, strong) NSMutableArray *radarItems;
@property (assign) float radarItemAngle;
@property (nonatomic, strong) FLRadarObject *selectedRadarObject;

//Compass proparies
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) float oldHeading;
@property (assign, nonatomic) float updatedHeading;
@property (assign, nonatomic) float northOffest;

//Moments
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;
@property (strong, nonatomic) UIImage *imgMoment;


@end
