//
//  FLForgotPasswordViewController.h
//  Flingoo
//
//  Created by Hemal on 11/14/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLForgotPasswordViewController : UIViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    IBOutlet UITextField *txtFieldEmail;
}
- (IBAction)createAccountClicked:(id)sender;
- (IBAction)sendEmailClicked:(id)sender;

@end
