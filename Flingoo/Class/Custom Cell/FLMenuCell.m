//
//  FLMenuCell.m
//  Flingoo
//
//  Created by Hemal on 11/15/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMenuCell.h"

@implementation FLMenuCell
@synthesize imgMenuCell,txtMenuTitle;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(!selected){
        [self unselectMyCell];
    }
}





-(void) selectMyCell;{
    self.selectedImageView.hidden = NO;
    self.unSelectedImageView.hidden  =YES;
}
-(void) unselectMyCell;{
    self.unSelectedImageView.hidden  = NO;
    self.selectedImageView.hidden = YES;
}


-(void) animateMe{
    [self bringSubviewToFront:self.overlay];
    NSLog(@"animation:%@", txtMenuTitle.text);
    
    [UIView animateWithDuration:0.1
                          delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlay.alpha = 0.7;
                     }
     
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5 animations:^{
                             self.overlay.alpha = 0;
                         }];
                     }];
}

-(NSString *)description{
    return txtMenuTitle.text;
}

@end
