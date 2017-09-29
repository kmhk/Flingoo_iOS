//
//  FLFreeCreditsViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLFreeCreditsViewController.h"
#import "FLBuyCreditsViewController.h"
#import "FLEarnCell.h"

@interface FLFreeCreditsViewController ()<UITableViewDataSource, UITableViewDelegate>

    @property(weak, nonatomic) IBOutlet UITableView *tableView;

    @property(nonatomic, strong) NSArray *souceArray;

@end

@implementation FLFreeCreditsViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"FLEarnCell" bundle:nil] forCellReuseIdentifier:@"FLEarnCell"];
    
    self.navigationController.navigationBar.topItem.title =  @"Free Credits";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 87, 33);
    [button addTarget:self action:@selector(buyCreditsBtnPress) forControlEvents: UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"ern_buyCredits.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    
    //source data
    self.souceArray = @[
                        @{@"id":@1,@"title":@"Earn credits with Sponsorpay", @"subtitle":@"Get up to 1000 credits", @"image":@"ern_sp.png"},
                        @{@"id":@2,@"title":@"Earn credits with Tapjoy", @"subtitle":@"Get up to 1000 credits", @"image":@"ern_tapjoy.png"},
                        @{@"id":@3,@"title":@"Become a VIP member", @"subtitle":@"Get weekly 100 credits", @"image":@"ern_vip.png"},
                        
                        @{@"id":@4,@"title":@"Daily login", @"subtitle":@"Get 5 credits", @"image":@"ern_login.png"},
                        @{@"id":@5,@"title":@"Confirm email address", @"subtitle":@"Get one time 25 credits", @"image":@"ern_emailcon.png"},
                        @{@"id":@6,@"title":@"Confirm phone number", @"subtitle":@"Get one time 25 credits", @"image":@"ern_MobileNo.png"},
                        
                        @{@"id":@7,@"title":@"Link to facebook", @"subtitle":@"Get one time 25 credits", @"image":@"ern_fb.png"},
                        @{@"id":@8,@"title":@"Invite Friend", @"subtitle":@"Get one time 100 credits", @"image":@"ern_invite.png"},
                        
                        ];
    
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



-(void) goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
    



-(void) buyCreditsBtnPress{
    FLBuyCreditsViewController *buyCredits = [[FLBuyCreditsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLBuyCreditsViewController-568h":@"FLBuyCreditsViewController" bundle:nil];
    [self.navigationController pushViewController:buyCredits animated:YES];
}









#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.souceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Create an instance of PointsItemCell
    FLEarnCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"FLEarnCell"];
    [cell setEarnType:kEarnTypeFree];
    
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


#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"row:%d", indexPath.row);
    
    switch (indexPath.row) {
        case 0:
        {
            //Sponsorpay
            
        }
            break;
        case 1:
        {
         //Tapjoy
            
        }
            break;
        case 2:
        {
            //VIP member
            
        }
            break;
        case 3:
        {
            //login
            
        }
            break;
        case 4:
        {
            //email address
            
            
        }
            break;
        case 5:
        {
            //photo number
            
        }
            break;
        case 6:
        {
            //facebook
            
        }
            break;
        case 7:
        {
            //invite
            
        }
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
