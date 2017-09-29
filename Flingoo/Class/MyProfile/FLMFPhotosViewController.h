//
//  FLMFPhotosViewController.h
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
#import "FLOtherProfile.h"

@interface FLMFPhotosViewController : HTViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,MBProgressHUDDelegate,FLWebServiceDelegate,UIPopoverControllerDelegate,UIAlertViewDelegate>
{

    NSMutableArray *albumPicArr;

    MBProgressHUD *HUD;
    UIPopoverController *popoverController;
    UIButton *deleteNavButton;
    int deleteIndex;
}




@property (weak, nonatomic) IBOutlet UICollectionView *collectionVwPhoto;
@property(nonatomic,weak) FLAlbum *albumObj;
@property(nonatomic,weak) FLOtherProfile *profileObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profile:(NSString *)profile;
@end
