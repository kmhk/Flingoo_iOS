//
//  FLRadar.m
//  Flingoo
//
//  Created by Hemal on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLRadarItem.h"

@implementation FLRadar
@synthesize radius;
@synthesize groups;
@synthesize meet_points;
@synthesize taxi_points;
@synthesize location_points;
@synthesize profiles;
@synthesize age_gteq;
@synthesize age_lteq;
@synthesize looking_for_eq;
@synthesize who_looking_for_eq;
//////////////
//{
//    "radius": 5,
//    "q": {
//        "age_gteq": 48,
//        "age_lteq": 49,
//        "looking_for_eq": "women",
//        "who_looking_for_eq": "men"
//    }
//}
/////////////
-(NSDictionary *)getRadarJsonObj:(FLRadar *)radarObj
{
    NSDictionary *objDic=
    @{@"age_gteq" : radarObj.age_gteq,
    @"age_lteq" : radarObj.age_lteq,
    @"looking_for_eq" : radarObj.looking_for_eq,
    @"who_looking_for_eq" : radarObj.who_looking_for_eq,
    };
    
    NSDictionary *radarDic=@{@"q" : objDic,@"radius" : radarObj.radius,@"groups" : [NSNumber  numberWithBool:radarObj.groups],
    @"meet_points" : [NSNumber  numberWithBool:radarObj.meet_points],
    @"taxi_points" : [NSNumber  numberWithBool:radarObj.taxi_points],
//    @"locations" : [NSNumber  numberWithBool:radarObj.locations],
    @"location_points" : [NSNumber  numberWithBool:radarObj.location_points],
    @"profiles" : [NSNumber  numberWithBool:radarObj.profiles]};
    
    return radarDic;
 
}

@end
