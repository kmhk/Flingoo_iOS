/*

 
 -(void) viewWillAppear:(BOOL)animated{
 [self hideTabBar:self.tabBarController];
 }
 
 -(void) viewWillDisappear:(BOOL)animated{
 [self showTabBar:self.tabBarController];
 }
 
 
 */

#import <UIKit/UIKit.h>

@interface UIViewController (TabHider)

- (void)showTabBar:(UITabBarController *) tabbarcontroller;
- (void)hideTabBar:(UITabBarController *) tabbarcontroller;

@end
