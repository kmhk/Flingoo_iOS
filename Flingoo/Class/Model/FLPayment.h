//
//  FLPayment.h
//  Flingoo
//
//  Created by Hemal on 12/26/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLPayment : NSObject
@property(nonatomic,strong) NSString *order_type;
@property(nonatomic,strong) NSString *order_id;
@property(nonatomic,strong) NSString *transaction_provider;
@property(nonatomic,strong) NSString *transaction_number;
@property(nonatomic,strong) NSString *transaction_amount;
@property(nonatomic,strong) NSString *transaction_status;
@property(nonatomic,strong) NSString *transaction_message;
-(NSDictionary *)getPaymentJsonObj:(FLPayment *)obj;
@end





