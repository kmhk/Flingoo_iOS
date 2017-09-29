//
//  FLShowGiftsViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/24/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//


#import "FLShowGiftsViewController.h"
#import "FLDetailedGiftCell.h"
#import "FLUtil.h"
#import "FLGiftItem.h"
#import "FLGlobalSettings.h"
#import "Config.h"

@interface FLShowGiftsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(weak, nonatomic) IBOutlet UICollectionView *giftsTable;



@end

@implementation FLShowGiftsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil giftTableType:(GiftTableType) gType;{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _giftType = gType;
    }
    return self;
}

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
    // Do any additional setup after loading the view from its nib.

    
    if(self.giftType==kGiftTableTypeKiss){
        self.giftTypeNameLabel.text = @"Kisses";
        self.navigationItem.title = @"Kisses";
//        self.giftsArray = @[
//                            @{@"name":@"Kiss",@"credit":@"1 credit",@"count":@"15",@"small":@"kissgrayicon.PNG", @"large":@"kiss.PNG"},
//                            @{@"name":@"Diamond Kiss",@"credit":@"5 credits",@"count":@"0",@"small":@"kissgrayicon.PNG", @"large":@"diamonkiss.PNG"},
//                            @{@"name":@"Fruity Kiss",@"credit":@"5 credits",@"count":@"2",@"small":@"kissgrayicon.PNG", @"large":@"fruitkiss.PNG"},
//                            @{@"name":@"Candy Kiss",@"credit":@"5 credits",@"count":@"4",@"small":@"kissgrayicon.PNG", @"large":@"candykiss.PNG"},
//                            @{@"name":@"Vampire Kiss",@"credit":@"5 credits",@"count":@"1",@"small":@"kissgrayicon.PNG", @"large":@"vampirekiss.PNG"},
//                            @{@"name":@"Gentleman Kiss",@"credit":@"5 credits",@"count":@"0",@"small":@"kissgrayicon.PNG", @"large":@"rosekiss.PNG"}
//                            ];
    }else{
        self.giftTypeNameLabel.text = @"Drinks";
        self.navigationItem.title = @"Drinks";
//        self.giftsArray = @[
//                            @{@"name":@"Espresso",@"credit":@"5 credits",@"count":@"15",@"small":@"espressogray.PNG", @"large":@"espresso.PNG"},
//                            @{@"name":@"Latte MAcchiato",@"credit":@"5 credits",@"count":@"0",@"small":@"lattemgray.PNG", @"large":@"lattem.PNG"},
//                            @{@"name":@"Coctail",@"credit":@"5 credits",@"count":@"0",@"small":@"coketailgray.PNG", @"large":@"coketail.PNG"},
//                            @{@"name":@"Shot",@"credit":@"5 credits",@"count":@"0",@"small":@"shotgray.PNG", @"large":@"shot.PNG"},
//                            @{@"name":@"Long Drink",@"credit":@"5 credits",@"count":@"0",@"small":@"longdgray.PNG", @"large":@"longd.PNG"},
//                            @{@"name":@"Soft Drink",@"credit":@"5 credits",@"count":@"0",@"small":@"softdgray.PNG", @"large":@"softd.PNG"}
//                            ];
    }
    
                    
    [self.giftsTable registerNib:[UINib nibWithNibName:@"FLDetailedGiftCell" bundle:nil] forCellWithReuseIdentifier:@"FLDetailedGiftCell"];
    
    
    //back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
}

-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}


-(void)setGiftType:(GiftTableType)giftType{
    if(giftType==kGiftTableTypeKiss){
        self.giftTypeNameLabel.text = @"Kisses";
        self.navigationItem.title = @"Kisses";
//        self.giftsArray = @[
//                            @{@"name":@"Kiss",@"credit":@"1 credit",@"count":@"15",@"small":@"kissgrayicon.PNG", @"large":@"kiss.PNG"},
//                            @{@"name":@"Diamond Kiss",@"credit":@"5 credits",@"count":@"0",@"small":@"kissgrayicon.PNG", @"large":@"diamonkiss.PNG"},
//                            @{@"name":@"Fruity Kiss",@"credit":@"5 credits",@"count":@"2",@"small":@"kissgrayicon.PNG", @"large":@"fruitkiss.PNG"},
//                            @{@"name":@"Candy Kiss",@"credit":@"5 credits",@"count":@"4",@"small":@"kissgrayicon.PNG", @"large":@"candykiss.PNG"},
//                            @{@"name":@"Vampire Kiss",@"credit":@"5 credits",@"count":@"1",@"small":@"kissgrayicon.PNG", @"large":@"vampirekiss.PNG"},
//                            @{@"name":@"Gentleman Kiss",@"credit":@"5 credits",@"count":@"0",@"small":@"kissgrayicon.PNG", @"large":@"rosekiss.PNG"}
//                            ];
    }else{
        self.giftTypeNameLabel.text = @"Drinks";
        self.navigationItem.title = @"Drinks";
//        self.giftsArray = @[
//                            @{@"name":@"Espresso",@"credit":@"5 credits",@"count":@"15",@"small":@"espressogray.PNG", @"large":@"espresso.PNG"},
//                            @{@"name":@"Latte MAcchiato",@"credit":@"5 credits",@"count":@"0",@"small":@"lattemgray.PNG", @"large":@"lattem.PNG"},
//                            @{@"name":@"Coctail",@"credit":@"5 credits",@"count":@"0",@"small":@"coketailgray.PNG", @"large":@"coketail.PNG"},
//                            @{@"name":@"Shot",@"credit":@"5 credits",@"count":@"0",@"small":@"shotgray.PNG", @"large":@"shot.PNG"},
//                            @{@"name":@"Long Drink",@"credit":@"5 credits",@"count":@"0",@"small":@"longdgray.PNG", @"large":@"longd.PNG"},
//                            @{@"name":@"Soft Drink",@"credit":@"5 credits",@"count":@"0",@"small":@"softdgray.PNG", @"large":@"softd.PNG"}
//                            ];
    }
    _giftType = giftType;
    [self.giftsTable reloadData];
}





-(void) goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark
#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.giftObjArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FLDetailedGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FLDetailedGiftCell" forIndexPath:indexPath];

    
    //set your data here,
    FLGiftItem *giftItemObj = [self.giftObjArr objectAtIndex:indexPath.row];
  
      
        cell.giftNameLabel.text = giftItemObj.name;
    cell.creditLAbel.text =[NSString stringWithFormat:@"%@ Credits",[giftItemObj.credits_required stringValue]];
        //hemalasankas**
            cell.countLabel.text = @"0";
   
     cell.largeGiftView.image =[UIImage imageNamed:[FLUtil getImageNameForGiftName:giftItemObj.name]];
    
//        if (self.giftType==kGiftTableTypeKiss)
//        {
//            cell.largeGiftView.image =[UIImage imageNamed:@"kiss.PNG"];
//        }
//        else
//        {
//             cell.largeGiftView.image =[UIImage imageNamed:@"espresso.PNG"];
//        }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //     [self cellSelect:(FLOtherProfile *)[findPeopleArr objectAtIndex:[indexPath row]]];
    

    FLGiftItem *giftObj=[self.giftObjArr objectAtIndex:indexPath.row];
 
    if ([giftObj.credits_required intValue] < [[FLGlobalSettings sharedInstance].current_user_profile.credits_remaining intValue]) {
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
        [webServiceApi giftSend:self withGiftItemID:giftObj withReceiverID:self.profileObj.uid];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:@"You don't have enough creadit" delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark - FlowLayout Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(145, 173);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(IS_IPAD){
        return UIEdgeInsetsMake(10,50,10,50);
    }else{
        return UIEdgeInsetsMake(10,10,10,10);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Webservice api delegate method



-(void)giftSendResult:(FLGiftItem *)giftObject:(NSString *)msg
{
    [HUD hide:YES];
    //balance creadit for current user
    [FLGlobalSettings sharedInstance].current_user_profile.credits_remaining=[NSNumber numberWithInt:([[FLGlobalSettings sharedInstance].current_user_profile.credits_remaining intValue]-[giftObject.credits_required intValue])];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PROFILE_UPDATED
     object:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    [alert show];
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
