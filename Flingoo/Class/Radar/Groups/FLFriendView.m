//
//  FLFriendView.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 12/6/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLFriendView.h"
#import "UIImageView+AFNetworking.h"
#import "FLWebServiceApi.h"


@implementation FLFriendView
//@synthesize delegate;
@synthesize originalPosition = _originalPosition;
@synthesize mainView, scrollParent;


- (id)initWithFrame:(CGRect)frame andProfile:(FLOtherProfile*)profile
{
    self = [super initWithFrame:frame];
    if (self){
        
        isInScrollview	= YES;
        _profile = profile;
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 15, 34, 34)];
        [activityIndicator startAnimating];
        activityIndicator.userInteractionEnabled = NO;
        [self addSubview:activityIndicator];
        
        self.backgroundColor = [UIColor blackColor];
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7;
        
        _imgv = [[UIImageView alloc] init];
        _imgv.contentMode = UIViewContentModeScaleAspectFill;
        _imgv.layer.cornerRadius = 7;
        _imgv.layer.masksToBounds = YES;
        _imgv.frame = CGRectMake(0, 0, 60, 60);
        NSLog(@"IMAGE PATH %@", _profile.image);
        
        __weak UIImageView *weakImageView = self.imgv;
        
        FLWebServiceApi *webServiceApi = [[FLWebServiceApi alloc] init];
        NSArray *foo = [_profile.image componentsSeparatedByString: @"/"];
        NSString *imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
        NSURL *profilePicUrl = [webServiceApi getImageFromName:imgNameWithPath];
        
//        NSURL *profilePicUrl = [NSURL URLWithString:_profile.image];
        [_imgv setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                     placeholderImage:nil
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  //                                        pictureView.image = image;
                                  NSLog(@"DOWN %@", image);
                                  weakImageView.image = image;
//                                  [activityIndicator removeFromSuperview];
                              }
                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                  NSLog(@"Error %@", [error localizedDescription]);
                                  [activityIndicator removeFromSuperview];
                              }];
        
        [self addSubview:_imgv];
    }
    return self;
}

#pragma mark - DRAG AND DROP

/*
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (isStillScrolling) {
        return;
    }
    
    [self.delegate touchDown];
    self.originalPosition = self.center;
    self.scrollParent.scrollEnabled = NO;
    
	if (isInScrollview == YES) {
		CGPoint newLoc = CGPointZero;
        newLoc = [[self superview] convertPoint:self.center toView:self.mainView];
        _originalOutsidePosition = newLoc;
        
        //		[self.superview touchesCancelled:touches withEvent:event];
		[self removeFromSuperview];
        
        self.center = newLoc;
//        [self.mainView setBackgroundColor:[UIColor greenColor]];
		[self.mainView addSubview:self];
        [self.mainView bringSubviewToFront:self];
		isInScrollview = NO;
	}
	else {
		;
	}
    
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (isStillScrolling) {
        return;
    }
    
	[UIView beginAnimations:@"stalk" context:nil];
	[UIView setAnimationDuration:.001];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
	UITouch *touch = [touches anyObject];
	self.center = [touch locationInView: self.superview];
    
	[UIView commitAnimations];
    
    if ([delegate isInsideRecycleBin:self touching:NO]){
        
    }
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (isStillScrolling) {
        return;
    }
    
    if ([delegate isInsideRecycleBin:self touching:YES]){
        [self addFriend:self];
    } else{
        
        [UIView animateWithDuration:0.4f animations:^{
            
            //        _originalOutsidePosition.y = 0;
            self.center = _originalOutsidePosition;
            
        } completion:^(BOOL finished) {
            NSLog(@"ORI X %f | Y %f", _originalPosition.x , _originalPosition.y);
            [self removeFromSuperview];
            self.center = _originalPosition;
            [self.scrollParent addSubview:self];
            isInScrollview = YES;
        }];
    }
    
    [self.delegate touchUp];
    
}

-(void)addFriend:(UIView*)sender{
    
    [UIView animateWithDuration:0.4f animations:^{
        
        sender.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [sender removeFromSuperview];
        [delegate repositionFrom:self];
        
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"BEGIN SCR");
    isStillScrolling = YES;
}

//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    isStillScrolling = YES;
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    isStillScrolling = YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"FINISH SCR");
    isStillScrolling = NO;
}
 
 */

@end
