//
//  FLEarnCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kEarnTypeNone ,
    kEarnTypeFree,
    kEarnTypeBuy
}EarnType;

@interface FLEarnCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UIButton *buyButton;
@property(nonatomic, strong) IBOutlet UIImageView *earnImageView;
@property(nonatomic, strong) IBOutlet UILabel *earnTitleLabel;
@property(nonatomic, strong) IBOutlet UILabel *earnSubtitle;
@property(nonatomic, assign) EarnType earnType;

@property(nonatomic, assign) BOOL isButtonEventSet;

@end
