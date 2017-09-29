//
//  CHDraggingCoordinator.m
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import "CHDraggingCoordinator.h"
#import <QuartzCore/QuartzCore.h>
#import "CHDraggableView.h"
#import "../../Class/Chat/FLChatBubbleBottomViewController.h"
#import "../../Class/Util/FLGlobalSettings.h"
#import "FLChat.h"
#import "Config.h"

typedef enum {
    CHInteractionStateNormal,
    CHInteractionStateConversation
} CHInteractionState;

@interface CHDraggingCoordinator ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSMutableDictionary *edgePointDictionary;;
@property (nonatomic, assign) CGRect draggableViewBounds;
@property (nonatomic, assign) CHInteractionState state;
@property (nonatomic, strong) UINavigationController *presentedNavigationController;
@property (nonatomic, strong) UIView *backgroundView;
@property(nonatomic, strong)  FLChatBubbleBottomViewController *chatBubbleBottom;

@end

@implementation CHDraggingCoordinator

//1
- (id)initWithWindow:(UIWindow *)window draggableViewBounds:(CGRect)bounds
{
    self = [super init];
    if (self) {
//        _window = window;
        
        _window = [UIApplication sharedApplication].keyWindow;
        if (!_window) _window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        
        _draggableViewBounds = bounds;
        _state = CHInteractionStateNormal;
        _edgePointDictionary = [NSMutableDictionary dictionary];
        _chatBubbleBottom = [[FLChatBubbleBottomViewController alloc] initWithNibName:(IS_IPAD)?@"FLChatBubbleBottomViewController-iPad":@"FLChatBubbleBottomViewController" bundle:nil];
        
        //UIInterfaceOrientationLandscapeLeft
        
        NSLog(@"_window: %@,_draggableViewBounds: %@, _state: %d, _edgePointDictionary:%@",_window, NSStringFromCGRect(_draggableViewBounds), _state, _edgePointDictionary);
    }
    return self;
}

#pragma mark - Geometry

//5   //7
- (CGRect)_dropArea
{
        NSLog(@"");
    return CGRectInset([self myBounds], -(int)(CGRectGetWidth(_draggableViewBounds)/6), 0);
}

-(CGRect) myBounds{
    //[self.window.screen applicationFrame]
    CGRect bounds = [[UIScreen mainScreen] bounds]; // portrait bounds
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
    }
    
    return bounds;
}

- (CGRect)_conversationArea
{
        NSLog(@"");
    CGRect slice;
    CGRect remainder;
    CGRectDivide([self myBounds], &slice, &remainder, CGRectGetHeight(CGRectInset(_draggableViewBounds, -10, 0)), CGRectMinYEdge);
    return slice;
}

//6     //9
- (CGRectEdge)_destinationEdgeForReleasePointInCurrentState:(CGPoint)releasePoint
{
        NSLog(@"");
    if (_state == CHInteractionStateConversation) {
        return CGRectMinYEdge;
    } else if(_state == CHInteractionStateNormal) {
        return releasePoint.x < CGRectGetMidX([self _dropArea]) ? CGRectMinXEdge : CGRectMaxXEdge;
    }
    NSAssert(false, @"State not supported");
    return CGRectMinYEdge;
}

//4
- (CGPoint)_destinationPointForReleasePoint:(CGPoint)releasePoint
{
        NSLog(@"");
    CGRect dropArea = [self _dropArea];
    
    CGFloat midXDragView = CGRectGetMidX(_draggableViewBounds);
    CGRectEdge destinationEdge = [self _destinationEdgeForReleasePointInCurrentState:releasePoint];
    CGFloat destinationY;
    CGFloat destinationX;
 
    CGFloat topYConstraint = CGRectGetMinY(dropArea) + CGRectGetMidY(_draggableViewBounds);
    CGFloat bottomYConstraint = CGRectGetMaxY(dropArea) - CGRectGetMidY(_draggableViewBounds);
    if (releasePoint.y < topYConstraint) { // Align ChatHead vertically
        destinationY = topYConstraint;
    }else if (releasePoint.y > bottomYConstraint) {
        destinationY = bottomYConstraint;
    }else {
        destinationY = releasePoint.y;
    }

    if (self.snappingEdge == CHSnappingEdgeBoth){   //ChatHead will snap to both edges
        if (destinationEdge == CGRectMinXEdge) {
            destinationX = CGRectGetMinX(dropArea) + midXDragView;
        } else {
            destinationX = CGRectGetMaxX(dropArea) - midXDragView;
        }
        
    }else if(self.snappingEdge == CHSnappingEdgeLeft){  //ChatHead will snap only to left edge
        destinationX = CGRectGetMinX(dropArea) + midXDragView;
        
    }else{  //ChatHead will snap only to right edge
        destinationX = CGRectGetMaxX(dropArea) - midXDragView;
    }

    return CGPointMake(destinationX, destinationY);
}






#pragma mark - Dragging

- (void)draggableViewHold:(CHDraggableView *)view
{
//        NSLog(@"HOLD---HOLD---HOLD---HOLD---HOLD---HOLD---");
}

- (void)draggableView:(CHDraggableView *)view didMoveToPoint:(CGPoint)point
{
//    NSLog(@"DID MOVE----DID MOVEDID MOVE----DID MOVE----DID MOVE----");
    
    if(!self.chatBubbleBottom.view.superview)[self showBottomPanelForBubble:view];
    
    if (_state == CHInteractionStateConversation) {
        if (_presentedNavigationController) {
            [self _dismissPresentedNavigationController];
        }
    }
}

- (void)draggableViewReleased:(CHDraggableView *)view
{
    NSLog(@"VIEW RELEASED----VIEW RELEASED----VIEW RELEASED----VIEW RELEASED----VIEW RELEASED----");
    
    if(self.chatBubbleBottom.view.superview) [self hideBottomPanelForBubble:view];
    
    if (_state == CHInteractionStateNormal) {
        [self _animateViewToEdges:view];
    }
//    else if(_state == CHInteractionStateConversation) {
//        [self _animateViewToConversationArea:view];
//        [self _presentViewControllerForDraggableView:view];
//    }
}

- (void)draggableViewTouched:(CHDraggableView *)view
{
//        NSLog(@"VIEW TOUCHED-------VIEW TOUCHED-------VIEW TOUCHED-------VIEW TOUCHED-------");
    if (_state == CHInteractionStateNormal) {
        _state = CHInteractionStateConversation;
        [self _animateViewToConversationArea:view];
        
        [self _presentViewControllerForDraggableView:view];
    } else if(_state == CHInteractionStateConversation) {
        _state = CHInteractionStateNormal;
        NSValue *knownEdgePoint = [_edgePointDictionary objectForKey:@(view.tag)];
        if (knownEdgePoint) {
            [self _animateView:view toEdgePoint:[knownEdgePoint CGPointValue]];
        } else {
            [self _animateViewToEdges:view];
        }
        [self _dismissPresentedNavigationController];
    }
}





#pragma mark - Bottom Panel

-(void) showBottomPanelForBubble:(CHDraggableView *) dragView{

    self.chatBubbleBottom.view.alpha = 0;
    
    CGRect tempFrame = self.chatBubbleBottom.view.frame;
    
    if(IS_IPAD){
        tempFrame.origin.y = self.window.bounds.size.width - tempFrame.size.height -20;
    }else{
        tempFrame.origin.y = self.window.bounds.size.height - tempFrame.size.height;
    }
    
    self.chatBubbleBottom.view.frame = tempFrame;
    
    [[[self.window subviews] objectAtIndex:0] insertSubview:self.chatBubbleBottom.view belowSubview:dragView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.chatBubbleBottom.view.alpha = 1.0f;
    }];
}

-(void) hideBottomPanelForBubble:(CHDraggableView *) dragView{
    
//    UIView *view = [self.window viewWithTag:889];
    if(self.chatBubbleBottom.view){
        
        CGRect frameToCompare = [self.window convertRect:self.chatBubbleBottom.dragToHideImageView.frame fromView:self.chatBubbleBottom.view];
        CGRect withFrame = CGRectMake(dragView.frame.origin.x, dragView.frame.origin.y, dragView.frame.size.width, dragView.frame.size.height);
        
        if(CGRectIntersectsRect(frameToCompare, withFrame)){
            //bubble on bottom panel, You can delete hide that chat now
            [_presentedNavigationController.view removeFromSuperview];
            [dragView removeFromSuperview];
            NSLog(@"👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍");
            
            for (FLChat *currentChatObj in [FLGlobalSettings sharedInstance].chatBubbleObjArr)
            {
                if ([currentChatObj.chatObj_id isEqualToString:[NSString stringWithFormat:@"%i",dragView.tag]] && [currentChatObj.message_type isEqualToString:dragView.chatType])
                {                    
                    [[FLGlobalSettings sharedInstance].chatBubbleObjArr removeObject:currentChatObj];
                }
            }
            
//            int indexToRemove = dragView.tag -1;
//            NSLog(@"indexToRemove: %d", indexToRemove);
//            if(indexToRemove>=0 && indexToRemove<[FLGlobalSettings sharedInstance].chatBubbleObjArr.count){
//                [[FLGlobalSettings sharedInstance].chatBubbleObjArr removeObjectAtIndex:(dragView.tag - 1)];
//            }
            

            
        }else{
            //bbubble not on the bottom panel
            NSLog(@"❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌");
        }
        
        [self.chatBubbleBottom.view removeFromSuperview];
    }
}







#pragma mark - Alignment

//2
- (void)draggableViewNeedsAlignment:(CHDraggableView *)view
{
    NSLog(@"Align view");
    [self _animateViewToEdges:view];
    
}






#pragma mark Dragging Helper

//3
- (void)_animateViewToEdges:(CHDraggableView *)view
{
        NSLog(@"");
    CGPoint destinationPoint = [self _destinationPointForReleasePoint:view.center];    
    [self _animateView:view toEdgePoint:destinationPoint];
    
}

//8
- (void)_animateView:(CHDraggableView *)view toEdgePoint:(CGPoint)point
{
        NSLog(@"");
    [_edgePointDictionary setObject:[NSValue valueWithCGPoint:point] forKey:@(view.tag)];
    [view snapViewCenterToPoint:point edge:[self _destinationEdgeForReleasePointInCurrentState:view.center]];
    
}

- (void)_animateViewToConversationArea:(CHDraggableView *)view
{
        NSLog(@"");
    CGRect conversationArea = [self _conversationArea];
    CGPoint center = CGPointMake(CGRectGetMidX(conversationArea), CGRectGetMidY(conversationArea));
    [view snapViewCenterToPoint:center edge:[self _destinationEdgeForReleasePointInCurrentState:view.center]];
}






#pragma mark - View Controller Handling

- (CGRect)_navigationControllerFrame
{
    NSLog(@"");
    CGRect slice;
    CGRect remainder;
    CGRectDivide([self myBounds], &slice, &remainder, CGRectGetMaxY([self _conversationArea]), CGRectMinYEdge);
    remainder.origin.y = remainder.origin.y - 20;
    remainder.size.height = remainder.size.height + 20;
    return remainder;
}

- (CGRect)_navigationControllerHiddenFrame
{
        NSLog(@"");
    return CGRectMake(CGRectGetMidX([self _conversationArea]), CGRectGetMaxY([self _conversationArea]), 0, 0);
}

- (void)_presentViewControllerForDraggableView:(CHDraggableView *)draggableView
{
        NSLog(@"");
    UIViewController *viewController = [_delegate draggingCoordinator:self viewControllerForDraggableView:draggableView];
    NSLog(@"viewController: %@", viewController);
    _presentedNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    NSLog(@"_presentedNavigationController: %@", _presentedNavigationController);
    [_presentedNavigationController setNavigationBarHidden:YES];
    _presentedNavigationController.view.layer.cornerRadius = 3;
    _presentedNavigationController.view.layer.masksToBounds = YES;
    _presentedNavigationController.view.layer.anchorPoint = CGPointMake(0.5f, 0);
    _presentedNavigationController.view.frame = [self _navigationControllerFrame];
    _presentedNavigationController.view.transform = CGAffineTransformMakeScale(0, 0);
    
//    [self.window insertSubview:_presentedNavigationController.view belowSubview:draggableView];
    [[[_window subviews] objectAtIndex:0] insertSubview:_presentedNavigationController.view belowSubview:draggableView];
    
    NSLog(@"draggable view: %@", NSStringFromCGRect(draggableView.frame));
    NSLog(@"chatView:%@", NSStringFromCGRect(_presentedNavigationController.view.frame));
    
    [self _unhidePresentedNavigationControllerCompletion:^{}];
}

- (void)_dismissPresentedNavigationController
{
        NSLog(@"");
    UINavigationController *reference = _presentedNavigationController;
    [self _hidePresentedNavigationControllerCompletion:^{
        [reference.view removeFromSuperview];
    }];
    _presentedNavigationController = nil;
}

- (void)_unhidePresentedNavigationControllerCompletion:(void(^)())completionBlock
{
        NSLog(@"");
    CGAffineTransform transformStep1 = CGAffineTransformMakeScale(1.1f, 1.1f);
    CGAffineTransform transformStep2 = CGAffineTransformMakeScale(1, 1);
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self.window bounds].size.height, [self.window bounds].size.width)];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5f];
    _backgroundView.alpha = 0.0f;
//    [self.window insertSubview:_backgroundView belowSubview:_presentedNavigationController.view];
        [[[_window subviews] objectAtIndex:0] insertSubview:_backgroundView belowSubview:_presentedNavigationController.view];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _presentedNavigationController.view.layer.affineTransform = transformStep1;
        _backgroundView.alpha = 1.0f;
    }completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.3f animations:^{
                _presentedNavigationController.view.layer.affineTransform = transformStep2;
            }];
        }
    }];
}

- (void)_hidePresentedNavigationControllerCompletion:(void(^)())completionBlock
{
        NSLog(@"");
    UIView *viewToDisplay = _backgroundView;
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _presentedNavigationController.view.transform = CGAffineTransformMakeScale(0, 0);
        _presentedNavigationController.view.alpha = 0.0f;
        _backgroundView.alpha = 0.0f;
    } completion:^(BOOL finished){
        if (finished) {
            [viewToDisplay removeFromSuperview];
            if (viewToDisplay == _backgroundView) {
                _backgroundView = nil;
            }
            completionBlock();
        }
    }];
}










@end
