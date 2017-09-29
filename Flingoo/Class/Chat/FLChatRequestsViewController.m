//
//  FLRevealUnfriendedViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//
//FLUnfriendedCell
#import "FLChatRequestsViewController.h"
#import "FLChatCell.h"
#import "FLChatScreenViewController.h"

@interface FLChatRequestsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property(weak, nonatomic) IBOutlet UITableView *unfriendTable;
@end

@implementation FLChatRequestsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Requests";
        self.tabBarItem.image = [UIImage imageNamed:@"chat_request_icon.png"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Requests";
    
    //add refreshController
    
    UIRefreshControl *tableEefreshControl = [[UIRefreshControl alloc] init];
    [tableEefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.unfriendTable addSubview:tableEefreshControl];
    
    self.unfriendTable.separatorColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
    
    //register custom cell
    [self.unfriendTable registerNib:[UINib nibWithNibName:@"FLChatCell" bundle:nil] forCellReuseIdentifier:@"FLChatCell"];
    
    
    //set chat request icon
    UITabBarItem *tbi = (UITabBarItem*)[[[self.tabBarController tabBar] items] objectAtIndex:1];
    [tbi setBadgeValue:@"5"];

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




#pragma mark - SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar; {
    NSLog(@"Search button pressed");
    
    //1) filter records in the table
    //2) reload tableview
    [self.unfriendTable reloadData];
    
    [searchBar resignFirstResponder];
}






#pragma mark - refresh controller

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    [refreshControl endRefreshing];
}





#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Create an instance of PointsItemCell
    FLChatCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"FLChatCell"];
//    if(!cell.graphicsReady) [cell makeGraphicsReady];
    
    
    //set your data here,
    [cell setOnline:[self randomBOOL]];
    [cell.profilePictureView setImage:[UIImage imageNamed:@"profilePic2.png"]];
    
    cell.profileNameLabel.text = @"Chris Anderson";
    cell.subtitleLabel.text = @"Hi";
    
    return cell;
}






#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(IS_IPAD){
        NSDictionary *dict = @{RemoteAction:kRemoteActionShowChatScreen,@"ClickedIndex":[NSNumber numberWithInt:indexPath.row]};
        self.communicator(dict);
    }else{
        FLChatScreenViewController *chatScreen = [[FLChatScreenViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLChatScreenViewController-568h":@"FLChatScreenViewController" bundle:nil];
        [self.navigationController pushViewController:chatScreen animated:YES];
        NSLog(@"didSelectRowAtIndexPath: %d", indexPath.row);
    }
}






#pragma mark - MISC
-(BOOL) randomBOOL{
    int r = arc4random() % 2;
    return ((r==0)? NO: YES);
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
