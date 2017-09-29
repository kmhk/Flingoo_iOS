//
//  FLProfile.h
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLOtherProfile : NSObject
@property(strong,nonatomic) NSNumber *age;
@property(strong,nonatomic) NSString *body_art;
@property(strong,nonatomic) NSString *children;
@property(strong,nonatomic) NSString *ethnicity;
@property(strong,nonatomic) NSString *eye_color;
@property(strong,nonatomic) NSString *figure;
@property(strong,nonatomic) NSString *full_name;
@property(strong,nonatomic) NSString *gender;
@property(strong,nonatomic) NSString *hair_color;
@property(strong,nonatomic) NSString *hair_length;
@property(strong,nonatomic) NSString *height;
@property(strong,nonatomic) NSNumber *uid;
@property(strong,nonatomic) NSString *image;
@property(strong,nonatomic) NSString *income;
@property(strong,nonatomic) NSString *living_situation;
@property(strong,nonatomic) NSString *orientation;
@property(strong,nonatomic) NSString *profession;
@property(strong,nonatomic) NSString *religion;
@property(strong,nonatomic) NSString *smoker;
@property(strong,nonatomic) NSString *training;
@property(strong,nonatomic) NSNumber *weight;
@property(strong,nonatomic) NSString *relationship_status;
@property(strong,nonatomic) NSString *email;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSString *latitude;
@property(strong,nonatomic) NSString *longitude;
@property(strong,nonatomic) NSString *looking_for;
@property(strong,nonatomic) NSString *who_looking_for;
@property(strong,nonatomic) NSNumber *is_friend;
@property(strong,nonatomic) NSNumber *is_online;
@property(strong,nonatomic) NSNumber *is_favourite;
@property(strong,nonatomic) NSNumber *looking_for_age_min;
@property(strong,nonatomic) NSNumber *looking_for_age_max;

@property(strong,nonatomic) NSNumber *last_seen_at;
//
//friend special
@property(strong,nonatomic) NSString *created_at;
@property(strong,nonatomic) NSString *friendship_id;

@property(strong,nonatomic) NSString *status_txt;

@property(strong,nonatomic) NSMutableArray *interviewQuestionsArr;//FLMyDetail with question key and answer index

@end
