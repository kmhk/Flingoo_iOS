//
//  FLWebServiceBlocks.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 1/15/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLWebServiceBlocks.h"
#import "FLWebServiceApi.h"
#import "FLGlobalSettings.h"
#import "AFNetworking.h"
#import "Config.h"

@implementation FLWebServiceBlocks

+(void)getCreditPlans:(void (^)(NSArray *plans, id))block{
    
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_CREDIT_PLANS] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CREDIT_PLANS %@", JSON);
        
        NSMutableArray *plans = [[NSMutableArray alloc] init];
        
        for (NSDictionary *plan in JSON) {
            [plans addObject:[NSString stringWithFormat:@"com.flingoo.payment.%@", [[plan objectForKey:@"credit_plan"] objectForKey:@"points"]]];
        }
        
        if (block) {
            block(plans, nil);
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CREDIT_PLANS requestFail %@", JSON);
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
    }];
    
    [operation start];
    
}

+(void)showGroupByID:(NSString *)groupId :(void (^)(FLGroup *group, id error))block{
    FLAPIClient *client = [FLAPIClient sharedClient];
    [client setDefaultHeader:@"X-AUTH-TOKEN" value:[FLGlobalSettings sharedInstance].current_user.auth_token];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@/%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GROUP,groupId] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSDictionary *groupDic = [JSON objectForKey:@"group"];
        NSArray *members = [groupDic objectForKey:@"users"];
        NSDictionary *ownerDic = [groupDic objectForKey:@"owner"];
        
        NSLog(@"OWNER %@", ownerDic);
        
        NSLog(@"GROUP DETAILS %@", groupDic);
        FLGroup *group = [[FLGroup alloc] init];
        [group setGid:[groupDic objectForKey:@"id"]];
        [group setName:[groupDic objectForKey:@"name"]];
        [group setDesc:[groupDic objectForKey:@"description"]];
        [group setImage:[groupDic objectForKey:@"image_256x256"]];
        
        NSMutableArray *membersList = [[NSMutableArray alloc] init];
        
        for (NSDictionary *member in members) {
            
            NSDictionary *user = [member objectForKey:@"user"];
            
            FLOtherProfile *profileObj = [[FLOtherProfile alloc] init];
            profileObj.uid = [user objectForKey:@"id"];
            profileObj.is_favourite = [user objectForKey:@"is_favourite"];
            profileObj.is_friend = [user objectForKey:@"is_friend"];
            profileObj.is_online = [user objectForKey:@"is_online"];
            profileObj.last_seen_at = [user objectForKey:@"last_seen_at"];
            NSDictionary *profile = [user objectForKey:@"profile"];
            profileObj.image = [profile objectForKey:@"image_128x128"];
            profileObj.full_name = [profile objectForKey:@"full_name"];
            profileObj.age = [NSNumber numberWithInt:[[profile objectForKey:@"age"] intValue]];
            [membersList addObject:profileObj];
        }
        
        group.group_memberships_attributes = membersList;
        
        //set owner
        FLOtherProfile *owner = [[FLOtherProfile alloc] init];
        [owner setUid:[NSNumber numberWithInt:[[ownerDic objectForKey:@"id"] intValue]]];
        NSDictionary *ownerProfile = [ownerDic objectForKey:@"profile"];
        [owner setFull_name:[ownerProfile objectForKey:@"full_name"]];
        [owner setImage:[ownerProfile objectForKey:@"image_128x128"]];
        
        [group setOwner:owner];
        
        if (block) {
            block(group, nil);
        }
        
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSLog(@"CREDIT_PLANS requestFail %@", JSON);
        NSLog(@"[HTTPClient Error]: %d", error.localizedDescription.intValue);
        
        if (block) {
            block(nil, error);
        }
        
    }];
    
    [operation start];
}

@end
