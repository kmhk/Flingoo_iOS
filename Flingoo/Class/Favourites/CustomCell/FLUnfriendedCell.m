//
//  FLUnfriendedCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLUnfriendedCell.h"
#import <QuartzCore/QuartzCore.h>

#define ONLINE_IMAGE_FRAME CGRectMake(74, 17, 8, 9);
#define OFFLINE_IMAGE_FRAME CGRectMake(74, 17, 6, 11);





@interface FLUnfriendedCell ()
@property(nonatomic, strong) IBOutlet UIImageView *statusImageView;
@end






@implementation FLUnfriendedCell




#pragma mark -
#pragma mark - Initialize

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView.hidden = YES;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){

    }
    return self;
}





#pragma mark - Inherit

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    return; //diable cell click
    [super setSelected:selected animated:animated];
}






#pragma mark - MISC

-(void) layoutSubviews;{
    [super layoutSubviews];
    self.profilePictureView.clipsToBounds = YES;
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.bounds.size.width/2.0f;
    
    //highlited
    self.profileNameLabel.highlightedTextColor = [UIColor colorWithRed:95/255.0f green:95/255.0f blue:95/255.0f alpha:1.0f];
    self.subtitleLabel.highlightedTextColor = [UIColor colorWithRed:124/255.0f green:146/255.0f blue:160/255.0f alpha:1.0f];
    self.timeLabel.highlightedTextColor = [UIColor lightGrayColor];

}

-(void) setOnline:(BOOL)online{
    if(online){
        self.statusImageView.image = [UIImage imageNamed:@"online.png"];
        self.statusImageView.frame = ONLINE_IMAGE_FRAME;
    }
    else{
        self.statusImageView.image = [UIImage imageNamed:@"offline.png"];
        self.statusImageView.frame = OFFLINE_IMAGE_FRAME;
    }
}


@end

