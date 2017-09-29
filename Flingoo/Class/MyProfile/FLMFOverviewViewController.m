//
//  FLMFOverviewViewController.m
//  Flingoo
//
//  Created by Hemal on 11/15/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMFOverviewViewController.h"
#import "FLVIPUpgradeViewController.h"
#import "FLMyGiftsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FLGlobalSettings.h"
#import "FLUtil.h"
#import "Config.h"
#import "FLOtherProfile.h"
#import "FLMFDetailsViewController.h"
#import "FLProfileViewController.h"
#import "FLMFPhotoGalleryViewController.h"
#import "FLUITabBarController.h"
#import "FLProfileVisitorsViewController.h"
#import "FLProfileVisitsViewController.h"

#define kBupNewY 53 //key bord new Y value for status update
#define PROFILE_VISITORS_IMG_Y 7
#define PROFILE_VISITORS_IMG_OFFSET 11
#define PROFILE_VISITORS_IMG_WIDTH_HEIGHT 64

@implementation FLMFOverviewViewController
@synthesize imgProfilePic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
         self.title = @"Overview";
        self.tabBarItem.image = [UIImage imageNamed:@"overview_tabbar.png"];
    }
    return self;
}

#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"imgProfilePic.frame1 %@",NSStringFromCGRect(imgProfilePic.frame));
    lblStatus.numberOfLines=3;
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
//    [scrollVwVisitors setContentSize:CGSizeMake(500, scrollVwVisitors.frame.size.height)];
    
//    self.view.frame=CGRectMake(0, -44, 320, 460);
    
//    self.view.layer.frame = CGRectInset(CGRectMake(0, -44, 320, 460), 20, 20);
    if([FLGlobalSettings sharedInstance].current_user_profile.status_txt!=nil && [[FLGlobalSettings sharedInstance].current_user_profile.status_txt length]>0)
    {
    lblStatus.text=[FLGlobalSettings sharedInstance].current_user_profile.status_txt;
    }
    lblFullName_iPad.text=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
    lblGenderAge_iPad.text=[NSString stringWithFormat:@"%@, %@ years",[FLGlobalSettings sharedInstance].current_user_profile.gender,[FLGlobalSettings sharedInstance].current_user_profile.age];
    [self setupProfilePicture];
    [self addAnimationToProfilePicture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupProfilePicture)
                                                 name:PROFILE_PICTURE_UPLOADED
                                               object:nil];
    
    if (IS_IPAD)
    {
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
        [webServiceApi profileVisitors:self];
    }
}



-(void) setupProfilePicture{
    
//thilina****
    
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
//    NSArray* foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
//    NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
    
    NSString *imgNameWithPath = [[FLGlobalSettings sharedInstance].current_user_profile.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
    NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
    
    
    //get previous indicator out
    UIView *act = [self.imgProfilePic viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    __block FLMFOverviewViewController *context = self;
    __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(self.imgProfilePic.bounds.size.width/2.0, self.imgProfilePic.bounds.size.height/2.0);
    activityIndicatorView.tag = ACT_INDICATOR_TAG;
    
    [self.imgProfilePic addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    [self.imgProfilePic setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           context.imgProfilePic.image = image;
                                           [context addAnimationToProfilePicture];
                                           [activityIndicatorView removeFromSuperview];
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                           [activityIndicatorView removeFromSuperview];
                                       }];
    
    
     
//    if ([FLGlobalSettings sharedInstance].current_user_profile.image!=nil && [[FLGlobalSettings sharedInstance].current_user_profile.image length]>0)
//    {
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
//        //get profile pic name without "http://flingoo.s3.amazonaws.com/"
//        NSArray* foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
//        NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
//        NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
//        
//        
//        
//        
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//        dispatch_async(queue, ^{
//            
//            NSData * imageData = [NSData dataWithContentsOfURL:profilePicUrl];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIImage *image = [UIImage imageWithData:imageData];
//                self.imgProfilePic.image = image;
//                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            });
//        });
//        
//    }
}

-(void) addAnimationToProfilePicture{
//    [self.imgProfilePic.superview.layer setMasksToBounds:YES];
    
    if(IS_IPAD){
        self.profilePictureViewContainer.layer.masksToBounds = YES;
    }
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    scale.duration = 25.0f;
    scale.repeatCount = INT_MAX;
    scale.autoreverses = YES;
    scale.fromValue = [NSNumber numberWithFloat:1.0f];
    scale.toValue = [NSNumber numberWithFloat:1.2f];
    scale.removedOnCompletion = NO;
    scale.fillMode = kCAFillModeForwards;
    [self.imgProfilePic.layer addAnimation:scale forKey:@"scaleAnimation"];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.topItem.title=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
    if (IS_IPAD) {
        if([FLGlobalSettings sharedInstance].current_user_profile){
            if([FLGlobalSettings sharedInstance].current_user_profile.full_name){
                self.communicator(@{RemoteNavigationTitleUpdate:[FLGlobalSettings sharedInstance].current_user_profile.full_name});
            }else{
                self.communicator(@{RemoteNavigationTitleUpdate:@" "});
            }
        }else{
            self.communicator(@{RemoteNavigationTitleUpdate:@" "});
        }
    }
   
    
//    self.navigationController.navigationBar.hidden=YES;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
//    self.navigationController.navigationBar.hidden=NO;

        if(IS_IPAD){
            [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
        }
    NSLog(@"imgProfilePic.frame1 %@",NSStringFromCGRect(imgProfilePic.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtStatusUpdate resignFirstResponder];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    if (isViewVisitorsVisible) {
        [txtStatusUpdate resignFirstResponder];
        [self hideVisitorsView];
    }
}

#pragma mark -
#pragma mark Actions

- (IBAction)reciGifClicked:(id)sender
{
    FLMyGiftsViewController *myGirfts = [[FLMyGiftsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLMyGiftsViewController-568h":@"FLMyGiftsViewController" bundle:nil launchMode:kGiftViewModePresent];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myGirfts];
    UIImage *navImage = [UIImage imageNamed:@"navigationbar.png"];
    [nav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    [self hideVisitorsView];
}

- (IBAction)myFansClicked:(id)sender
{
    if (isViewVisitorsVisible) {
        [txtStatusUpdate resignFirstResponder];
        [self hideVisitorsView];
    }
    else
    {
        if([FLGlobalSettings sharedInstance].profileVisitorsArr.count==0)
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
            
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            [webServiceApi profileVisitors:self];
        }
        else
        {
            [[scrollVwVisitors subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
           [self loadProfileVisitors];
        }
    }
}

- (IBAction)becomeVIPClicked:(id)sender {
    FLVIPUpgradeViewController *upgradeViewController = [[FLVIPUpgradeViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLVIPUpgradeViewController-568h":@"FLVIPUpgradeViewController" bundle:nil];
    
    UINavigationController *upgradeNav = [[UINavigationController alloc] initWithRootViewController:upgradeViewController];
    //set navigationbar image
    UIImage *navImage = [UIImage imageNamed:@"navigationbar.png"];
    [upgradeNav.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    
    [self presentViewController:upgradeNav animated:YES completion:nil];
}

- (IBAction)statusChangeClicked:(id)sender
{
    [self myFansClicked:nil];
}

- (IBAction)visitorsClicked:(id)sender {
    
    if(IS_IPAD){
        
        NSDictionary *dict = @{RemoteAction:kRemoteActionShowProfileVisitors};
        self.communicator(dict);
        
    }else{
        
        //set navigationbar back button
        UIBarButtonItem* menuBarButton1 = [FLUtil backBarButtonWithTarget:self action:@selector(backClicked)];
        
        //set navigationbar back button
        UIBarButtonItem* menuBarButton2 = [FLUtil backBarButtonWithTarget:self action:@selector(backClicked)];
        
    
        FLProfileVisitorsViewController *profileVisitorsViewController = [[FLProfileVisitorsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLProfileVisitorsViewController-568h":@"FLProfileVisitorsViewController" bundle:nil];
        
        FLProfileVisitsViewController *profileVisitsViewController = [[FLProfileVisitsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLProfileVisitsViewController-568h":@"FLProfileVisitsViewController" bundle:nil];
        
        
        
        UINavigationController *profileVisitorsNav = [[UINavigationController alloc] initWithRootViewController:profileVisitorsViewController];;
        UINavigationController *profileVisitsNav = [[UINavigationController alloc] initWithRootViewController:profileVisitsViewController];
        
        
        profileVisitorsNav.navigationBar.topItem.leftBarButtonItem = menuBarButton1;
        profileVisitsNav.navigationBar.topItem.leftBarButtonItem = menuBarButton2;
        
        
        
        
        
        UITabBarController *tabBarProfileVisitorsController = [[UITabBarController alloc] init];
        [[tabBarProfileVisitorsController tabBar] setBackgroundImage:[UIImage imageNamed:@"pv_tab_background.png"]];
        [[tabBarProfileVisitorsController tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"pv_selectedFooter.png"]];
        tabBarProfileVisitorsController.viewControllers = @[profileVisitorsNav,profileVisitsNav];
        [self.tabBarController presentViewController:tabBarProfileVisitorsController animated:YES completion:nil];
    }
    
}

-(void)backClicked//back clicked on profile visitors or profile visit view
{
//    [self dismissModalViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)profileClicked:sender
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
    
    FLOtherProfile *clickedProfile=(FLOtherProfile *)[[FLGlobalSettings sharedInstance].profileVisitorsArr objectAtIndex:[sender tag]];
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi userShow:self withUserID:[NSString stringWithFormat:@"%@",clickedProfile.uid]];
}

#pragma mark -
#pragma mark Keyboard notification

- (void)keyboardWillHide:(NSNotification *)n
{
    if (!isShowingKeyBord) {
        return;
    }
    
    CGRect newFram=CGRectMake(viewVisitos.frame.origin.x, viewVisitos.frame.origin.y+kBupNewY, viewVisitos.frame.size.width, viewVisitos.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [viewVisitos setFrame:newFram];
    [UIView commitAnimations];
    isShowingKeyBord=NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{

    CGRect newFram=CGRectMake(viewVisitos.frame.origin.x, viewVisitos.frame.origin.y-kBupNewY, viewVisitos.frame.size.width, viewVisitos.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [viewVisitos setFrame:newFram];
    [UIView commitAnimations];
    isShowingKeyBord=YES;
}

#pragma mark -
#pragma mark Util methods

-(void)hideVisitorsView
{
    int viewVisitosY=imgProfilePic.frame.size.height-self.navigationController.navigationBar.frame.size.height;
    //    viewVisitos.frame = CGRectMake(0, viewVisitosY+viewVisitos.frame.size.height, viewVisitos.frame.size.width, viewVisitos.frame.size.height);
    //    [self.view addSubview:viewVisitos];
    [UIView animateWithDuration:0.5
                     animations:^{
                         viewVisitos.frame = CGRectMake(0,viewVisitosY,viewVisitos.frame.size.width, viewVisitos.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         isViewVisitorsVisible=NO;
                     }];
}

-(void)profileSelect:(FLOtherProfile *)profileObj
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

-(void)loadProfileVisitors
{
    [btnNoOfVisitors setTitle:[NSString stringWithFormat:@"%i Visitors",[FLGlobalSettings sharedInstance].profileVisitorsArr.count] forState:UIControlStateNormal];
    int count=PROFILE_VISITORS_IMG_OFFSET + (PROFILE_VISITORS_IMG_WIDTH_HEIGHT + PROFILE_VISITORS_IMG_OFFSET)*[FLGlobalSettings sharedInstance].profileVisitorsArr.count;
    
    [scrollVwVisitors setContentSize:CGSizeMake(count, scrollVwVisitors.frame.size.height)];
    
    for (int x=0; x<[FLGlobalSettings sharedInstance].profileVisitorsArr.count; x++)
    {
        FLOtherProfile *profObj=(FLOtherProfile *)[[FLGlobalSettings sharedInstance].profileVisitorsArr objectAtIndex:x];
        //        scrollVwVisitors
        UIImageView *img_profile_view=[[UIImageView alloc] initWithFrame:CGRectMake((PROFILE_VISITORS_IMG_OFFSET + (PROFILE_VISITORS_IMG_WIDTH_HEIGHT + PROFILE_VISITORS_IMG_OFFSET)*x), PROFILE_VISITORS_IMG_Y, PROFILE_VISITORS_IMG_WIDTH_HEIGHT, PROFILE_VISITORS_IMG_WIDTH_HEIGHT)];
        /////
        UIButton *btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnProfile addTarget:self
                       action:@selector(profileClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        btnProfile.frame = img_profile_view.frame;
        btnProfile.tag=x;//array of index
        //////
        
        [scrollVwVisitors addSubview:img_profile_view];
        [scrollVwVisitors addSubview:btnProfile];
        CALayer *lyr = img_profile_view.layer;
        lyr.masksToBounds = YES;
        lyr.cornerRadius = img_profile_view.frame.size.width / 2;
        //////////////////////////////////////////////////////////
        
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
        NSString *imgNameWithPath = [profObj.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
        NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
        
        
        //get previous indicator out
        UIView *act = [img_profile_view viewWithTag:ACT_INDICATOR_TAG];
        
        //if has, then remove it
        if(act){
            [act removeFromSuperview];
        }
        
        __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center = CGPointMake(img_profile_view.bounds.size.width/2.0, img_profile_view.bounds.size.height/2.0);
        activityIndicatorView.tag = ACT_INDICATOR_TAG;
        
        [img_profile_view addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        
        [img_profile_view setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             img_profile_view.image = image;
                                             [activityIndicatorView removeFromSuperview];
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                             [activityIndicatorView removeFromSuperview];
                                         }];
        
        ///////////////////////////////////////////////////////////
    }
    
    
    int viewVisitosY=self.view.frame.size.height;
    viewVisitos.frame = CGRectMake(0, viewVisitosY+viewVisitos.frame.size.height, viewVisitos.frame.size.width, viewVisitos.frame.size.height);
    [self.view addSubview:viewVisitos];
    [UIView animateWithDuration:0.5
                     animations:^{
                         viewVisitos.frame = CGRectMake(0,viewVisitosY
                                                        -viewVisitos.frame.size.height,viewVisitos.frame.size.width, viewVisitos.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         isViewVisitorsVisible=YES;
                         
                         
                         
                     }];
}


#pragma mark -
#pragma mark parent view methods

-(void)enableDisableSliderView:(BOOL)enable
{
    txtStatusUpdate.userInteractionEnabled=enable;
    btnRecievedGift.userInteractionEnabled=enable;
    btnMyFans.userInteractionEnabled=enable;
    btnBecomeVIP.userInteractionEnabled=enable;
    btnAddStatus.userInteractionEnabled=enable;
    btnNoOfVisitors.userInteractionEnabled=enable;
}

#pragma mark -
#pragma mark textField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
   [textField resignFirstResponder];
    [self hideVisitorsView];
    if(txtStatusUpdate.text!=nil && [txtStatusUpdate.text length]>0)
    {
        lblStatus.text =  textField.text;
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
        [webServiceApi statusUpdate:self withStatusTxt:txtStatusUpdate.text];
    }
   
    
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark -
#pragma mark WebService Api delegate methods

-(void)statusUpdateResult:(NSString *)str
{
    NSLog(@"str %@",str);
    [FLGlobalSettings sharedInstance].current_user_profile.status_txt=txtStatusUpdate.text;
}

-(void)profileVisitorsResult:(NSMutableArray *)profileVisitorsArr
{
    [HUD hide:YES];
    [[FLGlobalSettings sharedInstance].profileVisitorsArr removeAllObjects];
    
    
    [FLGlobalSettings sharedInstance].profileVisitorsArr=profileVisitorsArr;
  
    [self loadProfileVisitors];
}

-(void)userShowResult:(FLOtherProfile *)profileObj
{
    [HUD hide:YES];
    [self profileSelect:profileObj];
}

#pragma mark -
#pragma mark - webservice Api Fail

-(void)unknownFailureCall
{
    [self showValidationAlert:NSLocalizedString(@"unknown_error", nil)];
}

-(void)requestFailCall:(NSString *)errorMsg
{
    [self showValidationAlert:errorMsg];
}

-(void)showValidationAlert:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}


- (IBAction)photoGalleryClicked:(id)sender
{
    //hemalasankas****
    /*
     
     UIViewController *photoGalleryViewCon = [[FLMFPhotoGalleryViewController alloc] initWithNibName:@"FLMFPhotoGalleryViewController" bundle:nil profile:MY_PROFILE withProfileObj:nil];
     have to pass MY_PROFILE as profile and profileObj as nil
     
     */
    
    NSDictionary *actionDic=@{@"Profile":MY_PROFILE,@"ProfileObject":[NSNull null]};
    
    [btnPhotoGallery setSelected:YES];
    [btnDetail setSelected:NO];
    NSDictionary *dict = @{RemoteAction:kRemoteActionMyProfilePhotoGallery,@"info":actionDic};
    self.communicator(dict);

}

- (IBAction)detailClicked:(id)sender
{
    [btnDetail setSelected:YES];
    [btnPhotoGallery setSelected:NO];
    
    NSDictionary *actionDic=@{@"Profile":MY_PROFILE,@"ProfileObject":@""};
    
    NSDictionary *dict = @{RemoteAction:kRemoteActionMyProfileDetails,@"ClickAction":actionDic};
    self.communicator(dict);
}
@end
