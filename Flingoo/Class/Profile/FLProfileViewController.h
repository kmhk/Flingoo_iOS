//
//  FLProfileViewController.h
//  Flingoo
//
//  Created by Hemal on 11/19/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeMenu.h"
#import "FLOtherProfile.h"
#import "HTViewController.h"
#import "FLWebServiceApi.h"

@interface FLProfileViewController : HTViewController<FLWebServiceDelegate>
{

    IBOutlet UIButton *btnProfile;
    IBOutlet UILabel *lblProfile;
    IBOutlet UIButton *btnGallery;
    IBOutlet UILabel *lblGallery;
    
    
    IBOutlet UIImageView *imgProfilePic;
    IBOutlet UIView *viewDummy;
    
    IBOutlet UILabel *lblYear;
    IBOutlet UILabel *lblAddress;
    IBOutlet UILabel *lblLastOnlineDate;
    IBOutlet UILabel *lblProfileComplition;
    IBOutlet UILabel *lblGalleryCount;
    IBOutlet UIImageView *testImgView;
    IBOutlet UILabel *lblStatus;
    
    IBOutlet UIButton *btnPhotoGallery;
    
    
    IBOutlet UILabel *lblFullName_iPad;
    IBOutlet UIButton *btnProfileDetail;
    IBOutlet UILabel *lblGenderAge_iPad;
    
    IBOutlet UIButton *btnFavorite_iPad;
    IBOutlet UIButton *btnFriend_iPad;
    IBOutlet UIButton *btnGift_iPad;
    IBOutlet UIButton *btnChat_iPad;
    IBOutlet UILabel *lblChat_iPad;
    IBOutlet UILabel *lblGift_iPad;
    IBOutlet UILabel *lblFavorite_iPad;
    IBOutlet UILabel *lblFriend_iPad;
}
- (IBAction)btnPofileClicked:(id)sender;
- (IBAction)btnGalleryClicked:(id)sender;
- (IBAction)menuClicked:(id)sender;

- (IBAction)chatClicked:(id)sender;
- (IBAction)giftClicked:(id)sender;
- (IBAction)friendClicked:(id)sender;
- (IBAction)favoriteClicked:(id)sender;
- (IBAction)backClicked_iPad:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profile:(NSString *)profile withProfileObj:(FLOtherProfile *)profileObj;
@property(nonatomic,strong) IBOutlet UIImageView *imgProfilePic;
@property(weak, nonatomic) IBOutlet UIView *profilePictureViewContainer;

@end
