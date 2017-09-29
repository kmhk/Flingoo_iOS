//
//  FLNotificationCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef enum {
    kIconTypeFindMeRequest = 0,
    kIconTypeTaxiRequest,
    kIconTypeFriendRequest,
    kIconTypeChatRequest,
    kIconTypeVampireKiss,
    kIconTypeCandyKiss,
    kIconTypeDiamondKiss,
    kIconTypeGentlemanKiss,
    kIconTypeFruityKiss,
    kIconTypeKiss,
    kIconTypeSoftDrink,
    kIconTypeShot,
    kIconTypeLongDrink,
    kIconTypeLatteMacchiato,
    kIconTypeEspresso,
    kIconTypeCocktail
}IconType;

@interface FLNotificationCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *profilePictureView;
@property(nonatomic, strong) IBOutlet UILabel *notificationText;
@property(nonatomic, strong) IBOutlet UILabel *timeLabel;
@property(nonatomic, strong) IBOutlet UIImageView *notificationIconImageView;
@property(nonatomic, assign) IconType iconType;


-(void) setNotificationSenderName:(NSString *) notSender notificationTypeName:(IconType) notificationType;


@end
