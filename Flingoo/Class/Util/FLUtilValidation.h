//
//  FLUtilValidation.h
//  Flingoo
//
//  Created by Hemal on 11/14/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLUtilValidation : NSObject
+ (BOOL)validateEmail: (NSString *) _email;
+(BOOL)validatePassword : (NSString *) _password;
@end
