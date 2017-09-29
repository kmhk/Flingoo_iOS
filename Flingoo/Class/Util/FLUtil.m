//
//  FLUtil.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 11/26/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLUtil.h"
#import "FLButtonWithRadarItem.h"
#import "Config.h"

@implementation FLUtil

+(float)roundFloat:(float)floatValue{
    return round(10 * floatValue) / 10;
}





+(CAAnimationGroup *) appearAnimation{
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.3f];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    fadeInAnimation.duration = 0.2f;
    fadeInAnimation.fillMode = kCAFillModeForwards;
    fadeInAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *zoomOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOutAnimation.fromValue = [NSNumber numberWithFloat:1.5f];
    zoomOutAnimation.toValue = [NSNumber numberWithFloat:0.9f];
    zoomOutAnimation.duration = 0.3f;
    zoomOutAnimation.fillMode = kCAFillModeForwards;
    zoomOutAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:[NSArray arrayWithObjects:fadeInAnimation, zoomOutAnimation, nil]];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.fillMode = kCAFillModeForwards; //if you dont set this it reverts to its old mode before removing and looks really stupid.
    animationGroup.removedOnCompletion = NO;
    
    return animationGroup;
    
    //    [self.animatableView.layer addAnimation:animationGroup forKey:@"lol"];
}


+(CAAnimationGroup *) disappearAnimation{
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //    fadeInAnimation.
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    fadeInAnimation.duration = 0.2f;
    fadeInAnimation.fillMode = kCAFillModeForwards;
    fadeInAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *zoomOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOutAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    zoomOutAnimation.toValue = [NSNumber numberWithFloat:0.9f];
    zoomOutAnimation.duration = 0.2f;
    zoomOutAnimation.fillMode = kCAFillModeForwards;
    zoomOutAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:[NSArray arrayWithObjects:fadeInAnimation, zoomOutAnimation, nil]];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.fillMode = kCAFillModeForwards; //if you dont set this it reverts to its old mode before removing and looks really stupid.
    animationGroup.removedOnCompletion = NO;
    
    return animationGroup;
    //    [self.animatableView.layer addAnimation:animationGroup forKey:@"lol"];
}

+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

+(NSString *)imageNameForUpload:(NSString *)uid
{
        NSString *uuid = [[NSUUID UUID] UUIDString];
        return [NSString stringWithFormat:@"%@-%@",uid,uuid];
}








#pragma mark - UIImage


//maintain the ratio
+ (UIImage *)imageScaledToSize:(CGSize)size image:(UIImage *) sourceImage
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [sourceImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}


+ (UIImage *)imageScaledToFitSize:(CGSize)size image:(UIImage *) sourceImage
{
    //calculate rect
    CGFloat aspect = sourceImage.size.width / sourceImage.size.height;
    if (size.width / aspect <= size.height)
    {
        return [[self class] imageScaledToSize:CGSizeMake(size.width, size.width / aspect) image:sourceImage];
    }
    else
    {
        return [[self class] imageScaledToSize:CGSizeMake(size.height * aspect, size.height) image:sourceImage];
    }
}


#pragma mark - Image Requests

+ (NSMutableURLRequest *)imageRequestWithURL:(NSURL *)url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad; //NSURLRequestUseProtocolCachePolicy
    request.HTTPShouldHandleCookies = NO;
    request.HTTPShouldUsePipelining = YES;
    request.timeoutInterval = 10;
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    return request;
}

#pragma mark -
#pragma mark Radar utils

+ (FLButtonWithRadarItem*)getButtonForRadarItem :(FLRadarObject*)item withItemPoint:(CGPoint)itemPoint{
    UIImage *image;
    
    int itemWidth = 28;
    int itemHight = 28;
    
    switch (item.radarType) {
        case TYPE_GROUP:{
            image = [UIImage imageNamed:@"GroupPoint"];
            itemWidth = 32;
            itemHight = 32;
            NSLog(@"GROUP");
            break;
        }
            
        case TYPE_PROFILE:{
            
            if ([item.userObj.gender isEqualToString:@"female"]) {
                image = [UIImage imageNamed:@"FemalePoint"];
                NSLog(@"GIRL");
            }else{
                image = [UIImage imageNamed:@"MalePoint"];
                NSLog(@"BOY");
            }
            
            break;
        }
            
        case TYPE_FEMALE:{
            
            break;
        }
        
        case TYPE_MEET_POINT:{
            image = [UIImage imageNamed:@"MeetPoint"];
            NSLog(@"MEET POINT");
            break;
        }
            
        case TYPE_TAXI_POINT:{
            image = [UIImage imageNamed:@"TaxiPoint"];
            NSLog(@"TAXI POINT");
            break;
        }
            
        default:
            break;
    }
    
    FLButtonWithRadarItem *btnItem = [[FLButtonWithRadarItem alloc] initWithFrame:CGRectMake(itemPoint.x, itemPoint.y, itemWidth, itemHight)];
    btnItem.center = itemPoint;
    [btnItem setRadarItem:item];
    [btnItem setImage:image forState:UIControlStateNormal];
    [item setButton:btnItem];
    
    return btnItem;
}

+ (float)angleFromCoordinate:(CLLocationCoordinate2D)first
               toCoordinate:(CLLocationCoordinate2D)second {
    
    float deltaLongitude = second.longitude - first.longitude;
    float deltaLatitude = second.latitude - first.latitude;
    float angle = (M_PI * .5f) - atan(deltaLatitude / deltaLongitude);
    
    if (deltaLongitude > 0)      return angle;
    else if (deltaLongitude < 0) return angle + M_PI;
    else if (deltaLatitude < 0)  return M_PI;
    
    return 0.0f;
}

+ (CGPoint)getAngle:(float)angleToGet withDistance:(int)distance{
    float angle = angleToGet * M_PI / 180;
    
    int line_end_x = 152 + cos(angle)*distance;
    
    int line_end_y = 152 + sin(angle)*distance;
    
    return CGPointMake(line_end_x, line_end_y);
}

+(NSDate *)getWebserviceDateFromString:(NSString *)dateString//eg:-2014-01-04T08:01:28+00:00
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:DATE_FORMAT_FORM_WEBSERVICE];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}

+(NSString *)getImageNameForGiftName:(NSString *)giftName
{
    NSString *imgName;
    if ([giftName isEqualToString:@"Vampire Kiss"])
    {
        imgName = @"vampirekiss.PNG";
    }
    else if ([giftName isEqualToString:@"Soft Drink"])
    {
        imgName = @"softd.PNG";
    }
    else if ([giftName isEqualToString:@"Shot"])
    {
        imgName = @"shot.PNG";
    }
    else if ([giftName isEqualToString:@"Long Drink"])
    {
        imgName = @"longd.PNG";
    }
    else if ([giftName isEqualToString:@"Latte Macchiato"])
    {
        imgName = @"lattem.PNG";
    }
    else if ([giftName isEqualToString:@"Kiss"])
    {
        imgName = @"kiss.PNG";
    }
    else if ([giftName isEqualToString:@"Gentleman Kiss"])
    {
        imgName = @"rosekiss.PNG";
    }
    else if ([giftName isEqualToString:@"Fruity Kiss"])
    {
        imgName = @"fruitkiss.PNG";
    }
    else if ([giftName isEqualToString:@"Espresso"])
    {
        imgName = @"espresso.PNG";
    }
    else if ([giftName isEqualToString:@"Diamond Kiss"])
    {
        imgName = @"diamonkiss.PNG";
    }
    else if ([giftName isEqualToString:@"Cocktail"])
    {
        imgName = @"coketail.PNG";
    }
    else if ([giftName isEqualToString:@"Candy Kiss"])
    {
       imgName = @"candykiss.PNG";
    }
    return imgName;
}









#pragma mark - Buttons

+(UIBarButtonItem *) barButtonWithImage:(UIImage *) image target:(id) target action:(SEL) action;{
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backButton = [[UIButton alloc]initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

+(UIBarButtonItem *) backBarButtonWithTarget:(id) target action:(SEL) action;{
    UIImage* btnBackImg = [UIImage imageNamed:@"back_btn.png"];
    CGRect frame = CGRectMake(0, 0, btnBackImg.size.width, btnBackImg.size.height);
    UIButton* backButton = [[UIButton alloc]initWithFrame:frame];
    [backButton setBackgroundImage:btnBackImg forState:UIControlStateNormal];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

+(UIBarButtonItem *) signInBarButtonWithTarget:(id) target action:(SEL) action;{
    UIImage* signinBtnImg = [UIImage imageNamed:@"signin_btn.png"];
    CGRect frameSignin = CGRectMake(0, 0, signinBtnImg.size.width, signinBtnImg.size.height);
    UIButton* signinBtn = [[UIButton alloc]initWithFrame:frameSignin];
    [signinBtn setBackgroundImage:signinBtnImg forState:UIControlStateNormal];
    [signinBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:signinBtn];
}

+(UIBarButtonItem *) logInBarButtonWithTarget:(id) target action:(SEL) action;{
    UIImage* loginBtnImg = [UIImage imageNamed:@"login_btn.png"];
    CGRect frameLogin = CGRectMake(0, 0, loginBtnImg.size.width, loginBtnImg.size.height);
    UIButton* loginBtn = [[UIButton alloc]initWithFrame:frameLogin];
    [loginBtn setBackgroundImage:loginBtnImg forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:loginBtn];
}

@end
