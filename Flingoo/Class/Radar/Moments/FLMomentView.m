//
//  FLMomentView.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 12/26/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLMomentView.h"
#import <QuartzCore/QuartzCore.h>
#import "FLRadarObject.h"
#import "FLWebServiceApi.h"
#import "Config.h"

@implementation FLMomentView

- (id)initWithFrame:(CGRect)frame andItem:(FLRadarObject*)item
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 66, 72)];
        [imgV setImage:[UIImage imageNamed:@"background_attachment_picture_preview"]];
        [self addSubview:imgV];
        
        UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 3, 58, 58)];
        imgV2.layer.cornerRadius = 3;
        imgV2.layer.masksToBounds = YES;
        NSLog(@"_item.image %@", item.image);
        
        //Download the image
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
        NSString *imgNameWithPath = [item.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
        NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
        
        
        //get previous indicator out
        UIView *act = [imgV2 viewWithTag:ACT_INDICATOR_TAG];
        
        //if has, then remove it
        if(act){
            [act removeFromSuperview];
        }
        
        __weak UIImageView *weakImageView = imgV2;
        
        __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.center = CGPointMake(imgV2.bounds.size.width/2.0, imgV2.bounds.size.height/2.0);
        activityIndicatorView.tag = ACT_INDICATOR_TAG;
        
        [imgV2 addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        
        NSLog(@"UURL %@", profilePicUrl);
        
        [imgV2 setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             NSLog(@"IMGE %@", image);
                                             weakImageView.image = image;
                                             [activityIndicatorView removeFromSuperview];
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                             NSLog(@"ERR %@", [error description]);
                                             [activityIndicatorView removeFromSuperview];
                                         }];
        
//        [imgV2 setImage:[UIImage imageNamed:item.image]];
        [self addSubview:imgV2];
        
    }
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
