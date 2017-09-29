//
//  FLImgObj.h
//  Flingoo
//
//  Created by Hemal on 12/12/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLImgObj : NSObject

@property (nonatomic,strong) NSString *folder_name;
@property(nonatomic,strong) NSData *imgData;
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) NSString *imgContentType;
@property (nonatomic,strong) NSString *albumID;//only use for upload album phtos
@property (nonatomic,strong) NSString *title;//only use for upload album phtos
@end
