//
//  FLNotificationCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLNotificationCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FLUtil.h"

@interface FLNotificationCell ()
    @property(nonatomic, copy) NSString *notificationTypeName;

@end


@implementation FLNotificationCell





#pragma mark -
#pragma mark - Initialize

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){

    }
    return self;
}






#pragma mark - Inherit

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}






#pragma mark - MISC

-(void) layoutSubviews;{
    [super layoutSubviews];
    //rounded profile picture
    self.profilePictureView.clipsToBounds = YES;
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.bounds.size.width/2.0f;
    
    //cell labels highlited color
    self.notificationText.highlightedTextColor = [UIColor colorWithRed:95/255.0f green:95/255.0f blue:95/255.0f alpha:1.0f];
    self.timeLabel.highlightedTextColor = [UIColor colorWithRed:124/255.0f green:146/255.0f blue:160/255.0f alpha:1.0f];

}

-(void) setIconType:(IconType)iconType;{
    
    switch (iconType) {
        case kIconTypeChatRequest:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"Not_ChatReq.png"];
        }
            break;
       
            break;
        case kIconTypeFindMeRequest:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"Not_findme.png"];
        }
            break;
        case kIconTypeFriendRequest:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"Not_FrndReq.png"];
        }
            break;
        case kIconTypeTaxiRequest:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"Not_taxiIcon.png"];
        }
            break;
            
        case kIconTypeVampireKiss:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"vampirekiss.PNG"];
        }
            break;
            
        case kIconTypeSoftDrink:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"softd.PNG"];
        }
            break;
        case kIconTypeShot:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"shot.PNG"];
        }
            break;
        case kIconTypeLongDrink:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"longd.PNG"];
        }
            break;
        case kIconTypeLatteMacchiato:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"lattem.PNG"];
        }
            break;
        case kIconTypeKiss:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"kiss.PNG"];
        }
            break;
        case kIconTypeGentlemanKiss:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"rosekiss.PNG"];
        }
            break;
        case kIconTypeFruityKiss:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"fruitkiss.PNG"];
        }
            break;
        case kIconTypeEspresso:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"espresso.PNG"];
        }
            break;
        case kIconTypeDiamondKiss:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"diamonkiss.PNG"];
        }
            break;
        case kIconTypeCocktail:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"coketail.PNG"];
        }
            break;
        case kIconTypeCandyKiss:
        {
            self.notificationIconImageView.image = [UIImage imageNamed:@"candykiss.PNG"];
        }
            break;
        default:
            break;
    }
    
    _iconType = iconType;
}

-(void) setNotificationSenderName:(NSString *) notSender notificationTypeName:(IconType) notificationType{
    
    NSString *notificationTypeName;
    
    
    switch (notificationType) {
        case kIconTypeChatRequest:
        {
            notificationTypeName=@"Chat Request";
        }
            break;
        case kIconTypeFindMeRequest:
        {
            notificationTypeName=@"Find Me Request";
        }
            break;
        case kIconTypeFriendRequest:
        {
            notificationTypeName=@"Friend Request";
        }
            break;
        case kIconTypeVampireKiss:
        {
            notificationTypeName=@"Vampire Kiss";
        }
            break;
        case kIconTypeSoftDrink:
        {
            notificationTypeName=@"Soft Drink";
        }
            break;
        case kIconTypeShot:
        {
            notificationTypeName=@"Shot";
        }
            break;
        case kIconTypeLongDrink:
        {
            notificationTypeName=@"Long Drink";
        }
            break;
        case kIconTypeLatteMacchiato:
        {
            notificationTypeName=@"Latte Macchiato";
        }
            break;
        case kIconTypeKiss:
        {
            notificationTypeName=@"Kiss";
        }
            break;
        case kIconTypeGentlemanKiss:
        {
            notificationTypeName=@"Gentleman Kiss";
        }
            break;
        case kIconTypeFruityKiss:
        {
            notificationTypeName=@"Fruity Kiss";
        }
            break;
        case kIconTypeEspresso:
        {
            notificationTypeName=@"Espresso";
        }
            break;
        case kIconTypeDiamondKiss:
        {
            notificationTypeName=@"Diamond Kiss";
        }
            break;
        case kIconTypeCocktail:
        {
            notificationTypeName=@"Cocktail";
        }
            break;
        case kIconTypeCandyKiss:
        {
            notificationTypeName=@"Candy Kiss";
        }
            break;
        case kIconTypeTaxiRequest:
        {
            notificationTypeName=@"Taxi Request";
        }
            break;
            
        default:
            break;
    }

    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSString *middleText = @" has sent you a ";
    
    NSString *rootString = [NSString stringWithFormat:@"%@%@%@", notSender, middleText, notificationTypeName];
    NSMutableAttributedString *textToDisplay = [[NSMutableAttributedString alloc] initWithString:rootString attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSRange nameRange = NSMakeRange(0, notSender.length);
    NSRange middleRange = NSMakeRange(notSender.length, middleText.length);
    NSRange requestNameRange = NSMakeRange((notSender.length + middleText.length), notificationTypeName.length);
    
    [textToDisplay setAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:nameRange];
    [textToDisplay setAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:requestNameRange];
    
    [textToDisplay addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:95/255.0f green:95/255.0f blue:95/255.0f alpha:1.0f] range:middleRange];
    
    [self.notificationText setAttributedText:textToDisplay];
}

@end
