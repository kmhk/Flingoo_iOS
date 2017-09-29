//
//  FLTaxiPoint.m
//  Flingoo
//
//  Created by Hemal on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLTaxiPoint.h"

@implementation FLTaxiPoint
@synthesize start_time;
@synthesize no_of_seats;
@synthesize start_address;
@synthesize destination_address;
@synthesize start_latitude;
@synthesize start_longitude;
@synthesize destination_latitude;
@synthesize destination_longitude;
@synthesize taxi_point_id;
@synthesize created_at;
-(NSDictionary *)getTaxipointDic:(FLTaxiPoint *)obj
{
    NSDictionary *userDataDic = @{
    @"start_time":obj.start_time,
    @"no_of_seats":obj.no_of_seats,
    @"start_address": obj.start_address,
    @"destination_address": obj.destination_address,
    @"start_latitude": obj.start_latitude,
    @"start_longitude" :obj.start_longitude,
    @"destination_latitude":obj.destination_latitude,
    @"destination_longitude": obj.destination_longitude
    };
    
    return userDataDic;
}

@end
