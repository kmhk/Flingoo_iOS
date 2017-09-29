//
//  RightPanelViewController.h
//  NewSructure
//
//  Created by Thilina Hewagama on 11/29/13.
//  Copyright (c) 2013 Thilina Hewagama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTViewController.h"

@interface RightPanelViewController : HTViewController

@property(weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

-(void) setRightPanelTitle:(NSString *) panelTitle;

-(void) showBackbutton;
-(void) hideBackButton;

@end
