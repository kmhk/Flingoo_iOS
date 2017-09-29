//
//  FLSplashViewController.h
//  Flingoo
//
//  Created by Hemal on 11/11/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLWebServiceApi.h"

@interface FLSplashViewController : UIViewController<FLWebServiceDelegate>
{

    IBOutlet UIActivityIndicatorView *actIndicatorInitial;
}

@property(weak, nonatomic) IBOutlet UIImageView *backgroundView;

- (IBAction)testAction:(id)sender;

@end
