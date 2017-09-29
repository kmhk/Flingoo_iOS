//
//  FLMFDetailsViewController.h
//  Flingoo
//
//  Created by Hemal on 11/17/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyDetail.h"
#import "FLParentSliderViewController.h"
#import "FLProfile.h"
#import "FLUserDetail.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"
#import "FLOtherProfile.h"

@interface FLMFDetailsViewController : FLParentSliderViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,FLWebServiceDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITableView *tblMyDetails;
       
    NSMutableArray *myDetailArr;
    UIActionSheet *actionSheet;
    UIPopoverController *popOver;
    UIView *popoverView;
    
    FLMyDetail *selectedDetailObj;
    int pickerSelectedIndex;
    NSIndexPath *selectedIndexPath;
    MBProgressHUD *HUD;
    NSMutableArray *interviewQuesSubmitArr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profile:(NSString *)profile withProfileObj:(FLOtherProfile *)profileObj;
@end
