//
//  FLBlockedPeopleViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLBlockedPeopleViewController.h"
#import "FLUnblockCell.h"
#import "FLOtherProfile.h"

@interface FLBlockedPeopleViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(weak, nonatomic) IBOutlet UITableView *unblockTable;
@property(nonatomic,strong) NSMutableArray *blockedUsersArr;
@end

@implementation FLBlockedPeopleViewController

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
    [self.unblockTable registerNib:[UINib nibWithNibName:@"FLUnblockCell" bundle:nil] forCellReuseIdentifier:@"FLUnblockCell"];
    
    self.navigationItem.title =  @"Blocked People";

    
    //back button

    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
  
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
    if(IS_IPAD){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:@"GLOBAL_BACK_BUTTON_PRESSED" object:nil];
    }
    
    self.blockedUsersArr=[[NSMutableArray alloc] init];

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
    [webService blockedUserList:self];
}


-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}


-(void) goBack
{
    if(IS_IPAD){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GLOBAL_BACK_BUTTON_PRESSED" object:nil];
        NSDictionary *dict = @{RemoteAction:kHideRightBackButton};
        self.communicator(dict);
    }
    [self.navigationController popViewControllerAnimated:YES];
}




//FLUnblockCell





#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.blockedUsersArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FLUnblockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLUnblockCell"];
      FLOtherProfile *profileObj=(FLOtherProfile *)[self.blockedUsersArr objectAtIndex:indexPath.row];
    
    if(!cell.isButtonActionSet) [cell.unblockButton addTarget:self action:@selector(unblockPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.unblockButton.tag = indexPath.row;
    
    //your data here,
    cell.profileNameLabel.text =  profileObj.full_name;
    
    
    //if icon type of the cell is Drink/Kiss, then cell on click will navigate to My gifts page
    //if the icon type is fine me request, then cell on click will show you the map
    
    return cell;
}






#pragma mark - Table view delegate
-(void) unblockPressed:(UIButton *) button{
    NSLog(@"unblock tapped for: %d", button.tag);
    
    FLOtherProfile *profileObj=[self.blockedUsersArr objectAtIndex:button.tag];
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
    [webService unblockUser:self withUserID:[NSString stringWithFormat:@"%@",profileObj.uid]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Webservice api delegate method

-(void)blockedUsersListResult:(NSMutableArray *)blockUsersArr
{
    self.blockedUsersArr=blockUsersArr;
    [self.unblockTable reloadData];
    [HUD hide:YES];
}

-(void)unblockUserResult:(NSString *)str
{
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService blockedUserList:self];
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
