//
//  FLSighInViewController.h
//  Flingoo
//
//  Created by Hemal on 11/11/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLSighInViewController : UIViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{

    IBOutlet UITextField *txtFieldEmail;
    IBOutlet UITextField *txtFieldPassword;
    MBProgressHUD *HUD;
    NSString *facebookToken;
}
- (IBAction)forgotPasswordClicked:(id)sender;
- (IBAction)loginWithFbClicked:(id)sender;

@end
