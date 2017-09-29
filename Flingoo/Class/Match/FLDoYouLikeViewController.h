//
//  FLDoYouLikeViewController.h
//  Flingoo
//
//  Created by Hemal on 11/18/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLDoYouLikeViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    IBOutlet UIImageView *imgProfilePic;
    
    IBOutlet UIButton *btnProfile;
    IBOutlet UIButton *btnYesLike;
    IBOutlet UIButton *btnMaybe;
    IBOutlet UIButton *btnNo;
    IBOutlet UILabel *lblProfile;
    IBOutlet UILabel *lblYesLike;
    IBOutlet UILabel *lblMaybe;
    IBOutlet UILabel *lblNo;
    MBProgressHUD *HUD;
}
- (IBAction)profileClicked:(id)sender;
- (IBAction)yesClicked:(id)sender;
- (IBAction)maybeClicked:(id)sender;
- (IBAction)noClicked:(id)sender;

@end
