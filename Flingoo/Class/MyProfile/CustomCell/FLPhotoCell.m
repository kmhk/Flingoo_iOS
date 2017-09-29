//
//  FLPhotoCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLPhotoCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FLPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setShouldShowCount:(BOOL)shouldShowCount{
    
    if(shouldShowCount){
        self.photoTitleLabel.frame = CGRectMake(10, 144, 100, 21);
        self.photoCountLabel.hidden = NO;
    }else{
        self.photoTitleLabel.frame = CGRectMake(10, 144, 124, 21);
        self.photoCountLabel.hidden = NO;
    }
    
    _shouldShowCount = shouldShowCount;
}





-(void) layoutSubviews;{
    [super layoutSubviews];
    self.photoImageView.clipsToBounds = YES;
    self.photoImageView.layer.cornerRadius = 5.0f;
}


@end
