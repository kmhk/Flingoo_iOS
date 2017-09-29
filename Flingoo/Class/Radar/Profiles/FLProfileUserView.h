//
//  FLProfileUserView.h
//  Flingoo
//
//  Created by Prasad De Zoysa on 12/31/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLRadarObject.h"
#import "FLWebServiceApi.h"
#import "UIViewController+options.h"

@interface FLProfileUserView : UIView<FLWebServiceDelegate>

@property(nonatomic, strong) IBOutlet UIImageView *imgProfilePic;
@property(nonatomic, strong) IBOutlet UIImageView *imgOnlinePresence;
@property(nonatomic, strong) IBOutlet UILabel *lblUserName;
@property(nonatomic, strong) IBOutlet UILabel *lblAgeAndDistance;
@property(nonatomic, strong) FLRadarObject *itemRadar;
@property(nonatomic, copy) Communicator communicator;
@property(nonatomic, strong) id delegate;

-(id)initWithRadarItem:(FLRadarObject *)radarItem andDelegate:(id)delegate;

@end
