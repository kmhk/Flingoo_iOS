//
//  FLBubbleCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLBubbleCell.h"
#import <QuartzCore/QuartzCore.h>

#define PADDING 5



@interface FLBubbleCell ()


@property(nonatomic, strong) IBOutlet UIView *bubbleBottom;
@property(nonatomic, strong) IBOutlet UIView *bubbleContainer;
@property(nonatomic, strong) IBOutlet UIImageView *bubbleBackground;
@property(nonatomic, strong) IBOutlet UILabel *bubbleTextLabel;
@property(nonatomic, strong) IBOutlet UIImageView *correctSignImageView;
@property(nonatomic, strong) IBOutlet UILabel *timeLabel;


@end

@implementation FLBubbleCell

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
        
    }
    
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"layoutSubviews");
    self.profilePictureView.clipsToBounds = YES;
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.bounds.size.width/2.0f;
    
}





#pragma mark - Control Methods

-(void) setSeen:(BOOL)seen{
    self.correctSignImageView.hidden = !seen;
    _seen = seen;
}

-(void)setChatText:(NSString *)chatText{
    _chatText = chatText;
    [self prepare];
}

-(void) setChatTime:(NSString *)chatTime{
    self.timeLabel.text = chatTime;
    
    CGSize expectedTimeLabel = [chatTime sizeWithFont:[UIFont systemFontOfSize:11.0f] constrainedToSize:self.timeLabel.frame.size lineBreakMode:self.timeLabel.lineBreakMode];
    
    CGRect frame = self.correctSignImageView.frame;
    int newX = self.bubbleBottom.frame.size.width - 5 - expectedTimeLabel.width - frame.size.width;
    
    if(newX>=0){
        frame.origin.x =  newX;
        self.correctSignImageView.frame = frame;
    }
    
    _chatTime = chatTime;
}

-(void) alightLeft;{
    CGRect bubbleContainerFrame = self.bubbleContainer.frame;
    bubbleContainerFrame.origin.x = 60;
    self.bubbleContainer.frame = bubbleContainerFrame;
    
    CGRect profilePicRect = self.profilePictureView.frame;
    profilePicRect.origin.x = 6;
    self.profilePictureView.frame = profilePicRect;
    
    CGRect chatLabelFrame = self.bubbleTextLabel.frame;
    chatLabelFrame.origin.x = 24;
    self.bubbleTextLabel.frame = chatLabelFrame;
    
    
    CGRect bubbleBottomFrame = self.bubbleBottom.frame;
    bubbleBottomFrame.origin.x = 24;
    self.bubbleBottom.frame = bubbleBottomFrame;
    
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(28.0f,21.0f, 7.0f, 8.0f);
    self.bubbleBackground.image = [[UIImage imageNamed:@"chat_left_bubble.png"] resizableImageWithCapInsets:capInsets];
}

-(void) alightRight;{
    NSLog(@"alightRight");

    if(IS_IPAD){
        CGRect bubbleContainerFrame = self.bubbleContainer.frame;
        bubbleContainerFrame.origin.x = 114;
        self.bubbleContainer.frame = bubbleContainerFrame;
        
        CGRect profilePicRect = self.profilePictureView.frame;
        profilePicRect.origin.x = 378;
        self.profilePictureView.frame = profilePicRect;
        
    }else{
        CGRect bubbleContainerFrame = self.bubbleContainer.frame;
        bubbleContainerFrame.origin.x = 0;
        self.bubbleContainer.frame = bubbleContainerFrame;
        
        CGRect profilePicRect = self.profilePictureView.frame;
        profilePicRect.origin.x = 264;
        self.profilePictureView.frame = profilePicRect;
        
    }
    

    
    CGRect chatLabelFrame = self.bubbleTextLabel.frame;
    chatLabelFrame.origin.x = 8;
    self.bubbleTextLabel.frame = chatLabelFrame;
    
    
    CGRect bubbleBottomFrame = self.bubbleBottom.frame;
    bubbleBottomFrame.origin.x = 8;
    self.bubbleBottom.frame = bubbleBottomFrame;
    
    
    UIEdgeInsets capInsets =  UIEdgeInsetsMake(27,6,7,20);
    
    self.bubbleBackground.image = [[UIImage imageNamed:@"chat_right_bubble.png"] resizableImageWithCapInsets:capInsets];
}

-(void) prepare{
    
    CGSize maximumLabelSize = CGSizeMake(240, 9999);
    
    CGSize expectedLabelSize = [self.chatText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maximumLabelSize lineBreakMode:self.bubbleTextLabel.lineBreakMode];
    
    if(expectedLabelSize.height>10){
        //adjust the label the the new height.
        CGRect newFrame = self.bubbleTextLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        self.bubbleTextLabel.frame = newFrame;
        
        self.bubbleTextLabel.text = self.chatText;
        
        self.bubbleContainer.frame = [self bubleContainerRectForTextHeight:expectedLabelSize.height];
        
        NSLog(@"%@", NSStringFromCGRect(self.bubbleBottom.frame));
        self.bubbleBottom.frame = [self bubleBottomRectForTextHeight:expectedLabelSize.height];
        NSLog(@"%@", NSStringFromCGRect(self.bubbleBottom.frame));
    }
}






#pragma mark - Helpers

-(CGRect) bubleContainerRectForTextHeight:(CGFloat) height{
    return CGRectMake(self.bubbleContainer.frame.origin.x, self.bubbleContainer.frame.origin.y, self.bubbleContainer.frame.size.width, height + 8 + 18 + 8);
}

-(CGRect) bubleBottomRectForTextHeight:(CGFloat) height{
    return CGRectMake(self.bubbleBottom.frame.origin.x, 12 + height, self.bubbleBottom.frame.size.width, self.bubbleBottom.frame.size.height);
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
