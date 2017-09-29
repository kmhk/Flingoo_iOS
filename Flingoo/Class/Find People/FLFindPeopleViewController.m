//
//  FLFindPeopleViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/19/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLFindPeopleViewController.h"
#import "FLPersonCell.h"
#import "ThumbCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FLProfileSearch.h"
#import "FLUtilUserDefault.h"
#import "FLGlobalSettings.h"
#import "FLOtherProfile.h"
#import "FLMFDetailsViewController.h"
#import "FLProfileViewController.h"
#import "FLMFPhotoGalleryViewController.h"
#import "FLUITabBarController.h"
#import "Config.h"
#import "Macros.h"


#define ARRAOW_CONTAINER_FROM_RECT CGRectMake(4 - (139 * 1.5),1,139,92)
#define ARRAOW_CONTAINER_TO_RECT CGRectMake(4,1,139,92)


@interface FLFindPeopleViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(weak, nonatomic) IBOutlet UITableView *personTableView;
@property(weak, nonatomic) IBOutlet UICollectionView *personCollectionView;
@property(nonatomic, strong) UIBarButtonItem *rightButton;
@property(weak, nonatomic) IBOutlet UIView *tableContainer;
@property(nonatomic, assign)TableMode tableMode;
@property(weak, nonatomic) IBOutlet UIButton *selectCollectionButton;
@property(weak, nonatomic) IBOutlet UIButton *selectTableButton;
@property(weak, nonatomic) IBOutlet UIView *arrowContainer;
@property(weak, nonatomic) IBOutlet UIImageView *arrowProfilePic;
@property(weak, nonatomic) IBOutlet UILabel *arrowLabel;

@end




@implementation FLFindPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Near by";
        self.tabBarItem.image = [UIImage imageNamed:@"FP_tab_icon_mapmarker.PNG"];
        findPeopleArr=[[NSMutableArray alloc] init];
    }
    return self;
}




#pragma mark -
#pragma mark - ViewLyfeCycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    UIRefreshControl *tableEefreshControl = [[UIRefreshControl alloc] init];
    tableEefreshControl.tag = kTableModeTable;
    
    UIRefreshControl *collectionRefreshControl = [[UIRefreshControl alloc] init];
    collectionRefreshControl.tag = kTableModeCollection;
    
    [tableEefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [collectionRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.personTableView addSubview:tableEefreshControl];
    [self.personCollectionView addSubview:collectionRefreshControl];
    
    
    self.navigationItem.title = @"Find People";
    
    self.personCollectionView.hidden = YES;
    self.tableMode = kTableModeTable;
    
    //register custom cell
    [self.personTableView registerNib:[UINib nibWithNibName:@"FLPersonCell" bundle:nil] forCellReuseIdentifier:@"FLPersonCell"];
    [self.personCollectionView registerNib:[UINib nibWithNibName:@"ThumbCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbCell"];
    
    [self setUpGraphics];
    
    UIImage* filterBtnImg = [UIImage imageNamed:@"FilterBtn.png"];
    CGRect frameFilter = CGRectMake(0, 0, filterBtnImg.size.width, filterBtnImg.size.height);
    UIButton* filterBtn = [[UIButton alloc]initWithFrame:frameFilter];
    [filterBtn setBackgroundImage:filterBtnImg forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
    //    [self.navigationItem setRightBarButtonItem:filterBarButton];
    self.navigationItem.rightBarButtonItem=filterBarButton;
    
    
    
    
    self.otherProfilePicture1.image = [UIImage imageNamed:@"profilePic2.png"];
    self.otherProfilePicture2.image = [UIImage imageNamed:@"profilePic3.png"];
    [self callReload];
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
    /////////////////// load profile pictrue
    
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    
    NSString *imgNameWithPath = [[FLGlobalSettings sharedInstance].current_user_profile.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
    NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
    
    
    //get previous indicator out
    UIView *act = [self.arrowProfilePic viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(self.arrowProfilePic.bounds.size.width/2.0, self.arrowProfilePic.bounds.size.height/2.0);
    activityIndicatorView.tag = ACT_INDICATOR_TAG;
    
    [self.arrowProfilePic addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    
    [self.arrowProfilePic setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             self.arrowProfilePic.image = image;
                                             [activityIndicatorView removeFromSuperview];
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                             [activityIndicatorView removeFromSuperview];
                                         }];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self sendArrowContainerToDefaultPosition];
    [self sendOtherProfilePicturesToBack];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self appearArrowContainer];
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
    
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.navigationItem.rightBarButtonItem = nil;
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
    
    //hemalasankas**
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    FLProfileSearch *profleSearchObj=[[FLProfileSearch alloc] init];
    profleSearchObj.radius=[NSNumber numberWithInt:20];
    //    profleSearchObj.age_gteq=[NSNumber numberWithInt:[FLUtilUserDefault getLookingAgeMin]];
    //    profleSearchObj.age_lteq=[NSNumber numberWithInt:[FLUtilUserDefault getLookingAgeMax]];
    //    profleSearchObj.gender_eq=[FLUtilUserDefault getLookingFor];
    profleSearchObj.age_gteq=[NSNumber numberWithInt:0];
    profleSearchObj.age_lteq=[NSNumber numberWithInt:80];
//    profleSearchObj.gender_eq=[FLGlobalSettings sharedInstance].current_user_profile.looking_for;
//    profleSearchObj.orientation_eq=[FLGlobalSettings sharedInstance].current_user_profile.orientation;
    
    profleSearchObj.gender_eq=@"";
    profleSearchObj.orientation_eq=@"";
    
    [webService profileSearch:self withUserData:profleSearchObj];
    //}
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

-(void)profileSearchResult:(NSMutableArray *)profileObjArr
{
    findPeopleArr=profileObjArr;
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



#pragma mark - button actions

-(void) filterClicked:(UIButton *) button{
    NSLog(@"filter me please :'(");
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










#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"countcount %i",[findPeopleArr count]);
    return [findPeopleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Create an instance of PointsItemCell
    FLPersonCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"FLPersonCell"];
    
    
    //set your data here,
    FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
    profileObj=(FLOtherProfile *)[findPeopleArr objectAtIndex:indexPath.row];
    
    ///////////////////
    cell.profileNameLabel.text=profileObj.full_name;
    cell.subtitleLine1.text=[NSString stringWithFormat:@"%@",profileObj.age];
    [cell setOnline:[profileObj.is_online boolValue]];
    
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
    ////////////////////////////////////////////////////////////
    
    
    return cell;
}


#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	HUD.dimBackground = YES;
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Connecting";
	HUD.square = YES;
    [HUD show:YES];
    
    FLOtherProfile *clickedProfile=(FLOtherProfile *)[findPeopleArr objectAtIndex:[indexPath row]];
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi userShow:self withUserID:[NSString stringWithFormat:@"%@",clickedProfile.uid]];
    
   
}








#pragma mark
#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [findPeopleArr count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ThumbCell *cell = (ThumbCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbCell" forIndexPath:indexPath];
    
    
    
    //set your data here,
    FLOtherProfile *profileObj=[[FLOtherProfile alloc] init];
    profileObj=(FLOtherProfile *)[findPeopleArr objectAtIndex:indexPath.row];
    
    ///////////////////
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
    ////////////////////////////////////////////////////////////

    
    return cell;
}


//- (void)collectionView:(UICollectionViewCell *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self cellSelect:nil];
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//     [self cellSelect:(FLOtherProfile *)[findPeopleArr objectAtIndex:[indexPath row]]];
    
    
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	HUD.dimBackground = YES;
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Connecting";
	HUD.square = YES;
    [HUD show:YES];
    
    FLOtherProfile *clickedProfile=(FLOtherProfile *)[findPeopleArr objectAtIndex:[indexPath row]];
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi userShow:self withUserID:[NSString stringWithFormat:@"%@",clickedProfile.uid]];
}

#pragma mark - FlowLayout Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(145, 172);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,10,10,10);
}











#pragma mark - button press events

-(IBAction) selectTableButtonPressed:(id)sender;{
    [self flipTableContainerToMode:kTableModeTable];
}

-(IBAction) selectCollectionButtonPressed:(id)sender;{
    [self flipTableContainerToMode:kTableModeCollection];
}

-(void) filterButtonPressed{
    [self.tabBarController setSelectedIndex:1];
}

-(IBAction) eyeCatcherButtonPressed:(id)sender;{
    [self createEyeCatcher];
}

-(void) createEyeCatcher{
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    // Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    HUD.delegate = self;
    HUD.labelText = @"Creating Eye Catcher";
    HUD.square = YES;
    [HUD show:YES];
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    [webSeviceApi createEyeCatcher:self];
}

#pragma mark - weservice API delegate

-(void)createEyeCatcherResult:(NSString *)str{
    [HUD hide:YES];
    if(IS_IPAD){
        NSDictionary *dict = @{RemoteAction:kRemoteActionShowEyeCatcher};
        self.communicator(dict);
    }else{
        [self.tabBarController setSelectedIndex:2];
    }
}












#pragma mark - Graphics

-(void) setUpGraphics{
    
    self.arrowContainer.frame = ARRAOW_CONTAINER_FROM_RECT;
    
    self.personTableView.separatorColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
    
    self.arrowProfilePic.clipsToBounds = YES;
    self.arrowProfilePic.layer.cornerRadius = 5.0f;
//    self.arrowProfilePic.image = [UIImage imageNamed:@"profilePic.png"];
    
    
    self.otherProfilePicture1.clipsToBounds = YES;
    self.otherProfilePicture1.layer.cornerRadius = 5.0f;
    
    self.otherProfilePicture2.clipsToBounds = YES;
    self.otherProfilePicture2.layer.cornerRadius = 5.0f;
    
}



#pragma mark
#pragma mark - Animations

-(void) sendArrowContainerToDefaultPosition{
    self.arrowContainer.frame = ARRAOW_CONTAINER_FROM_RECT;
}

-(void) appearArrowContainer{
    [UIView animateWithDuration:0.7
                          delay:1.0 options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.arrowContainer.frame = ARRAOW_CONTAINER_TO_RECT;
                     }
     
                     completion:^(BOOL finished){
                         [self otherProfilesAnimation];
                     }];
}


-(void) otherProfilesAnimation{
    NSLog(@"other profile animation");
    CGRect frame1 = self.otherProfilePicture1.frame;
    CGRect frame2 = self.otherProfilePicture2.frame;
    
    frame1.origin.x = 168;
    frame2.origin.x = 237;
    
    [UIView animateWithDuration:1.0
                          delay:0.5 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.otherProfilePicture1.frame = frame1;
                         self.otherProfilePicture2.frame = frame2;
                     }
     
                     completion:^(BOOL finished){
                         
                     }];
    
}

-(void) sendOtherProfilePicturesToBack{
    
    CGRect frame1 = self.otherProfilePicture1.frame;
    CGRect frame2 = self.otherProfilePicture2.frame;
    
    frame1.origin.x = 321;
    frame2.origin.x = 420;
    
    self.otherProfilePicture1.frame = frame1;
    self.otherProfilePicture2.frame = frame2;
}


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












#pragma mark -
#pragma mark parent view methods

-(void)enableDisableSliderView:(BOOL)enable{
    //disble all your touches
}









#pragma mark - MISC
-(BOOL) randomBOOL{
    int r = arc4random() % 2;
    return ((r==0)? NO: YES);
}









- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end