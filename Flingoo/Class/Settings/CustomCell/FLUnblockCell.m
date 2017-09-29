//
//  FLUnblockCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLUnblockCell.h"

@implementation FLUnblockCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}




-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.isButtonActionSet = NO;
    }
    return self;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Unblock"];
    // making text property to underline text-
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    // using text on button
    [self.unblockButton setAttributedTitle: titleString forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
