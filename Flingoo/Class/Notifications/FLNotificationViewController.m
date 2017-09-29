//
//  FLNotificationViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLNotificationViewController.h"
#import "FLNotificationCell.h"
#import "FLMapViewController.h"
#import "FLMyGiftsViewController.h"
#import "FLGlobalSettings.h"
#import "FLNotication.h"
#import "FLWebServiceApi.h"
#import "Config.h"
#import "FLFFriendRequestsViewController.h"


@interface FLNotificationViewController ()<UITableViewDataSource, UITableViewDelegate>
    @property(weak, nonatomic) IBOutlet UITableView *notificationTable;
//    @property(nonatomic, strong) NSArray *contentArray;

@end






@implementation FLNotificationViewController


#pragma mark - 
#pragma mark Intialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - 
#pragma mark - ViewLifeCycle
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //add refresh controller
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.notificationTable addSubview:refreshControl];
    
    //register custom cell
    self.navigationItem.title = @"Notifications";
    [self.notificationTable registerNib:[UINib nibWithNibName:@"FLNotificationCell" bundle:nil] forCellReuseIdentifier:@"FLNotificationCell"];
    
    [self setUpGraphics];

    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:RECEIVED_NEW_NOTIFICATION
                                               object:nil];
    
}

-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}

/*
 
 @"sender" @"profilePic" @"receriver" @"requestType"  @"requestString"
 
 0
 Anna Hurtz has sent you a Find Me Request
 findme.png
 2
 Jane Pieterz has sent you a Friend Request
 FrndReq.png
 3
 Napoleon Bonaparte has sent you a Chat Request
 ChatReq.png
 4
 Bertrand Russell has sent you a Milk Coffee
 Drink.png
 5
 Albert Einstein has sent you a Kiss
 kiss.png
 
 */



#pragma mark - refresh controller
- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self notificationReceived:nil];
}





#pragma mark - Graphics

-(void) setUpGraphics{
    self.notificationTable.separatorColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
}





#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [FLGlobalSettings sharedInstance].notificationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FLNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLNotificationCell"];
    
    //<##>
    FLNotication *notificationObj = [[FLGlobalSettings sharedInstance].notificationArr objectAtIndex:indexPath.row];
    
//    if(dict){
//        [cell setNotificationSenderName:[dict objectForKey:@"sender"] notificationTypeName:[dict objectForKey:@"requestString"]];
//        cell.profilePictureView.image = [UIImage imageNamed:[dict objectForKey:@"profilePic"]];
//        [cell setIconType:[[dict objectForKey:@"requestType"] intValue]];
//        cell.timeLabel.text = @"12.30 P.M";
//    }
    
   
        
    //////
      
    
    ///////////////////////////////////////////////////////////////////
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    //hemalasankas**
    NSString *imgNameWithPath = [notificationObj.sender_profile_pic stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
    NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
    
    
    //get previous indicator out
    UIView *act = [cell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    
    __weak FLNotificationCell *weakCell = cell;
    __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(cell.profilePictureView.bounds.size.width/2.0, cell.profilePictureView.bounds.size.height/2.0);
    activityIndicatorView.tag = ACT_INDICATOR_TAG;
    
    [cell.profilePictureView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    
    [cell.profilePictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakCell.profilePictureView.image = image;
                                            [activityIndicatorView removeFromSuperview];
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                            [activityIndicatorView removeFromSuperview];
                                        }];
    ////////////////////////////////////////////////////////////
    
    //////
    int iconType;
    if ([notificationObj.notification_type isEqualToString:@"friend_request"]) {
        
        iconType=kIconTypeFriendRequest;
    }
    else if ([notificationObj.notification_type isEqualToString:@"find_me"])
    {
        iconType=kIconTypeFindMeRequest;
    }
    //hemalasankas** have to modify with webservice changes
    else if ([notificationObj.notification_type isEqualToString:@"Vampire Kiss"])
    {
        iconType=kIconTypeVampireKiss;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Soft Drink"])
    {
        iconType=kIconTypeSoftDrink;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Shot"])
    {
        iconType=kIconTypeShot;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Long Drink"])
    {
        iconType=kIconTypeLongDrink;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Latte Macchiato"])
    {
        iconType=kIconTypeLatteMacchiato;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Kiss"])
    {
        iconType=kIconTypeKiss;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Gentleman Kiss"])
    {
        iconType=kIconTypeGentlemanKiss;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Fruity Kiss"])
    {
        iconType=kIconTypeFruityKiss;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Espresso"])
    {
        iconType=kIconTypeEspresso;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Diamond Kiss"])
    {
        iconType=kIconTypeDiamondKiss;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Cocktail"])
    {
        iconType=kIconTypeCocktail;
    }
    else if ([notificationObj.notification_type isEqualToString:@"Candy Kiss"])
    {
        iconType=kIconTypeCandyKiss;
    }
    
    [cell setIconType:iconType];
    
    [cell setNotificationSenderName:notificationObj.sender_name notificationTypeName:iconType];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    cell.timeLabel.text =  [formatter stringFromDate:notificationObj.receivedDate];
    
    
    //if icon type of the cell is Drink/Kiss, then cell on click will navigate to My gifts page
    //if the icon type is fine me request, then cell on click will show you the map
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FLNotificationCell *cell = (FLNotificationCell *)[tableView cellForRowAtIndexPath:indexPath];
    FLNotication *clickedNotificationObj=(FLNotication *)[[FLGlobalSettings sharedInstance].notificationArr objectAtIndex:indexPath.row];
    
    
    if (!clickedNotificationObj.read_status) {
        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
        [webService notificationUpdate:self withNotificationID:clickedNotificationObj.notification_id];
    }
    if(IS_IPAD){
        
        if(cell.iconType==kIconTypeFindMeRequest){
            
            CLLocationCoordinate2D loc2;
            loc2.latitude = [clickedNotificationObj.latitude doubleValue];
            loc2.longitude =[clickedNotificationObj.longitude doubleValue];
            NSData *data = [NSData dataWithBytes:&loc2 length:sizeof(loc2)];
            
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowMap,@"coordinates":data};
            self.communicator(dict);
            
        }
        else if(cell.iconType==kIconTypeFriendRequest){
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowFriendRequests};
            self.communicator(dict);
        }else if(cell.iconType==kIconTypeChatRequest){
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowChatRequest};
            self.communicator(dict);
        }
//        else if(cell.iconType==kIconTypeDrink || cell.iconType == kIconTypeKiss ){
//            NSDictionary *dict = @{RemoteAction:kRemoteActionShowMyGifts};
//            self.communicator(dict);
//        }
        else //load kiss and drinks
        {
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowMyGifts};
            self.communicator(dict);
        }
        
    }else{
        if(cell.iconType==kIconTypeFindMeRequest){
            
            FLMapViewController *mapViewController = [[FLMapViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLMapViewController-568h":@"FLMapViewController" bundle:nil];
            [mapViewController setCalloutText:@"Albert is Here"];
            
            CLLocationCoordinate2D loc2;
            loc2.latitude = [clickedNotificationObj.latitude doubleValue];
            loc2.longitude = [clickedNotificationObj.longitude doubleValue];
            [mapViewController setToCoordinate:loc2];
            
            [self.navigationController pushViewController:mapViewController animated:YES];
        }
        else if(cell.iconType==kIconTypeFriendRequest){
            FLFFriendRequestsViewController *myFansViewController = [[FLFFriendRequestsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLFFriendRequestsViewController-568h":@"FLFFriendRequestsViewController" bundle:nil];
            [self.navigationController pushViewController:myFansViewController animated:YES];
        }
//        else if(cell.iconType==kIconTypeDrink || cell.iconType == kIconTypeKiss ){
//            FLMyGiftsViewController *myGirfts = [[FLMyGiftsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLMyGiftsViewController-568h":@"FLMyGiftsViewController" bundle:nil launchMode:kGiftViewModePush];
//            [self.navigationController pushViewController:myGirfts animated:YES];
//        }
        else{//load kiss and drinks
            FLMyGiftsViewController *myGirfts = [[FLMyGiftsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLMyGiftsViewController-568h":@"FLMyGiftsViewController" bundle:nil launchMode:kGiftViewModePush];
            [self.navigationController pushViewController:myGirfts animated:YES];
        }
    }
    
}


#pragma mark - Other

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification

-(void)notificationReceived:(NSNotification *)notification
{
    [self.notificationTable reloadData];
}


#pragma mark -
#pragma mark - Webservice api delegate method

-(void)notificationUpdatedResult:(NSString *)notificationID
{
    NSLog(@"notification updated");
    for (int x=0; x<[FLGlobalSettings sharedInstance].notificationArr.count; x++)
    {
        FLNotication *notificationObj=[[FLGlobalSettings sharedInstance].notificationArr objectAtIndex:x];
        if ([[NSString stringWithFormat:@"%@",notificationObj.notification_id] isEqualToString: [NSString stringWithFormat:@"%@",notificationID]])
        {
            
            notificationObj.read_status=YES;
//            [[FLGlobalSettings sharedInstance].notificationArr removeObjectAtIndex:x];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:RECEIVED_NEW_NOTIFICATION
             object:self];
            return;
        }
    }
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



-(void)dealloc
{
 [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
