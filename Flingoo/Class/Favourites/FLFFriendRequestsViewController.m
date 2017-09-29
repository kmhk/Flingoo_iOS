//
//  FLFFriendRequestsViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLFFriendRequestsViewController.h"
#import "UIViewController+TabHider.h"
#import "FLFAddFriendsViewController.h"
#import "FLFriendRequestCell.h"
#import "FLOtherProfile.h"
#import "Config.h"

@interface FLFFriendRequestsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *requestTableView;

@end

@implementation FLFFriendRequestsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        friendArr=[[NSMutableArray alloc] init];
    }
    return self;
}





#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Friend Requests";
    
    // Do any additional setup after loading the view from its nib.
    UIRefreshControl *tableEefreshControl = [[UIRefreshControl alloc] init];
    [tableEefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.requestTableView addSubview:tableEefreshControl];
    
    self.requestTableView.separatorColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
    
    [self.requestTableView registerNib:[UINib nibWithNibName:@"FLFriendRequestCell" bundle:nil] forCellReuseIdentifier:@"FLFriendRequestCell"];

    
    //back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable:)
                                                 name:@"ReloadFrndReqTbl"
                                               object:nil];
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
}



-(void)reloadTable:(NSNotification *)notification {
   
    [self callReload];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self callReload];
    
        if(IS_IPAD){
            [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
        }
  
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ReloadFrndReqTbl"
                                                  object:nil];
}


#pragma mark -
#pragma mark - Util method

-(void)callReload
{
//    if([friendArr count]==0)
//    {
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        // Set the hud to display with a color
        //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        HUD.delegate = self;
        HUD.labelText = @"Connecting";
        HUD.square = YES;
        [HUD show:YES];
        
        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
//        [webService friendshipFriendList:self];
        [webService friendshipRequestListing:self];
//    }
}



-(void) goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void) viewWillAppear:(BOOL)animated{
    [self hideTabBar:self.tabBarController];
}







#pragma mark - refresh controller

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self callReload];
    [refreshControl endRefreshing];
}















#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [friendArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Create an instance of PointsItemCell
    FLFriendRequestCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"FLFriendRequestCell"];
    
    if(!cell.targetSet){
        cell.acceptButton.tag = indexPath.row;
        cell.rejectButton.tag = indexPath.row;
        [cell.rejectButton addTarget:self action:@selector(rejectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.acceptButton addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.targetSet = YES;
    }
    
    FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
    profileObj=(FLOtherProfile *)[friendArr objectAtIndex:indexPath.row];

    
    cell.profileNameLabel.text=profileObj.full_name;
    cell.friendship_id=profileObj.friendship_id;
    //set your data here,
    [cell setOnline:[self randomBOOL]];
//    [cell.profilePictureView setImage:[UIImage imageNamed:@"profilePic.png"]];
    
    ///////////////////////////////////////////////////////////////////
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    //    NSArray* foo = [profileObj.image componentsSeparatedByString: @"/"];
    //    NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
    
    NSString *imgNameWithPath = [profileObj.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
    
    NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
    
    
    //get previous indicator out
    UIView *act = [cell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    
    __weak FLFriendRequestCell *weakCell = cell;
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
    
    return cell;
}


#pragma mark - Cell Button Events

-(void) acceptButtonPressed:(UIButton *) button{
    NSLog(@"cell %d request accepted", button.tag);
}

-(void) rejectButtonPressed:(UIButton *) button{
    NSLog(@"cell %d request rejected", button.tag);
}






#pragma mark - Button Press Events

-(IBAction) inviteButtonPressed:(id)sender;{
    FLFAddFriendsViewController *invite = [[FLFAddFriendsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLFAddFriendsViewController-568h":@"FLFAddFriendsViewController" bundle:nil];
    [self.navigationController pushViewController:invite animated:YES];
}











#pragma mark - MISC
-(BOOL) randomBOOL{
    int r = arc4random() % 2;
    return ((r==0)? NO: YES);
}



#pragma mark -
#pragma mark - Webservice api delegate method

-(void)profileFriendshipSearchResult:(NSMutableArray *)profileObjArr
{
    friendArr=profileObjArr;
    [self.requestTableView reloadData];
    [HUD hide:YES];
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
