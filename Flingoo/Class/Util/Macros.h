//
//  Macros.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#ifndef Flingoo_Macros_h
#define Flingoo_Macros_h

#import "FLUtil.h"
#import "UIImageView+AFNetworking.h"

#define IS_IPHONE5 ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] bounds].size.height ==568)
#define ACT_INDICATOR_TAG 982
#define M_PLACE_HOLDER_IMAGE [UIImage imageNamed:@"dummyProPicMale.png"]
#define F_PLACE_HOLDER_IMAGE [UIImage imageNamed:@"dummyProPicFemale.png"]


typedef enum {
    kTableModeTable,
    kTableModeCollection
}TableMode;

typedef enum {
    kLikeYouLockTypeUnlocked,
    kLikeYouLockTypeLocked
}LikeYouLockType;




#ifdef DEBUG
#define NSLog( s, ... ) NSLog( @"%s: %@\n\n", __PRETTY_FUNCTION__,[NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ...)
#endif

#endif
