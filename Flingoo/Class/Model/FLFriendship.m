//
//  FLFriendship.m
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLFriendship.h"

@implementation FLFriendship
@synthesize friend_id;
@synthesize initiator;

-(NSDictionary *)getFriendshipJsonObj:(FLFriendship *)obj
{
    
    NSDictionary *dic=@{@"friend_id":obj.friend_id,@"initiator" :[NSNumber numberWithBool:obj.initiator] };
    return dic;
    
}
@end
