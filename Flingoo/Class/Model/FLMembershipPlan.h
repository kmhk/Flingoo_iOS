//
//  FLMembershipPlan.h
//  Flingoo
//
//  Created by Hemal on 1/15/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMembershipPlan : NSObject

@property(nonatomic,strong) NSString *amount;
@property(nonatomic,strong) NSString *description;
@property(nonatomic,strong) NSString *membership_plan_id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) int term;

@end
