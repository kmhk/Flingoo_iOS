//
//  FLSendGiftCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLSendGiftCell.h"

@implementation FLSendGiftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectedBackgroundView.hidden  = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews;{
    [super layoutSubviews];
    //highlited
    self.giftTypeLabel.highlightedTextColor = [UIColor colorWithRed:95/255.0f green:95/255.0f blue:95/255.0f alpha:1.0f];
}

@end
