//
//  FLDetailSectionOneCell.h
//  Flingoo
//
//  Created by Hemal on 11/18/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyDetail.h"

@interface FLDetailSectionOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblUserAnswer;
@property (weak, nonatomic) FLMyDetail *currentDetailObj;
@property (weak, nonatomic) IBOutlet UIImageView *imgDownArrow;

@end
