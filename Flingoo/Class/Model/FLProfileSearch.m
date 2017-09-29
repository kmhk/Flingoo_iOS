//
//  FLProfileSearch.m
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLProfileSearch.h"

@implementation FLProfileSearch
@synthesize radius;
@synthesize age_gteq;
@synthesize age_lteq;
@synthesize gender_eq;
@synthesize orientation_eq;

-(NSDictionary *)getProfileSearchJsonObj:(FLProfileSearch *)obj
{
    NSDictionary *proSearchDic1 = @{
    @"age_gteq":obj.age_gteq==nil?@"":obj.age_gteq,
    @"age_lteq":obj.age_lteq==nil?@"":obj.age_lteq,
    @"gender_eq": obj.gender_eq==nil?@"":obj.gender_eq,
    @"orientation_eq": obj.orientation_eq==nil?@"":obj.orientation_eq
    };
    
    NSDictionary *proSearchDic2 = @{
    @"radius" : obj.radius,@"q" : proSearchDic1
    };
    return proSearchDic2;
}


@end
