//
//  ThumbCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/20/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLVIPCollectionCell.h"
#import <QuartzCore/QuartzCore.h>

#define ONLINE_IMAGE_FRAME CGRectMake(126, 150, 8, 9);
#define OFFLINE_IMAGE_FRAME CGRectMake(128, 150, 6, 11);

@interface FLVIPCollectionCell ()
@end

@implementation FLVIPCollectionCell

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
    self.vipImageView.clipsToBounds = YES;
    self.vipImageView.layer.cornerRadius = 5.0f;
}


@end
