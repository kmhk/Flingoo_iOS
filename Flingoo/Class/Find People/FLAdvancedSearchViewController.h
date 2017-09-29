//
//  FLAdvancedSearchViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/19/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MyView.h"
#import "MBProgressHUD.h"

typedef enum {
    kAdvencedSearch,
    kMatchFilter
}SearchType;

@interface FLAdvancedSearchViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@property(nonatomic, strong) IBOutlet MyView *myView;
@property(nonatomic, assign) SearchType searchType;

- (IBAction)labelSliderChanged:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(SearchType) type;

@end
