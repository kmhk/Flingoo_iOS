//
//  FLEarnCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLEarnCell.h"

#define TITLE_RECT_FREE  CGRectMake(74, 15, 217, 21)
#define TITLE_RECT_BUY  CGRectMake(76, 15, 180, 21)
#define SUBTITLE_RECT_FREE CGRectMake(74,31,226,21)
#define SUBTITLE_RECT_BUY CGRectMake(74,31,152,21)

@interface FLEarnCell ()

@property(nonatomic, strong) IBOutlet UIImageView *arrow;
@end

@implementation FLEarnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.earnType = kEarnTypeNone;
        self.isButtonEventSet = NO;
        self.selectedBackgroundView.hidden = YES;
    }
    return self;
}


-(void) layoutSubviews{
    [super layoutSubviews];
    
    //highlited
    self.earnTitleLabel.highlightedTextColor = [UIColor colorWithRed:95/255.0f green:95/255.0f blue:95/255.0f alpha:1.0f];
    self.earnSubtitle.highlightedTextColor = [UIColor colorWithRed:124/255.0f green:146/255.0f blue:160/255.0f alpha:1.0f];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
    
    // Configure the view for the selected state
}

-(void) setEarnType:(EarnType)earnType{
    if(earnType==self.earnType) return;
    if(earnType==kEarnTypeFree){
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.arrow.hidden = NO;
        self.buyButton.hidden = YES;
        self.earnTitleLabel.frame  = TITLE_RECT_FREE;
        self.earnSubtitle.frame = SUBTITLE_RECT_FREE;
    }else{
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.arrow.hidden = YES;
        self.buyButton.hidden = NO;
        self.earnTitleLabel.frame  = TITLE_RECT_BUY;
        self.earnSubtitle.frame = SUBTITLE_RECT_BUY;
    }
    _earnType = earnType;
}

@end
