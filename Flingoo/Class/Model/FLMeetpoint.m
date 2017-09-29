//
//  FLMeetpoint.m
//  Flingoo
//
//  Created by Hemal on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMeetpoint.h"

@implementation FLMeetpoint
@synthesize created_at;
@synthesize description;
@synthesize point_id;
@synthesize image;
@synthesize latitude;
@synthesize longitude;
@synthesize name;
@synthesize date_time;



-(NSDictionary *)getMeetPointJsonObj:(FLMeetpoint *)obj
{
    NSDictionary *meetPointDic1 = @{
    @"name":obj.name==nil?@"":obj.name,
    @"description":obj.description==nil?@"":obj.description,
    @"image": obj.image==nil?@"":obj.image,
    @"latitude": obj.latitude==nil?@"":obj.latitude,
    @"longitude": obj.latitude==nil?@"":obj.longitude
    };
    
    NSDictionary *meetPointDic2 = @{
    @"meet_point" : meetPointDic1
    };
    return meetPointDic2;
}

@end
