//
//  FLAPIClient.h
//  Flingoo
//
//  Created by Hemal on 11/12/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface FLAPIClient : AFHTTPClient
+(FLAPIClient *)sharedClient;
@end
