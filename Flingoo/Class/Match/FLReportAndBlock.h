//
//  FLReportAndBlock.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/26/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import "FLOtherProfile.h"
#import "FLWebServiceApi.h"

@interface FLReportAndBlock : FLParentSliderViewController<FLWebServiceDelegate>
{

    IBOutlet UILabel *lblUserName;
}
@property(nonatomic,strong) FLOtherProfile *profileObj;
@end
