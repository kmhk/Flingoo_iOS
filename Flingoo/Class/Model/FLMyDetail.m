//
//  FLMyDetail.m
//  Flingoo
//
//  Created by Hemal on 11/18/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMyDetail.h"

@implementation FLMyDetail

@synthesize header;//table header=== INTERVIEW_QUSTION_LIST>>>
@synthesize question;//question=== INTERVIEW_QUSTION_LIST>>>title
@synthesize user_answer_index;//user answer=== INTERVIEW_QUSTION_LIST>>>
@synthesize questionKey;//qustion key=== INTERVIEW_QUSTION_LIST>>>question->id
@synthesize answers_arr;//all answers arr=== INTERVIEW_QUSTION_LIST>>>question->options->option->title
@synthesize answers_key_arr;//all answers key arr===  INTERVIEW_QUSTION_LIST>>>question->options->option->id

@end
