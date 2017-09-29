//
//  FLMenuTopCell.m
//  Flingoo
//
//  Created by Hemal on 11/15/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMenuTopCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FLMenuTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//      self.imgProfilePic.layer.cornerRadius = 60 / 2;
//        self.imgProfilePic.layer.masksToBounds = YES;
        
       

    }
    return self;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.bounds.size.width/2.0f;
//}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeArrowWithUp:(BOOL)up
{

}

@end
