//
//  FLFAddFriendsViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/22/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLFAddFriendsViewController.h"
#import "UIViewController+TabHider.h"
#import <MessageUI/MessageUI.h>

@interface FLFAddFriendsViewController ()<UISearchBarDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
@property(weak, nonatomic) IBOutlet UISearchBar *serachBar;
@end

@implementation FLFAddFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Add Friends";
    
    //back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
}





-(void) goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void) viewWillAppear:(BOOL)animated{
    [self hideTabBar:self.tabBarController];
}
-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}







#pragma mark - SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar; {
    NSLog(@"Search button pressed");
    [searchBar resignFirstResponder];
}








#pragma mark - button press events

-(IBAction) inviteThroughFacebookButtonPressed:(id)sender;{
    
}

-(IBAction) inviteByEmailButtonPressed:(id)sender;{
    [self showEmail];
}

-(IBAction) inviteBySMSButtonPressed:(id)sender;{
    [self showSMS];
}

-(IBAction) copyInviteTextButtonPressed:(id)sender;{
    [self copyToClipBoard];
}







#pragma mark - Email
- (void) showEmail{
    // Email Subject
    NSString *emailTitle = @"Flingoo Rox";
    // Email Content
    NSString *messageBody = @"Hey flingoo is amazing !!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@""];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}










#pragma mark - SMS

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil)message:NSLocalizedString(@"failed_to_send_sms", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSMS{
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"your_device_doesnt_sms", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = @"Join with Flingoooo!";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}





#pragma mark - Copy to clipboard

-(void) copyToClipBoard{
    [UIPasteboard generalPasteboard].string = @"hello!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"success", nil) message:NSLocalizedString(@"invite_text_clopied", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"dismiss", nil) otherButtonTitles:nil];
    [alert show];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
