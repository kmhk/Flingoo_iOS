//
//  FLVIPUpgradeViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLVIPUpgradeViewController.h"
#import "FLVIPMembershipsViewController.h"

@interface FLVIPUpgradeViewController ()
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UIView *content;
-(IBAction) buttonButtonPressed:(UIButton *)button;
@end

@implementation FLVIPUpgradeViewController

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
    [self.scrollView setContentSize:self.content.frame.size];
    [self.scrollView addSubview:self.content];
    self.navigationController.navigationBar.topItem.title = @"VIP Upgrade";
    
    
    //back button
    
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];    
    
    NSLog(@"VIEW DID LOAD");
    NSLog(@"view:%@", self.view);
    NSLog(@"parentScrollView:%@", self.parentScrollView);
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opaque = NO;
//        self.view.layer.opacity = 0;
    }
}


-(void) viewDidAppear:(BOOL)animated{
    NSLog(@"VIEW DID APPEAR");
    NSLog(@"view:%@", self.view);
    NSLog(@"parentScrollView:%@", self.parentScrollView);
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}


-(void) goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}










#pragma mark - button actions



-(IBAction) buttonButtonPressed:(UIButton *)button;{
    
    switch (button.tag) {
        case 1:
        {
            //become a vip
            FLVIPMembershipsViewController *membershipsViewController = [[FLVIPMembershipsViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLVIPMembershipsViewController-568h":@"FLVIPMembershipsViewController" bundle:nil];
            [self.navigationController pushViewController:membershipsViewController animated:YES];
        }
            break;
        case 2:
        {
            //bubble messages
            
        }
            break;
        case 3:
        {
            //highlighted
            
            
        }
            break;
        case 4:
        {
            //add free
            
            
        }
            break;
        case 5:
        {
            //ghost mode
            
            
        }
            break;
        case 6:
        {
            //free confirmation
            
            
        }
            break;
        case 7:
        {
            //unlimited matches
            
            
        }
            break;
        case 8:
        {
            //free gifts
            
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
