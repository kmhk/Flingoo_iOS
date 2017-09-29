//
//  FLTempVCViewController.h
//  Flingoo
//
//  Created by Hemal on 11/14/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLWebServiceApi.h"


@interface FLTempVCViewController : UIViewController<FLWebServiceDelegate>
- (IBAction)testAction:(id)sender;
- (IBAction)removeUser:(id)sender;

@end
