//
//  FLPhotoAlbumColleCell.m
//  Flingoo
//
//  Created by Hemal on 11/16/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLPhotoAlbumColleCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FLPhotoAlbumColleCell

//@synthesize imgCellPic,lblImageDetail;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self customInit];
    }
    
    return self;
}

- (void)customInit
{
    self.layer.cornerRadius = 10;
    CGFloat borderWidth = 3.0f;
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.layer.borderColor = [UIColor redColor].CGColor;
    bgView.layer.borderWidth = borderWidth;
    self.selectedBackgroundView = bgView;
}

- (void)setImage:(UIImage*)image
{
//    self.imgCellPic.contentMode = UIViewContentModeScaleAspectFill;
    
    NSLog(@"self.imgCellPic.frame %@",NSStringFromCGRect(self.imgCellPic.frame));
    self.imgCellPic.image = image;
    
    if (!image) {
        self.imgCellPic.image = [UIImage imageNamed:@"photo_vw_bg.png"];
//        self.imgCellPic.contentMode = UIViewContentModeScaleAspectFit;
    }
    
//    self.imgCellPic.layer.cornerRadius=10;
    
    CALayer * l = [self.imgCellPic layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
