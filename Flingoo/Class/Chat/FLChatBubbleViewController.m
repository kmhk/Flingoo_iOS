//
//  FLChatBubbleViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 1/13/14.
//  Copyright (c) 2014 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLChatBubbleViewController.h"
#import "UIViewController+TabHider.h"
#import "FLBubbleCell.h"
#import "FLImageBubbleCell.h"
#import "FLChatMessage.h"
#import "FLGlobalSettings.h"
#import "Config.h"
#import "FLWebServiceApi.h"

#define BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_5 CGRectMake(0,460, self.keyboardPanel.frame.size.width, self.keyboardPanel.frame.size.height)
#define BOTTOM_PANEL_VISIBLE_FRAME_IPHONE_5 CGRectMake(0, 311, self.keyboardPanel.frame.size.width, self.keyboardPanel.frame.size.height)
#define BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_4 CGRectMake(0,372, self.keyboardPanel.frame.size.width, self.keyboardPanel.frame.size.height)
#define BOTTOM_PANEL_VISIBLE_FRAME_IPHONE_4 CGRectMake(0, 223, self.keyboardPanel.frame.size.width, self.keyboardPanel.frame.size.height)

#define BOTTOM_PANEL_HIDDEN_FRAME CGRectMake(0,self.view.frame.size.height- (20 + 44), self.keyboardPanel.frame.size.width, self.keyboardPanel.frame.size.height)
#define BOTTOM_PANEL_VISIBLE_FRAME CGRectMake(0, self.view.frame.size.height - (20 + self.keyboardPanel.frame.size.height), self.keyboardPanel.frame.size.width, self.keyboardPanel.frame.size.height)

#define IPAD_BOTTOM_PANEL_DEFAULT_FRAME CGRectMake(0,660,436,209)
#define IPAD_BOTTOM_PANEL_MOVEDUP_FRAME CGRectMake(0,495,436,209)


@interface FLChatBubbleViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) BOOL isBottomPanelVisible;
@property (nonatomic, assign) BOOL isKeyboardVisible;
@property (nonatomic, strong) UIPopoverController *popOver;

@end

@implementation FLChatBubbleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





#pragma mark - UIView lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(IS_IPAD==NO){
        //add keyboard panel
        CGRect frame = (IS_IPHONE_4)?BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_4:BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_5;
        //        frame.origin.y+=20;
        self.keyboardPanel.frame = frame;
        [self.view addSubview:self.keyboardPanel];
        self.isBottomPanelVisible = NO;
        self.isKeyboardVisible = NO;
        
        [self adjustTableViewToHeight:((IS_IPHONE_4)?BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_4:BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_5).origin.y];
        
        //add delete button
        UIImage* filterBtnImg = [UIImage imageNamed:@"chat_delete.png"];
        CGRect frameFilter = CGRectMake(0, 0, filterBtnImg.size.width, filterBtnImg.size.height);
        UIButton* filterBtn = [[UIButton alloc]initWithFrame:frameFilter];
        [filterBtn setBackgroundImage:filterBtnImg forState:UIControlStateNormal];
        [filterBtn addTarget:self action:@selector(deleteChatPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
        self.navigationItem.rightBarButtonItem=filterBarButton;
        
        //back button
        self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
        
        self.navigationItem.title=self.currentChatObj.chatObjName;
        self.lblUsername.text=self.currentChatObj.chatObjName;
        
        
    }
    
    
    //FLBubbleCell
    //register custom cell
    [self.chatTableView registerNib:[UINib nibWithNibName:@"FLBubbleCell" bundle:nil] forCellReuseIdentifier:@"FLBubbleCell"];
    [self.chatTableView registerNib:[UINib nibWithNibName:@"FLImageBubbleCell" bundle:nil] forCellReuseIdentifier:@"FLImageBubbleCell"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(chatChanged:)
                                                 name:RECEIVED_CHAT_FOR_USER
                                               object:nil];
    //    [self scrollToBottom];
    
    
    
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
    [webService userChatListForUser:self withUserID:self.currentChatObj.chatObj_id];
    
    
    NSLog(@"screen:%@", self.view);
    
}



- (void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}

- (void) goBack
{
    if ([self.navigationController.viewControllers[0] isKindOfClass:[FLChatBubbleViewController class]]) {//came from othere view
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];//came from chat
}

- (void) viewWillAppear:(BOOL)animated{
    NSLog(@"appear 1 table:%@", NSStringFromCGRect(self.chatTableView.frame));
    //register for keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideShowKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    if(IS_IPAD==NO){
        [self hideTabBar:self.tabBarController];
    }
    NSLog(@"appear 2 table:%@", NSStringFromCGRect(self.chatTableView.frame));
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    //unregister for keyboard
    [self showTabBar:self.tabBarController];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notification Methods

-(void)chatChanged:(NSNotification *)notification
{
    NSDictionary *chatDic=[notification userInfo];
    FLChat *chatObj=(FLChat *)[chatDic objectForKey:@"chatObj"];
    FLChatMessage *chatMsgObj=(FLChatMessage *)[chatObj.chatMessageArr lastObject];
    if ([[NSString stringWithFormat:@"%@",chatMsgObj.userID] isEqualToString: [NSString stringWithFormat:@"%@",self.currentChatObj.chatObj_id]])
    {
        //        NSDate *date = [NSDate date];
        //        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //        df.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        //        NSString *dateString = [df stringFromDate:date];
        
        chatMsgObj.user_imageURL=self.currentChatObj.chatObj_image_url;
        [self.currentChatObj.chatMessageArr addObject:chatMsgObj];
        [self reloadChatTable];
    }
}

-(void)reloadChatTable
{
    [self.chatTableView reloadData];
    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.3];
}

-(void)scrollToBottom
{
    FLChat *chatObj=self.currentChatObj;
    if (chatObj.chatMessageArr.count>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:chatObj.chatMessageArr.count-1 inSection:0];
            NSLog(@"index path: %@", ipath);
            NSLog(@"index path row: %i", ipath.row);
            
            [self.chatTableView scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionBottom animated: YES];
        });
    }
    
    NSLog(@"table frame: %@", NSStringFromCGRect(self.chatTableView.frame));
    NSLog(@"table bounds: %@", NSStringFromCGRect(self.chatTableView.bounds));
    
    
}



#pragma mark - keyboard

-(void)willShowKeyboard:(NSNotification *)notification{
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if(IS_IPAD){
        
        self.isKeyboardVisible = YES;
        self.isBottomPanelVisible = NO;
        
        CGRect frame = IPAD_BOTTOM_PANEL_DEFAULT_FRAME;
        frame.origin.y -= keyboardSize.width;
        
        [self adjustTableViewToHeight:frame.origin.y];
        [UIView animateWithDuration:0.3f animations:^{
            self.keyboardPanel.frame = frame;
        }];
        
    }else{
        
        self.isKeyboardVisible = YES;
        self.isBottomPanelVisible = NO;
        
        CGRect frame;
        
        if(IS_IPHONE_5){
            frame = BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_5;
        }else{
            frame = BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_4;
        }
        
        frame.origin.y -= keyboardSize.height;
        
        NSLog(@"keyboardSize.height: %f, ----------------frame---------------------------------------------------------- %@", keyboardSize.height, NSStringFromCGRect(frame));
        
        [self adjustTableViewToHeight:frame.origin.y];
        [UIView animateWithDuration:0.3f animations:^{
            self.keyboardPanel.frame = frame;
        }];
    }
}

-(void)hideShowKeyboard:(NSNotification *)notification{
    
    if(IS_IPAD){
        
        self.isKeyboardVisible = NO;
        
        if(self.isBottomPanelVisible){
            [self adjustTableViewToHeight:IPAD_BOTTOM_PANEL_MOVEDUP_FRAME.origin.y];
            [UIView animateWithDuration:0.3f animations:^{
                self.keyboardPanel.frame = IPAD_BOTTOM_PANEL_MOVEDUP_FRAME;
            }];
        }else{
            [self adjustTableViewToHeight:IPAD_BOTTOM_PANEL_DEFAULT_FRAME.origin.y];
            [UIView animateWithDuration:0.3f animations:^{
                self.keyboardPanel.frame = IPAD_BOTTOM_PANEL_DEFAULT_FRAME;
            }];
        }
        [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
        
    }else{
        
        self.isKeyboardVisible = NO;
        
        NSLog(@"isKeyboardVisible: %@", (self.isKeyboardVisible)?@"YES":@"NO");
        
        if(self.isBottomPanelVisible){
            CGRect frame;
            
            if(IS_IPHONE_5){
                frame = BOTTOM_PANEL_VISIBLE_FRAME_IPHONE_5;
            }else{
                frame = BOTTOM_PANEL_VISIBLE_FRAME_IPHONE_4;
            }
            
            [self adjustTableViewToHeight:frame.origin.y];
            [UIView animateWithDuration:0.3f animations:^{
                self.keyboardPanel.frame = frame;
            }];
        }else{
            
            CGRect frame;
            
            if(IS_IPHONE_5){
                frame = BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_5;
            }else{
                frame = BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_4;
            }
            
            [self adjustTableViewToHeight:frame.origin.y];
            [UIView animateWithDuration:0.3f animations:^{
                self.keyboardPanel.frame = frame;
            }];
        }
        [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
    }
}

-(void) scrollTableViewToBottom{
    
    if(self.chatTableView.contentOffset.y <10){
        return;
    }
    
    [self.chatTableView scrollRectToVisible:CGRectMake(0, self.chatTableView.contentSize.height - self.chatTableView.bounds.size.height, self.chatTableView.bounds.size.width, self.chatTableView.bounds.size.height) animated:YES];
}



#pragma mark - button actions

-(void) deleteChatPressed:(UIButton *) button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) addItemButtonPressed:(id)sender;{
    if(self.isKeyboardVisible){
        self.isBottomPanelVisible = YES;
        [self.chatTextField resignFirstResponder];
    }else{
        if(self.isBottomPanelVisible) [self hideBottomPanel];
        else [self showBottomPanel];;
    }
}

-(IBAction) sendButtonPressed:(UIButton *) sender
{
    NSLog(@"self.chatTextField.text %@",self.chatTextField.text);
    if (self.chatTextField.text!=nil && [self.chatTextField.text length]>0)
    {
        [self chatSend:self.chatTextField.text];
        self.chatTextField.text  = @"";
        [self.chatTextField resignFirstResponder];
    }
}

-(void)chatSend:(NSString *)chatText
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString *dateString = [df stringFromDate:date];
    FLChatMessage *chatMsgObj=[[FLChatMessage alloc] init];
    chatMsgObj.message=chatText;
    chatMsgObj.chatDateTime=dateString;
    chatMsgObj.username=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
    chatMsgObj.userID=[FLGlobalSettings sharedInstance].current_user_profile.uid;
    chatMsgObj.user_imageURL=[FLGlobalSettings sharedInstance].current_user_profile.image;
    [self updateChatObjAndSend:chatMsgObj];
    
    //        [[NSNotificationCenter defaultCenter]
    //         postNotificationName:RECEIVED_CHAT_FOR_USER
    //         object:self];
    [self reloadChatTable];
    [self scrollToBottom];
}


-(IBAction) photoButtonPressed:(id)sender;{
    [self addImage];
}

-(IBAction) locationButtonPressed:(id)sender;{
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        //            lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyBest;
        lm.distanceFilter = kCLDistanceFilterNone;
        [lm startUpdatingLocation];
        CLLocation *location = [lm location];
        CLGeocoder *gc = [[CLGeocoder alloc] init];
        [gc reverseGeocodeLocation:location completionHandler:^(NSArray *placemark, NSError *error) {
            CLPlacemark *pm = [placemark objectAtIndex:0];
            NSDictionary *address = pm.addressDictionary;
            NSArray *frm = [address valueForKey:@"FormattedAddressLines"];
            
            NSLog(@"add111 %@", address);
            NSLog(@"AAA111 %@", frm);
            if (frm!=nil)
            {
                //                cell.lblAddress.text = [NSString stringWithFormat:@"in %@",frm];
                
                NSLog(@"frmfrm %i",[frm count]);
                //                [self chatSend:[frm componentsJoinedByString: @","]];
                //                [self chatSend:@"Sri Saugathodaya Mawatha,Colombo,Sri Lanka"];
                self.chatTextField.text=[frm componentsJoinedByString: @","];
            }
            
        }];
    }

}

#pragma mark - Add Image

- (void) addImage{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from Album",@"Take Photo", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex:%d", buttonIndex);
    
    if(buttonIndex==2){
        if(IS_IPAD){
            
        }else{
            [self hideBottomPanel];
        }
    }else if(buttonIndex==0){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if(IS_IPAD){
            if (self.popOver != nil) {
                [self.popOver dismissPopoverAnimated:YES];
                self.popOver=nil;
            }
            
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            [popover presentPopoverFromRect:CGRectMake(100, 10, 100, 30) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.popOver = popover;
        }else{
            [self presentViewController:picker animated:YES completion:NULL];
        }
        
    }else if(buttonIndex==1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if(IS_IPAD){
            if (self.popOver != nil) {
                [self.popOver dismissPopoverAnimated:YES];
                self.popOver=nil;
            }
            
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            [popover presentPopoverFromRect:CGRectMake(100, 10, 100, 30) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.popOver = popover;
        }else{
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    //    NSDate *date = [NSDate date];
    //    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    df.dateFormat = @"hh:mm a";
    //    NSString *dateString = [df stringFromDate:date];
    
    //    NSDictionary *new = @{@"profilePic":@"profilePic4.png",@"type":@1,@"image":chosenImage,@"seen":@0,@"time":dateString};
    
    
    
    
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Uploading...";
    [HUD show:YES];
    
    
    
    //upload album pic
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    FLImgObj *imgObj=[[FLImgObj alloc] init];
    imgObj.folder_name=IMAGE_DIRECTORY_ALBUM;
    imgObj.imgData=UIImageJPEGRepresentation(chosenImage,0.0);
    imgObj.imageName=[NSString stringWithFormat:@"%@.%@",[FLUtil imageNameForUpload:[FLGlobalSettings sharedInstance].current_user_profile.uid],@"jpg"];
    imgObj.imgContentType=@"image/jpeg";
    imgObj.albumID=IMAGE_DIRECTORY_CHAT;
    imgObj.title=@"TestImgTitle";
    [webSeviceApi uploadImage:self withImgObj:imgObj];
    
    
    //    [self.contentArray addObject:new];
    [self.chatTableView reloadData];
    
    //    [self.chatTableView layoutIfNeeded];
    //    NSIndexPath* indexPath = [NSIndexPath indexPathForRow: ([self.chatTableView numberOfRowsInSection:([self.chatTableView numberOfSections]-1)]-1) inSection: ([self.chatTableView numberOfSections]-1)];
    //    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.3];
    
    if(IS_IPAD){
        if (self.popOver != nil) {
            [self.popOver dismissPopoverAnimated:YES];
            self.popOver=nil;
        }
    }else{
        NSLog(@"I got the image");
        [picker dismissViewControllerAnimated:YES completion:^{
            [self hideBottomPanel];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    if(IS_IPAD){
        if (self.popOver != nil) {
            [self.popOver dismissPopoverAnimated:YES];
            self.popOver=nil;
        }
    }else{
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [self hideBottomPanel];
        }];
    }
}


#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"%@", textField.text);
    if (self.chatTextField.text!=nil && [self.chatTextField.text length]>0)
    {
        [self chatSend:self.chatTextField.text];
        self.chatTextField.text  = @"";
    }
    [self.chatTextField resignFirstResponder];
    return YES;
}

-(void)updateChatObjAndSend:(FLChatMessage *)chatMsg
{
    //    FLChat *chatObj=[[FLGlobalSettings sharedInstance].chatArr objectAtIndex:chatUserIndex];
    
    //web service call
    
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService chatSend:self withMessage:chatMsg.message withReceiverID:self.currentChatObj.chatObj_id withType:MSG_TYPE_PRIVATE];//current chatObj id
    [self.currentChatObj.chatMessageArr addObject:chatMsg];
    
}


#pragma mark - Reveal keyboard bottom

-(void) showBottomPanel{
    
    if(IS_IPAD){
        self.isBottomPanelVisible = YES;
        [self adjustTableViewToHeight:IPAD_BOTTOM_PANEL_MOVEDUP_FRAME.origin.y];
        [UIView animateWithDuration:0.3f animations:^{
            self.keyboardPanel.frame = IPAD_BOTTOM_PANEL_MOVEDUP_FRAME;
        }];
    }else{
        self.isBottomPanelVisible = YES;
        CGRect frame;
        
        if(IS_IPHONE_5){
            frame = BOTTOM_PANEL_VISIBLE_FRAME_IPHONE_5;
        }else{
            frame = BOTTOM_PANEL_VISIBLE_FRAME_IPHONE_4;
        }
        [self adjustTableViewToHeight:frame.origin.y];
        [UIView animateWithDuration:0.3f animations:^{
            self.keyboardPanel.frame = frame;
        }];
    }
    
}

-(void) hideBottomPanel{
    if(IS_IPAD){
        self.isBottomPanelVisible = NO;
        [self adjustTableViewToHeight:IPAD_BOTTOM_PANEL_DEFAULT_FRAME.origin.y];
        [UIView animateWithDuration:0.3f animations:^{
            self.keyboardPanel.frame = IPAD_BOTTOM_PANEL_DEFAULT_FRAME;
        } completion:^(BOOL finished){
            
        }];
        [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
    }else{
        CGRect frame;
        
        if(IS_IPHONE_5){
            frame = BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_5;
        }else{
            frame = BOTTOM_PANEL_HIDDEN_FRAME_IPHONE_4;
        }
        self.isBottomPanelVisible = NO;
        [self adjustTableViewToHeight:frame.origin.y];
        [UIView animateWithDuration:0.3f animations:^{
            self.keyboardPanel.frame = frame;
        }];
        [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
    }
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.currentChatObj.chatMessageArr==nil){
        return 0;
    }
    return self.currentChatObj.chatMessageArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"self.currentChatObj %@",self.currentChatObj);
    FLChatMessage *chatMsgObj=[self.currentChatObj.chatMessageArr objectAtIndex:indexPath.row];
    ///////////////////
    NSLog(@"chatMsgObj.message222222 %@",chatMsgObj.message);
    
    NSString *word = @".jpg";//check message has jpg
    if ([chatMsgObj.message rangeOfString:word].location != NSNotFound)
    {
        FLImageBubbleCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"FLImageBubbleCell"];
        
        imageCell.seen = chatMsgObj.seen;
        imageCell.chatTime = chatMsgObj.chatDateTime;
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
        //////////////////////////////////////////////////////
        //////////////////////////////////////////////////////
        NSString *imgNameWithPath = [NSString stringWithFormat:@"%@%@/%@",IMAGE_DIRECTORY_ALBUM,IMAGE_DIRECTORY_CHAT, chatMsgObj.message];
        NSURL *imgUrl=[webServiceApi getImageFromName:imgNameWithPath];
        
        //get previous indicator out
        UIView *act = [imageCell.photoImageView viewWithTag:ACT_INDICATOR_TAG];
        
        //if has, then remove it
        if(act){
            [act removeFromSuperview];
        }
        
        __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center = CGPointMake(imageCell.photoImageView.bounds.size.width/2.0, imageCell.photoImageView.bounds.size.height/2.0);
        activityIndicatorView.tag = ACT_INDICATOR_TAG;
        [imageCell.photoImageView addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        [imageCell.photoImageView setImageWithURLRequest:[FLUtil imageRequestWithURL:imgUrl]
                                        placeholderImage:nil
                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                     imageCell.photoImageView.image = image;
                                                     //                                                    cell.imageView.image = [UIImage imageNamed:@"cancelbtn@2x.PNG"];
                                                     [activityIndicatorView removeFromSuperview];
                                                 }
                                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                     [activityIndicatorView removeFromSuperview];
                                                 }];
        //////////////////////////////////////////////////////
        //////////////////////////////////////////////////////
        
        
        /////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////
        
        
        if (IS_IPAD)
        {
            
            if ([[NSString stringWithFormat:@"%@",chatMsgObj.userID] isEqualToString:[NSString stringWithFormat:@"%@",[FLGlobalSettings sharedInstance].current_user_profile.uid]])//check user me
            {
                [imageCell alightRight];
                NSString *imgNameWithPath = [[FLGlobalSettings sharedInstance].current_user_profile.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
                
                NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
                
                //get previous indicator out
                UIView *act = [imageCell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
                
                //if has, then remove it
                if(act){
                    [act removeFromSuperview];
                }
                
                __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicatorView.center = CGPointMake(imageCell.profilePictureView.bounds.size.width/2.0, imageCell.profilePictureView.bounds.size.height/2.0);
                activityIndicatorView.tag = ACT_INDICATOR_TAG;
                
                [imageCell.profilePictureView addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
                
                
                [imageCell.profilePictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                                    placeholderImage:nil
                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                 imageCell.profilePictureView.image = image;
                                                                 [activityIndicatorView removeFromSuperview];
                                                             }
                                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                                 [activityIndicatorView removeFromSuperview];
                                                             }];
            }
            else
            {
                [imageCell alightLeft];
                
                NSString *imgNameWithPath = [chatMsgObj.user_imageURL stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
                NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
                
                
                //get previous indicator out
                UIView *act = [imageCell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
                
                //if has, then remove it
                if(act){
                    [act removeFromSuperview];
                }
                
                __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicatorView.center = CGPointMake(imageCell.profilePictureView.bounds.size.width/2.0, imageCell.profilePictureView.bounds.size.height/2.0);
                activityIndicatorView.tag = ACT_INDICATOR_TAG;
                
                [imageCell.profilePictureView addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
                
                
                [imageCell.profilePictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                                    placeholderImage:nil
                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                 imageCell.profilePictureView.image = image;
                                                                 [activityIndicatorView removeFromSuperview];
                                                             }
                                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                                 [activityIndicatorView removeFromSuperview];
                                                             }];
            }
            
        }else{
            
            if ([[NSString stringWithFormat:@"%@",chatMsgObj.userID] isEqualToString:[NSString stringWithFormat:@"%@",[FLGlobalSettings sharedInstance].current_user_profile.uid]])
            {
                [imageCell alightLeft];
                NSString *imgNameWithPath = [[FLGlobalSettings sharedInstance].current_user_profile.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
                
                NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
                
                //get previous indicator out
                UIView *act = [imageCell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
                
                //if has, then remove it
                if(act){
                    [act removeFromSuperview];
                }
                
                __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicatorView.center = CGPointMake(imageCell.profilePictureView.bounds.size.width/2.0, imageCell.profilePictureView.bounds.size.height/2.0);
                activityIndicatorView.tag = ACT_INDICATOR_TAG;
                
                [imageCell.profilePictureView addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
                
                
                [imageCell.profilePictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                                    placeholderImage:nil
                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                 imageCell.profilePictureView.image = image;
                                                                 [activityIndicatorView removeFromSuperview];
                                                             }
                                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                                 [activityIndicatorView removeFromSuperview];
                                                             }];
            }
            else
            {
                [imageCell alightRight];
                
                NSString *imgNameWithPath = [chatMsgObj.user_imageURL stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
                NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
                //get previous indicator out
                UIView *act = [imageCell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
                
                //if has, then remove it
                if(act){
                    [act removeFromSuperview];
                }
                
                __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicatorView.center = CGPointMake(imageCell.profilePictureView.bounds.size.width/2.0, imageCell.profilePictureView.bounds.size.height/2.0);
                activityIndicatorView.tag = ACT_INDICATOR_TAG;
                
                [imageCell.profilePictureView addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
                
                
                [imageCell.profilePictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                                    placeholderImage:nil
                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                 imageCell.profilePictureView.image = image;
                                                                 [activityIndicatorView removeFromSuperview];
                                                             }
                                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                                 [activityIndicatorView removeFromSuperview];
                                                             }];
            }
        }
        
        
        //////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////
        
        return imageCell;
        
        
        
        
        
        
        //        NSString *imgNameWithPath = [NSString stringWithFormat:@"%@%@/%@",IMAGE_DIRECTORY_ALBUM,IMAGE_DIRECTORY_CHAT, chatMsgObj.message];
        //        NSURL *imgUrl=[webServiceApi getImageFromName:imgNameWithPath];
        //        NSData * data = [NSData dataWithContentsOfURL:imgUrl];
        //        UIImage *result_img = [UIImage imageWithData:data];
        //
        //        imageCell.profilePictureView.image = [UIImage imageNamed:@"flower.jpg"];
        //        imageCell.photoImageView.image=result_img;
        //        //sample
        //        if(indexPath.row %2) [imageCell alightLeft];
        //        else [imageCell alightRight];
        //        return imageCell;
    }
    
    
    //text cell
    
    
    
    FLBubbleCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"FLBubbleCell"];
    cell.seen = chatMsgObj.seen;
    cell.chatText =chatMsgObj.message;
    cell.chatTime = chatMsgObj.chatDateTime;
    
    if (IS_IPAD)
    {
        
        if ([[NSString stringWithFormat:@"%@",chatMsgObj.userID] isEqualToString:[NSString stringWithFormat:@"%@",[FLGlobalSettings sharedInstance].current_user_profile.uid]])//check user me
        {
            [cell alightRight];
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            NSString *imgNameWithPath = [[FLGlobalSettings sharedInstance].current_user_profile.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
            
            NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
            
            //get previous indicator out
            UIView *act = [cell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
            
            //if has, then remove it
            if(act){
                [act removeFromSuperview];
            }
            
            __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicatorView.center = CGPointMake(cell.profilePictureView.bounds.size.width/2.0, cell.profilePictureView.bounds.size.height/2.0);
            activityIndicatorView.tag = ACT_INDICATOR_TAG;
            
            [cell.profilePictureView addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            
            
            [cell.profilePictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                           placeholderImage:nil
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                        cell.profilePictureView.image = image;
                                                        [activityIndicatorView removeFromSuperview];
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                        [activityIndicatorView removeFromSuperview];
                                                    }];
            
        }
        else
        {
            [cell alightLeft];
            
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            NSString *imgNameWithPath = [chatMsgObj.user_imageURL stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
            NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
            
            
            //get previous indicator out
            UIView *act = [cell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
            
            //if has, then remove it
            if(act){
                [act removeFromSuperview];
            }
            
            __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicatorView.center = CGPointMake(cell.profilePictureView.bounds.size.width/2.0, cell.profilePictureView.bounds.size.height/2.0);
            activityIndicatorView.tag = ACT_INDICATOR_TAG;
            
            [cell.profilePictureView addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            
            
            [cell.profilePictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                           placeholderImage:nil
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                        cell.profilePictureView.image = image;
                                                        [activityIndicatorView removeFromSuperview];
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                        [activityIndicatorView removeFromSuperview];
                                                    }];
        }
    }else{
        
        if ([[NSString stringWithFormat:@"%@",chatMsgObj.userID] isEqualToString:[NSString stringWithFormat:@"%@",[FLGlobalSettings sharedInstance].current_user_profile.uid]])
        {
            [cell alightLeft];
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            NSString *imgNameWithPath = [[FLGlobalSettings sharedInstance].current_user_profile.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
            
            NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
            
            //get previous indicator out
            UIView *act = [cell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
            
            //if has, then remove it
            if(act){
                [act removeFromSuperview];
            }
            
            __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicatorView.center = CGPointMake(cell.profilePictureView.bounds.size.width/2.0, cell.profilePictureView.bounds.size.height/2.0);
            activityIndicatorView.tag = ACT_INDICATOR_TAG;
            
            [cell.profilePictureView addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            
            
            [cell.profilePictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                           placeholderImage:nil
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                        cell.profilePictureView.image = image;
                                                        [activityIndicatorView removeFromSuperview];
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                        [activityIndicatorView removeFromSuperview];
                                                    }];
        }
        else
        {
            [cell alightRight];
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            NSString *imgNameWithPath = [chatMsgObj.user_imageURL stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
            NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
            //get previous indicator out
            UIView *act = [cell.profilePictureView viewWithTag:ACT_INDICATOR_TAG];
            
            //if has, then remove it
            if(act){
                [act removeFromSuperview];
            }
            
            __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicatorView.center = CGPointMake(cell.profilePictureView.bounds.size.width/2.0, cell.profilePictureView.bounds.size.height/2.0);
            activityIndicatorView.tag = ACT_INDICATOR_TAG;
            
            [cell.profilePictureView addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            
            
            [cell.profilePictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                           placeholderImage:nil
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                        cell.profilePictureView.image = image;
                                                        [activityIndicatorView removeFromSuperview];
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                        [activityIndicatorView removeFromSuperview];
                                                    }];
        }
    }
    return cell;
}



#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    
    //detect chat type
    NSString *word = @".jpg";
    FLChatMessage *chatMsgObj=[self.currentChatObj.chatMessageArr objectAtIndex:indexPath.row];
    BOOL isPhoto = ([chatMsgObj.message rangeOfString:word].location != NSNotFound);
    
    if(isPhoto){
        return 170;
    }else{
        
        int padding = 10;
        
        CGSize stringSize = [chatMsgObj.message sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                           constrainedToSize:CGSizeMake(240, 9999)
                                               lineBreakMode:NSLineBreakByWordWrapping];
        
        return stringSize.height+padding + 8 + 18 + 8;
    }

}




#pragma mark - TableView animations

//this method is used to calculate the height depending on the text input
-(void) adjustTableViewToHeight:(CGFloat) height{
    
    NSLog(@"chat table:%@", NSStringFromCGRect(self.chatTableView.frame));
    
    CGRect frame = self.chatTableView.frame;
    //change the hight of the table
    frame.size.height = height - self.chatTableView.frame.origin.y;
    [UIView animateWithDuration:0.3 animations:^{
        self.chatTableView.frame = frame;
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark WebService delegate methods


-(void)chatSendResult:(NSString *)str
{
    NSLog(@"str %@",str);
    
}

-(void)chatForUserResult:(NSMutableArray *)chatMessageArr
{
    [HUD hide:YES];
    [self.currentChatObj.chatMessageArr removeAllObjects];
    self.currentChatObj.chatMessageArr=chatMessageArr;
    //    [self.chatTableView reloadData];
    
    //    [[NSNotificationCenter defaultCenter]
    //     postNotificationName:RECEIVED_CHAT_FOR_USER
    //     object:self];
    [self reloadChatTable];
}

//after upload image update album view
-(void)albumImageUploaded:(FLImgObj *)imgObj
{
    [HUD hide:YES];
    [self chatSend:imgObj.imageName];
}

#pragma mark WebService delegate Error

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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}
@end

