//
//  FLBuyCreditsViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLBuyCreditsViewController.h"
#import "FLTransactionClient.h"
#import "FLGlobalSettings.h"
#import "FLEarnCell.h"
#import "FLUtil.h"

@interface FLBuyCreditsViewController ()<UITableViewDataSource, UITableViewDelegate>

    @property(weak, nonatomic) IBOutlet UITableView *tableView;
    @property(weak, nonatomic) IBOutlet UILabel *balanceLabel;

    @property(nonatomic, strong) NSArray *souceArray;

@end

@implementation FLBuyCreditsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [FLTransactionClient sharedInstance:^(BOOL success, NSArray *products) {
            
            
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"FLEarnCell" bundle:nil] forCellReuseIdentifier:@"FLEarnCell"];
    
    self.navigationItem.title =  @"Buy Credits";
    
    [self.balanceLabel setText:[NSString stringWithFormat:@"Your Balance : %d", [[FLGlobalSettings sharedInstance].current_user_profile.credits_remaining intValue]]];
    
    //load initial data ern_Coins1.png
    self.souceArray = @[
                             @{@"id":@1,@"title":@"250 Credits", @"subtitle":@"$ 0.99", @"image":@"ern_Coins1.png"},
                             @{@"id":@2,@"title":@"525 Credits", @"subtitle":@"$ 1.99 (Save 10%)", @"image":@"ern_Coins2.png"},
                             @{@"id":@3,@"title":@"1200 Credits", @"subtitle":@"$ 9.99 (Save 20%)", @"image":@"ern_Coins3.png"}
                             
                             ];

    
    //back button
    
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    if(IS_IPAD){
//        self.view.layer.anchorPoint = CGPointMake(0,0);
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        self.parentScrollView.layer.opacity = 0;
        [CATransaction commit];
        
//        self.view.transform = CGAffineTransformMakeScale(1.7,1.7);
    }
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





-(void) goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}










#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.souceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Create an instance of PointsItemCell
    FLEarnCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"FLEarnCell"];
    
    [cell setEarnType:kEarnTypeBuy];
    if(!cell.isButtonEventSet){
        [cell.buyButton addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.buyButton.tag = indexPath.row;
    
    
    
    //set your data here,
    NSDictionary *dict = [self.souceArray objectAtIndex:indexPath.row];
    if(dict){
        if([dict objectForKey:@"title"]){
            cell.earnTitleLabel.text = [dict objectForKey:@"title"];
        }
        if([dict objectForKey:@"subtitle"]){
            cell.earnSubtitle.text = [dict objectForKey:@"subtitle"];
        }
        if([dict objectForKey:@"image"]){
            cell.earnImageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
        }
    }
    
    return cell;
}



-(void) buyButtonPressed:(UIButton *) button{
    NSLog(@"buy button for row:%d", button.tag);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
