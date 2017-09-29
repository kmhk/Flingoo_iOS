//
//  FLAlbum.h
//  Flingoo
//
//  Created by Hemal on 12/14/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLAlbum : NSObject
@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) BOOL moments;
@property(nonatomic,strong) NSString *albumID;
@property(nonatomic,strong) NSMutableArray *photoObjArr;
@property(nonatomic,strong) NSString *created_at;
@property(nonatomic,assign) int photo_count;
@property(nonatomic,strong) NSString *cover_image;
-(NSDictionary *)getAlbumJsonObj:(FLAlbum *)obj;
@end
