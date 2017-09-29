//
//  FLChangeMobileNumberViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 12/30/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhoneNoDelegate <NSObject>

@required
- (void)phoneNoViewDismiss:(NSString *)phoneNo;
@end


@interface FLChangeMobileNumberViewController : UIViewController
@property (nonatomic, assign)   id<PhoneNoDelegate> delegate;
@end
