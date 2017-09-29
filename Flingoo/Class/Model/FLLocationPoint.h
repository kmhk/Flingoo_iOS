//
//  FLLocationPoint.h
//  Flingoo
//
//  Created by Hemal on 12/16/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLLocationPoint : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *description;
@property(nonatomic,strong) NSString *latitude;
@property(nonatomic,strong) NSString *longitude;

-(NSDictionary *)getLocationPointJsonObj:(FLLocationPoint *)obj;

@end
