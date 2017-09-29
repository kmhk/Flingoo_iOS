//
//  FLUITabBarController.m
//  Take Secure Pics
//
//  Created by Prasad De Zoysa on 9/15/13.
//  Copyright (c) 2013 Prasad De Zoysa. All rights reserved.
//

#import "FLUITabBarController.h"
#import <QuartzCore/QuartzCore.h>
#import "FLSendGiftsViewController.h"
#import "FLReportAndBlock.h"
#import "FLChatScreenViewController.h"
#import "FLGlobalSettings.h"
#import "FLChat.h"
#import "Config.h"

@interface FLUITabBarController ()
@property (nonatomic,strong) FLOtherProfile *profileObj;
@end

@implementation FLUITabBarController

@synthesize leftButton,rightButton,centerButton;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProfileObj:(FLOtherProfile *)profileObj
{
    self.profileObj=profileObj;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.profileObj=profileObj;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self addCustomButtons];
    if (IS_IPHONE_5)
    {
        viewDummy=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,568)];
    }
    else
    {
        viewDummy=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,480)];
    }
    
    [viewDummy setBackgroundColor:[UIColor blackColor]];
    viewDummy.alpha=0;
    [self.view addSubview:viewDummy];
    
    UILabel *lblTitleChat = [[UILabel alloc] initWithFrame:CGRectMake(-1, 44, 47, 15)];
    [lblTitleChat setTextColor:[UIColor whiteColor]];
    [lblTitleChat setBackgroundColor:[UIColor clearColor]];
    [lblTitleChat setFont:[UIFont systemFontOfSize:12]];
    [lblTitleChat setTextAlignment:NSTextAlignmentCenter];
    [lblTitleChat setText:@"Chat"];
    
    UILabel *lblTitleGift = [[UILabel alloc] initWithFrame:CGRectMake(-1, 44, 47, 15)];
    [lblTitleGift setTextColor:[UIColor whiteColor]];
    [lblTitleGift setBackgroundColor:[UIColor clearColor]];
    [lblTitleGift setFont:[UIFont systemFontOfSize:12]];
    [lblTitleGift setTextAlignment:NSTextAlignmentCenter];
    [lblTitleGift setText:@"Gift"];
    
    UILabel *lblTitleFriend = [[UILabel alloc] initWithFrame:CGRectMake(-1, 44, 47, 15)];
    [lblTitleFriend setTextColor:[UIColor whiteColor]];
    [lblTitleFriend setBackgroundColor:[UIColor clearColor]];
    [lblTitleFriend setFont:[UIFont systemFontOfSize:12]];
    [lblTitleFriend setTextAlignment:NSTextAlignmentCenter];
//    [lblTitleFriend setText:[self.profileObj.status isEqualToString:@"accepted"]?@"Unfriend":@"Friend"];
    [lblTitleFriend setText:[self.profileObj.is_friend boolValue]?@"Unfriend":@"Friend"];
    
    UILabel *lblTitleFavorite = [[UILabel alloc] initWithFrame:CGRectMake(-1, 44, 47, 15)];
    [lblTitleFavorite setTextColor:[UIColor whiteColor]];
    [lblTitleFavorite setBackgroundColor:[UIColor clearColor]];
    [lblTitleFavorite setFont:[UIFont systemFontOfSize:12]];
    [lblTitleFavorite setTextAlignment:NSTextAlignmentCenter];
    [lblTitleFavorite setText:@"Favorite"];
    
    UILabel *lblTitleReport = [[UILabel alloc] initWithFrame:CGRectMake(-1, 44, 47, 15)];
    [lblTitleReport setTextColor:[UIColor whiteColor]];
    [lblTitleReport setBackgroundColor:[UIColor clearColor]];
    [lblTitleReport setFont:[UIFont systemFontOfSize:12]];
    [lblTitleReport setTextAlignment:NSTextAlignmentCenter];
    [lblTitleReport setText:@"Report"];
    
    
    
    // Default Menu
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat.png"]
                                                           highlightedImage:[UIImage imageNamed:@"chat.png"]
                                                               ContentImage:[UIImage imageNamed:@"chat.png"]
                                                    highlightedContentImage:nil titleLable:lblTitleChat lablesWithArr:nil];
    
    
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"gift.png"]
                                                           highlightedImage:[UIImage imageNamed:@"gift.png"]
                                                               ContentImage:[UIImage imageNamed:@"gift.png"]
                                                    highlightedContentImage:nil titleLable:lblTitleGift lablesWithArr:nil];
    
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"addFrnd.png"]
                                                           highlightedImage:[UIImage imageNamed:[self.profileObj.is_friend boolValue]?@"removeFrnd.png":@"addFrnd.png"]
                                                               ContentImage:[UIImage imageNamed:[self.profileObj.is_friend boolValue]?@"removeFrnd.png":@"addFrnd.png"]
                                                    highlightedContentImage:nil titleLable:lblTitleFriend  lablesWithArr:nil];
    
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"fav.png"]
                                                           highlightedImage:[UIImage imageNamed:@"fav.png"]
                                                               ContentImage:[UIImage imageNamed:@"fav.png"]
                                                    highlightedContentImage:nil titleLable:lblTitleFavorite  lablesWithArr:nil];
    
    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"report.png"]
                                                           highlightedImage:[UIImage imageNamed:@"report.png"]
                                                               ContentImage:[UIImage imageNamed:@"report.png"]
                                                    highlightedContentImage:nil titleLable:lblTitleReport  lablesWithArr:nil];
    
    NSArray *menus;
    NSArray *titleArr;
    if(self.profileObj.friendship_id==nil)
    {
    menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem5, nil];
        titleArr=[[NSArray alloc] initWithObjects:lblTitleChat,lblTitleGift,lblTitleFriend,lblTitleReport, nil];
        
    }
    else
    {
     menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3,starMenuItem4, starMenuItem5, nil];
        titleArr=[[NSArray alloc] initWithObjects:lblTitleChat,lblTitleGift,lblTitleFriend,lblTitleFavorite,lblTitleReport, nil];
    }
   
    
    //    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
    //                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
    //                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
    //                                                highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
    
    

    
    startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bottomorangebtnpressed.png"]
                                                       highlightedImage:[UIImage imageNamed:@"bottomorangebtnpressed.png"]
                                                           ContentImage:[UIImage imageNamed:@"bottomorangebtnpressed.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"bottomorangebtnpressed.png"]titleLable:nil lablesWithArr:titleArr];
    startItem.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
    menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds startItem:startItem optionMenus:menus];
    
    menu.delegate = self;
    int extraHeight=IS_IPHONE5?89:0;
    menu.startPoint = CGPointMake(160, 450.0+extraHeight);
    //    menu.startPoint = CGPointMake(160, 400.0);
    menu.rotateAngle = -1.0;
    menu.menuWholeAngle = (5*M_PI/6 - M_PI/6)-0.1;
    
    menu.nearRadius=140.0f;
    menu.endRadius=150.0f;
    menu.farRadius=170.0f;
    
    [self.view addSubview:menu];
    
//    menu.hidden=YES;
//    startItem.hidden=YES;
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 0:
        {
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
            break;
        case 1:
        {
            FLSendGiftsViewController *gifts = [[FLSendGiftsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLSendGiftsViewController-568h":@"FLSendGiftsViewController" bundle:nil];
            gifts.profileObj=self.profileObj;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:gifts];
            [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
            
            [self presentViewController:navController animated:YES completion:nil];
            
        }
            break;
        case 2:
        {
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
            break;
        case 3:
        {
            
            if(self.profileObj.friendship_id==nil)
            {
              
                
                FLReportAndBlock *reportVwCon = [[FLReportAndBlock alloc] initWithNibName:(IS_IPHONE5)?@"FLReportAndBlock-568h":@"FLReportAndBlock" bundle:nil];
                reportVwCon.profileObj=self.profileObj;
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reportVwCon];
                [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
                
                [self presentViewController:navController animated:YES completion:nil];
            }
            else
            {
                FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
                //                [webService favouriteRemove:self withFriendshipId:self.profileObj.friendship_id];
                
                [webService favouriteAdd:self withFriendshipId:self.profileObj.friendship_id];
            }
        }
            break;
        case 4:
        {
            FLReportAndBlock *gifts = [[FLReportAndBlock alloc] initWithNibName:(IS_IPHONE5)?@"FLReportAndBlock-568h":@"FLReportAndBlock" bundle:nil];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:gifts];
            [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
            
            [self presentViewController:navController animated:YES completion:nil];
        }
            break;
   
        default:
            break;
    }
    
    NSLog(@"Select the index : %d",idx);
}




- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    NSLog(@"Menu was closed!");
    
}

- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {
    NSLog(@"Menu is open!");
    //    [self.view addSubview:viewDummy];
    //    viewDummy.hidden=NO;
    //    [imgProfilePic setBackgroundColor:[UIColor blackColor]];
    //    imgProfilePic.alpha=0.6;
    
}

- (void)awesomeMenuWillFinishAnimationClose:(AwesomeMenu *)menu
{
    NSLog(@"Menu will close!");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6];
    viewDummy.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)awesomeMenuWillAnimationOpen:(AwesomeMenu *)menu
{
    NSLog(@"Menu will open!");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    viewDummy.alpha = 0.6;
    [UIView commitAnimations];
}


// Create a custom UIButton and add it to the center of our tab bar
-(void) addCustomButtons
{

    //    // Background
    //    UIImageView* bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBarBackground.png"]] autorelease];
    //    bgView.frame = CGRectMake(0, 420, 320, 60);
    //    [self.view addSubview:bgView];
    
    // Initialise our two images
    UIImage *btnImage =[UIImage imageNamed:@"profile.png"];
    UIImage *btnImageSelected =[UIImage imageNamed:@"profilePressed.png"];
    int extraHight=IS_IPHONE5?88:0;
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
    leftButton.frame = CGRectMake(0, 430+extraHight, 124, 50); // Set the frame (size and position) of the button)
    [leftButton setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
    [leftButton setBackgroundImage:btnImageSelected forState:UIControlStateHighlighted]; // Set the image for the selected state of the button
    [leftButton setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
 
    [leftButton setImage:btnImageSelected forState:UIControlStateHighlighted];
    [leftButton setImage:btnImageSelected forState:UIControlStateSelected];
   
    
    UILabel  * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,32,118, 20)];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.textColor=[UIColor whiteColor];
    [leftLabel setFont:[UIFont systemFontOfSize:10]];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.text = @"Profile(100%)";
    [leftButton addSubview:leftLabel];
    [leftButton setTag:0];
    
    
    
    UIImage *btnCenterImage = [UIImage imageNamed:@"bottomorangebtn.png"];
    UIImage *btnCenterImageSelected = [UIImage imageNamed:@"bottomorangebtnpressed.png"];
    centerButton= [UIButton buttonWithType:UIButtonTypeCustom];
    centerButton.frame = CGRectMake(118, 421+extraHight, 84, 59);
    [centerButton setBackgroundImage:btnCenterImage forState:UIControlStateNormal];
    [centerButton setBackgroundImage:btnCenterImageSelected forState:UIControlStateSelected];
    [centerButton setBackgroundImage:btnCenterImageSelected forState:UIControlStateHighlighted];
    [centerButton setImage:btnCenterImageSelected forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [centerButton setTag:1];
    [centerButton setSelected:YES];
    
    UIImage *btnRightImage = [UIImage imageNamed:@"gallery.png"];
    UIImage *btnRightImageSelected = [UIImage imageNamed:@"galleryPressed.png"];
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(196, 430+extraHight, 124, 50);
    [rightButton setBackgroundImage:btnRightImage forState:UIControlStateNormal];
    [rightButton setBackgroundImage:btnRightImageSelected forState:UIControlStateSelected];
    [rightButton setBackgroundImage:btnRightImageSelected forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:btnRightImageSelected forState:UIControlStateDisabled];
    [rightButton setImage:btnRightImageSelected forState:UIControlStateHighlighted];
     [rightButton setImage:btnRightImageSelected forState:UIControlStateSelected];
//     [rightButton setImage:btnRightImg forState:UIControlStateNormal];
    [rightButton setTag:2];
    
    UILabel  *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,32,118, 20)];
    rightLabel.backgroundColor = [UIColor clearColor];
    rightLabel.textColor=[UIColor whiteColor];
    [rightLabel setFont:[UIFont systemFontOfSize:10]];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.text = @"Photo Gallery";
    [rightButton addSubview:rightLabel];
    
    
    // Add my new buttons to the view
    [self.view addSubview:leftButton];
    [self.view addSubview:rightButton];
    [self.view addSubview:centerButton];
    
    // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
    [leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [centerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked:(id)sender
{
    int tagNum = [sender tag];
    [self selectTab:tagNum];
}

- (void)selectTab:(int)tabID
{
    switch(tabID)
    {
        case 0:
            menu.hidden=YES;
            startItem.hidden=YES;
            [leftButton setSelected:true];
            [centerButton setSelected:false];
            [rightButton setSelected:false];
            break;
        case 1:
            startItem.hidden=NO;
            menu.hidden=NO;
            [leftButton setSelected:false];
            [centerButton setSelected:true];
            [rightButton setSelected:false];
            break;
        case 2:
            menu.hidden=YES;
            startItem.hidden=YES;
            [leftButton setSelected:false];
            [centerButton setSelected:false];
            [rightButton setSelected:true];
            break;
    }
    self.selectedIndex = tabID;
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
