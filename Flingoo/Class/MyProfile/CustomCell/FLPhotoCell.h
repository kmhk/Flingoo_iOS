//
//  FLPhotoCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLPhotoCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property(nonatomic, strong) IBOutlet UILabel *photoTitleLabel;
@property(nonatomic, strong) IBOutlet UILabel *photoCountLabel;
@property(nonatomic, assign) BOOL shouldShowCount;
@property (strong, nonatomic) IBOutlet UIButton *btnCellDelete;

@end
