//
//  FLMyGiftCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FLMyGiftCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *profileNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@property(nonatomic, strong) IBOutlet UILabel *timeLabel;
@property(nonatomic, strong) IBOutlet UIImageView *profilePictureView;
@property(nonatomic, strong) IBOutlet UIImageView *giftPictureView;
@property(nonatomic, strong) IBOutlet UIButton *giftPictureViewButton;
@property(nonatomic, assign) BOOL online;


@end
