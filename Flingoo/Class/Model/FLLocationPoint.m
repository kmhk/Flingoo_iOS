//
//  FLLocationPoint.m
//  Flingoo
//
//  Created by Hemal on 12/16/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLLocationPoint.h"

@implementation FLLocationPoint
@synthesize name;
@synthesize description;
@synthesize latitude;
@synthesize longitude;

-(NSDictionary *)getLocationPointJsonObj:(FLLocationPoint *)obj
{
    NSDictionary *locationPointDic1 = @{
    @"name":obj.name==nil?@"":obj.name,
    @"description":obj.description==nil?@"":obj.description,
    @"latitude": obj.latitude==nil?@"":obj.latitude,
    @"latitude": obj.latitude==nil?@"":obj.latitude
    };
    
    NSDictionary *locationPointDic2 = @{
    @"location_point" : locationPointDic1
    };
    return locationPointDic2;
}

@end
