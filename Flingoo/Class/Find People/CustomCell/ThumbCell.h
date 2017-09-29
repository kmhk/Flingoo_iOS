//
//  ThumbCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/20/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UILabel *profileNameLabel;
@property(weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property(nonatomic, assign) BOOL online;

-(void) hideStatus;
@end
