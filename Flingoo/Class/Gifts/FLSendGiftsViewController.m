//
//  FLSendGiftsViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLSendGiftsViewController.h"
#import "FLSendGiftCell.h"
#import "FLShowGiftsViewController.h"
#import "FLUtil.h"
#import "FLGiftItem.h"

#define  gift_item_type_kiss @"kiss"//kiss and drink hardcoded
#define  gift_item_type_drink @"drink"

@interface FLSendGiftsViewController ()<UITableViewDataSource, UITableViewDelegate>
    @property(weak, nonatomic) IBOutlet UITableView *sendGiftsTable;
@property(nonatomic, strong) NSMutableArray *giftTypesArray;
@property(nonatomic, strong) NSMutableArray *kissTypesArray;
@property(nonatomic, strong) NSMutableArray *drinkTypesArray;

@end

@implementation FLSendGiftsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Send Gift";
    self.giftTypesArray=[[NSMutableArray alloc] init];
    self.kissTypesArray=[[NSMutableArray alloc] init];
    self.drinkTypesArray=[[NSMutableArray alloc] init];
    
    //register custom cell
    [self.sendGiftsTable registerNib:[UINib nibWithNibName:@"FLSendGiftCell" bundle:nil] forCellReuseIdentifier:@"FLSendGiftCell"];
    
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
//<##>
//    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
//[webServiceApi getUserSettingsList:self];
////    [webServiceApi getGiftItemAllList:self];
//[webServiceApi likeToUser:self withUserID:@"160"];
//likeToUser
    
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Connecting";
	HUD.square = YES;
    [HUD show:YES];
    
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    [webServiceApi getGiftItemAllList:self];
}

-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}




-(void) goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.giftTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FLSendGiftCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"FLSendGiftCell"];
    
    
    //set your data here,
    NSDictionary *dict = [self.giftTypesArray objectAtIndex:indexPath.row];
    NSLog(@"dict:%@", dict);
    if(dict){
        if([dict objectForKey:@"giftTyepeName"]){
            cell.giftTypeLabel.text = [dict objectForKey:@"giftTyepeName"];
        }
        if([dict objectForKey:@"giftTypeImage"]){
            cell.giftTypeImageView.image = [UIImage imageNamed:[dict objectForKey:@"giftTypeImage"]];
            NSLog(@"cell.giftTypeImageView.image:%@", cell.giftTypeImageView.image);
        }
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD){
        if(indexPath.row==0){
            NSDictionary *dict = @{RemoteAction:kRemoteActionShowKissGifts};
            self.communicator(dict);
        }else{
             NSDictionary *dict = @{RemoteAction:kRemoteActionShowDrinkGifts};
            self.communicator(dict);
        }
        
    }else{
        if(indexPath.row==0){
            FLShowGiftsViewController *show = [[FLShowGiftsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLShowGiftsViewController-568h":@"FLShowGiftsViewController" bundle:nil giftTableType:kGiftTableTypeKiss];
            NSDictionary *dict = [self.giftTypesArray objectAtIndex:indexPath.row];
            show.giftObjArr=[dict objectForKey:@"giftObjArr"];
            show.profileObj=self.profileObj;
            [self.navigationController pushViewController:show animated:YES];
            
        }else if(indexPath.row==1){
            FLShowGiftsViewController *show = [[FLShowGiftsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLShowGiftsViewController-568h":@"FLShowGiftsViewController" bundle:nil giftTableType:kGiftTableTypeDrink];
            NSDictionary *dict = [self.giftTypesArray objectAtIndex:indexPath.row];
            show.giftObjArr=[dict objectForKey:@"giftObjArr"];
            show.profileObj=self.profileObj;
            [self.navigationController pushViewController:show animated:YES];
        }
    }
}

#pragma mark -
#pragma mark - Webservice api delegate method


-(void)giftItemListResult:(NSMutableArray *)giftArr
{
    [HUD hide:YES];
    [self.kissTypesArray removeAllObjects];
    [self.drinkTypesArray removeAllObjects];
    for (id gift in giftArr)
    {
        FLGiftItem *giftObj=(FLGiftItem *)gift;
        if ([giftObj.item_type isEqualToString:gift_item_type_kiss])
        {
            [self.kissTypesArray addObject:giftObj];
        }
        else if ([giftObj.item_type isEqualToString:gift_item_type_drink])
        {
            [self.drinkTypesArray addObject:giftObj];
        }
    }
    
    self.giftTypesArray = [@[
                           @{@"giftTyepeName":@"Send a Kiss",@"giftTypeImage":@"send_kisses.PNG",@"giftObjArr":self.kissTypesArray},
                           @{@"giftTyepeName":@"Invite for a Drink",@"giftTypeImage":@"send_drinks.PNG",@"giftObjArr":self.drinkTypesArray}
                           ] mutableCopy];
    
    [self.sendGiftsTable reloadData];
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
