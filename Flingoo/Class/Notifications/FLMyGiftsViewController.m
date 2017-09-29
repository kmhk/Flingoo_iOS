//
//  FLMyGiftsViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMyGiftsViewController.h"
#import "FLMyGiftCell.h"
#import "FLGift.h"
#import "Config.h"
#import "FLUtil.h"

@interface FLMyGiftsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(weak, nonatomic) IBOutlet UITableView *myGiftsTable;
@property(nonatomic,strong) NSMutableArray *giftArr;
@property(nonatomic, assign) GiftViewMode giftViewMode;

@end



@implementation FLMyGiftsViewController


#pragma mark - Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil launchMode:(GiftViewMode) launchMode;{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _giftViewMode = launchMode;
    }
    return self;
}





#pragma mark - View Lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //add refresh controller
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.myGiftsTable addSubview:refreshControl];
    
    self.giftArr=[[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"My Gifts";
    self.navigationItem.backBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem.title = @"Back";
    
    [self.myGiftsTable registerNib:[UINib nibWithNibName:@"FLMyGiftCell" bundle:nil] forCellReuseIdentifier:@"FLMyGiftCell"];
    [self setUpGraphics];
        
    //back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
 
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
    [self dataLoad];
    
}

-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}



-(void) goBack{
    if(self.giftViewMode==kGiftViewModePush){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - Util

-(void)dataLoad
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
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService getGiftAllReceivedItems:self];
}


#pragma mark - MISC

-(void) setUpGraphics{
    self.myGiftsTable.separatorColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self dataLoad];
}


/*
 
 @{@"sender":@"Albert Einstein",@"profilePic":@"profilePic2.png",@"requestType":@0,@"requestString":@"Find Me Request"},
 @{@"sender":@"Anna Hurtz",@"profilePic":@"profilePic.png",@"requestType":@5,@"requestString":@"Kiss"},
 @{@"sender":@"Jane Pieterz",@"profilePic":@"profilePic3.png",@"requestType":@2,@"requestString":@"Friend Request"},
 @{@"sender":@"Napoleon Bonaparte",@"profilePic":@"profilePic4.png",@"requestType":@3,@"requestString":@"Chat Request"},
 @{@"sender":@"Bertrand Russell",@"profilePic":@"profilePic2.png",@"requestType":@4,@"requestString":@"Milk Coffee"}
 
 */



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.giftArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLMyGiftCell *cell = (FLMyGiftCell *)[tableView dequeueReusableCellWithIdentifier:@"FLMyGiftCell"];
    
    //adde button action
    cell.giftPictureViewButton.tag = indexPath.row;
    [cell.giftPictureViewButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    //your data here,
//    if(indexPath.row==0){
//        cell.profileNameLabel.text = @"Anna Hurtz";
//        cell.profilePictureView.image = [UIImage imageNamed:@"profilePic.png"];
//        cell.giftPictureView.image = [UIImage imageNamed:@"kiss.PNG"];
//        cell.online = YES;
//    }else{
//        cell.profileNameLabel.text = @"Bertrand Russell";
//        cell.profilePictureView.image = [UIImage imageNamed:@"profilePic2.png"];
//        cell.giftPictureView.image = [UIImage imageNamed:@"espresso.PNG"];
//        cell.online = YES;
//    }
    
    FLGift *giftObj=(FLGift *)[self.giftArr objectAtIndex:indexPath.row];
    cell.profileNameLabel.text = giftObj.sender_full_name;
    cell.subtitleLabel.text=[NSString stringWithFormat:@"Sent you a %@",giftObj.gift_name];
    
     cell.giftPictureView.image = [UIImage imageNamed:[FLUtil getImageNameForGiftName:giftObj.gift_name]];
    
//    if ([giftObj.gift_type isEqualToString:@"kiss"])
//    {
//        cell.giftPictureView.image = [UIImage imageNamed:@"kiss.PNG"];
//    }
//    else if ([giftObj.gift_type isEqualToString:@"drink"])
//    {
//        cell.giftPictureView.image = [UIImage imageNamed:@"espresso.PNG"];
//    }
    
    cell.online = [giftObj.sender_is_online boolValue];
    cell.timeLabel.text = [giftObj.created_at stringWithISO8061Format];
    ///////////////////////////////////////////////////////////////////
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    NSString *imgNameWithPath = [giftObj.sender_image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
    NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
    
    
    //get previous indicator out
    UIView *act = [cell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    __weak FLMyGiftCell *weakCell = cell;
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

-(void) buttonPressed:(UIButton *) button;{
    NSLog(@"clickedButtonRow: %d", button.tag);
}


#pragma mark - Others

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark - Webservice api delegate method

-(void)giftReceivedAllListResult:(NSMutableArray *)receivedGiftArr
{
    [HUD hide:YES];
    [self.giftArr removeAllObjects];
    self.giftArr=receivedGiftArr;
    [self.myGiftsTable reloadData];
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



@end
