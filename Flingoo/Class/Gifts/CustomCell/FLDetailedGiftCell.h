//
//  FLDetailedGiftCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLDetailedGiftCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UIImageView *smallGiftView;
@property(nonatomic, strong) IBOutlet UIImageView *largeGiftView;
@property(nonatomic, strong) IBOutlet UILabel *giftNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *creditLAbel;
@property(nonatomic, strong) IBOutlet UILabel *countLabel;

@end
