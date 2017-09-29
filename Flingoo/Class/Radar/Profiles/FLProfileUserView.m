//
//  FLProfileUserView.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 12/31/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLProfileUserView.h"
#import "UIImageView+AFNetworking.h"
#import "FLMFPhotoGalleryViewController.h"
#import "FLProfileViewController.h"
#import "FLUITabBarController.h"
#import "FLMFDetailsViewController.h"
#import "Config.h"
#import <QuartzCore/QuartzCore.h>

@implementation FLProfileUserView

- (id)initWithFrame:(CGRect)frame
{
    self = self = [[[NSBundle mainBundle] loadNibNamed:@"FLProfileUserView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        
    }
    return self;
}

-(id)initWithRadarItem:(FLRadarObject *)radarItem andDelegate:(id)delegate{
    self = self = [[[NSBundle mainBundle] loadNibNamed:@"FLProfileUserView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        _imgProfilePic.layer.cornerRadius = 5;
        _imgProfilePic.layer.masksToBounds = YES;
        
        if (radarItem) {
            NSLog(@"IMAGE >< %@", radarItem.userObj.image);
            
            if ([radarItem.userObj.is_online boolValue]) {
                [_imgOnlinePresence setImage:[UIImage imageNamed:@"online"]];
            }else{
                [_imgOnlinePresence setImage:[UIImage imageNamed:@"offline"]];
            }
            
//            if ([radarItem.userObj.gender isEqualToString:@"male"]) {
//                [_imgProfilePic setImage:M_PLACE_HOLDER_IMAGE];
//            }else{
//                [_imgProfilePic setImage:F_PLACE_HOLDER_IMAGE];
//            }
            
            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicatorView.center = CGPointMake(_imgProfilePic.bounds.size.width/2.0, _imgProfilePic.bounds.size.height/2.0);
//            activityIndicatorView.tag = ACT_INDICATOR_TAG;
            
            [_imgProfilePic addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            
            NSURL *profilePicUrl = [NSURL URLWithString:radarItem.userObj.image];
            
            __weak UIImageView *weakImageView = self.imgProfilePic;
            
            [_imgProfilePic setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                  placeholderImage:[radarItem.userObj.gender isEqualToString:@"male"] ? M_PLACE_HOLDER_IMAGE : F_PLACE_HOLDER_IMAGE
                                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                             
                                                             [weakImageView setImage:image];
                                                             [activityIndicatorView removeFromSuperview];
                                                             
                                                         }
                                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                             [activityIndicatorView removeFromSuperview];
                                                         }];

            
            [_lblUserName setText:radarItem.userObj.full_name];
            [_lblAgeAndDistance setText:[NSString stringWithFormat:@"%d Years, %.01f KM", [radarItem.userObj.age intValue], 10.4f]];
            
            self.delegate = delegate;
            self.itemRadar = radarItem;
        }
        
    }
    return self;
}

#pragma mark - Profiles
#pragma mark -

- (IBAction)loadProfile:(UIButton *)sender {
    NSLog(@"CALLV - %@", [NSString stringWithFormat:@"%@",self.itemRadar.userObj.uid]);
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi userShow:self withUserID:[NSString stringWithFormat:@"%@",_itemRadar.userObj.uid]];
}

-(void)userShowResult:(FLOtherProfile *)profileObj
{
//    [HUD hide:YES];
    [self previewOtherProfile:profileObj];
}

-(void)previewOtherProfile:(FLOtherProfile*)profile{
    if (IS_IPAD)
    {
        NSDictionary *actionDic=@{@"Profile":OTHER_PROFILE,@"ProfileObject":profile};
        NSDictionary *dict = @{RemoteAction:kRemoteActionShowProfile,@"ClickAction":actionDic};
        self.communicator(dict);
    }else
    {
        FLMFDetailsViewController *detailViewCon=[[FLMFDetailsViewController alloc] initWithNibName:@"FLMFDetailsViewController" bundle:nil
                                                                                            profile:OTHER_PROFILE withProfileObj:profile];
        
        UINavigationController *navDetail=[[UINavigationController alloc] initWithRootViewController:detailViewCon];
        
        
        FLProfileViewController *profileViewCon=[[FLProfileViewController alloc] initWithNibName:@"FLProfileViewController" bundle:nil profile:OTHER_PROFILE withProfileObj:profile];
        UINavigationController *navProfile=[[UINavigationController alloc] initWithRootViewController:profileViewCon];
        
        
        FLMFPhotoGalleryViewController *photoGalleryViewCon=[[FLMFPhotoGalleryViewController alloc] initWithNibName:@"FLMFPhotoGalleryViewController" bundle:nil profile:OTHER_PROFILE withProfileObj:profile];
        
        UINavigationController *navPhotoGallery=[[UINavigationController alloc] initWithRootViewController:photoGalleryViewCon];
        
        UIImage *navImage1 = [UIImage imageNamed:@"navigationbar.png"];
        [navDetail.navigationBar setBackgroundImage:navImage1 forBarMetrics:UIBarMetricsDefault];
        
        UIImage *navImage2 = [UIImage imageNamed:@"navigationbar.png"];
        [navProfile.navigationBar setBackgroundImage:navImage2 forBarMetrics:UIBarMetricsDefault];
        
        UIImage *navImage3 = [UIImage imageNamed:@"navigationbar.png"];
        [navPhotoGallery.navigationBar setBackgroundImage:navImage3 forBarMetrics:UIBarMetricsDefault];
        
        FLUITabBarController *tabBarController = [[FLUITabBarController alloc] initWithNibName:nil bundle:nil withProfileObj:profile];
        
        [[tabBarController tabBar] setBackgroundImage:[UIImage imageNamed:nil]];
        [[tabBarController tabBar] setSelectionIndicatorImage:[UIImage imageNamed:nil]];
        
        
        tabBarController.viewControllers = @[navDetail,navProfile,navPhotoGallery];
        
        //    [tabBarController setSelectedIndex:1];
        
        [_delegate presentViewController:tabBarController animated:YES completion:nil];
        
        [tabBarController setSelectedIndex:1];
        
    }
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
