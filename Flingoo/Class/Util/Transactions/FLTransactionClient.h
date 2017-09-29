//
//  FLTransactionClient.h
//  Flingoo
//
//  Created by Prasad De Zoysa on 1/15/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLPurchase.h"

@interface FLTransactionClient : FLPurchase

+ (FLTransactionClient*)sharedInstance:(RequestProductsCompletionHandler)handler;

@end
