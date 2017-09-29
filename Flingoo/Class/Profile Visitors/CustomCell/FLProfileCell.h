//
//  FLProfileCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLProfileCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UILabel *profileNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@property(weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property(nonatomic, assign) BOOL online;


@end
