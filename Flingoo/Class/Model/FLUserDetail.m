//
//  FLUserDetail.m
//  Flingoo
//
//  Created by Hemal on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLUserDetail.h"

@implementation FLUserDetail
@synthesize full_name;
@synthesize mobile_number;
@synthesize birth_date;
@synthesize gender;
@synthesize looking_for;
@synthesize who_looking_for;
@synthesize orientation;
@synthesize weight;
@synthesize figure;
@synthesize hair_color;
@synthesize hair_length;
@synthesize eye_color;
@synthesize body_art;
@synthesize smoker;
@synthesize ethnicity;
@synthesize religion;
@synthesize children;
@synthesize living_situation;
@synthesize training;
@synthesize profession;
@synthesize income;
@synthesize relationship_status;
@synthesize height;
@synthesize imageNameProfile;
@synthesize looking_for_age_min;
@synthesize looking_for_age_max;

-(NSMutableDictionary *)getUserDetailJsonObj:(FLUserDetail *)obj
{
     
   
    
    NSMutableDictionary *userDataMuDic=[[NSMutableDictionary alloc] init];
    if (obj.full_name!=nil)[userDataMuDic setObject:obj.full_name forKey:@"full_name"];
    if (obj.mobile_number!=nil)[userDataMuDic setObject:obj.mobile_number forKey:@"mobile_number"];
    if (obj.gender!=nil)[userDataMuDic setObject:obj.gender forKey:@"gender"];
    if (obj.looking_for!=nil)[userDataMuDic setObject:obj.looking_for forKey:@"looking_for"];
    if (obj.who_looking_for!=nil)[userDataMuDic setObject:obj.who_looking_for forKey:@"who_looking_for"];
    if (obj.orientation!=nil)[userDataMuDic setObject:obj.orientation forKey:@"orientation"];
    if (obj.weight!=nil)[userDataMuDic setObject:obj.weight forKey:@"weight"];
    if (obj.figure!=nil)[userDataMuDic setObject:obj.figure forKey:@"figure"];
    if (obj.hair_color!=nil)[userDataMuDic setObject:obj.hair_color forKey:@"hair_color"];
    if (obj.hair_length!=nil)[userDataMuDic setObject:obj.hair_length forKey:@"hair_length"];
    if (obj.smoker!=nil)[userDataMuDic setObject:obj.smoker forKey:@"smoker"];
    if (obj.ethnicity!=nil)[userDataMuDic setObject:obj.ethnicity forKey:@"ethnicity"];
    if (obj.religion!=nil)[userDataMuDic setObject:obj.religion forKey:@"religion"];
    if (obj.children!=nil)[userDataMuDic setObject:obj.children forKey:@"children"];
    if (obj.living_situation!=nil)[userDataMuDic setObject:obj.living_situation forKey:@"living_situation"];
    if (obj.training!=nil)[userDataMuDic setObject:obj.training forKey:@"training"];
    if (obj.profession!=nil)[userDataMuDic setObject:obj.profession forKey:@"profession"];
    if (obj.income!=nil)[userDataMuDic setObject:obj.income forKey:@"income"];
    if (obj.relationship_status!=nil)[userDataMuDic setObject:obj.relationship_status forKey:@"relationship_status"];
    if (obj.height!=nil)[userDataMuDic setObject:obj.height forKey:@"height"];
    if (obj.birth_date!=nil)[userDataMuDic setObject:obj.birth_date forKey:@"birth_date"];
    if (obj.eye_color!=nil)[userDataMuDic setObject:obj.eye_color forKey:@"eye_color"];
     if (obj.body_art!=nil)[userDataMuDic setObject:obj.body_art forKey:@"body_art"];
    if (obj.body_art!=nil)[userDataMuDic setObject:obj.body_art forKey:@"body_art"];
    if (obj.imageNameProfile!=nil)[userDataMuDic setObject:obj.imageNameProfile forKey:@"image"];
    if (obj.looking_for_age_min!=nil)[userDataMuDic setObject:obj.looking_for_age_min forKey:@"looking_for_age_min"];
    if (obj.looking_for_age_max!=nil)[userDataMuDic setObject:obj.looking_for_age_max forKey:@"looking_for_age_max"];
    
    NSLog(@"userDataMuDic %@",userDataMuDic);
    
    return userDataMuDic;
}

@end
