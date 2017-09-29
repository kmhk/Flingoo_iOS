//
//  FLRadarObject.h
//  Flingoo
//
//  Created by Hemal on 12/18/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FLMomentView.h"
#import "FLEnums.h"
#import "FLOtherProfile.h"

@interface FLRadarObject : NSObject

@property(nonatomic,assign) FLRadarType radarType;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,strong) NSString *latitude;
@property(nonatomic,strong) NSString *longitude;
@property(nonatomic,strong) NSString *radarID;

@property(nonatomic,strong) NSString *created_at;
@property(nonatomic,strong) NSString *date_time;
@property(nonatomic,strong) NSString *image;

@property(nonatomic,strong) NSString *destination_address;
@property(nonatomic,strong) NSString *destination_latitude;
@property(nonatomic,strong) NSString *destination_longitude;
@property(nonatomic,assign) int no_of_seats;
@property(nonatomic,strong) NSString *start_address;
@property(nonatomic,strong) NSString *start_latitude;
@property(nonatomic,strong) NSString *start_longitude;
@property(nonatomic,strong) NSString *start_time;


@property(nonatomic,strong) FLOtherProfile *userObj;

//@property(nonatomic,strong) NSString *email;
//@property(nonatomic,strong) NSString *uid;
//@property(nonatomic,strong) NSNumber *is_friend;
//@property(nonatomic,strong) NSNumber *is_online;
//@property(nonatomic,strong) NSString *last_seen_at;
//@property(nonatomic,strong) NSNumber *age;
//@property(nonatomic,strong) NSString *body_art;
//@property(nonatomic,strong) NSString *children;
//@property(nonatomic,strong) NSString *ethnicity;
//@property(nonatomic,strong) NSString *eye_color;
//@property(nonatomic,strong) NSString *figure;
//@property(nonatomic,strong) NSString *full_name;
//@property(nonatomic,strong) NSString *gender;
//@property(nonatomic,strong) NSString *hair_color;
//@property(nonatomic,strong) NSString *hair_length;
//@property(nonatomic,strong) NSString *height;
//@property(nonatomic,strong) NSString *income;
//@property(nonatomic,strong) NSString *living_situation;
//@property(nonatomic,strong) NSString *looking_for;
//@property(nonatomic,strong) NSNumber *looking_for_age_max;
//@property(nonatomic,strong) NSNumber *looking_for_age_min;
//@property(nonatomic,strong) NSString *orientation;
//@property(nonatomic,strong) NSString *profession;
//@property(nonatomic,strong) NSString *relationship_status;
//@property(nonatomic,strong) NSString *religion;
//@property(nonatomic,strong) NSString *smoker;
//@property(nonatomic,strong) NSString *training;
//@property(strong,nonatomic) NSNumber *weight;
//@property(nonatomic,strong) NSString *status;

@property (retain, nonatomic) UIButton *button;
@property (retain, nonatomic) FLMomentView *viewMoment;
@property (retain, nonatomic) CLLocation *location;
@property (assign, nonatomic) float calculatedAngle;
@property (retain, nonatomic) NSMutableArray *points;

@end
