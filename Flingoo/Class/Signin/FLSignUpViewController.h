//
//  FLSignUpViewController.h
//  Flingoo
//
//  Created by Hemal on 11/10/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FLWebServiceApi.h"

@interface FLSignUpViewController : UIViewController<MBProgressHUDDelegate,FLWebServiceDelegate>
{
    MBProgressHUD *HUD;
    IBOutlet UIImageView *imgBg;
    NSString *facebookToken;
}
- (IBAction)loginWithFB:(id)sender;
- (IBAction)registerWithEmail:(id)sender;
- (IBAction)signInNow:(id)sender;

@end
