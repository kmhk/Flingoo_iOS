//
//  FLCredits.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 1/15/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLPurchase.h"
#import "FLWebServiceBlocks.h"


@implementation FLPurchase

- (id)initWithProductIdentifiers:(NSArray*)plans withProductsCallbackHandler:(RequestProductsCompletionHandler)handler{
    
    NSLog(@"Plans in Purchase class %@", plans);
    
    NSSet *productIdentifiersSet = [[NSSet alloc] init];
    [productIdentifiersSet setByAddingObjectsFromArray:plans];
    
    _completionHandler = [handler copy];
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiersSet];
    [_productsRequest setDelegate:self];
    [_productsRequest start];
    
    return  self;
}

-(void)buyCoins{
    NSLog(@"Buying");
}

#pragma mark -
#pragma mark - SKProductsRequestDelegate methods

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"Loaded list of products... %@", response);
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers){
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    }
    
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    NSLog(@"skProducts %@", skProducts);
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"Failed to load list of products. %@", [error description]);
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
}

@end
