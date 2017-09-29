//
//  FLUserDetail.h
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLUserDetail : NSObject
@property(strong,nonatomic) NSString *full_name;
@property(strong,nonatomic) NSString *mobile_number;
@property(strong,nonatomic) NSString *birth_date;
@property(strong,nonatomic) NSString *gender;
@property(strong,nonatomic) NSString *looking_for;
@property(strong,nonatomic) NSString *who_looking_for;
@property(strong,nonatomic) NSString *orientation;
@property(strong,nonatomic) NSNumber *weight;
@property(strong,nonatomic) NSString *figure;
@property(strong,nonatomic) NSString *hair_color;
@property(strong,nonatomic) NSString *hair_length;
@property(strong,nonatomic) NSString *eye_color;
@property(strong,nonatomic) NSString *body_art;
@property(strong,nonatomic) NSString *smoker;
@property(strong,nonatomic) NSString *ethnicity;
@property(strong,nonatomic) NSString *religion;
@property(strong,nonatomic) NSString *children;
@property(strong,nonatomic) NSString *living_situation;
@property(strong,nonatomic) NSString *training;
@property(strong,nonatomic) NSString *profession;
@property(strong,nonatomic) NSString *income;
@property(strong,nonatomic) NSString *relationship_status;
@property(strong,nonatomic) NSNumber *height;
@property(strong,nonatomic) NSString *imageNameProfile;
@property(strong,nonatomic) NSNumber *looking_for_age_min;
@property(strong,nonatomic) NSNumber *looking_for_age_max;

-(NSMutableDictionary *)getUserDetailJsonObj:(FLUserDetail *)obj;

@end
