//
//  FLNotificationSettingsViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLNotificationSettingsViewController.h"

@interface FLNotificationSettingsViewController ()

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UIView *content;

@property(weak, nonatomic) IBOutlet UISwitch *notification;
@property(weak, nonatomic) IBOutlet UISwitch *sounds;

@property(weak, nonatomic) IBOutlet UISwitch *gifts;
@property(weak, nonatomic) IBOutlet UISwitch *profileVisitors;
@property(weak, nonatomic) IBOutlet UISwitch *messages;
@property(weak, nonatomic) IBOutlet UISwitch *favourits;
@property(weak, nonatomic) IBOutlet UISwitch *friends;
@property(weak, nonatomic) IBOutlet UISwitch *findMe;
@property(weak, nonatomic) IBOutlet UISwitch *freeCredits;
@property(weak, nonatomic) IBOutlet UISwitch *match;
@property(weak, nonatomic) IBOutlet UISwitch *comment;


@end

@implementation FLNotificationSettingsViewController

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
    self.navigationItem.title = @"Notifications";
    
    //ui switches
    self.notification.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.sounds.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.gifts.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.profileVisitors.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.messages.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.favourits.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.friends.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.findMe.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.freeCredits.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.match.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.comment.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    
    [self.scrollView addSubview:self.content];
    [self.scrollView setContentSize:self.content.frame.size];

    
    //back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
    if(IS_IPAD){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:@"GLOBAL_BACK_BUTTON_PRESSED" object:nil];
    }
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
