//
//  FLRadar.h
//  Flingoo
//
//  Created by Hemal on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FLRadar : NSObject
@property(strong,nonatomic) NSString *radius;
@property(assign,nonatomic) BOOL groups;
@property(assign,nonatomic) BOOL meet_points;
@property(assign,nonatomic) BOOL taxi_points;
@property(assign,nonatomic) BOOL location_points;
@property(assign,nonatomic) BOOL profiles;
@property(strong,nonatomic) NSNumber *age_gteq;
@property(strong,nonatomic) NSNumber *age_lteq;
@property(strong,nonatomic) NSString *looking_for_eq;
@property(strong,nonatomic) NSString *who_looking_for_eq;

@property (retain, nonatomic) CLLocation *location;
@property (assign, nonatomic) float calculatedAngle;
@property (retain, nonatomic) UIButton *button;
@property(nonatomic, assign) FLRadarType type;


-(NSDictionary *)getRadarJsonObj:(FLRadar *)radarObj;
@end
