//
//  FLMFPhotosViewController.m
//  Flingoo
//
//  Created by Hemal on 11/15/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMFPhotosViewController.h"
#import "FLPhotoAlbumColleCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FLPhotoCell.h"
#import "FLGlobalSettings.h"
#import "Config.h"
#import "Macros.h"

//typedef enum {
//    PROFILE_PICTURE=1,
//    MY_ALBUM
//} CellTypeType;

//#import "Cell.h"

@interface FLMFPhotosViewController ()
//@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
//@property(nonatomic,strong) FLOtherProfile *profileObj;
@property(nonatomic,strong) NSString *uploadedImageName;
@property(nonatomic,weak) UIButton *btnBack;
@property(nonatomic,strong) NSString *profile;
@end

@implementation FLMFPhotosViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profile:(NSString *)profile
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.profile=profile;
//        self.tabBarItem.title = @"Photo Gallery";
        self.tabBarItem.image = [UIImage imageNamed:@"photogallery_tabbar.png"];
    }
    return self;
}

#pragma mark -
#pragma mark view lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    albumPicArr=[[NSMutableArray alloc] init];

        
    self.navigationItem.title = self.albumObj.title;
   
        
        UIRefreshControl *collectionRefreshControl = [[UIRefreshControl alloc] init];
        collectionRefreshControl.tag = kTableModeCollection;
        
      
        [collectionRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

        [self.collectionVwPhoto addSubview:collectionRefreshControl];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.collectionVwPhoto registerNib:[UINib nibWithNibName:@"FLPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"FLPhotoCell"];

    
    
    ////add delete navigation back button
    [self.navigationItem setHidesBackButton:YES];
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBack setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    self.btnBack.frame = CGRectMake(5, 9, 50, 30);
    [self.navigationController.navigationBar addSubview:self.btnBack];
    
    
//    if (IS_IPHONE || IS_IPHONE_5) {
//        ////add delete navigation back button
//        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btnBack setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
//        [btnBack addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
//        self.navigationItem.leftBarButtonItem=backBarButton;
//    }
    
    
    if ([self.profile isEqualToString:MY_PROFILE]) {
        ////add delete navigation button
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
    [self callReload];
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

//-(void)backClicked
//{
//    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
//}


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

-(void)callReload
{
   
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
    if ([self.profile isEqualToString:MY_PROFILE])
    {
        [webService albumPhotoList:self withAlbumID:self.albumObj.albumID];
    }
    else
    {
        [webService usersAlbumPhotoList:self withUserID:[NSString stringWithFormat:@"%@",self.profileObj.uid] withAlbumID:self.albumObj.albumID];
    }
        
    
    
}


#pragma mark - refresh controller

- (void)refresh:(UIRefreshControl *)refreshControl
{
            
       [self callReload];
    
    [refreshControl endRefreshing];
}

#pragma mark
#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    if ([self.profile isEqualToString:OTHER_PROFILE])
    {
        return [albumPicArr count];
    }
    else
    {
        return [albumPicArr count] +1;
    }
       
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FLPhotoCell *cell = (FLPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FLPhotoCell" forIndexPath:indexPath];
    
   
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
        FLPhoto *photoObj=[albumPicArr objectAtIndex:cellIndex];
        cell.shouldShowCount = YES;
        cell.photoTitleLabel.text = photoObj.created_at;
        
        if ([self.profile isEqualToString:MY_PROFILE])
        {
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
     ///////////////////////////////////////////////////////////////////////
//        [cell.photoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:photoObj.imgURL]]
//                                       placeholderImage:[UIImage imageNamed:@"fv_addFriend.png"]
//                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                                    cell.photoImageView.image = image;
//                                                
//                                           
//                                                }
//                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
//                                                    
//                                                
//                                                }];
        
    ///////////////////////////////////////////////////////////////////
        FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
//        NSArray* foo = [photoObj.imgURL componentsSeparatedByString: @"/"];
//        NSString* imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
        
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
        
        
        [cell.photoImageView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               weakCell.photoImageView.image = image;
                                               [activityIndicatorView removeFromSuperview];
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                               [activityIndicatorView removeFromSuperview];
                                           }];
        ////////////////////////////////////////////////////////////
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
            FLPhotoCell *cell =(FLPhotoCell *)[self.collectionVwPhoto cellForItemAtIndexPath:indexPath];
            
            
            
            CGRect frm = cell.frame;
            //              frm.origin.y = frm.origin.y ;
            
            //          [popOver presentPopoverFromRect:frm inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            //              [popoverController presentPopoverFromRect:frm inView:self.collectionVwAlbum permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            [sheet showFromRect:frm inView:self.collectionVwPhoto animated:YES];
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
                
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    
                    [self presentViewController:_picker animated:YES completion:nil];
                    
                    
                } else
                {
                    
                    popoverController = [[UIPopoverController alloc] initWithContentViewController:_picker];
                    [popoverController setDelegate:self];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
                    FLPhotoCell *cell =(FLPhotoCell *)[self.collectionVwPhoto cellForItemAtIndexPath:indexPath];
                    
                    CGRect frm = cell.frame;
                    //                    frm.origin.y = frm.origin.y ;
                    [popoverController presentPopoverFromRect:frm inView:self.collectionVwPhoto permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
//    FLPhotoCell *cell =(FLPhotoCell *)[self.collectionVwPhoto cellForItemAtIndexPath:indexPath];
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
    
    
   
    //upload album pic
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    FLImgObj *imgObj=[[FLImgObj alloc] init];
    imgObj.folder_name=IMAGE_DIRECTORY_ALBUM;
    imgObj.imgData=UIImageJPEGRepresentation(originalImage,0.0);
    imgObj.imageName=[NSString stringWithFormat:@"%@.%@",[FLUtil imageNameForUpload:[FLGlobalSettings sharedInstance].current_user_profile.uid],@"jpg"];
    imgObj.imgContentType=@"image/jpeg";
    imgObj.albumID=self.albumObj.albumID;
    imgObj.title=@"TestImgTitle";
    [webSeviceApi uploadImage:self withImgObj:imgObj];

    
    
    

}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -
#pragma mark - web service api


//-(void)profileImageUploaded:(FLImgObj *)imgObj
//{
//    FLUserDetail *userDetail=[[FLUserDetail alloc] init];
//    userDetail.imageNameProfile=imgObj.imageName;
//    userDetail.full_name=[FLGlobalSettings sharedInstance].current_user_profile.full_name;
//    userDetail.birth_date=[FLGlobalSettings sharedInstance].current_user_profile.birth_date;
//    self.uploadedImageName=imgObj.imageName;
//    
//    
//    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
//    [webSeviceApi profileUpdate:self withUserData:userDetail];
//    
//    
////    -(void)uploadAlbumImage:(id)_delegate withAlbumObj:(FLPhoto *)photoObj
//}


//after upload image update album view
-(void)albumImageUploaded:(FLImgObj *)imgObj
{
    FLPhoto *photoObj=[[FLPhoto alloc] init];
    photoObj.albumID=imgObj.albumID;
    photoObj.title=imgObj.title;
    photoObj.imageName=imgObj.imageName;
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    [webSeviceApi uploadAlbumImage:self withAlbumObj:photoObj];
}


-(void)albumPhotoUploadedResult:(FLPhoto *)photoObj
{
//    [HUD hide:YES];
//    [albumPicArr addObject:albumObj];
//    [self.collectionVwPhoto reloadData];
    
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService albumPhotoList:self withAlbumID:self.albumObj.albumID];
}

-(void)albumPhotoListResult:(NSMutableArray *)photoObjArr
{
    [HUD hide:YES];
    [albumPicArr removeAllObjects];
    [albumPicArr addObjectsFromArray:photoObjArr];
    [self.collectionVwPhoto reloadData];
}

-(void)deletePhotoResult:(NSString *)str
{
        [HUD hide:YES];
        [albumPicArr removeObjectAtIndex:deleteIndex];
        [self.collectionVwPhoto reloadData];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    	[alertView show];
}


//
//-(void)albumCreateResult:(FLAlbum *)albumObj;
//{
//    [HUD hide:YES];
//    [albumPicArr addObject:albumObj];
//    [self.collectionVwPhoto reloadData];
//}
//
//
//
//
//-(void)albumDeleteResult:(NSString *)msg
//{
//    [HUD hide:YES];
//    [albumPicArr removeObjectAtIndex:deleteIndex];
//    [self.collectionVwPhoto reloadData];
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alertView show];
//  
//}

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


-(void)deleteCellClicked:(id)sender
{
    NSLog(@"%d",[sender tag]);

      
            HUD=[[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.dimBackground = YES;
            // Set the hud to display with a color
            //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
            HUD.delegate = self;
            HUD.labelText = @"Connecting";
            HUD.square = YES;
            [HUD show:YES];
            
             deleteIndex=[sender tag]-1;
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            FLPhoto *photoObj=[albumPicArr objectAtIndex:deleteIndex];
    [webServiceApi photoDelete:self withAlbumID:self.albumObj.albumID withPhotoID:photoObj.imgID];
        
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
    [self.collectionVwPhoto reloadData];
}

-(void)backClicked
{
    
    [self.btnBack removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
