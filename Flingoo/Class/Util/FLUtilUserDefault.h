//
//  FLUtilUserDefault.h
//  Flingoo
//
//  Created by Hemal on 11/25/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLUtilUserDefault : NSObject

+(void)setUsername:(NSString *)username;
+(void)removeUsername;
+(NSString *)getUsername;

+(void)setPassword:(NSString *)password;
+(void)removePassword;
+(NSString *)getPassword;

+(void)setFBAuthToken:(NSString *)fbAuthToken;
+(void)removeFBAuthToken;
+(NSString *)getFBAuthToken;

+(void)setGender:(NSString *)gender;
+(void)removeGender;
+(NSString *)getGender;

+(void)setLookingFor:(NSString *)lookingFor;
+(void)removeLookingFor;
+(NSString *)getLookingFor;

+(void)setWhoAreLookingFor:(NSString *)whoAreLookingFor;
+(void)removeWhoAreLookingFor;
+(NSString *)getWhoAreLookingFor;

+(void)setLookingAgeMin:(int)lookingAgeMin;
+(void)removeLookingAgeMin;
+(int)getLookingAgeMin;

+(void)setLookingAgeMax:(int)lookingAgeMax;
+(void)removeLookingAgeMax;
+(int)getLookingAgeMax;

+(NSString *)getTempUserAddress;
+(void)removeTempUserAddress;
+(void)setTempUserAddress:(NSString *)address;

+(void)removeAllUserData;


@end
