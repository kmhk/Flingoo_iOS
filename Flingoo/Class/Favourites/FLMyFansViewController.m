//
//  FLMyFansViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMyFansViewController.h"
#import "FLProfileCell.h"
#import "FLPersonCell.h"
#import "ThumbCell.h"
#import "Config.h"
#import "FLOtherProfile.h"
#import "FLMFDetailsViewController.h"
#import "FLProfileViewController.h"
#import "FLMFPhotoGalleryViewController.h"
#import "FLUITabBarController.h"


@interface FLMyFansViewController() <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(weak, nonatomic) IBOutlet UITableView *personTableView;
@property(weak, nonatomic) IBOutlet UICollectionView *personCollectionView;
@property(weak, nonatomic) IBOutlet UIView *tableContainer;
@property(weak, nonatomic) IBOutlet UIButton *selectCollectionButton;
@property(weak, nonatomic) IBOutlet UIButton *selectTableButton;
@property(nonatomic, assign)TableMode tableMode;

@end

@implementation FLMyFansViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         likeUsersArr=[[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"My Fans";
    
    //add refreshController
    
    UIRefreshControl *tableEefreshControl = [[UIRefreshControl alloc] init];
    tableEefreshControl.tag = kTableModeTable;
    
    UIRefreshControl *collectionRefreshControl = [[UIRefreshControl alloc] init];
    collectionRefreshControl.tag = kTableModeCollection;
    
    [tableEefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [collectionRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.personTableView addSubview:tableEefreshControl];
    [self.personCollectionView addSubview:collectionRefreshControl];
    
    
    self.personCollectionView.hidden = YES;
    self.tableMode = kTableModeTable;
    
    self.personTableView.separatorColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
    
    //register custom cell
    [self.personTableView registerNib:[UINib nibWithNibName:@"FLPersonCell" bundle:nil] forCellReuseIdentifier:@"FLPersonCell"];
    [self.personCollectionView registerNib:[UINib nibWithNibName:@"ThumbCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbCell"];

    
    //back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];

    
     [self callReload];
    
//    if(IS_IPAD){
//        [CATransaction setDisableActions:YES];
//        self.parentScrollView.layer.opacity = 0;
//    }
    
}


-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}




-(void) goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - refresh controller

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    NSLog(@"refreshControl %@",refreshControl);
    if(refreshControl.tag == kTableModeCollection){
        //reload collection
        [self callReload];
    }else{
        //reload table
        [self callReload];
    }
    
    [refreshControl endRefreshing];
}


#pragma mark -
#pragma mark - Util method

-(void)callReload
{
    //    if([findPeopleArr count]==0)
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
    [webService likeUsersList:self];
}

-(void)cellSelect:(FLOtherProfile *)profileObj
{
    if (IS_IPAD)
    {
        NSDictionary *actionDic=@{@"Profile":OTHER_PROFILE,@"ProfileObject":profileObj};
        NSDictionary *dict = @{RemoteAction:kRemoteActionShowProfile,@"ClickAction":actionDic};
        self.communicator(dict);
    }else
    {
        FLMFDetailsViewController *detailViewCon=[[FLMFDetailsViewController alloc] initWithNibName:@"FLMFDetailsViewController" bundle:nil
                                                                                            profile:OTHER_PROFILE withProfileObj:profileObj];
        
        UINavigationController *navDetail=[[UINavigationController alloc] initWithRootViewController:detailViewCon];
        
        
        FLProfileViewController *profileViewCon=[[FLProfileViewController alloc] initWithNibName:@"FLProfileViewController" bundle:nil profile:OTHER_PROFILE withProfileObj:profileObj];
        UINavigationController *navProfile=[[UINavigationController alloc] initWithRootViewController:profileViewCon];
        
        
        FLMFPhotoGalleryViewController *photoGalleryViewCon=[[FLMFPhotoGalleryViewController alloc] initWithNibName:@"FLMFPhotoGalleryViewController" bundle:nil profile:OTHER_PROFILE withProfileObj:profileObj];
        
        UINavigationController *navPhotoGallery=[[UINavigationController alloc] initWithRootViewController:photoGalleryViewCon];
        
        UIImage *navImage1 = [UIImage imageNamed:@"navigationbar.png"];
        [navDetail.navigationBar setBackgroundImage:navImage1 forBarMetrics:UIBarMetricsDefault];
        
        UIImage *navImage2 = [UIImage imageNamed:@"navigationbar.png"];
        [navProfile.navigationBar setBackgroundImage:navImage2 forBarMetrics:UIBarMetricsDefault];
        
        UIImage *navImage3 = [UIImage imageNamed:@"navigationbar.png"];
        [navPhotoGallery.navigationBar setBackgroundImage:navImage3 forBarMetrics:UIBarMetricsDefault];
        
        FLUITabBarController *tabBarController = [[FLUITabBarController alloc] initWithNibName:nil bundle:nil withProfileObj:profileObj];
        
        [[tabBarController tabBar] setBackgroundImage:[UIImage imageNamed:nil]];
        [[tabBarController tabBar] setSelectionIndicatorImage:[UIImage imageNamed:nil]];
        
        
        tabBarController.viewControllers = @[navDetail,navProfile,navPhotoGallery];
        
        //    [tabBarController setSelectedIndex:1];
        
        [self presentViewController:tabBarController animated:YES completion:nil];
        
        [tabBarController setSelectedIndex:1];
        
    }
}

#pragma mark -
#pragma mark - Webservice api delegate method
-(void)likeUserListResult:(NSMutableArray *)likeUserArr
{
    likeUsersArr=likeUserArr;
    [self.personTableView reloadData];
    [self.personCollectionView reloadData];
    [HUD hide:YES];
}


-(void)userShowResult:(FLOtherProfile *)profileObj
{
    [HUD hide:YES];
    [self cellSelect:profileObj];
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


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [likeUsersArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Create an instance of PointsItemCell
    FLPersonCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"FLPersonCell"];
    
    FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
    profileObj=(FLOtherProfile *)[likeUsersArr objectAtIndex:indexPath.row];
    
 
//    [cell.profilePictureView setImage:[UIImage imageNamed:@"profilePic.png"]];
    
    
    ///////////////////
    cell.profileNameLabel.text=profileObj.full_name;
    cell.subtitleLine1.text=[NSString stringWithFormat:@"%@",profileObj.age];
    [cell setOnline:[profileObj.is_online boolValue]];
    cell.subtitleLine2.text = @"10.7 km (Koswatta, Battaramulla)";
    //    [cell.profilePictureView setImage:[UIImage imageNamed:@"profilePic.png"]];
    
    ///////////////////
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
    
    __weak FLPersonCell *weakCell = cell;
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

    
    return cell;
}


#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //load
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    // Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    HUD.delegate = self;
    HUD.labelText = @"Connecting";
    HUD.square = YES;
    [HUD show:YES];
    
    FLOtherProfile *clickedProfile=(FLOtherProfile *)[likeUsersArr objectAtIndex:[indexPath row]];
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi userShow:self withUserID:[NSString stringWithFormat:@"%@",clickedProfile.uid]];
}








#pragma mark
#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [likeUsersArr count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  ThumbCell *cell = (ThumbCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbCell" forIndexPath:indexPath];
    FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
    profileObj=(FLOtherProfile *)[likeUsersArr objectAtIndex:indexPath.row];
    
    cell.profileNameLabel.text=profileObj.full_name;
    //set your data here,
    [cell setOnline:[profileObj.is_online boolValue]];
    //    cell.profilePicImageView.image = [UIImage imageNamed:@"profilePic.png"];
    ///////////////////////////////////////////////////////////////////
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    //    NSArray* foo = [profileObj.image componentsSeparatedByString: @"/"];
    //    NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
    
    NSString *imgNameWithPath = [profileObj.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
    
    NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
    
    
    //get previous indicator out
    UIView *act = [cell.profilePicImageView viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(cell.profilePicImageView.bounds.size.width/2.0, cell.profilePicImageView.bounds.size.height/2.0);
    activityIndicatorView.tag = ACT_INDICATOR_TAG;
    
    [cell.profilePicImageView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    
    [cell.profilePicImageView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                    placeholderImage:nil
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 cell.profilePicImageView.image = image;
                                                 [activityIndicatorView removeFromSuperview];
                                             }
                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                 [activityIndicatorView removeFromSuperview];
                                             }];
    
    
    return cell;
}





#pragma mark - FlowLayout Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(145, 172);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(IS_IPAD){
        return UIEdgeInsetsMake(10,20,10,20);
    }else{
        return UIEdgeInsetsMake(10,10,10,10);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
           HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        // Set the hud to display with a color
        //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        HUD.delegate = self;
        HUD.labelText = @"Connecting";
        HUD.square = YES;
        [HUD show:YES];
        
        FLOtherProfile *clickedProfile=(FLOtherProfile *)[likeUsersArr objectAtIndex:[indexPath row]];
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
        [webServiceApi userShow:self withUserID:[NSString stringWithFormat:@"%@",clickedProfile.uid]];
        
    
}






#pragma mark - button press events

-(IBAction) selectTableButtonPressed:(id)sender;{
    [self flipTableContainerToMode:kTableModeTable];
}

-(IBAction) selectCollectionButtonPressed:(id)sender;{
    [self flipTableContainerToMode:kTableModeCollection];
}








#pragma mark - MISC
-(BOOL) randomBOOL{
    int r = arc4random() % 2;
    return ((r==0)? NO: YES);
}









#pragma mark
#pragma mark - Animations

-(void) flipTableContainerToMode:(TableMode) tableMode{
    if(self.tableMode==tableMode) return;
    if(tableMode==kTableModeTable){
        [self.selectTableButton setImage:[UIImage imageNamed:@"FP_show_table_selected.PNG"] forState:UIControlStateNormal];
        [self.selectCollectionButton setImage:[UIImage imageNamed:@"FP_show_collection_btn.PNG"] forState:UIControlStateNormal];
    }else {
        [self.selectTableButton setImage:[UIImage imageNamed:@"FP_show_table_unselected.png"] forState:UIControlStateNormal];
        [self.selectCollectionButton setImage:[UIImage imageNamed:@"FP_show_collection_btn_selected.png"] forState:UIControlStateNormal];
    }
    
    [UIView transitionWithView:self.tableContainer
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        if(self.tableMode==kTableModeTable){
                            //                            [self.personCollectionView reloadData];
                            self.personTableView.hidden = YES;
                            self.personCollectionView.hidden = NO;
                            self.tableMode = kTableModeCollection;
                        }else{
                            //                            [self.personTableView reloadData];
                            self.personTableView.hidden = NO;
                            self.personCollectionView.hidden = YES;
                            self.tableMode = kTableModeTable;
                        }
                    }
                    completion:^(BOOL finished){
                        
                    }];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

