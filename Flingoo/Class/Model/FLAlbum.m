//
//  FLAlbum.m
//  Flingoo
//
//  Created by Hemal on 12/14/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLAlbum.h"

@implementation FLAlbum
@synthesize title;
@synthesize moments;
@synthesize albumID;
@synthesize photoObjArr;
@synthesize created_at;
@synthesize cover_image;
@synthesize photo_count;

-(NSDictionary *)getAlbumJsonObj:(FLAlbum *)obj
{
    NSDictionary *albumObj = @{
    @"title":obj.title==nil?@"":obj.title,
    @"moments":[NSNumber numberWithBool:obj.moments]
    };
    
    NSDictionary *albumDic = @{
    @"album" : albumObj
    };
    return albumDic;
}

@end
