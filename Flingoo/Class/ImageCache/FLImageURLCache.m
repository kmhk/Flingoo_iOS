//
//  FLImageURLCache.m
//  Flingoo
//
//  Created by Thilina Hewagama on 1/12/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//


#import "FLImageURLCache.h"

@implementation FLImageURLCache

@synthesize urlCacheObject;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static FLImageURLCache  *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        urlCacheObject = [[NSCache alloc] init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
