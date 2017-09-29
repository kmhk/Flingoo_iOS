//
//  FLMeetpoint.h
//  Flingoo
//
//  Created by Hemal on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMeetpoint : NSObject
@property(strong,nonatomic) NSString *created_at;
@property(strong,nonatomic) NSString *description;
@property(strong,nonatomic) NSString *point_id;
@property(strong,nonatomic) NSString *image;
@property(strong,nonatomic) NSString *latitude;
@property(strong,nonatomic) NSString *longitude;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *date_time;

-(NSDictionary *)getMeetPointJsonObj:(FLMeetpoint *)obj;

@end


