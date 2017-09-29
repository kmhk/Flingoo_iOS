//
//  FLRegAddInfoViewController.h
//  Flingoo
//
//  Created by Hemal on 11/11/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLRegAddInfoViewController : UIViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
  
    IBOutlet UIButton *btnImMale;
    IBOutlet UIButton *btnImFemale;
    IBOutlet UIButton *btnLookingMen;
    IBOutlet UIButton *btnLookingWomen;
    IBOutlet UIButton *btnLookingBoth;
    IBOutlet UIButton *btnWhoAreMen;
    IBOutlet UIButton *btnWhoAreWomen;
    IBOutlet UIButton *btnWhoAreBoth;
    
    BOOL imMale;
    BOOL imFemale;
    BOOL lookingMen;
    BOOL lookingWomen;
    BOOL lookingBoth;
    BOOL whoAreMen;
    BOOL whoAreWomen;
    BOOL whoAreBoth;
    
    IBOutlet UIImageView *imgBg;
    
    MBProgressHUD *HUD;
    
    NSString *lookingFor;
    NSString *gender;
    NSString *whoLookingFor;
    int lookingAgeMin;
    int lookingAgeMax;
}

@property (weak, nonatomic) IBOutlet NMRangeSlider *sliderAge;
- (IBAction)labelSliderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;
- (IBAction)imClicked:(id)sender;
- (IBAction)lookingForClicked:(id)sender;
- (IBAction)whoAreClicked:(id)sender;






@end
