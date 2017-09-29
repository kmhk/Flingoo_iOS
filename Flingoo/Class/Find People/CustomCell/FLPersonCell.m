//
//  FLPersonCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/19/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLPersonCell.h"
#import <QuartzCore/QuartzCore.h>

#define ONLINE_IMAGE_FRAME CGRectMake(74, 12, 8, 9);
#define OFFLINE_IMAGE_FRAME CGRectMake(74, 12, 6, 11);

@interface FLPersonCell ()
    @property(nonatomic, strong) IBOutlet UIImageView *statusImageView;
@end

@implementation FLPersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView.hidden = YES;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){

    }
    return self;
}

-(void) layoutSubviews;{
    [super layoutSubviews];
    self.profilePictureView.clipsToBounds = YES;
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.bounds.size.width/2.0f;

    
    //highlited
    self.profileNameLabel.highlightedTextColor = [UIColor colorWithRed:95/255.0f green:95/255.0f blue:95/255.0f alpha:1.0f];
    self.subtitleLine1.highlightedTextColor = [UIColor colorWithRed:124/255.0f green:146/255.0f blue:160/255.0f alpha:1.0f];
    self.subtitleLine2.highlightedTextColor = [UIColor colorWithRed:124/255.0f green:146/255.0f blue:160/255.0f alpha:1.0f];
}










#pragma mark - 
#pragma mark - Handle State

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











- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
//    self.profileNameLabel.highlighted = NO;
//    self.subtitleLine1.highlighted = NO;
//    self.subtitleLine2.highlighted = NO;
    // Configure the view for the selected state
}

@end
