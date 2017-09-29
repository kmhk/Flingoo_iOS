//
//  FLCredits.h
//  Flingoo
//
//  Created by Prasad De Zoysa on 1/15/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface FLPurchase : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property(strong) RequestProductsCompletionHandler completionHandler;

@property(nonatomic, retain) SKProductsRequest *productsRequest;

- (id)initWithProductIdentifiers:(NSArray*)plans withProductsCallbackHandler:(RequestProductsCompletionHandler)handler;

-(void)buyCoins;

@end
