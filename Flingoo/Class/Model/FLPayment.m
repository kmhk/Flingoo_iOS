//
//  FLPayment.m
//  Flingoo
//
//  Created by Hemal on 12/26/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLPayment.h"

@implementation FLPayment
@synthesize order_type;
@synthesize order_id;
@synthesize transaction_provider;
@synthesize transaction_number;
@synthesize transaction_amount;
@synthesize transaction_status;
@synthesize transaction_message;


-(NSDictionary *)getPaymentJsonObj:(FLPayment *)obj
{
    NSDictionary *payment = @{
    @"order_type":obj.order_type==nil?@"":obj.order_type,
    @"order_id":obj.order_id==nil?@"":obj.order_id,
    @"transaction_provider":obj.transaction_provider==nil?@"":obj.transaction_provider,
    @"transaction_number":obj.transaction_number==nil?@"":obj.transaction_number,
    @"transaction_amount":obj.transaction_amount==nil?@"":obj.transaction_amount,
    @"transaction_status":obj.transaction_status==nil?@"":obj.transaction_status,
    @"transaction_message":obj.transaction_message==nil?@"":obj.transaction_message
    };
    
    NSDictionary *paymentDic = @{
    @"payment" : payment
    };
    return paymentDic;
}

@end
