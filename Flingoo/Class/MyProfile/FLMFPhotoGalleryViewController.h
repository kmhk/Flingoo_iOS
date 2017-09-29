//
//  FLMFPhotoGalleryViewController.h
//  Flingoo
//
//  Created by Hemal on 11/15/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLOtherProfile.h"
#import "HTViewController.h"
#import "FLAlbum.h"
#import "FLPhoto.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLMFPhotoGalleryViewController : HTViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,MBProgressHUDDelegate,FLWebServiceDelegate,UIPopoverControllerDelegate,UIAlertViewDelegate>
{
//    BOOL fill_in_process;
    
    NSMutableArray *albumArr;
    NSMutableArray *profilePicArr;
    IBOutlet UIButton *btnLeft;//profile pic
    IBOutlet UIButton *btnRight;//btn album
    
    IBOutlet UIView *viewAlbum;
    
    NSString *forProfile;
    
//    NSMutableArray *cellArr;
    
    
    MBProgressHUD *HUD;
    UIPopoverController *popoverController;
    UIButton * deleteNavButton;
}
- (IBAction)profilePicClicked:(id)sender;
- (IBAction)myAlbumClicked:(id)sender;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profile:(NSString *)profile withProfileObj:(FLOtherProfile *)profileObj;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVwAlbum;

@end
