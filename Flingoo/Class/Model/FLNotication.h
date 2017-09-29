//
//  FLNotication.h
//  Flingoo
//
//  Created by Hemal on 12/25/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLNotication : NSObject
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSString *notification_id;
@property(nonatomic,strong) NSString *notification_type;
@property(nonatomic,strong) NSString *sender_id;
@property(nonatomic,strong) NSString *sender_name;
@property(nonatomic,assign) BOOL read_status;
@property(nonatomic,strong) NSDate *receivedDate;
@property(nonatomic,strong) NSString *latitude;
@property(nonatomic,strong) NSString *longitude;
@property(nonatomic,strong) NSString *sender_profile_pic;
@end
