//
//  FLUserLocation.m
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLUserLocation.h"

@implementation FLUserLocation
@synthesize latitude;
@synthesize longitude;
@synthesize is_online;


-(NSDictionary *)getUserLocationJsonObj:(FLUserLocation *)userLocationObj
{
    NSDictionary *dic=@{
    @"latitude" : userLocationObj.latitude,
    @"longitude" :userLocationObj.longitude,
    @"is_online" :[NSNumber numberWithBool:userLocationObj.is_online]
    };
    
    return dic;
}

@end
