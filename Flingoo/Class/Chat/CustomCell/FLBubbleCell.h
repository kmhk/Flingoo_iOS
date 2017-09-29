//
//  FLBubbleCell.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLBubbleCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property(nonatomic, strong) NSNumber *chatEntryId;
@property(nonatomic, copy) NSString *chatText;
@property(nonatomic, copy) NSString *chatTime;
@property(nonatomic, assign)BOOL seen;

-(void) prepare;
-(void) alightLeft;
-(void) alightRight;

@end
