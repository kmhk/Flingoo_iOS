//
//  FLDetailSectionTwoCell.h
//  Flingoo
//
//  Created by Hemal on 11/18/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyDetail.h"

@interface FLDetailSectionTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAnswer;
@property (weak,nonatomic) FLMyDetail *currentDetailsObject;
@property (weak, nonatomic) IBOutlet UIImageView *imgDownArrow;
@end
