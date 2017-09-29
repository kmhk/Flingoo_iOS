//
//  FLChat.h
//  Flingoo
//
//  Created by Hemal on 12/8/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLChatMessage.h"

@interface FLChat : NSObject//store chat common property on that array
@property(strong,nonatomic) NSString *chatObjName;//username or user id
@property(assign,nonatomic) BOOL is_online;//only user for private chat
@property(strong,nonatomic) NSString *chatObj_image_url;
@property(strong,nonatomic) NSString *chatObj_id;//user id or group id
@property(strong,nonatomic) NSMutableArray *chatMessageArr;//store chat messages
@property(assign,nonatomic) NSString *message_type; //group or privart
@property(strong,nonatomic) FLChatMessage *chat_last_msg_obj; //use for keep last message
@end
