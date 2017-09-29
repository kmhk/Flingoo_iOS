//
//  LeftPanelViewController.m
//  NewSructure
//
//  Created by Thilina Hewagama on 11/29/13.
//  Copyright (c) 2013 Thilina Hewagama. All rights reserved.
//

#import "LeftPanelViewController.h"
#import "FLMenuTopCell.h"
#import "MainCell_iPad.h"
#import "SubCell_iPad.h"
#import "GroupHeaderCell_iPad.h"
#import "MBProgressHUD.h"
#import "FLWebServiceApi.h"
#import "FLGlobalSettings.h"
#import "FLUtilUserDefault.h"
#import "Config.h"
#import "FLNotication.h"
#import "FLAppDelegate.h"


@interface LeftPanelViewController ()<MBProgressHUDDelegate>{
    
}

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (assign)BOOL isOpen;
@property (strong, nonatomic) IBOutlet UITableView *tblMenu;
@property (nonatomic,retain)NSIndexPath *selectIndex;
@end

@implementation LeftPanelViewController
@synthesize isOpen,selectIndex;

#define CELL_NOTIFICATION_IMG_X 185
#define CELL_NOTIFICATION_IMG_Y 7












#pragma mark - Initialize

- (id) init{
    if (self = [super initWithNibName:@"SDNestedTableView" bundle:nil])
        {
        // do init stuff
        }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}










#pragma mark - View Lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"iPadLeftMenu" ofType:@"plist"];
    _dataList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSLog(@"%@",path);
    
    self.tblMenu.sectionFooterHeight = 0;
    self.tblMenu.sectionHeaderHeight = 0;
    self.isOpen = NO;
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"sideBarBg.png"]];
    self.tblMenu.backgroundColor = background;
    
    self.tblMenu.separatorColor = [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0];
    
    ////////set location
    _locationManager=[[CLLocationManager alloc] init];
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // We listen to events from the locationManager
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profilePicUpdated:)
                                                 name:PROFILE_PICTURE_UPLOADED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:RECEIVED_NEW_NOTIFICATION
                                               object:nil];
    
    FLAppDelegate *appDelegate=(FLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate callNotificationService];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}











#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
        {
        FLUserLocation *userLocationObj=[[FLUserLocation alloc] init];
        userLocationObj.latitude=[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        userLocationObj.longitude=[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        userLocationObj.is_online=YES;
        [_locationManager stopUpdatingLocation];
        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
        [webService userLocationSet:self withUserData:userLocationObj];
        }
}

/*
 
 - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
 {
 NSLog(@"didFailWithError: %@", error);
 UIAlertView *errorAlert = [[UIAlertView alloc]
 initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"failed_get_your_location", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
 [errorAlert show];
 }

 
 */

/*
 
 
 #pragma mark - Nested Tables methods
 
 - (NSInteger)mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section
 {
 return 8;
 }
 
 - (NSInteger)mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
 {
 return 3;
 }
 
 - (SDGroupCell *)mainTable:(UITableView *)mainTable setItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 item.itemText.text = [NSString stringWithFormat:@"My Main Item %u", indexPath.row +1];
 return item;
 }
 
 - (SDSubCell *)item:(SDGroupCell *)item setSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 subItem.itemText.text = [NSString stringWithFormat:@"My Sub Item %u", indexPath.row +1];
 return subItem;
 }
 
 - (void) mainTable:(UITableView *)mainTable itemDidChange:(SDGroupCell *)item
 {
 SelectableCellState state = item.selectableCellState;
 NSIndexPath *indexPath = [self.tableView indexPathForCell:item];
 switch (state) {
 case Checked:
 NSLog(@"Changed Item at indexPath:%@ to state \"Checked\"", indexPath);
 break;
 case Unchecked:
 NSLog(@"Changed Item at indexPath:%@ to state \"Unchecked\"", indexPath);
 break;
 case Halfchecked:
 NSLog(@"Changed Item at indexPath:%@ to state \"Halfchecked\"", indexPath);
 break;
 default:
 break;
 }
 }
 
 - (void) item:(SDGroupCell *)item subItemDidChange:(SDSelectableCell *)subItem
 {
 SelectableCellState state = subItem.selectableCellState;
 NSIndexPath *indexPath = [item.subTable indexPathForCell:subItem];
 switch (state) {
 case Checked:
 NSLog(@"Changed Sub Item at indexPath:%@ to state \"Checked\"", indexPath);
 break;
 case Unchecked:
 NSLog(@"Changed Sub Item at indexPath:%@ to state \"Unchecked\"", indexPath);
 break;
 default:
 break;
 }
 }
 
 - (void)expandingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
 {
 NSLog(@"Expanded Item at indexPath: %@", indexPath);
 }
 
 - (void)collapsingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
 {
 NSLog(@"Collapsed Item at indexPath: %@", indexPath);
 }

 
 */






#pragma mark - Notification

- (void)profilePicUpdated:(NSNotification *) notification{
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    
    FLMenuTopCell *cell = (FLMenuTopCell *)[self.tblMenu cellForRowAtIndexPath:indexPath];
    if ([FLGlobalSettings sharedInstance].current_user_profile.image!=nil && [[FLGlobalSettings sharedInstance].current_user_profile.image length]>0)
        {
        
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

- (void)notificationReceived:(NSNotification *)notification{
    
    //<##>
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:9];
    //    [self.tblMenu reloadData];
    [self.tblMenu reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                        withRowAnimation:UITableViewRowAnimationNone];
    
}











//-(void)notificationListResult:(NSMutableArray *)notificationArr
//{
//    [[FLGlobalSettings sharedInstance].notificationArr removeAllObjects];
//    [FLGlobalSettings sharedInstance].notificationArr=notificationArr;
//    [self notificationReceived:nil];
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return [[[_dataList objectAtIndex:section] objectForKey:@"list"] count]+1;;
        }
    }
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!(self.isOpen && self.selectIndex.section == indexPath.section && indexPath.row !=0) && [[[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"] isEqualToString:@"TopCell"]){
        return 140;
    }
    else if (!(self.isOpen && self.selectIndex.section == indexPath.section && indexPath.row !=0) && [[[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"] isEqualToString:@"Stay in Touch"]){
        return 24;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"CELL FOR INDEX PATH: %@", indexPath);
    NSLog(@"SELECTED INDEX PATH:%@", self.selectedIndexPath);
    
    if([indexPath compare:self.selectedIndexPath]==NSOrderedSame){
        NSLog(@"SAME_1");
    }
    
    if(indexPath.section==self.selectedIndexPath.section && indexPath.row==self.selectedIndexPath.row){
        NSLog(@"SAME_2");
    }
    
    if (self.isOpen && self.selectIndex.section == indexPath.section && indexPath.row !=0) {
        
        
        static NSString *CellIdentifier = @"SubCell_iPad";
        SubCell_iPad *cell = (SubCell_iPad *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSArray *list = [[_dataList objectAtIndex:self.selectIndex.section] objectForKey:@"list"];
        cell.titleLabel.text = [list objectAtIndex:indexPath.row-1];
        
        //        [cell.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
        //-----------Thilina---------------->>
        if([indexPath compare:self.selectedIndexPath]==NSOrderedSame){
            NSLog(@"MAKING CELL RED");
            [cell setBackgroundColor:[UIColor redColor]];
        }else{
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        //-----------Thilina---------------->>
        
        return cell;
        
        
        
    }else{
        NSString *name = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"];
        if ([name isEqualToString:@"TopCell"]) {
            static NSString *CellIdentifier = @"FLMenuTopCell";
            FLMenuTopCell *cell = (FLMenuTopCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            
            cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.bounds.size.width/2.0f;
            cell.imgProfilePic.layer.masksToBounds = YES;
            
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
            btnSetting.frame = CGRectMake(228,5, imageSettingBtn.size.width,imageSettingBtn.size.height);
            [btnSetting setBackgroundImage:imageSettingBtn forState:UIControlStateNormal];
            [btnSetting addTarget:self action:@selector(settingClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnSetting];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lblUserName.text=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
            //            cell.lblAddress.text=[FLUtilUserDefault getTempUserAddress];
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
                    
                    NSLog(@"add %@", address);
                    NSLog(@"AAA %@", frm);
                    
                    if (frm!=nil)
                        {
                        cell.lblAddress.text = [NSString stringWithFormat:@"in %@",frm];
                        }
                }];
                
                
            }
            ///////////////////////////////////////
            
            
            
            
            
            
            
            //            if ([FLGlobalSettings sharedInstance].tempFacebookImgUrl!=nil)
            //            {
            //                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            //                dispatch_async(queue, ^{
            //
            //                    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[FLGlobalSettings sharedInstance].tempFacebookImgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            //                    dispatch_async(dispatch_get_main_queue(), ^{
            //                        UIImage *image = [UIImage imageWithData:imageData];
            //                        cell.imgProfilePic.image=image;
            //                    });
            //                });
            //
            //            }
            
            
            //thilina****
            
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            //            NSArray* foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
            //            NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
            
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
            
            
            
            //-----------Thilina---------------->>
            if([indexPath compare:self.selectedIndexPath]==NSOrderedSame){
                NSLog(@"MAKING CELL RED");
                [cell setBackgroundColor:[UIColor redColor]];
            }else{
                [cell setBackgroundColor:[UIColor clearColor]];
            }
            //-----------Thilina---------------->>
            
            return cell;
        }
        else if([name isEqualToString:@"Stay in Touch"])
            {
            static NSString *CellIdentifier = @"GroupHeaderCell_iPad";
            GroupHeaderCell_iPad *cell = (GroupHeaderCell_iPad *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            //            NSArray *list = [[_dataList objectAtIndex:self.selectIndex.section] objectForKey:@"list"];
            cell.titleLabel.text = name;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //-----------Thilina---------------->>
            if([indexPath compare:self.selectedIndexPath]==NSOrderedSame){
                NSLog(@"MAKING CELL RED");
                [cell setBackgroundColor:[UIColor redColor]];
            }else{
                [cell setBackgroundColor:[UIColor clearColor]];
            }
            //-----------Thilina---------------->>
            
            return cell;
            }
        else
            {
            static NSString *CellIdentifier = @"MainCell_iPad";
            MainCell_iPad *cell = (MainCell_iPad *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            
            cell.titleLabel.text = name;
            
            //            [cell.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            //            [cell.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            
            [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
            
            if ([name isEqualToString:@"Find People"])cell.imgIcon.image=[UIImage imageNamed:@"FindPeopleIcon.png"];
            else if ([name isEqualToString:@"Match"])cell.imgIcon.image=[UIImage imageNamed:@"MatchIcon.png"];
            else if ([name isEqualToString:@"Live Radar"])cell.imgIcon.image=[UIImage imageNamed:@"radarIcon.png"];
            else if ([name isEqualToString:@"Chat"])cell.imgIcon.image=[UIImage imageNamed:@"chatIcon.png"];
            else if ([name isEqualToString:@"Profile Visitors"])cell.imgIcon.image=[UIImage imageNamed:@"ProfileVisitorsIcon.png"];
            else if ([name isEqualToString:@"Favourites"])cell.imgIcon.image=[UIImage imageNamed:@"FavIcon.png"];
            else if ([name isEqualToString:@"Contacts"])cell.imgIcon.image=[UIImage imageNamed:@"freindsIcon.png"];
            else if ([name isEqualToString:@"Notifications"]){
                NSLog(@"indexPath %@",indexPath);
                cell.imgIcon.image=[UIImage imageNamed:@"NotificationIcon.png"];
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
                
                
                
            }
            else if ([name isEqualToString:@"Find Me"])cell.imgIcon.image=[UIImage imageNamed:@"FindMeIcon.png"];
            else if ([name isEqualToString:@"Settings"])cell.imgIcon.image=[UIImage imageNamed:@"SettingIcon.png"];
            else if ([name isEqualToString:@"Sign Out"])cell.imgIcon.image=[UIImage imageNamed:@"SignOutIcon.png"];
            
            //-----------Thilina---------------->>
            if([indexPath compare:self.selectedIndexPath]==NSOrderedSame){
                NSLog(@"MAKING CELL RED");
                [cell setBackgroundColor:[UIColor redColor]];
            }else{
                [cell setBackgroundColor:[UIColor clearColor]];
            }
            //-----------Thilina---------------->>
            
            return cell;
            }
    }
}


//-----------Thilina---------------->>
- (void) colorMagic:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
    
    switch (indexPath.section) {
        case 0:
        {
        if(self.selectedIndexPath){
            [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
        }
        
        [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
        self.selectedIndexPath = indexPath;
        }
            break;
        case 1:
        {
        if(indexPath.row==1){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }else if(indexPath.row==2){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }else if(indexPath.row==3){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }
        }
            break;
        case 2:
        {
        if(indexPath.row==1){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }else if(indexPath.row==2){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }else if(indexPath.row==3){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }
        }
            break;
        case 3:
        {
        if(self.selectedIndexPath){
            [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
        }
        
        [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
        self.selectedIndexPath = indexPath;
        }
            break;
        case 5:
        {
        if(indexPath.row==1){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }else if(indexPath.row==2){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }
        
        }
            break;
        case 6:
        {
        if(indexPath.row==1){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }else if(indexPath.row==2){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }
        }
            break;
        case 7:
        {
        if(self.selectedIndexPath){
            [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
        }
        
        [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
        self.selectedIndexPath = indexPath;
        }
            break;
        case 8:
        {
        if(indexPath.row==1){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }else if(indexPath.row==2){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }else if(indexPath.row==3){
            if(self.selectedIndexPath){
                [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            }
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
            self.selectedIndexPath = indexPath;
        }
        }
            break;
        case 9:
        {
        if(self.selectedIndexPath){
            [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
        }
        
        [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
        self.selectedIndexPath = indexPath;
        }
            break;
        case 10:
        {
        if(self.selectedIndexPath){
            [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
        }
        
        [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
        self.selectedIndexPath = indexPath;
        }
            break;
        case 11:
        {
        if(self.selectedIndexPath){
            [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setBackgroundColor:[UIColor clearColor]];
        }
        
        [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
        self.selectedIndexPath = indexPath;
        }
            break;
            
        default:
            break;
    }
    
}











#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath: %@", indexPath);
    
    
    //-----------Thilina---------------->>
    [self colorMagic:tableView didSelectRowAtIndexPath:indexPath];
    //-----------Thilina---------------->>
    
    
    if (!(self.isOpen && self.selectIndex.section == indexPath.section && indexPath.row !=0) && ([[[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"] isEqualToString:@"Stay in Touch"])){
        return;
    }
    
    
    
    if (indexPath.row == 0) {
        
        
        NSString *titleString=[[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"];
        if ([titleString isEqualToString:@"TopCell"]) {
            NSLog(@"Clicked %@",titleString);
            NSDictionary *dict = @{RemoteAction:kRemoteActionMyProfile};
            self.communicator(dict);
        }
        else if ([titleString isEqualToString:@"Live Radar"]) {
            NSLog(@"Clicked %@",titleString);
            NSDictionary *dict = @{RemoteAction:@"None"};
            self.communicator(dict);
        }
        else if ([titleString isEqualToString:@"Favourites"]) {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowFavourites};
            self.communicator(dict);
        }
        else if ([titleString isEqualToString:@"Notifications"]) {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowNotifications};
            self.communicator(dict);
        }
        else if ([titleString isEqualToString:@"Find Me"]) {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowFindMe};
            self.communicator(dict);
        }
        else if ([titleString isEqualToString:@"Settings"]) {
            NSDictionary *dict = @{RemoteAction:kRemoteActionSettings};
            self.communicator(dict);
        }
        else if ([titleString isEqualToString:@"Sign Out"]) {
            NSDictionary *dict = @{RemoteAction:kRemoteActionSignOut};
            self.communicator(dict);
        }
        
        
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
            {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
                {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
                
                }
            }
        
        
    }else
        {
        NSDictionary *dic = [_dataList objectAtIndex:indexPath.section];
        NSArray *list = [dic objectForKey:@"list"];
        NSString *item = [list objectAtIndex:indexPath.row-1];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:item message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        //        [alert show];
        
        if ([item isEqualToString:@"Near By"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowFindPeople};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"Advanced Search"])
            {
            NSLog(@"Clicked %@",item);
            }
        else if ([item isEqualToString:@"Eye Catcher"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowEyeCatcher};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"Do You Like?"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowDoYouLike};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"Matches"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowMatches};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"Like You"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowLikeYou};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"My Chats"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowMyChat};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"Requests"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowChatRequest};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"Visitors"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowProfileVisitors};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"Visits"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowProfileVisits};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"Friends"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowFriends};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"Requests "])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowFriendRequests};
            self.communicator(dict);
            }
        else if ([item isEqualToString:@"Unfriended"])
            {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowUnfriended};
            self.communicator(dict);
            }
        
        }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}











- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert{
    
    self.isOpen = firstDoInsert;
    
    MainCell_iPad *cell = (MainCell_iPad *)[self.tblMenu cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.tblMenu beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount = [[[_dataList objectAtIndex:section] objectForKey:@"list"] count];
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert){
        [self.tblMenu insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else{
        [self.tblMenu deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	
	
	[self.tblMenu endUpdates];
    
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.tblMenu indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    
    if (self.isOpen) [self.tblMenu scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}











#pragma mark - Action

-(void)vipClicked:(id)sender{
    NSDictionary *dict = @{RemoteAction:kRemoteActionShowVip};
    self.communicator(dict);
}

-(void)freeCreditClicked:(id)sender{
    NSDictionary *dict = @{RemoteAction:kRemoteActionShowFreeCredits};
    self.communicator(dict);
}

-(void)settingClicked:(id)sender{
    NSDictionary *dict = @{RemoteAction:kRemoteActionSettings};
    self.communicator(dict);
}











#pragma mark - Button Press Events

-(IBAction) fineMeButtonPressed:(id)sender;{
    NSLog(@"communicator:%@", self.communicator);
}

-(IBAction) chatScreensButtonPressed:(id)sender;{
    NSDictionary *dict = @{RemoteAction:kRemoteActionShowChatScreen};
    self.communicator(dict);
}

-(IBAction) addFriendsButtonPressed:(id)sender;{
    NSDictionary *dict = @{RemoteAction:kRemoteActionShowAddFriends};
    self.communicator(dict);
}

-(IBAction) blockPeopleButtonPressed:(id)sender;{
    NSDictionary *dict = @{RemoteAction:kRemoteActionShowBlockedPeople};
    self.communicator(dict);
}

-(IBAction) showGiftsButtonPressed:(id)sender;{
    NSDictionary *dict = @{RemoteAction:kRemoteActionShowSendGifts};
    self.communicator(dict);
}

-(IBAction) findPeopleButtonPressed:(id)sender;{
    NSDictionary *dict = @{RemoteAction:kRemoteActionShowFindPeople};
    self.communicator(dict);
}

-(IBAction) advancedSearchButtonPressed:(id)sender;{
    NSDictionary *dict = @{RemoteAction:kRemoteActionShowAdvancedSearch};
    self.communicator(dict);
}

-(IBAction) myGiftsButtonPressed:(id)sender;{
    NSDictionary *dict = @{RemoteAction:kRemoteActionShowMyGifts};
    self.communicator(dict);
}











- (void) dealloc{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
