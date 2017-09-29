//
//  FLFriendship.h
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLFriendship : NSObject
@property(strong,nonatomic) NSNumber *friend_id;
@property(assign,nonatomic) BOOL initiator;
-(NSDictionary *)getFriendshipJsonObj:(FLFriendship *)obj;
@end
