//
//  FLProfileSearch.h
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLProfileSearch : NSObject
@property(strong,nonatomic) NSNumber *radius;
@property(strong,nonatomic) NSNumber *age_gteq;
@property(strong,nonatomic) NSNumber *age_lteq;
@property(strong,nonatomic) NSString *gender_eq;
@property(strong,nonatomic) NSString *orientation_eq;

-(NSDictionary *)getProfileSearchJsonObj:(FLProfileSearch *)obj;

@end
