//
//  FLWebServiceBlocks.h
//  Flingoo
//
//  Created by Prasad De Zoysa on 1/15/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLAPIClient.h"
#import "FLGroup.h"
#import "FLOtherProfile.h"

@interface FLWebServiceBlocks : NSObject

+ (void)getCreditPlans:(void (^)(NSArray *plans, id error))block;

//Groups
+ (void)showGroupByID:(NSString *)groupId :(void (^)(FLGroup *group, id error))block;

@end
