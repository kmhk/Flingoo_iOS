//
//  FLGroup.m
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLGroup.h"

@implementation FLGroup
@synthesize name;
@synthesize desc;
@synthesize image;
@synthesize group_memberships_attributes;

-(NSDictionary *)getGroupJsonObj:(FLGroup *)groupObj
{
    NSMutableArray *users=[[NSMutableArray alloc] init];
    for (id userid in groupObj.group_memberships_attributes)
    {
        NSDictionary *userDic=@{@"user_id" :userid};
        [users addObject:userDic];
    }
    NSDictionary *newGroupObj=@{@"name":groupObj.name,
    @"description":groupObj.desc,
    @"image":groupObj.image,
    @"group_memberships_attributes":users
    };
    return newGroupObj;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@ | %@ | %@ | %@", name, desc, image, group_memberships_attributes];
}

@end
