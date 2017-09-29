//
//  FLUtilValidation.m
//  Flingoo
//
//  Created by Hemal on 11/14/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLUtilValidation.h"

@implementation FLUtilValidation

+(BOOL) validateEmail: (NSString *) _email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:_email];
}

+(BOOL) validatePassword : (NSString *) _password
{
    return [_password length]<6 ? NO:YES;
}


@end
