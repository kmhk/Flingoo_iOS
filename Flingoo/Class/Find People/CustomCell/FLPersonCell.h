//
//  FLPersonCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/19/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLPersonCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *profileNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *subtitleLine1;
@property(nonatomic, strong) IBOutlet UILabel *subtitleLine2;
@property(nonatomic, strong) IBOutlet UIImageView *profilePictureView;
@property(nonatomic, assign) BOOL online;


@end
