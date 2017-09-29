//
//  FLChatMessage.h
//  Flingoo
//
//  Created by Hemal on 12/8/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLChatMessage : NSObject
@property(strong,nonatomic) NSString *message;
@property(strong,nonatomic) NSString *chatDateTime;
@property(strong,nonatomic) NSString *username;
@property(strong,nonatomic) NSString *userID;
@property(strong,nonatomic) NSString *user_imageURL;
@property(assign,nonatomic) BOOL seen;//this one for use only sended message
@end
