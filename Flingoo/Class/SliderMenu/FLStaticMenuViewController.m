//
//  UIStaticDemo.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "FLStaticMenuViewController.h"
#import "FLMenuCell.h"
#import "FLMenuTopCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FLVIPUpgradeViewController.h"
#import "FLFreeCreditsViewController.h"
#import "FLSettingsViewController.h"
#import "FLGlobalSettings.h"
#import "FLUtilUserDefault.h"
#import "FLWebServiceApi.h"
#import "Config.h"
#import "FLNotication.h"
#import "FLAppDelegate.h"

@interface FLStaticMenuViewController ()
    @property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation FLStaticMenuViewController

@synthesize delegate;
@synthesize data = _data;
#define CELL_NOTIFICATION_IMG_X 185
#define CELL_NOTIFICATION_IMG_Y 7


- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {

        myDetailsTxtArr=[NSArray arrayWithObjects:@"TopCell",@"Find people",@"Match",@"Live Radar", nil];
        
        myStyTouchTxtArr=[NSArray arrayWithObjects:@"Chat",@"Profile Visitors",@"Favorites",@"Friends",@"Notifications",@"Find Me",@"Settings",@"Sign Out", nil];
        
//        self.selectedIndexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];

    UIView *bgView = [[UIView alloc] init];
//    bgView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    bgView.backgroundColor = [UIColor blackColor];
    [self.tableView setBackgroundView:bgView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    
//    if ([delegate respondsToSelector:@selector(staticDemoDidSelectText:)])
//    {
//        [delegate staticDemoDidSelectText:[myDetailsTxtArr objectAtIndex:3]];
////                self.selectedIndexPath= [NSIndexPath indexPathForRow:3 inSection:0];
////                [self.tableView reloadData];
//    }
    

   
    [self performSelector:@selector(showingRadar) withObject:nil afterDelay:0.1f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profilePicUpdated:)
                                                 name:PROFILE_PICTURE_UPLOADED
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:RECEIVED_NEW_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profileUpdatedNotification)
                                                 name:PROFILE_UPDATED
                                               object:nil];
    FLAppDelegate *appDelegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate callNotificationService];
    
//    FLWebServiceApi *webservice =[[FLWebServiceApi alloc] init];
//    [webservice getNotificationList:self];
    
}

-(void)showingRadar
{
    self.selectedIndexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:YES  scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:self.selectedIndexPath];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0)
    {
        return [myDetailsTxtArr count];
    }
    else
    {
        return [myStyTouchTxtArr count];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifierTop = @"FLMenuTopCell";
    static NSString *CellIdentifier = @"FLMenuCell";

    if ([indexPath row]==0 && [indexPath section]==0) {
        FLMenuTopCell *cell = (FLMenuTopCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierTop];
        
        
        if(cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifierTop owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                if([currentObject isKindOfClass:[FLMenuTopCell class]]){
                    cell = (FLMenuTopCell *)currentObject;
                    break;
                }
            }
        }
//<##>
        UIImage *imageVipBtn = [UIImage imageNamed:@"vip_btn.png"];
        btnVip = [UIButton buttonWithType:UIButtonTypeCustom];
        btnVip.frame = CGRectMake(5,5, imageVipBtn.size.width,imageVipBtn.size.height);
        [btnVip setBackgroundImage:imageVipBtn forState:UIControlStateNormal];
        [btnVip addTarget:self action:@selector(vipClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnVip];
        
        UIImage *imageFreeCrdBtn = [UIImage imageNamed:@"free_creedit_btn.png"];
        btnFreeCrd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFreeCrd.frame = CGRectMake(77,5, imageFreeCrdBtn.size.width,imageFreeCrdBtn.size.height);
        [btnFreeCrd setBackgroundImage:imageFreeCrdBtn forState:UIControlStateNormal];
        [btnFreeCrd addTarget:self action:@selector(freeCreditClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnFreeCrd];
        
        UIImage *imageSettingBtn = [UIImage imageNamed:@"settingBtn.png"];
        btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSetting.frame = CGRectMake(223,5, imageSettingBtn.size.width,imageSettingBtn.size.height);
        [btnSetting setBackgroundImage:imageSettingBtn forState:UIControlStateNormal];
        [btnSetting addTarget:self action:@selector(settingClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnSetting];
        
        cell.lblUserName.text=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
        cell.lblCredit.text=[NSString stringWithFormat:@"$%@",[FLGlobalSettings sharedInstance].current_user_profile.credits_remaining];
        ///////////////////////////////////////
        //get user location
        CLLocationManager *lm = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled]) {
//            lm.delegate = self;
            lm.desiredAccuracy = kCLLocationAccuracyBest;
            lm.distanceFilter = kCLDistanceFilterNone;
            [lm startUpdatingLocation];
            CLLocation *location = [lm location];
            CLGeocoder *gc = [[CLGeocoder alloc] init];
            [gc reverseGeocodeLocation:location completionHandler:^(NSArray *placemark, NSError *error) {
                CLPlacemark *pm = [placemark objectAtIndex:0];
                NSDictionary *address = pm.addressDictionary;
                NSString*frm = [address valueForKey:@"Street"];
                
                NSLog(@"add111 %@", address);
                NSLog(@"AAA111 %@", frm);
                if (frm!=nil)
                {
                     cell.lblAddress.text = [NSString stringWithFormat:@"in %@",frm];
                }
               
            }];

          
        }
        ///////////////////////////////////////
        
//        cell.lblAddress.text=[FLUtilUserDefault getTempUserAddress];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /////////////////////////////////////////
//        if ([FLGlobalSettings sharedInstance].tempFacebookImgUrl!=nil)
//        {
//            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//            dispatch_async(queue, ^{
//                
//                NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[FLGlobalSettings sharedInstance].tempFacebookImgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIImage *image = [UIImage imageWithData:imageData];
//                    cell.imgProfilePic.image=image;
//                });
//            });
//
//        }
        /////////////////////////////////////////
        
        
        //thilina****
        
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
//        NSArray* foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
//        NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
        NSString *imgNameWithPath = [[FLGlobalSettings sharedInstance].current_user_profile.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
        NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
        
        
        //get previous indicator out
        UIView *act = [cell.imgProfilePic viewWithTag:ACT_INDICATOR_TAG];
        
        //if has, then remove it
        if(act){
            [act removeFromSuperview];
        }
        
        __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center    = CGPointMake(cell.imgProfilePic.bounds.size.width/2.0, cell.imgProfilePic.bounds.size.height/2.0);
        activityIndicatorView.tag       = ACT_INDICATOR_TAG;
        
        [cell.imgProfilePic addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
    
        
        [cell.imgProfilePic setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               cell.imgProfilePic.image = image; 
                                               [activityIndicatorView removeFromSuperview];
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                               [activityIndicatorView removeFromSuperview];
                                           }];
        
        
        /*
        if ([FLGlobalSettings sharedInstance].current_user_profile.image!=nil && [[FLGlobalSettings sharedInstance].current_user_profile.image length]>0)
        {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            //get profile pic name without "http://flingoo.s3.amazonaws.com/"
            NSArray* foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
            NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
            
        NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
            
            
            
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                
                NSData * imageData = [NSData dataWithContentsOfURL:profilePicUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithData:imageData];
                    cell.imgProfilePic.image=image;
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                });
            });

        }
        */
        
        /////////////////////////////////////////
        
        CALayer *lyr = cell.imgProfilePic.layer;
        lyr.masksToBounds = YES;
        lyr.cornerRadius = cell.imgProfilePic.frame.size.width / 2; // assumes image is a square
        
        return cell;
    }
    
    FLMenuCell *cell = (FLMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            if([currentObject isKindOfClass:[FLMenuCell class]]){
                cell = (FLMenuCell *)currentObject;
                break;
            }
        }
    }
    
    UIImage *cellImg;
    if ([indexPath section]==0)
    {
        cell.txtMenuTitle.text =[myDetailsTxtArr objectAtIndex:indexPath.row];
        
        switch (indexPath.row) {
            case 1:
                cellImg=[UIImage imageNamed:@"FindPeopleIcon.png"];
                break;
            case 2:
                cellImg=[UIImage imageNamed:@"MatchIcon.png"];
                break;
            case 3:
                cellImg=[UIImage imageNamed:@"radarIcon.png"];
                break;
        }
    }
    else
    {
        cell.txtMenuTitle.text =[myStyTouchTxtArr objectAtIndex:indexPath.row];
        switch (indexPath.row)
        {
    case 0:
        cellImg=[UIImage imageNamed:@"chatIcon.png"];
        break;
    case 1:
        cellImg=[UIImage imageNamed:@"ProfileVisitorsIcon.png"];
        break;
    case 2:
        cellImg=[UIImage imageNamed:@"FavIcon.png"];
        break;
    case 3:
        cellImg=[UIImage imageNamed:@"freindsIcon.png"];
        break;
    case 4:
        cellImg=[UIImage imageNamed:@"NotificationIcon.png"];
                
                int unreadedNotificationCount=0;
                for(id obj in [FLGlobalSettings sharedInstance].notificationArr)
                {
                    FLNotication *notificationObj=(FLNotication *)obj;
                    if (!notificationObj.read_status) {
                        unreadedNotificationCount++;
                    }
                }
                
                if (unreadedNotificationCount>0)//add notification image
                {
                    if (!imgNotificationBubble)
                    {
                        UIImage *img_notification=[UIImage imageNamed:@"NotificationBubble.PNG"];
                        imgNotificationBubble=[[UIImageView alloc] initWithFrame:CGRectMake(CELL_NOTIFICATION_IMG_X,CELL_NOTIFICATION_IMG_Y,img_notification.size.width, img_notification.size.height)];
                        imgNotificationBubble.image=img_notification;
                        
                        lblNoOfNotifications = [[UILabel alloc] initWithFrame:CGRectMake(0,(-2),img_notification.size.width, img_notification.size.height)];
                        lblNoOfNotifications.backgroundColor = [UIColor clearColor];
                        lblNoOfNotifications.textColor=[UIColor whiteColor];
                        [lblNoOfNotifications setFont:[UIFont boldSystemFontOfSize:13]];
                        lblNoOfNotifications.textAlignment=NSTextAlignmentCenter;
                        
                        [imgNotificationBubble addSubview:lblNoOfNotifications];
                    }
                    lblNoOfNotifications.text=[NSString stringWithFormat:@"%i",unreadedNotificationCount];
                    [cell addSubview:imgNotificationBubble];
                }
                else
                {
                    if (imgNotificationBubble)
                    {
                        [imgNotificationBubble removeFromSuperview];
                        imgNotificationBubble=nil;
                    }
                }
        break;
    case 5:
        cellImg=[UIImage imageNamed:@"FindMeIcon.png"];
        break;
    case 6:
        cellImg=[UIImage imageNamed:@"SettingIcon.png"];
        break;
    case 7:
        cellImg=[UIImage imageNamed:@"SignOutIcon.png"];
        break;
    default:
        break;
        }
    }
    
    
    cell.imgMenuCell.image=cellImg;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.unSelectedImageView.image = [[UIImage imageNamed:@"menu_cell_bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0];    
    cell.selectedImageView.image =  [[UIImage imageNamed:@"Seleced.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0];
    if([indexPath compare:self.selectedIndexPath]==NSOrderedSame){
        NSLog(@"select %@==%@", indexPath, self.selectedIndexPath);
        [cell selectMyCell];
    }else{
        NSLog(@"unselect %@!=%@", indexPath, self.selectedIndexPath);
        [cell unselectMyCell];
    }
  
    
    
    
    
    
//    [cell animateMe];
    
//    UIImageView *imgView1 = [[UIImageView alloc]init];
//    imgView1.image=[UIImage imageNamed:@"menu_cell_bg.png"];
//    UIImageView *imgView2 = [[UIImageView alloc]init];
//    imgView2.image=[UIImage imageNamed:@"bgimg.PNG"];
//    
//    cell.backgroundView=imgView1;
//    cell.selectedBackgroundView=imgView2;
//    [cell.backgroundView addSubView:imgView1];
//    [cell.selectedBackgroundView addSubView:imgView2];
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row]==0 && [indexPath section]==0) {
        return 140;
    }
    return 44;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view;
    if (section==0)
    {
//        FlMenuHeaderView *headerView=[[FlMenuHeaderView alloc] initWithNibName:@"FlMenuHeaderView" bundle:nil];
//         view= headerView.view;
        view =nil;
    }
    else
    {
        
        UIImage *img=[UIImage imageNamed:@"menu_seperator.png"];
        
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 265, 24)];
        
        UIImageView *imgview= [[UIImageView alloc] initWithImage:img];
        
        imgview.frame=CGRectMake(0, 0, 265, 24);
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12,0,125,24)];
        label.text = @"Stay in touch";
       [label setFont:[UIFont systemFontOfSize:11]];
        label.backgroundColor = [UIColor clearColor];
//label.backgroundColor = [UIColor redColor];
        label.textColor = [UIColor whiteColor];
        
        
        
        
        [view removeConstraints:view.constraints];
        
        [view addSubview:imgview];
        //Add label to view
        [view addSubview:label];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0)
    {
        return 0;
    }
    return 24;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    btnVip.highlighted=NO;
    btnFreeCrd.highlighted=NO;
    btnSetting.highlighted=NO;
}


#pragma mark - Table view delegate

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
            if([[tableView cellForRowAtIndexPath:indexPath] isMemberOfClass:[FLMenuCell class]]){
                FLMenuCell *cell = (FLMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
                [cell animateMe];
            }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    btnVip.highlighted=NO;
    btnFreeCrd.highlighted=NO;
    btnSetting.highlighted=NO;

    
    
    [self performSelector:@selector(moveAfterAnimation:) withObject:indexPath afterDelay:0.5f];
    if (indexPath.row==7) {
        return;
    }
    [self performSelector:@selector(showSelected:) withObject:indexPath afterDelay:0.9];
}





#pragma mark - Helper Classes
- (void) moveAfterAnimation:(NSIndexPath *)  indexPath{
    if ([delegate respondsToSelector:@selector(staticDemoDidSelectText:)])
    {
        self.selectedIndexPath = indexPath;
        
        NSLog(@"cell:%@",[self.tableView cellForRowAtIndexPath:indexPath]);
        
        if ([indexPath section]==0)
        {
            [delegate staticDemoDidSelectText:[myDetailsTxtArr objectAtIndex:indexPath.row]];
        }
        else
        {
            [delegate staticDemoDidSelectText:[myStyTouchTxtArr objectAtIndex:indexPath.row]];
        }
        
    }
}

-(void) showSelected:(NSIndexPath *)  indexPath{
    if ([delegate respondsToSelector:@selector(staticDemoDidSelectText:)])
    {
        if([[self.tableView cellForRowAtIndexPath:indexPath] isMemberOfClass:[FLMenuCell class]]){
            FLMenuCell *cell = (FLMenuCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            for(UIView *view in cell.subviews){
                NSLog(@"view:%@", view);
            }
            
            [cell selectMyCell];
        }
    
    }
}




#pragma mark - Action

-(void)vipClicked:(id)sender{
    
    FLVIPUpgradeViewController *upgradeViewController = [[FLVIPUpgradeViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLVIPUpgradeViewController-568h":@"FLVIPUpgradeViewController" bundle:nil];
    
    UINavigationController *upgradeNav = [[UINavigationController alloc] initWithRootViewController:upgradeViewController];
    //set navigationbar image
    UIImage *navImage = [UIImage imageNamed:@"navigationbar.png"];
    [upgradeNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];

    [self presentViewController:upgradeNav animated:YES completion:nil];    
}

-(void)freeCreditClicked:(id)sender{
    
    FLFreeCreditsViewController *freeCredits = [[FLFreeCreditsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLFreeCreditsViewController-568h":@"FLFreeCreditsViewController" bundle:nil];
    
    UINavigationController *buyNav = [[UINavigationController alloc] initWithRootViewController:freeCredits];
    UIImage *navImage = [UIImage imageNamed:@"navigationbar.png"];
    [buyNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    
    [self presentViewController:buyNav animated:YES completion:nil];
}

-(void)settingClicked:(id)sender{
    FLSettingsViewController *settingsViewController = [[FLSettingsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLSettingsViewController-568h":@"FLSettingsViewController" bundle:nil launchMode:kSettingsLaunchModeWheel];
    
    UINavigationController *buyNav = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    UIImage *navImage = [UIImage imageNamed:@"navigationbar.png"];
    
    [buyNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    
     [self presentViewController:buyNav animated:YES completion:nil];
    
}

#pragma mark - NSNotification



- (void)profilePicUpdated:(NSNotification *)notification
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    
   FLMenuTopCell *cell = (FLMenuTopCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([FLGlobalSettings sharedInstance].current_user_profile.image!=nil && [[FLGlobalSettings sharedInstance].current_user_profile.image length]>0)
    {
//         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
//        //get profile pic name without "http://flingoo.s3.amazonaws.com/"
//        NSArray* foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
//        NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
//        
//        NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
//        
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//        dispatch_async(queue, ^{
//            
//            NSData * imageData = [NSData dataWithContentsOfURL:profilePicUrl];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIImage *image = [UIImage imageWithData:imageData];
//                cell.imgProfilePic.image=image;
//                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            });
//        });
        
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
//        NSArray* foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
//        NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
        
         NSString *imgNameWithPath = [[FLGlobalSettings sharedInstance].current_user_profile.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
        NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
        
        
        //get previous indicator out
        UIView *act = [cell.imgProfilePic viewWithTag:ACT_INDICATOR_TAG];
        
        //if has, then remove it
        if(act){
            [act removeFromSuperview];
        }
        
        __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center = CGPointMake(cell.imgProfilePic.bounds.size.width/2.0, cell.imgProfilePic.bounds.size.height/2.0);
        activityIndicatorView.tag = ACT_INDICATOR_TAG;
        
        [cell.imgProfilePic addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        
        
        [cell.imgProfilePic setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               cell.imgProfilePic.image = image;
                                               [activityIndicatorView removeFromSuperview];
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                               [activityIndicatorView removeFromSuperview];
                                           }];
        
    }
    
}

-(void)notificationReceived:(NSNotification *)notification
{
    
//    FLWebServiceApi *webservice =[[FLWebServiceApi alloc] init];
//    [webservice getNotificationList:self];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:1];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

-(void)profileUpdatedNotification
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

//-(void)notificationListResult:(NSMutableArray *)notificationArr
//{
//    [[FLGlobalSettings sharedInstance].notificationArr removeAllObjects];
//    [FLGlobalSettings sharedInstance].notificationArr=notificationArr;
////    [self notificationReceived:nil];
//    
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:1];
//    
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                          withRowAnimation:UITableViewRowAnimationNone];
//}


#pragma mark - dealloc

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
