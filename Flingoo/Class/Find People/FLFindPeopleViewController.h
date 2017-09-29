//
//  FLFindPeopleViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/19/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLWebServiceApi.h"
#import "MBProgressHUD.h"

@interface FLFindPeopleViewController : FLParentSliderViewController<FLWebServiceDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *findPeopleArr;
    MBProgressHUD *HUD;
}

@property(weak, nonatomic) IBOutlet UIImageView *otherProfilePicture1;
@property(weak, nonatomic) IBOutlet UIImageView *otherProfilePicture2;


@end


///test