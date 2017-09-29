//
//  FLNotificationCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kNotificationTypeFindMeRequest,
    kNotificationTypeTaxiRequest,
    kNotificationTypeFriendRequest,
    kNotificationTypeChatRequest,
    kNotificationTypeMilkCoffee,
    kNotificationTypeKiss
}NotificationType;

@interface FLNotificationCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *profilePictureView;
@property(nonatomic, strong) IBOutlet UILabel *notificationText;
@property(nonatomic, strong) IBOutlet UILabel *timeLabel;
@property(nonatomic, strong) IBOutlet UIImageView *notificationIconImageView;
@property(nonatomic, assign) NotificationType notificationType;
@property(nonatomic, assign) BOOL graphicsReady;

-(void) makeGraphicsReady;

@end
