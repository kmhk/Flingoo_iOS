//
//  FLProfileViewController.m
//  Flingoo
//
//  Created by Hemal on 11/19/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FLMFDetailsViewController.h"
#import "FLLikeYouViewController.h"
#import "FLChatScreenViewController.h"
#import "FLGlobalSettings.h"
#import "Config.h"
#import "Macros.h"

@interface FLProfileViewController ()
@property(nonatomic,strong) FLOtherProfile *profileObj;
@property(nonatomic,strong) NSString *profile;
@end

@implementation FLProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profile:(NSString *)profile withProfileObj:(FLOtherProfile *)profileObj
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([profileObj isKindOfClass:[FLOtherProfile class]]) {
            self.profile=profile;
            self.profileObj=profileObj;
            self.navigationItem.title=profileObj.full_name;
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
  
    if ([self.profile isEqualToString:OTHER_PROFILE])
    {
            self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(backClicked)];
    }
}

-(void)backClicked
{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblStatus.text=self.profileObj.status_txt;
    if (IS_IPAD) {
        if (self.profileObj!=nil) {
            lblFullName_iPad.text=self.profileObj.full_name;
            
            lblGenderAge_iPad.text=[NSString stringWithFormat:@"%@, %@ years",self.profileObj.gender,self.profileObj.age];
            
//            if ([self.profileObj.status isEqualToString:@"accepted"])
             if ([self.profileObj.is_friend boolValue])
            {
                UIImage *unfriend_img=[UIImage imageNamed:@"Unfriend.png"];
                [btnFriend_iPad setImage:unfriend_img forState:UIControlStateNormal];
                lblFriend_iPad.text=@"Unfriend";
               
            }

        }
      if(self.profileObj.friendship_id==nil)
      {
            btnGift_iPad.center=CGPointMake((btnChat_iPad.center.x+btnFavorite_iPad.center.x)/2,btnFavorite_iPad.center.y);
            lblGift_iPad.center=CGPointMake((lblChat_iPad.center.x+lblFavorite_iPad.center.x)/2,lblFavorite_iPad.center.y);
            
            btnFriend_iPad.center=CGPointMake(btnFavorite_iPad.center.x,btnFavorite_iPad.center.y);
            lblFriend_iPad.center=CGPointMake(lblFavorite_iPad.center.x,lblFavorite_iPad.center.y);
            btnFavorite_iPad.hidden=YES;
            lblFavorite_iPad.hidden=YES;
        }
        
    }
    else
    {
     lblLastOnlineDate.text=[NSString stringWithFormat:@"Last Time Online %@",self.profileObj.last_seen_at];
    }
[self setupProfilePicture];
}


-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
        //update navigation title
        if(self.profileObj){
            if(self.profileObj.full_name){
                self.communicator(@{RemoteNavigationTitleUpdate:self.profileObj.full_name});
            }
        }else{
            self.communicator(@{RemoteNavigationTitleUpdate:@""});
        }
    }
}


//- (void)rotateText:(UILabel *)label duration:(NSTimeInterval)duration degrees:(CGFloat)degrees {
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddArc(path,nil, 160, 236, 100, DEGREES_TO_RADIANS(0), DEGREES_TO_RADIANS(degrees), YES);
//    
//    CAKeyframeAnimation *theAnimation;
//    
//    // animation object for the key path
//    theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    theAnimation.path=path;
//    CGPathRelease(path);
//    
//    // set the animation properties
//    theAnimation.duration=duration;
//    theAnimation.removedOnCompletion = NO;
//    theAnimation.autoreverses = NO;
//    theAnimation.rotationMode = kCAAnimationRotateAutoReverse;
//    theAnimation.fillMode = kCAFillModeForwards;
//    
//    [label.layer addAnimation:theAnimation forKey:@"position"];
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPofileClicked:(id)sender {
//    [self rotateText:lblAddress duration:0.5 degrees:0.5f];
    if(IS_IPAD){
        NSDictionary *actionDic=@{@"Profile":OTHER_PROFILE,@"ProfileObject":self.profileObj==nil?@"":self.profileObj};
        NSDictionary *dict = @{RemoteAction:kRemoteActionMyProfileDetails,@"ClickAction":actionDic};
        self.communicator(dict);
        [btnPhotoGallery setSelected:NO];
        [btnProfileDetail setSelected:YES];
    }
}



- (IBAction)btnGalleryClicked:(id)sender {
    if(IS_IPAD){

        //hemalasankas****
        /*
         
         FLMFPhotoGalleryViewController *photoGalleryViewCon=[[FLMFPhotoGalleryViewController alloc] initWithNibName:@"FLMFPhotoGalleryViewController" bundle:nil profile:OTHER_PROFILE withProfileObj:profileObj];
         have to pass MY_PROFILE as profile and profileObj as nil
         
         */
        
        NSDictionary *actionDic=@{@"Profile":self.profile,@"ProfileObject":self.profileObj};
        NSDictionary *dict = @{RemoteAction:kRemoteActionMyProfilePhotoGallery,@"info":actionDic};
        self.communicator(dict);
        [btnPhotoGallery setSelected:YES];
        [btnProfileDetail setSelected:NO];
    }
}

- (IBAction)menuClicked:(id)sender
{
    
}

- (IBAction)chatClicked:(id)sender

{
    
    
//    NSMutableArray *chatArr=[FLGlobalSettings sharedInstance].chatArr;
//    int chatObjIndex=0;
//    BOOL tempCheck=NO;
//    for (int x=0; x<[chatArr count]; x++)//check exsisting chat
//    {
//        FLChat *chatObj=[chatArr objectAtIndex:x];
//        if ([chatObj.uid isEqualToString:[self.profileObj.uid stringValue]])
//        {
//            chatObjIndex=x;
//            tempCheck=YES;
//            break;
//        }
//    }
//    if (!tempCheck) {
//        
//        //add new empty chat object
//        FLChat *chatObj=[[FLChat alloc] init];
//        chatObj.username=self.profileObj.full_name;
//        chatObj.uid=[self.profileObj.uid stringValue];
//        //hemalasankas**
////        chatObj.image_url=@"profilePic.png";
//        chatObj.image_url=self.profileObj.image;
//        chatObj.is_online=[self.profileObj.is_online boolValue];
//        chatObj.is_private=YES;
//        chatObj.chatMessageArr=[[NSMutableArray alloc] init];
//        [[FLGlobalSettings sharedInstance].chatArr addObject:chatObj];
//        chatObjIndex=[[FLGlobalSettings sharedInstance].chatArr count]-1;//send last index in array
//    }
//
//    NSDictionary *dict = @{RemoteAction:kRemoteActionShowChatScreen,@"ClickedIndex":[NSString stringWithFormat:@"%i",chatObjIndex]};
//    self.communicator(dict);
    /////////////////////////////
    

    if(IS_IPAD){
        
        FLChat *chatObj=[[FLChat alloc] init];
        chatObj.chatObj_id=[self.profileObj.uid stringValue];
        chatObj.chatObjName=self.profileObj.full_name;
        chatObj.is_online=[self.profileObj.is_online boolValue];
        chatObj.message_type=MSG_TYPE_PRIVATE;
        chatObj.chatObj_image_url=self.profileObj.image;
        chatObj.chatMessageArr=[[NSMutableArray alloc] init];//updating existing obj
        
        BOOL isPrivate = [chatObj.message_type isEqualToString:MSG_TYPE_PRIVATE];
        NSDictionary *dict = @{RemoteAction:(isPrivate)?kRemoteActionShowChatScreen:kRemoteActionShowChatGroupScreen,@"ClickedChatObject":chatObj};
        self.communicator(dict);
        
    }else{
        FLChatScreenViewController *chatScreen = [[FLChatScreenViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLChatScreenViewController-568h":@"FLChatScreenViewController" bundle:nil];
        
        FLChat *chatObj=[[FLChat alloc] init];
        chatObj.chatObj_id=[self.profileObj.uid stringValue];
        chatObj.chatObjName=self.profileObj.full_name;
        chatObj.is_online=[self.profileObj.is_online boolValue];
        chatObj.message_type=MSG_TYPE_PRIVATE;
        chatObj.chatObj_image_url=self.profileObj.image;
        chatObj.chatMessageArr=[[NSMutableArray alloc] init];//updating existing obj
        
        chatScreen.currentChatObj=chatObj;
        
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:chatScreen];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
    
}

- (IBAction)giftClicked:(id)sender {
    
}

- (IBAction)friendClicked:(id)sender {
//    if ([self.profileObj.status isEqualToString:@"accepted"])
    if ([self.profileObj.is_friend boolValue])
    {
        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
        [webService friendshipReject:self withFriendshipId:self.profileObj.friendship_id];
    }
    else
    {
        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
        FLFriendship *friendshipObj=[[FLFriendship alloc] init];
        friendshipObj.friend_id=self.profileObj.uid;
        friendshipObj.initiator=YES;
        [webService createFriendship:self withUserData:friendshipObj];
    }

}

- (IBAction)favoriteClicked:(id)sender {
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    //                [webService favouriteRemove:self withFriendshipId:self.profileObj.friendship_id];
    
    [webService favouriteAdd:self withFriendshipId:self.profileObj.friendship_id];
}

- (IBAction)backClicked_iPad:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - Util method

-(void) setupProfilePicture{
    
    //thilina****
    
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    NSString *imgNameWithPath = [self.profileObj.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
    NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
    
    
    //get previous indicator out
    UIView *act = [self.imgProfilePic viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    __block FLProfileViewController *context = self;
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
    
    
}

-(void) addAnimationToProfilePicture{
    
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


#pragma mark -
#pragma mark - webservice Api call

-(void)createFriendshipResult:(NSString *)message
{
    NSLog(@"createFriendshipResult message %@",message);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}

-(void)friendshipRejectResult:(NSString *)message
{
    NSLog(@"createFriendshipResult message %@",message);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadFrndReqTbl" object:self];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
    
}

-(void)addFavouriteResult:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:str delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
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



@end
