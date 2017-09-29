//
//  FLUtil.h
//  Flingoo
//
//  Created by Prasad De Zoysa on 11/26/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "FLRadarObject.h"
#import "FLButtonWithRadarItem.h"

@interface FLUtil : NSObject

+(float)roundFloat:(float)floatValue;

//animations
+(CAAnimationGroup *) disappearAnimation;
+(CAAnimationGroup *) appearAnimation;

//image upload
+ (NSString *)contentTypeForImageData:(NSData *)data;
+(NSString *)imageNameForUpload:(NSString *)uid;

//util
+ (UIImage *)imageScaledToSize:(CGSize)size image:(UIImage *) sourceImage;
+ (UIImage *)imageScaledToFitSize:(CGSize)size image:(UIImage *) sourceImage;

//image requests

+ (NSMutableURLRequest *)imageRequestWithURL:(NSURL *)url;

//Radar services
+ (FLButtonWithRadarItem*)getButtonForRadarItem :(FLRadarObject*)item withItemPoint:(CGPoint)itemPoint;
+ (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second;
+ (CGPoint)getAngle:(float)angleToGet withDistance:(int)distance;

//webservice date string to nsdate
+(NSDate *)getWebserviceDateFromString:(NSString *)dateString;

//get gift image name for gift name
+(NSString *)getImageNameForGiftName:(NSString *)giftName;


+(UIBarButtonItem *) barButtonWithImage:(UIImage *) image target:(id) target action:(SEL) action;
+(UIBarButtonItem *) backBarButtonWithTarget:(id) target action:(SEL) action;
+(UIBarButtonItem *) signInBarButtonWithTarget:(id) target action:(SEL) action;
+(UIBarButtonItem *) logInBarButtonWithTarget:(id) target action:(SEL) action;

@end
