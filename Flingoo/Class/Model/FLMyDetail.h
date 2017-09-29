//
//  FLMyDetail.h
//  Flingoo
//
//  Created by Hemal on 11/18/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMyDetail : NSObject

@property (nonatomic,strong) NSString *header;
@property (nonatomic,strong) NSString *question;
@property (nonatomic,strong) NSArray *answers_arr;
@property (nonatomic,strong) NSArray *answers_key_arr;
@property (nonatomic,assign) int user_answer_index;
@property (nonatomic,strong) NSString *questionKey;

@end
