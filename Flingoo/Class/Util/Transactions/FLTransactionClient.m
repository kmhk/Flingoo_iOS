//
//  FLTransactionClient.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 1/15/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLTransactionClient.h"
#import "FLWebServiceBlocks.h"

@implementation FLTransactionClient

static FLTransactionClient * sharedInstance;

+ (FLTransactionClient *)sharedInstance:(RequestProductsCompletionHandler)handler{
    
    if (!sharedInstance) {
        
        [FLWebServiceBlocks getCreditPlans:^(NSArray *plans, id error) {
            
            NSLog(@"FLTransactionClient Plans %@", plans);
            
            sharedInstance = [[self alloc] initWithProductIdentifiers:plans withProductsCallbackHandler:handler];
            
        }];
    }
    
    return sharedInstance;
    
}

@end
