//
//  FLMFPhotoGalleryViewController.m
//  Flingoo
//
//  Created by Hemal on 11/15/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMFPhotoGalleryViewController.h"
#import "FLPhotoAlbumColleCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FLPhotoCell.h"
#import "FLGlobalSettings.h"
#import "Config.h"
#import "FLMFPhotosViewController.h"
#import "Macros.h"

//typedef enum {
//    PROFILE_PICTURE=1,
//    MY_ALBUM
//} CellTypeType;

//#import "Cell.h"

@interface FLMFPhotoGalleryViewController ()
//@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
@property(nonatomic,strong) FLOtherProfile *profileObj;
@property(nonatomic,strong) NSString *profile;
@property(nonatomic,strong) NSString *uploadedImageName;
@end

@implementation FLMFPhotoGalleryViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profile:(NSString *)profile withProfileObj:(FLOtherProfile *)profileObj{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.tabBarItem.title = @"Photo Gallery";
        self.tabBarItem.image = [UIImage imageNamed:@"photogallery_tabbar.png"];
        self.profileObj=profileObj;
        self.profile=profile;
    }
    
    return self;
}


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profile:(NSString *)profile
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//
//        forProfile=profile;
//
//        self.tabBarItem.title = @"Photo Gallery";
//        self.tabBarItem.image = [UIImage imageNamed:@"photogallery_tabbar.png"];
//    }
//    return self;
//}

#pragma mark -
#pragma mark view lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    profilePicArr=[[NSMutableArray alloc] init];
    albumArr=[[NSMutableArray alloc] init];
    
    
    if ([self.profile isEqualToString:MY_PROFILE])
    {
        [self callReload:NO];
    }
    else{
    FLPhoto *photoObj=[[FLPhoto alloc] init];
    //hemalasankas**
    photoObj.title=@"Current Pic Title";
    photoObj.imageName=@"Current Pic Name";
    if ([self.profile isEqualToString:OTHER_PROFILE])
    {
        photoObj.imgURL=self.profileObj.image;
    }else
    {
        photoObj.imgURL=[FLGlobalSettings sharedInstance].current_user_profile.image;
    }
    [profilePicArr addObject:photoObj];
    ////////
    }
    
    
    
    
    
    
    self.navigationItem.title = @"Photo Gallery";
    if (IS_IPAD) {
        viewAlbum.center=CGPointMake(218, 352);
        [self.view addSubview:viewAlbum];
    }
    else
    {
        viewAlbum.center=CGPointMake(160, 184);
        [self.view addSubview:viewAlbum];
        
        UIRefreshControl *collectionRefreshControl = [[UIRefreshControl alloc] init];
        collectionRefreshControl.tag = kTableModeCollection;
        
        
        [collectionRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        
        
        [self.collectionVwAlbum addSubview:collectionRefreshControl];
        
    }
    
    [btnLeft setSelected:YES];
    
    //    [self addImageURL];
    
    //    [self.collectionVwAlbum registerClass:[Cell class] forCellWithReuseIdentifier:@"Cell"];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.collectionVwAlbum registerNib:[UINib nibWithNibName:@"FLPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"FLPhotoCell"];
    
    
    
    if ([self.profile isEqualToString:OTHER_PROFILE]) {
        self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(backClicked)];
    }
    else
    {
        ////add bar button
        UIImage* btnDeleteImg = [UIImage imageNamed:@"chat_delete.png"];
        UIImage* btnCancelImg = [UIImage imageNamed:@"cancelbtn.PNG"];
        
        CGRect frame = CGRectMake((320-btnDeleteImg.size.width), 0, btnDeleteImg.size.width, btnDeleteImg.size.height);
        deleteNavButton = [[UIButton alloc] initWithFrame:frame];
        [deleteNavButton setBackgroundImage:btnDeleteImg forState:UIControlStateNormal];
        
        [deleteNavButton setBackgroundImage:btnCancelImg forState:UIControlStateSelected];
        
        [deleteNavButton addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *deleteBarButton = [[UIBarButtonItem alloc] initWithCustomView:deleteNavButton];
        self.navigationItem.rightBarButtonItem=deleteBarButton;
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //    [self clearVisibleCells];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if ([forProfile isEqualToString:OTHER_PROFILE]) {
//        UIImage* btnBackImg = [UIImage imageNamed:@"back_btn.png"];
//        CGRect frame = CGRectMake(0, 0, btnBackImg.size.width, btnBackImg.size.height);
//        UIButton* backButton = [[UIButton alloc]initWithFrame:frame];
//        [backButton setBackgroundImage:btnBackImg forState:UIControlStateNormal];
//        [backButton addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem* cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        [self.navigationItem setLeftBarButtonItem:cancelBarButton];
//    }
//}

-(void)backClicked
{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //    self.navigationController.navigationBar.hidden=NO;
    
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}

#pragma mark -
#pragma mark - Util method

-(void)callReload:(BOOL)isAlbum
{
    HUD=[[MBProgressHUD alloc] initWithView:viewAlbum];
    [viewAlbum addSubview:HUD];
    HUD.dimBackground = YES;
    // Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    HUD.delegate = self;
    HUD.labelText = @"Connecting";
    HUD.square = YES;
    [HUD show:YES];
    
    if (isAlbum) {
        if ([self.profile isEqualToString:MY_PROFILE]) {
            FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
            [webService albumList:self];
        }
        else
        {
            FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
            [webService albumList:self withUserID:[NSString stringWithFormat:@"%@",self.profileObj.uid]];
            
        }        
    }
    else//get profile pic list
    {

        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
        [webService profilePicList:self];
      
    }
}


#pragma mark - refresh controller

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    
    //reload table
    
    if (btnRight.isSelected)
    {
        [self callReload:YES];
    }
    
    [refreshControl endRefreshing];
}

#pragma mark
#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (btnLeft.isSelected)
    {
        if ([self.profile isEqualToString:OTHER_PROFILE])
        {
            return [profilePicArr count];
        }else
        {
            return [profilePicArr count] +1;
        }
    }
    else
    {
        int albumCount=[albumArr count];
        
        if ([self.profile isEqualToString:OTHER_PROFILE])
        {
            [btnRight setTitle:[NSString stringWithFormat:@"Albums (%i)",albumCount] forState:UIControlStateNormal];
            return albumCount;
        }else
        {
            [btnRight setTitle:[NSString stringWithFormat:@"My Albums (%i)",albumCount] forState:UIControlStateNormal];
            return albumCount+1;
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FLPhotoCell *cell = (FLPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FLPhotoCell" forIndexPath:indexPath];
    
    if (btnLeft.selected)
    {
        if (indexPath.row==0 && [self.profile isEqualToString:MY_PROFILE])
        {
            cell.shouldShowCount = YES;
            cell.photoImageView.image = [UIImage imageNamed:@"fv_addFriend.png"];
            cell.photoTitleLabel.text = @"Add New Photo";
            cell.btnCellDelete.hidden=YES;
            //        cell.photoCountLabel.text = @"(2)";
        }
        else
        {
            int cellIndex=[self.profile isEqualToString:MY_PROFILE]?(indexPath.row-1):indexPath.row;
            FLPhoto *photoObj=[profilePicArr objectAtIndex:cellIndex];
            cell.shouldShowCount = YES;
            cell.photoTitleLabel.text = photoObj.created_at;
            
            
            if ([self.profile isEqualToString:MY_PROFILE]) {
                cell.btnCellDelete.tag=indexPath.row;
                [cell.btnCellDelete addTarget:self action:@selector(deleteCellClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                if (deleteNavButton.isSelected)
                {
                    cell.btnCellDelete.hidden=NO;
                }
                else
                {
                    cell.btnCellDelete.hidden=YES;
                }
            }
            
            
            
            //////////////////////////////////////////////////////
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            NSString *imgNameWithPath = [photoObj.imgURL stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
            NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
            
            
            //get previous indicator out
            UIView *act = [cell.photoImageView viewWithTag:ACT_INDICATOR_TAG];
            
            //if has, then remove it
            if(act){
                [act removeFromSuperview];
            }
        
        
            __weak FLPhotoCell *weakCell = cell;
            __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicatorView.center = CGPointMake(cell.photoImageView.bounds.size.width/2.0, cell.photoImageView.bounds.size.height/2.0);
            activityIndicatorView.tag = ACT_INDICATOR_TAG;
            
            [cell.photoImageView addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            //        [activityIndicatorView removeFromSuperview];
            
            [cell.photoImageView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                       placeholderImage:nil
                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                    weakCell.photoImageView.image = image;
                                                    [activityIndicatorView removeFromSuperview];
                                                }
                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                    [activityIndicatorView removeFromSuperview];
                                                }];
            
            
        
        }
    }
    else
    {
        if (indexPath.row==0 && [self.profile isEqualToString:MY_PROFILE])
        {
            cell.shouldShowCount = YES;
            cell.photoImageView.image = [UIImage imageNamed:@"fv_addFriend.png"];
            cell.photoTitleLabel.text = @"Add New Album";
            cell.btnCellDelete.hidden=YES;
            //        cell.photoCountLabel.text = @"(2)";
        }
        else
        {
            int cellIndex=[self.profile isEqualToString:MY_PROFILE]?(indexPath.row-1):indexPath.row;
            FLAlbum *albumObj=[albumArr objectAtIndex:cellIndex];
            cell.shouldShowCount = YES;
            cell.photoImageView.image = [UIImage imageNamed:@"fv_addFriend.png"];
            cell.photoTitleLabel.text = [NSString stringWithFormat:@"%@ (%i)",albumObj.title,albumObj.photo_count];
            
            if ([self.profile isEqualToString:MY_PROFILE])
            {
                cell.btnCellDelete.tag=indexPath.row;
                [cell.btnCellDelete addTarget:self action:@selector(deleteCellClicked:) forControlEvents:UIControlEventTouchUpInside];
                if (deleteNavButton.isSelected){
                    cell.btnCellDelete.hidden=NO;
                }
                else
                {
                    cell.btnCellDelete.hidden=YES;
                }
            }
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            
            NSString *imgNameWithPath = [albumObj.cover_image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
            NSURL *profilePicUrl=[webServiceApi getImageFromName:imgNameWithPath];
            
            
            //get previous indicator out
            UIView *act = [cell.photoImageView viewWithTag:ACT_INDICATOR_TAG];
            
            //if has, then remove it
            if(act){
                [act removeFromSuperview];
            }
        
            __weak FLPhotoCell *weakCell = cell;
            __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicatorView.center = CGPointMake(cell.photoImageView.bounds.size.width/2.0, cell.photoImageView.bounds.size.height/2.0);
            activityIndicatorView.tag = ACT_INDICATOR_TAG;
            
            [cell.photoImageView addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            //        [activityIndicatorView removeFromSuperview];
            
            [cell.photoImageView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                       placeholderImage:nil
                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                    weakCell.photoImageView.image = image;
                                                    [activityIndicatorView removeFromSuperview];
                                                }
                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                    [activityIndicatorView removeFromSuperview];
                                                }];

        
        }
        
    }
    
    
    return cell;
}





#pragma mark -
#pragma mark - Flow Layout delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(145, 173);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //    return UIEdgeInsetsMake(10,10,10,10);
    if (IS_IPAD) {
        return UIEdgeInsetsMake(10,55,10,50);
    }
    return UIEdgeInsetsMake(10,10,10,10);
}



#pragma mark - UICollectionViewDelegate



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //special case
    if(indexPath.row == 0 && [self.profile isEqualToString:MY_PROFILE]){//add image or album
        if(btnLeft.selected){
            
            //    // Create the sheet without buttons
            UIActionSheet *sheet = [[UIActionSheet alloc]
                                    initWithTitle:@"Profile Picture"
                                    delegate:self
                                    cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:nil];
            
            // Add buttons one by one (e.g. in a loop from array etc...)
            [sheet addButtonWithTitle:@"Upload Photo"];
            [sheet addButtonWithTitle:@"Take Photo"];
            // Also add a cancel button
            [sheet addButtonWithTitle:@"Cancel"];
            // Set cancel button index to the one we just added so that we know which one it is in delegate call
            // NB - This also causes this button to be shown with a black background
            sheet.cancelButtonIndex = sheet.numberOfButtons-1;
            
            
            if (IS_IPHONE || IS_IPHONE_5) {
                [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
            }
            else
            {
                NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
                FLPhotoCell *cell =(FLPhotoCell *)[self.collectionVwAlbum cellForItemAtIndexPath:indexPath];
                
                
                
                CGRect frm = cell.frame;
                //              frm.origin.y = frm.origin.y ;
                
                //          [popOver presentPopoverFromRect:frm inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                //              [popoverController presentPopoverFromRect:frm inView:self.collectionVwAlbum permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                [sheet showFromRect:frm inView:self.collectionVwAlbum animated:YES];
            }
            
            
            
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Album Name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
        }
        
    }
    else if(!deleteNavButton.isSelected && btnRight.isSelected)
    {
        if (IS_IPAD) {
            
            
            /// hemalasankas****
            /*
             
             FLMFPhotosViewController *photoVwCon=[[FLMFPhotosViewController alloc] initWithNibName:@"FLMFPhotosViewController-iPad" bundle:nil profile:self.profile];
             
             if ([self.profile isEqualToString:MY_PROFILE])
             {
             photoVwCon.albumObj=[albumArr objectAtIndex:(indexPath.row-1)];
             }else
             {
             photoVwCon.albumObj=[albumArr objectAtIndex:indexPath.row];
             photoVwCon.profileObj=self.profileObj;
             
             }
             pass self.profile for profile , photoVwCon.albumObj , photoVwCon.profileObj
             
             */
            
            
            FLOtherProfile *profileObject = nil;
            FLAlbum *album = nil;
            
            
            if ([self.profile isEqualToString:MY_PROFILE])
            {
                album=[albumArr objectAtIndex:(indexPath.row-1)];
                profileObject=nil;
                
            }else
            {
                album=[albumArr objectAtIndex:indexPath.row];
                profileObject=self.profileObj;
                
            }
            
            
            NSDictionary *moreInfo = @{@"profileObj":(profileObject)?profileObject:[NSNull null], @"albumObj":(album)?album:[NSNull null], @"profile": self.profile};
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:kRemoteActionShowPhotoViewController forKey:RemoteAction];
            [dict setObject:moreInfo forKey:@"info"];
            
            self.communicator(dict);
            
        }else{
            
            
            FLMFPhotosViewController *photoVwCon=[[FLMFPhotosViewController alloc] initWithNibName:@"FLMFPhotosViewController" bundle:nil profile:self.profile];
            
            //        photoVwCon.albumObj=[albumArr objectAtIndex:[self.profile isEqualToString:MY_PROFILE]?(indexPath.row-1):indexPath.row];
            if ([self.profile isEqualToString:MY_PROFILE])
            {
                photoVwCon.albumObj=[albumArr objectAtIndex:(indexPath.row-1)];
            }else
            {
                photoVwCon.albumObj=[albumArr objectAtIndex:indexPath.row];
                photoVwCon.profileObj=self.profileObj;
                
            }
            
            [self.navigationController pushViewController:photoVwCon animated:YES];
        }
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet1
clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet1.cancelButtonIndex) {
        return;
    }
	switch (buttonIndex) {
		case 0:
		{
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *_picker=nil;
                if (popoverController) {
                    [popoverController dismissPopoverAnimated:NO];
                    
                }
                _picker = [[UIImagePickerController alloc] init];
                _picker.delegate = self;
                _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                _picker.wantsFullScreenLayout = YES;
                
                //[popoverController presentPopoverFromBarButtonItem:sender
                //   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
                if (IS_IPHONE || IS_IPHONE_5)
                {
                    
                    [self presentViewController:_picker animated:YES completion:nil];
                }
                else
                {
                    
                    popoverController = [[UIPopoverController alloc] initWithContentViewController:_picker];
                    [popoverController setDelegate:self];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
                    FLPhotoCell *cell =(FLPhotoCell *)[self.collectionVwAlbum cellForItemAtIndexPath:indexPath];
                    
                    CGRect frm = cell.frame;
                    //                    frm.origin.y = frm.origin.y ;
                    [popoverController presentPopoverFromRect:frm inView:self.collectionVwAlbum permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    
                    
                    
                    
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error access photo library"
                                                                message:@"your device non support photo library"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
			break;
		}
		case 1:
		{
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                if( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) return;
                
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //                imagePickerController.allowsImageEditing = YES;
                
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error to access Camera"
                                                                message:@""
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
			break;
		}
            
	}
}

#pragma mark -
#pragma mark Image picker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // write your code here ........
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    [imgProfilePic setContentMode:UIViewContentModeScaleAspectFill];
    
//    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:1 inSection:0];
//    FLPhotoCell *cell =(FLPhotoCell *)[self.collectionVwAlbum cellForItemAtIndexPath:indexPath];
//    cell.photoImageView.image=originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (IS_IPAD)
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Uploading...";
    [HUD show:YES];
    
    
    
    //upload profile pic
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    FLImgObj *imgObj=[[FLImgObj alloc] init];
    imgObj.folder_name=IMAGE_DIRECTORY_PROFILE;
    imgObj.imgData=UIImageJPEGRepresentation(originalImage,0.0);
    imgObj.imageName=[NSString stringWithFormat:@"%@.%@",[FLUtil imageNameForUpload:[FLGlobalSettings sharedInstance].current_user_profile.uid],@"jpg"];
    imgObj.imgContentType=@"image/jpeg";
    [webSeviceApi uploadImage:self withImgObj:imgObj];
    
    
    
    
    //    [picker dismissViewControllerAnimated:YES completion:nil];
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - Alertview delegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0)
    {
        NSString *title=[[alertView textFieldAtIndex:0] text];
        if (title!=nil && [title length]>0)
        {
            FLAlbum *albumObj=[[FLAlbum alloc] init];
            albumObj.title=[[alertView textFieldAtIndex:0] text];
            albumObj.moments=NO;
            FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
            [webSeviceApi createAlbum:self withAlbumObj:albumObj];
        }
    }
}

#pragma mark -
#pragma mark - web service api

//after upload image update image name in profile
-(void)profileImageUploaded:(FLImgObj *)imgObj
{
//    FLUserDetail *userDetail=[[FLUserDetail alloc] init];
//    userDetail.imageNameProfile=imgObj.imageName;
//    userDetail.full_name=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
//    userDetail.birth_date=[FLGlobalSettings sharedInstance].current_user_profile.birth_date;
//    self.uploadedImageName=imgObj.imageName;
//    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
//    [webSeviceApi profileUpdate:self withUserData:userDetail];
    
//    FLUserDetail *userDetail=[[FLUserDetail alloc] init];
//    userDetail.imageNameProfile=imgObj.imageName;
//    userDetail.full_name=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
//    userDetail.birth_date=[FLGlobalSettings sharedInstance].current_user_profile.birth_date;
    self.uploadedImageName=imgObj.imageName;
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
//    [webSeviceApi profileUpdate:self withUserData:userDetail];
    [webSeviceApi imageUploadToDir:self withImageName:imgObj.imageName];
}

//-(void)profileUpdateResult:(NSString *)msg
//{
//    [HUD hide:YES];
//    NSLog(@"profileUpdateResult msg %@",msg);
//    //set image name to current user singleton object
//    
//    [FLGlobalSettings sharedInstance].current_user_profile.image=[NSString stringWithFormat:@"http://flingoo.s3.amazonaws.com/profiles/%@",self.uploadedImageName];
//    
//    /////////////////////
//    [profilePicArr removeAllObjects];
//    FLPhoto *photoObj=[[FLPhoto alloc] init];
//    //hemalasankas**
//    photoObj.title=@"Current Pic Title";
//    photoObj.imageName=@"Current Pic Name";
//    photoObj.imgURL=[FLGlobalSettings sharedInstance].current_user_profile.image;
//    [profilePicArr addObject:photoObj];
//    /////////////////////
//    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:PROFILE_PICTURE_UPLOADED
//     object:self];
//    
//    //    //temp
//    //    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
//    //    [webSeviceApi currentUser:self];
//    
//}


-(void)profilePicUploaded:(NSString *)str
{
    [HUD hide:YES];
    NSLog(@"profileUpdateResult msg %@",str);
    //set image name to current user singleton object
    
    [FLGlobalSettings sharedInstance].current_user_profile.image=[NSString stringWithFormat:@"http://flingoo.s3.amazonaws.com/profiles/%@",self.uploadedImageName];
    
    /////////////////////
    [profilePicArr removeAllObjects];
    FLPhoto *photoObj=[[FLPhoto alloc] init];
    //hemalasankas**
    photoObj.title=@"Current Pic Title";
    photoObj.imageName=@"Current Pic Name";
    photoObj.imgURL=[FLGlobalSettings sharedInstance].current_user_profile.image;
    [profilePicArr addObject:photoObj];
    /////////////////////
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PROFILE_PICTURE_UPLOADED
     object:self];
    [self callReload:NO];
}



-(void)albumCreateResult:(FLAlbum *)albumObj;
{
    [HUD hide:YES];
    [albumArr addObject:albumObj];
    [self.collectionVwAlbum reloadData];
}

-(void)albumListResult:(NSMutableArray *)albumListArr
{
    [HUD hide:YES];
    [albumArr removeAllObjects];
    [albumArr addObjectsFromArray:albumListArr];
    [self.collectionVwAlbum reloadData];
}

-(void)profilePicListResult:(NSMutableArray *)photoArr
{
    [HUD hide:YES];
    [profilePicArr removeAllObjects];
    [profilePicArr addObjectsFromArray:photoArr];
    [self.collectionVwAlbum reloadData];

}

-(void)albumDeleteResult:(NSString *)msg
{
    //    [HUD hide:YES];
    //    [albumArr removeObjectAtIndex:deleteIndex];
    //    [self.collectionVwAlbum reloadData];
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //	[alertView show];
    
}




#pragma mark -
#pragma mark Error Handling

-(void)unknownFailureCall
{
    [HUD hide:YES];
    [self showValidationAlert:@"Unknown Error" ];
}

-(void)requestFailCall:(NSString *)errorMsg
{
    [HUD hide:YES];
    if (errorMsg) {
        [self showValidationAlert:errorMsg];
    }
}

-(void)showValidationAlert:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark - Actions

- (IBAction)profilePicClicked:(id)sender {
    if (!btnLeft.selected) {
        [UIView transitionWithView:viewAlbum
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:nil
                        completion:nil];
        
        [btnLeft setSelected:YES];
        [btnRight setSelected:NO];
        //        [self addImageURL];
        [self.collectionVwAlbum reloadData];
        //        cellArr=profilePicArr;
        //        [self fill];
        
    }
}

- (IBAction)myAlbumClicked:(id)sender
{
    if (!btnRight.selected) {
        [btnRight setSelected:YES];
        [btnLeft setSelected:NO];
        [self callReload:YES];
        [UIView transitionWithView:viewAlbum
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:nil
                        completion:nil];
        
        //        cellArr=myAlbumPicArr;
        //        [self fill];
        
        //        [self addImageURL];
        //        [self.collectionVwAlbum reloadData];
        
        
    }
}

-(void)deleteCellClicked:(id)sender
{
    NSLog(@"%d",[sender tag]);
    
    if (btnRight.isSelected)//delete album
    {
        HUD=[[MBProgressHUD alloc] initWithView:viewAlbum];
        [viewAlbum addSubview:HUD];
        HUD.dimBackground = YES;
        // Set the hud to display with a color
        //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        HUD.delegate = self;
        HUD.labelText = @"Connecting";
        HUD.square = YES;
        [HUD show:YES];
        
        //             deleteIndex=[sender tag]-1;
        //            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
        //            FLAlbum *albumObj=[albumArr objectAtIndex:deleteIndex];
        //            [webServiceApi albumDelete:self withAlbumID:albumObj.albumID];
    }
}

-(void)deleteClicked
{
    
    if (deleteNavButton.isSelected) {//cancel action
        [deleteNavButton setSelected:NO];
        
        
    }
    else//delete action
    {
        [deleteNavButton setSelected:YES];
        
        
    }
    [self.collectionVwAlbum reloadData];
}

@end
