//
//  FLImageURLCache.h
//  Flingoo
//
//  Created by Thilina Hewagama on 1/12/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLImageURLCache : NSObject {
    NSCache *urlCacheObject;
}

@property (nonatomic, retain) NSCache *urlCacheObject;

+ (id)sharedManager;


@end
