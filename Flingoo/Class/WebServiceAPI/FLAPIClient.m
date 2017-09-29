//
//  FLAPIClient.m
//  Flingoo
//
//  Created by Hemal on 11/12/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLAPIClient.h"
#import "Config.h"
#import "AFJSONRequestOperation.h"

@implementation FLAPIClient

+(FLAPIClient *)sharedClient {
    static FLAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:WEBSERVICE_DOMAIN_URL]];
    });
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Content-Type" value:@"application/json"];
    [self setDefaultHeader:@"Accept" value:@"application/vnd.flingoo.v1"];
    
//    if ([[FLGlobalSettings sharedInstance].current_user.auth_token!=nil) {
//        [self setDefaultHeader:@"X-AUTH-TOKEN" value:[[FLGlobalSettings sharedInstance].current_user.auth_token];
//    }
    self.parameterEncoding = AFJSONParameterEncoding;
    
    return self;
    
}
@end
