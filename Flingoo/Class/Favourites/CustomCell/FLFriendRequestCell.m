//
//  FLFriendRequestCell.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLFriendRequestCell.h"
#import <QuartzCore/QuartzCore.h>

#define ONLINE_IMAGE_FRAME CGRectMake(74, 12, 8, 9);
#define OFFLINE_IMAGE_FRAME CGRectMake(74, 12, 6, 11);

@interface FLFriendRequestCell ()
@property(nonatomic, strong) IBOutlet UIImageView *statusImageView;
@end

@implementation FLFriendRequestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView.hidden = YES;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.targetSet = NO;
    }
    return self;
}

-(void) layoutSubviews;{
    [super layoutSubviews];
    self.profilePictureView.clipsToBounds = YES;
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.bounds.size.width/2.0f;
    
    
    //highlited
    self.profileNameLabel.highlightedTextColor = [UIColor colorWithRed:95/255.0f green:95/255.0f blue:95/255.0f alpha:1.0f];
}










#pragma mark -
#pragma mark - Handle State

-(void) setOnline:(BOOL)online{
    if(online){
        self.statusImageView.image = [UIImage imageNamed:@"online.png"];
        self.statusImageView.frame = ONLINE_IMAGE_FRAME;
    }
    else{
        self.statusImageView.image = [UIImage imageNamed:@"offline.png"];
        self.statusImageView.frame = OFFLINE_IMAGE_FRAME;
    }
}











- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
    [super setSelected:selected animated:animated];
    
    //    self.profileNameLabel.highlighted = NO;
    //    self.subtitleLine1.highlighted = NO;
    //    self.subtitleLine2.highlighted = NO;
    // Configure the view for the selected state
}

- (IBAction)rejectClicked:(id)sender {
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi friendshipReject:self withFriendshipId:self.friendship_id];
    
}

- (IBAction)actionClicked:(id)sender {
//    id view = [self superview];
//    
//    while ([view isKindOfClass:[UITableView class]] == NO) {
//        view = [view superview];
//    }
//    
//    UITableView *tableView = (UITableView *)view;
//    
//    HUD=[[MBProgressHUD alloc] initWithView:tableView];
//    [tableView addSubview:HUD];
//	HUD.delegate = self;
//    HUD.labelText = @"Connecting";
//    [HUD show:YES];
    
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
     [webServiceApi friendshipAccept:self withFriendshipId:self.friendship_id];
    
}

#pragma mark -
#pragma mark - Webservice api delegate method

-(void)friendshipAcceptResult:(NSString *)str
{
    NSLog(@"str %@",str);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadFrndReqTbl" object:self];
}

-(void)friendshipRejectResult:(NSString *)str
{
    NSLog(@"str %@",str);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadFrndReqTbl" object:self];
}

#pragma mark- FLWebServiceDelegate Fail
#pragma mark-

-(void)unknownFailureCall
{
    [self showValidationAlert:@"Unknown Error"];
    
}

-(void)requestFailCall:(NSString *)errorMsg
{
    [self showValidationAlert:errorMsg];
}

-(void)showValidationAlert:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}

@end
