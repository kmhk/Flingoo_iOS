//
//  FLPhoto.m
//  Flingoo
//
//  Created by Hemal on 12/14/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLPhoto.h"

@implementation FLPhoto
@synthesize title;
@synthesize imageName;
@synthesize albumID;
@synthesize imgURL;
@synthesize created_at;
@synthesize imgID;



-(NSDictionary *)getPhotoJsonObj:(FLPhoto *)obj
{
    NSDictionary *albumObj = @{
    @"title":obj.title==nil?@"":obj.title,
     @"image":obj.imageName==nil?@"":obj.imageName
    };
    
    NSDictionary *albumDic = @{
    @"photo" : albumObj
    };
    return albumDic;
}


@end
