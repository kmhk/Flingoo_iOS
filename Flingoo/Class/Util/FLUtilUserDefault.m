//
//  FLUtilUserDefault.m
//  Flingoo
//
//  Created by Hemal on 11/25/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLUtilUserDefault.h"
#import "FLGlobalSettings.h"

@implementation FLUtilUserDefault

#pragma mark -auth_token

//+(void)setAuthToken:(NSString *)auth_token
//{
//    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
//    [df setObject:auth_token forKey:@"auth_token"];
//    [df synchronize];
//}
//
//+(void)removeAuthToken
//{
//    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
//    [df setObject:@"" forKey:@"auth_token"];
//    [df synchronize];
//}
//
//+(NSString *)getAuthToken
//{
//    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
//    return [df objectForKey:@"auth_token"];
//}

#pragma mark -username

+(void)setUsername:(NSString *)username
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:username forKey:@"username"];
    [df synchronize];
}

+(void)removeUsername
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:@"" forKey:@"username"];
    [df synchronize];
}

+(NSString *)getUsername
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    return [df objectForKey:@"username"];
}

#pragma mark -password

+(void)setPassword:(NSString *)password
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:password forKey:@"password"];
    [df synchronize];
}

+(void)removePassword
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:@"" forKey:@"password"];
    [df synchronize];
}

+(NSString *)getPassword
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    return [df objectForKey:@"password"];
}

/////////////////////////
#pragma mark -username

+(void)setFBAuthToken:(NSString *)fbAuthToken
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:fbAuthToken forKey:@"fbAuthToken"];
    [df synchronize];
}

+(void)removeFBAuthToken
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:@"" forKey:@"fbAuthToken"];
    [df synchronize];
}

+(NSString *)getFBAuthToken
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    return [df objectForKey:@"fbAuthToken"];
}


////////////////////
#pragma mark -gender

+(void)setGender:(NSString *)gender
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:gender forKey:@"gender"];
    [df synchronize];
}

+(void)removeGender
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:@"" forKey:@"gender"];
    [df synchronize];
}

+(NSString *)getGender
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    return [df objectForKey:@"gender"];
}

////////////////////
#pragma mark -lookingFor

+(void)setLookingFor:(NSString *)lookingFor
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:lookingFor forKey:@"lookingFor"];
    [df synchronize];
}

+(void)removeLookingFor
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:@"" forKey:@"lookingFor"];
    [df synchronize];
}

+(NSString *)getLookingFor
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    return [df objectForKey:@"lookingFor"];
}

////////////////////
#pragma mark - whoAreLookingFor

+(void)setWhoAreLookingFor:(NSString *)whoAreLookingFor
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:whoAreLookingFor forKey:@"whoAreLookingFor"];
    [df synchronize];
}

+(void)removeWhoAreLookingFor
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:@"" forKey:@"whoAreLookingFor"];
    [df synchronize];
}

+(NSString *)getWhoAreLookingFor
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    return [df objectForKey:@"whoAreLookingFor"];
}

////////////////////
#pragma mark -lookingAgeMin

+(void)setLookingAgeMin:(int)lookingAgeMin
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setInteger:lookingAgeMin forKey:@"lookingAgeMin"];
    [df synchronize];
}

+(void)removeLookingAgeMin
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setInteger:0 forKey:@"lookingAgeMin"];
    [df synchronize];
}

+(int)getLookingAgeMin
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    return [df integerForKey:@"lookingAgeMin"];
}

////////////////////
#pragma mark -lookingAgeMax

+(void)setLookingAgeMax:(int)lookingAgeMax
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setInteger:lookingAgeMax forKey:@"lookingAgeMax"];
    [df synchronize];
}

+(void)removeLookingAgeMax
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setInteger:0 forKey:@"lookingAgeMax"];
    [df synchronize];
}

+(int)getLookingAgeMax
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    return [df integerForKey:@"lookingAgeMax"];
}


#pragma mark - User Address temporary

+(void)setTempUserAddress:(NSString *)address
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:address forKey:@"TempAddress"];
    [df synchronize];
}

+(void)removeTempUserAddress
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:@"" forKey:@"TempAddress"];
    [df synchronize];
}

+(NSString *)getTempUserAddress
{
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    return [df objectForKey:@"TempAddress"];
}


////////////////////
#pragma mark -lookingAgeMax
+(void)removeAllUserData
{
    [self removeUsername];
    [self removePassword];
    [self removeFBAuthToken];
    [self removeGender];
    [self removeLookingFor];
    [self removeWhoAreLookingFor];
    [self removeLookingAgeMin];
    [self removeLookingAgeMax];
    [self removeTempUserAddress];
    [FLGlobalSettings sharedInstance].tempFacebookImgUrl=nil;
    [FLGlobalSettings sharedInstance].settingObj=nil;
}

@end
