//
//  FLAdvancedSearchResultsViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 1/16/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLAdvancedSearchResultsViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

-(id) initWithSearchResultsArray:(NSArray *) resultsArray;

@end
