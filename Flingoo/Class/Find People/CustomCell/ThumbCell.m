//
//  ThumbCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/20/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "ThumbCell.h"
#import <QuartzCore/QuartzCore.h>

#define ONLINE_IMAGE_FRAME CGRectMake(126, 150, 8, 9);
#define OFFLINE_IMAGE_FRAME CGRectMake(128, 150, 6, 11);

@interface ThumbCell ()
@property(nonatomic, strong) IBOutlet UIImageView *statusImageView;
@end

@implementation ThumbCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    self.profilePicImageView.clipsToBounds = YES;
    self.profilePicImageView.layer.cornerRadius = 5.0f;
}

-(void) hideStatus;{
    self.statusImageView.hidden = YES;
}











#pragma mark -
#pragma mark - Handle State

-(void) setOnline:(BOOL)online{
    self.statusImageView.hidden = NO;
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
