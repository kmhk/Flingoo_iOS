//
//  FLMatchesViewController.h
//  Flingoo
//
//  Created by Hemal on 11/18/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLMatchesViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
//    NSMutableArray *profilePicArrURL;
//    NSMutableArray *pictureObjArr;
//    IBOutlet UIView *viewUserList;
//    IBOutlet UIButton *btnThum;
//    IBOutlet UIButton *btnListView;
    MBProgressHUD *HUD;
}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(NSString *)type;
//- (IBAction)thumbClicked:(id)sender;
//- (IBAction)listClicked:(id)sender;
//@property (weak, nonatomic) IBOutlet UICollectionView *collectionUserList;

@end
