//
//  FLRevealUnfriendedViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//
//FLUnfriendedCell
#import "FLMyChatViewController.h"
#import "FLChatScreenViewController.h"
#import "FLChatCell.h"
#import "FLGlobalSettings.h"
#import "FLChat.h"
#import "Config.h"
#import "FLChatMessage.h"
#import "FLGroupChatScreenViewController.h"


@interface FLMyChatViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
    @property(weak, nonatomic) IBOutlet UITableView *unfriendTable;

//@property(nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation FLMyChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"My Chat";
        self.tabBarItem.image = [UIImage imageNamed:@"chat_icon.png"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Chat";
    
    //add refreshController
    
    UIRefreshControl *tableEefreshControl = [[UIRefreshControl alloc] init];
    [tableEefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.unfriendTable addSubview:tableEefreshControl];
    
    self.unfriendTable.separatorColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
    
    //register custom cell
    [self.unfriendTable registerNib:[UINib nibWithNibName:@"FLChatCell" bundle:nil] forCellReuseIdentifier:@"FLChatCell"];
    
    //set chat request icon
    UITabBarItem *tbi = (UITabBarItem*)[[[self.tabBarController tabBar] items] objectAtIndex:1];
    [tbi setBadgeValue:@"5"];
    
    
    //add delete button
    UIImage* filterBtnImg = [UIImage imageNamed:@"chat_delete.png"];
    CGRect frameFilter = CGRectMake(0, 0, filterBtnImg.size.width, filterBtnImg.size.height);
    UIButton* filterBtn = [[UIButton alloc]initWithFrame:frameFilter];
    [filterBtn setBackgroundImage:filterBtnImg forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(deleteChatPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
    //    [self.navigationItem setRightBarButtonItem:filterBarButton];
    self.navigationItem.rightBarButtonItem=filterBarButton;
    
//    [self chatArrPrepare:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(chatArrPrepare:)
                                                 name:RECEIVED_CHAT_UPDATE
                                               object:nil];
    
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
    
    //if not added this we can't hide progerss bar on viewDidAppear
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    // Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    HUD.delegate = self;
    HUD.labelText = @"Connecting";
    HUD.square = YES;
    [HUD show:YES];
    
    [self getAllChatData];
    
}



-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
    
//    HUD=[[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.dimBackground = YES;
//    // Set the hud to display with a color
//    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
//    HUD.delegate = self;
//    HUD.labelText = @"Connecting";
//    HUD.square = YES;
//    [HUD show:YES];

    [self getAllChatData];
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notification Methods

-(void)chatArrPrepare:(NSNotification *)notification
{
//    NSMutableArray *chatArr=[FLGlobalSettings sharedInstance].chatArr;
//    
//          for (int x=0; x<[chatArr count]; x++)
//      {
//          FLChat *chatObj=[chatArr objectAtIndex:x];
//      }
    [self getAllChatData];
//    [self.unfriendTable reloadData];
}

-(void)getAllChatData
{
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi userChatList:self];
}



#pragma mark - button actions

-(void) deleteChatPressed:(UIButton *) button{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"now_what", nil) message:NSLocalizedString(@"now_what", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"dismiss", nil) otherButtonTitles:nil];
    [alert show];
}







#pragma mark - SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar; {
    NSLog(@"Search button pressed");
    
    //1) filter records in the table
    //2) reload tableview
    [self.unfriendTable reloadData];
    
    [searchBar resignFirstResponder];
}






#pragma mark - refresh controller

- (void)refresh:(UIRefreshControl *)refreshControl
{
     [refreshControl endRefreshing];
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    // Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    HUD.delegate = self;
    HUD.labelText = @"Connecting";
    HUD.square = YES;
    [HUD show:YES];
    
    [self getAllChatData];
    
   
}





#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[FLGlobalSettings sharedInstance].chatArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Create an instance of PointsItemCell
    FLChatCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"FLChatCell"];
//    if(!cell.graphicsReady) [cell makeGraphicsReady];
    
    
    //set your data here,
//    [cell setOnline:[self randomBOOL]];
//    [cell.profilePictureView setImage:[UIImage imageNamed:@"profilePic.png"]];
    
    FLChat *chatObj = [[FLGlobalSettings sharedInstance].chatArr objectAtIndex:indexPath.row];
        cell.profileNameLabel.text = chatObj.chatObjName;
//    //hemalasankas**
//    UIImage *img_profile_pic=[UIImage imageNamed:chatObj.image_url];
//        cell.profilePictureView.image = img_profile_pic;
    
    ///////////////////////////////////////////////////////////////////
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    NSString *imgNameWithPath = [chatObj.chatObj_image_url stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
    NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
    
    
    //get previous indicator out
    UIView *act = [cell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    __weak FLChatCell *weakCell = cell;
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
    
    
    
     cell.online = chatObj.is_online;

     cell.subtitleLabel.text = chatObj.chat_last_msg_obj.message;
    cell.timeLabel.text=chatObj.chat_last_msg_obj.chatDateTime;
    return cell;
}






#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPAD)
    {
////        hemalasankas****
//        NSDictionary *dict = @{RemoteAction:kRemoteActionShowChatScreen,@"content":@""};
//        self.communicator(dict);
        
//        NSDictionary *dict = @{RemoteAction:kRemoteActionShowChatScreen,@"ClickedIndex":[NSString stringWithFormat:@"%i",indexPath.row]};
//        self.communicator(dict);
        
//        NSDictionary *dict = @{RemoteAction:kRemoteActionShowChatScreen};
//        self.communicator(dict);

        FLChat *clickedChatObj=[[FLGlobalSettings sharedInstance].chatArr objectAtIndex:indexPath.row];
        BOOL isPrivate = [clickedChatObj.message_type isEqualToString:MSG_TYPE_PRIVATE];
//      NSDictionary *dict = @{RemoteAction:kRemoteActionShowChatScreen,@"ClickedIndex":[NSString stringWithFormat:@"%i",indexPath.row]};
       NSDictionary *dict = @{RemoteAction:(isPrivate)?kRemoteActionShowChatScreen:kRemoteActionShowChatGroupScreen,@"ClickedChatObject":clickedChatObj};
        self.communicator(dict);
        
    }else{
        FLChat *clickedChatObj=[[FLGlobalSettings sharedInstance].chatArr objectAtIndex:indexPath.row];
        
        if ([clickedChatObj.message_type isEqualToString:MSG_TYPE_PRIVATE]) {
            FLChatScreenViewController *chatScreen = [[FLChatScreenViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLChatScreenViewController-568h":@"FLChatScreenViewController" bundle:nil];
            //        chatScreen.chatObj=(FLChat *)[[FLGlobalSettings sharedInstance].chatArr objectAtIndex:indexPath.row];
            chatScreen.currentChatObj=clickedChatObj;            
            [self.navigationController pushViewController:chatScreen animated:YES];
        }
        else
        {
            FLGroupChatScreenViewController *chatScreen = [[FLGroupChatScreenViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLGroupChatScreenViewController-568h":@"FLGroupChatScreenViewController" bundle:nil];
            //        chatScreen.chatObj=(FLChat *)[[FLGlobalSettings sharedInstance].chatArr objectAtIndex:indexPath.row];
            chatScreen.currentChatObj=clickedChatObj;
            [self.navigationController pushViewController:chatScreen animated:YES];
        }

        NSLog(@"didSelectRowAtIndexPath: %d", indexPath.row);
        
    }
}






#pragma mark - MISC
//-(BOOL) randomBOOL{
//    int r = arc4random() % 2;
//    return ((r==0)? NO: YES);
//}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Webservice Api

-(void)userChatsResult:(NSMutableArray *)chatArr
{
    [HUD hide:YES];
    [[FLGlobalSettings sharedInstance].chatArr removeAllObjects];
    [FLGlobalSettings sharedInstance].chatArr=chatArr;
    [self.unfriendTable reloadData];
}

#pragma mark- FLWebServiceDelegate Fail
#pragma mark-

-(void)unknownFailureCall
{
    [HUD hide:YES];
    [self showValidationAlert:@"Unknown Error"];
}

-(void)requestFailCall:(NSString *)errorMsg
{
    [HUD hide:YES];
    [self showValidationAlert:errorMsg];
}

-(void)showValidationAlert:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}



@end
