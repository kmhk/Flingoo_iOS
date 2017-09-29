//
//  FLMenuCell.h
//  Flingoo
//
//  Created by Hemal on 11/15/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgMenuCell;
@property (weak, nonatomic) IBOutlet UILabel *txtMenuTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;


@property(weak, nonatomic) IBOutlet UIImageView *unSelectedImageView;
@property(weak, nonatomic) IBOutlet UIImageView *selectedImageView;

-(void) selectMyCell;
-(void) unselectMyCell;

@property(weak, nonatomic) IBOutlet UIView *overlay;

-(void) animateMe;

@end
