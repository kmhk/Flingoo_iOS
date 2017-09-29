//
//  FLUserLocation.h
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLUserLocation : NSObject
@property(strong,nonatomic) NSString *latitude;
@property(strong,nonatomic) NSString *longitude;
@property(assign,nonatomic) BOOL is_online;
-(NSDictionary *)getUserLocationJsonObj:(FLUserLocation *)userLocationObj;
@end
