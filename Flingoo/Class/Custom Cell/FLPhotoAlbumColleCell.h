//
//  FLPhotoAlbumColleCell.h
//  Flingoo
//
//  Created by Hemal on 11/16/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLPhotoAlbumColleCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgCellPic;
@property (strong, nonatomic) IBOutlet UILabel *lblImageDetail;

- (void)setImage:(UIImage*)image;

@end
