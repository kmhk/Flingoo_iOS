//
//  AHDescriptionViewController.h
//  AHIMS
//
//  Created by Prasad De Zoysa on 8/24/12.
//  Copyright (c) 2012 JBMDigital. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AHDescriptionViewController : UIViewController<UITextViewDelegate>{
//    AHCustomButton *imgButton;
    UITextField *txtField;
    UITextView *txtImageComment;
    IBOutlet UIBarButtonItem *btnDone;
//    AHSiteContentViewController *siteContentView;
    
}

@property(nonatomic, retain) UITextField *txtField;

//@property(nonatomic, retain) AHCustomButton *imgButton;
//@property(nonatomic, retain) AHSiteContentViewController *siteContentView;

@end
