//
//  FLUnblockCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLUnblockCell : UITableViewCell

@property(nonatomic, assign) BOOL isButtonActionSet;

@property(nonatomic, strong) IBOutlet UILabel *profileNameLabel;
@property(nonatomic, strong) IBOutlet UIButton *unblockButton;

@end
