//
//  FLGift.h
//  Flingoo
//
//  Created by Hemal on 1/5/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLGift : NSObject
@property(nonatomic,strong) NSString *gift_id;
@property(nonatomic,strong) NSString *gift_type;
@property(nonatomic,strong) NSString *gift_name;
@property(nonatomic,strong) NSDate *created_at;
@property(nonatomic,strong) NSString *sender_id;
@property(nonatomic,strong) NSNumber *sender_is_friend;
@property(nonatomic,strong) NSNumber *sender_is_online;
@property(nonatomic,strong) NSString *sender_full_name;
@property(nonatomic,strong) NSString *sender_image;
@end
