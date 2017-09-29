//
//  FLChangePasswordViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 12/30/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLChangePasswordViewController : UIViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@end
