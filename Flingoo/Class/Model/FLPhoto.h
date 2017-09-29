//
//  FLPhoto.h
//  Flingoo
//
//  Created by Hemal on 12/14/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLPhoto : NSObject
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *imageName;
@property(strong,nonatomic) NSString *albumID;
@property(strong,nonatomic) NSString *imgURL;
@property(strong,nonatomic) NSString *created_at;
@property(strong,nonatomic) NSString *imgID;


-(NSDictionary *)getPhotoJsonObj:(FLPhoto *)obj;
@end
