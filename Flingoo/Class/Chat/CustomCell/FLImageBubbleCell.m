//
//  FLImageBubbleCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLImageBubbleCell.h"
#import <QuartzCore/QuartzCore.h>

@interface FLImageBubbleCell ()

@property(nonatomic, strong) IBOutlet UIView *bubbleContainer;
@property(nonatomic, strong) IBOutlet UIImageView *bubbleBackground;
@property(nonatomic, strong) IBOutlet UIImageView *correctSignImageView;
@property(nonatomic, strong) IBOutlet UILabel *timeLabel;

@property(weak, nonatomic) IBOutlet UIView *innerContent;

@end

@implementation FLImageBubbleCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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

-(void) setChatTime:(NSString *)chatTime{
    self.timeLabel.text = chatTime;
    _chatTime = chatTime;
}

-(void) alightLeft;{
    CGRect bubbleContainerFrame = self.bubbleContainer.frame;
    bubbleContainerFrame.origin.x = 60;
    self.bubbleContainer.frame = bubbleContainerFrame;
    
    CGRect profilePicRect = self.profilePictureView.frame;
    profilePicRect.origin.x = 6;
    self.profilePictureView.frame = profilePicRect;
    
    CGRect innerContentRect = self.innerContent.frame;
    innerContentRect.origin.x = 18;
    self.innerContent.frame = innerContentRect;
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(28.0f,21.0f, 7.0f, 8.0f);
    self.bubbleBackground.image = [[UIImage imageNamed:@"chat_left_bubble.png"] resizableImageWithCapInsets:capInsets];
}

-(void) alightRight;{

    if(IS_IPAD){
        CGRect bubbleContainerFrame = self.bubbleContainer.frame;
        bubbleContainerFrame.origin.x = 226;
        self.bubbleContainer.frame = bubbleContainerFrame;
        
        CGRect profilePicRect = self.profilePictureView.frame;
        profilePicRect.origin.x = 374;
        self.profilePictureView.frame = profilePicRect;
    }else{
        CGRect bubbleContainerFrame = self.bubbleContainer.frame;
        bubbleContainerFrame.origin.x = 112;
        self.bubbleContainer.frame = bubbleContainerFrame;
        
        CGRect profilePicRect = self.profilePictureView.frame;
        profilePicRect.origin.x = 264;
        self.profilePictureView.frame = profilePicRect;
    }
    

    
    CGRect innerContentRect = self.innerContent.frame;
    innerContentRect.origin.x = 4;
    self.innerContent.frame = innerContentRect;
    
    
    UIEdgeInsets capInsets =  UIEdgeInsetsMake(27,6,7,20);
    
    self.bubbleBackground.image = [[UIImage imageNamed:@"chat_right_bubble.png"] resizableImageWithCapInsets:capInsets];
}


@end
