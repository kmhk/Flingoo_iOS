//
//  FLFriendView.h
//  Flingoo
//
//  Created by Prasad De Zoysa on 12/6/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLOtherProfile.h"

//@protocol FriendButtonDelegate;

@interface FLFriendView : UIView{
//    id<FriendButtonDelegate> delegate;
    
    CGPoint _originalPosition;
    CGPoint _originalOutsidePosition;
    
    BOOL isInScrollview;
    BOOL isStillScrolling;
    
    // PARENT VIEW WHERE THE VIEWS CAN BE DRAGGED
    UIView *mainView;
    // SCROLL VIEW WHERE YOU GONNA PUT THE THUMBNAILS
    UIScrollView *scrollParent;
    
    
}

//@property (nonatomic, retain) id<FriendButtonDelegate> delegate;

@property (nonatomic) CGPoint originalPosition;

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIScrollView *scrollParent;
@property (nonatomic, retain) FLOtherProfile *profile;
@property (nonatomic, retain) UIImageView *imgv;
@property (nonatomic, assign) int groupSelectedIndex;

- (id)initWithFrame:(CGRect)frame andProfile:(FLOtherProfile*)profile;

@end

//@protocol FriendButtonDelegate
//-(void) touchDown;
//-(void) touchUp;
//-(BOOL) isInsideRecycleBin:(FLFriendView *)button touching:(BOOL)finished;
//-(void)repositionFrom:(FLFriendView*)my;
//@end
