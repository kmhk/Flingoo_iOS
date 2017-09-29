//
//  UIViewController+TabHider.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "UIViewController+TabHider.h"

@implementation UIViewController (TabHider)






- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        CGRect tabFrame = CGRectMake(view.frame.origin.x, [[UIScreen mainScreen] bounds].size.height, view.frame.size.width, view.frame.size.height);
        CGRect viewFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [UIView animateWithDuration:0.5
                                  delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 view.frame = tabFrame;
                             } completion:^(BOOL finished){
                                 
                             }];
        }
        else
        {
            NSLog(@"expand");
            view.frame = viewFrame;
        }
    }  
}






- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    [self performSelector:@selector(showTabBarHelper:) withObject:tabbarcontroller afterDelay:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        
        CGRect tabFrame = CGRectMake(view.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - (20 +49), view.frame.size.width, view.frame.size.height);
        if([view isKindOfClass:[UITabBar class]])
        {
            [UIView animateWithDuration:0.5 animations:^{
                view.frame = tabFrame;
            }];
        }
    }
    
}






-(void) showTabBarHelper:(UITabBarController *) tabbarcontroller{
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        CGRect viewFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - (20 + 49));
        
        if(![view isKindOfClass:[UITabBar class]])
        {
            view.frame = viewFrame;
        }
    }
}

@end
