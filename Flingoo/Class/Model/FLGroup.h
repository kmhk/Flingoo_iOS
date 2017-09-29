//
//  FLGroup.h
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLOtherProfile.h"

@interface FLGroup : NSObject
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *gid;
@property(strong,nonatomic) NSString *desc;
@property(strong,nonatomic) NSString *image;//image name
@property(strong,nonatomic) FLOtherProfile *owner;
@property(strong,nonatomic) NSArray  *group_memberships_attributes;//group members userid

-(NSDictionary *)getGroupJsonObj:(FLGroup *)groupObj;

@end

