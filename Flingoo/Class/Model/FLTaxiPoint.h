//
//  FLTaxiPoint.h
//  Flingoo
//
//  Created by Hemal on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLTaxiPoint : NSObject
@property(strong,nonatomic) NSString *start_time;
@property(strong,nonatomic) NSNumber *no_of_seats;
@property(strong,nonatomic) NSString *start_address;
@property(strong,nonatomic) NSString *destination_address;
@property(strong,nonatomic) NSString *start_latitude;
@property(strong,nonatomic) NSString *start_longitude;
@property(strong,nonatomic) NSString *destination_latitude;
@property(strong,nonatomic) NSString *destination_longitude;
@property(strong,nonatomic) NSString *taxi_point_id;
@property(strong,nonatomic) NSString *created_at;
-(NSDictionary *)getTaxipointDic:(FLTaxiPoint *)obj;

@end
