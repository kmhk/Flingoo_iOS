//
//  FLTempVCViewController.m
//  Flingoo
//
//  Created by Hemal on 11/14/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLTempVCViewController.h"
#import "FLProfileSearch.h"
#import "FLUserLocation.h"
#import "FLFriendship.h"
#import "FLGroup.h"
#import "FLCreatedGroup.h"
#import "FLMeetpoint.h"
#import "FLTaxiPoint.h"
#import "FLRadarItem.h"
#import "FLUtilUserDefault.h"
#import "FLLocationPoint.h"
#import "FLGlobalSettings.h"
#import "FLUtil.h"
#import "Config.h"

@implementation FLTempVCViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Action

- (IBAction)testAction:(id)sender
{
    
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    //     //Current User
//        [webSeviceApi currentUser:self];
    
    //    Profiles : me
//         [webSeviceApi currentUserProfileDetail:self];//(PLEASE USE /users/me INSTEAD)
    
    //Sign out
//        [webSeviceApi signOutUser:self];
    
    //Profiles: update
//        FLUserDetail *userdetailObj=[[FLUserDetail alloc] init];
//        userdetailObj.full_name=@"test 66";
//        userdetailObj.mobile_number=@"77";
//        userdetailObj.birth_date=@"09/10/1990";
//        userdetailObj.gender=@"male";
//        userdetailObj.looking_for=@"";
//        userdetailObj.who_looking_for=@"men";
//        userdetailObj.orientation=@"private";
//        userdetailObj.age=[NSNumber numberWithInt:20];
//        userdetailObj.weight=[NSNumber numberWithInt:50];
//        userdetailObj.figure=@"slim";
//        userdetailObj.hair_color=@"black";
//        userdetailObj.hair_length=@"bald";
//        userdetailObj.eye_color=@"blue";
//        userdetailObj.body_art=@"piercing";
//        userdetailObj.smoker=@"smoker";
//        userdetailObj.ethnicity=@"european";
//        userdetailObj.religion=@"spiritual";
//        userdetailObj.children=@"no_children";
//        userdetailObj.living_situation=@"alone";
//        userdetailObj.training=@"not_finished";
//        userdetailObj.profession=@"job_seeker";
//        userdetailObj.income=@"no_income";
//        [webSeviceApi profileUpdate:self withUserData:userdetailObj];
    
    
//    //    //profile search
//        FLProfileSearch *proSeaObj=[[FLProfileSearch alloc] init];
//        proSeaObj.radius=[NSNumber numberWithInt:1000];
//        proSeaObj.age_gteq=[NSNumber numberWithInt:1];
//        proSeaObj.age_lteq=[NSNumber numberWithInt:100];
//        proSeaObj.gender_eq=@"male";
//        proSeaObj.orientation_eq=@"private";
//        [webSeviceApi profileSearch:self withUserData:proSeaObj];
    
    //    //set current location
    //    FLUserLocation *userLocationObj=[[FLUserLocation alloc] init];
    //    userLocationObj.latitude=@"79.0023232323";
    //    userLocationObj.longitude=@"69.9398434343";
    //    userLocationObj.is_online=YES;
    //    [webSeviceApi userLocationSet:self withUserData:userLocationObj];
    
    
    ////     //Friendship: create
//        FLFriendship *friendshipObj=[[FLFriendship alloc] init];
//        friendshipObj.friend_id=[NSNumber numberWithInt:29];
//        friendshipObj.initiator=YES;
//        [webSeviceApi createFriendship:self withUserData:friendshipObj];
    
    ////   // Friendships: Requests Listing
//        [webSeviceApi friendshipRequestListing:self];
    
    //    //Friendships: Accept
//       [webSeviceApi friendshipAccept:self withFriendshipId:@"12"];
    
    //    //Friendships: Reject
//        [webSeviceApi friendshipReject:self withFriendshipId:@"12"];
    
    //Friendships: Favourite - Add
//        [webSeviceApi favouriteAdd:self
//                  withFriendshipId:@"12"];
    
    //    Friendships: Favourites - Listing
//        [webSeviceApi favouriteListing:self];
    
    //    Friendships: Favourite - Remove
//        [webSeviceApi favouriteRemove:self withFriendshipId:@"12"];
    
  //   //Groups: Create
//        FLGroup *groupObj=[[FLGroup alloc] init];
//        groupObj.name=@"Test Group12222";
//        groupObj.description=@"This is Test Group111122";
//        groupObj.image=@"test.png";
//        groupObj.group_memberships_attributes=[NSArray arrayWithObjects:[NSNumber numberWithInt:26],[NSNumber numberWithInt:27],[NSNumber numberWithInt:45] , nil];
//        [webSeviceApi groupCreate:self withGroupObj:groupObj];
  
  //    Groups: List all
//        [webSeviceApi groupListAll:self];
    
  //Groups: Update
//       FLGroup *groupObj=[[FLGroup alloc] init];
//       groupObj.name=@"Test Group1";
//       groupObj.description=@"This is Test Group";
//       groupObj.image=@"test.png";
//       groupObj.group_memberships_attributes=[NSArray arrayWithObjects:[NSNumber numberWithInt:44] , nil];
//       [webSeviceApi groupUpdate:self withGroupObj:groupObj withGroupID:@"3"];
    
    
    //////    Groups: Add Users
//        [webSeviceApi groupUserUpdate:self withUserIDs:[NSArray arrayWithObjects:@"44", nil] withGroupID:@"11"];
    
    //    //Groups: Owned
//        [webSeviceApi groupsOwend:self];
    
//    //    Meet points: Create
//    FLMeetpoint *meetPointObj=[[FLMeetpoint alloc] init]; 
//    meetPointObj.name=@"Meet Point 11133";
//    meetPointObj.description=@"This is Test Meet point";
//    meetPointObj.image=[NSString stringWithFormat:@"%@.%@",[FLUtil imageNameForUpload:[FLGlobalSettings 	sharedInstance].current_user_profile.uid],@"jpg"];
//    meetPointObj.latitude=@"79.0023232323";
//    meetPointObj.longitude=@"69.9398434343";
//    [webSeviceApi meetPointCreate:self withMeetPointObj:meetPointObj];
    
    
    
    //    Meet points: Owned
//    [webSeviceApi meetPointOwend:self];
    
    //Meet points: List
//        [webSeviceApi meetpointListAll:self];
    
    //  //Taxi points: Create
//       FLTaxiPoint *taxiPointObj=[[FLTaxiPoint alloc] init];
//       taxiPointObj.start_time=@"10.00";
//       taxiPointObj.no_of_seats=[NSNumber numberWithInt:10];
//       taxiPointObj.start_address=@"test start_address";
//       taxiPointObj.destination_address=@"test destination_address";
//       taxiPointObj.start_latitude=@"10.2522";
//       taxiPointObj.start_longitude=@"10.2522";
//       taxiPointObj.destination_latitude=@"10.2522";
//       taxiPointObj.destination_longitude=@"10.2522";
//       [webSeviceApi taxiPointCreate:self withGroupObj:taxiPointObj];
    
    //<##>
//    //////    Radar: Search
//       FLRadar *radarObj=[[FLRadar alloc] init];
//       radarObj.radius=@"10";
//       radarObj.groups=YES;
//       radarObj.meet_points=YES;
//       radarObj.taxi_points=YES;
//       radarObj.location_points=YES;
//       radarObj.profiles=YES;
//       radarObj.age_gteq=[NSNumber numberWithInt:1];
//       radarObj.age_lteq=[NSNumber numberWithInt:80];
//       radarObj.looking_for_eq=@"both";
//       radarObj.who_looking_for_eq=@"both";
//       [webSeviceApi radarSearch:self withRadar:radarObj];
    
    
    
    
    
    
    //    Heartbeat
//        [webSeviceApi heartbeatNotify:self];
    
//    [webSeviceApi userShow:self withUserID:@"26"];
   
  
    
//    //image upload
//    NSString *uuid = [[NSUUID UUID] UUIDString];
//    //    NSString *userId= [[FLGlobalSettings sharedInstance] current_user]!=nil?([[FLGlobalSettings sharedInstance] current_user]).userID:@"";//once create curent user object must have to give userID for that object
//    NSString *userId=@"26";
//    NSString *imgName=[NSString stringWithFormat:@"%@-%@.png",userId,uuid];
//    
//    UIImage *image = [UIImage imageNamed:@"free_creedit_btn@2x.png"];
//    //    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [webSeviceApi uploadImage:imageData withDirectoryName:@"profile" withImageName:imgName];
    
//    
//    [webSeviceApi processBackgroundThreadUpload:imageData];
    
//     [webSeviceApi forgotPassword:self withEmail:@"htswarnasiri@gmail.com"];

//    [webSeviceApi interviewQuestionList:self];
//    [webSeviceApi profilePicsList:self];
    
    
    
//    Location Points
//    Location points: Create
    
//    FLLocationPoint *locationPointObj=[[FLLocationPoint alloc] init];
//    locationPointObj.name=@"Meet Point 11133";
//    locationPointObj.description=@"This is Test Meet point";
//    locationPointObj.latitude=@"79.0023232323";
//    locationPointObj.longitude=@"69.9398434343";
//    [webSeviceApi locationPointCreate:self withLocationPointObj:locationPointObj];
    
    
//    Location points: Check-in
//    [webSeviceApi locationCheckin:self withVenueID:@"10"];

    //Users : Like
//    [webSeviceApi likeToUser:self withUserID:@"121"];
    
    //Users : Unlike
//    [webSeviceApi unlikeToUser:self withUserID:@"122"];
    
//    [webSeviceApi likeUsersList:self];
    
    
//    FLAlbum *albumObj=[[FLAlbum alloc] init];
//    albumObj.title=@"Moment1";
//    albumObj.moments=YES;
//    [webSeviceApi createAlbum:self withAlbumObj:albumObj];
    
   
    
//    [webSeviceApi momentList:self];
    

//    [webSeviceApi creaditPlansList:self];
//    currently gave this error
//    
//    CREDIT_PLANS requestFail {
//        error = "uninitialized constant Api::V1::CreditPlansController";
//        status = 404;
//    }

    
//    [webSeviceApi getVipMembershipList:self];
//    //same as current user profile webservice method and can't get expected result

    [webSeviceApi getVipMembershipPlanList:self];
//    //got empty list
//    VIP_MEMBERSHIP_PLAN_LIST (
//    )

  
 

    
//    FLPayment *paymentObj=[[FLPayment alloc] init];
//    paymentObj.order_type=@"credit";
//    paymentObj.order_id=@"1";
//    paymentObj.transaction_provider=@"in_app_apple";
//    paymentObj.transaction_number=@"ABC123";
//    paymentObj.transaction_amount=@"2.99";
//    paymentObj.transaction_status=@"completed";
//    paymentObj.transaction_message=@"Transaction completed11";
//    [webSeviceApi sendPayment:self withLocationPointObj:paymentObj];
    

    

//    [webSeviceApi albumList:self];
    
//      [webSeviceApi createEyeCatcher:self];
    
//    [webSeviceApi getEyeCatcherProfileList:self];
    
//    [webSeviceApi creaditPlansList:self];
    
//    [webSeviceApi getVipMembershipList:self];
    
    
    
    
}

-(void)membershipPlanResult:(NSMutableArray *)membershipPlanArr
{

}


-(void)creditPlanResult:(NSMutableArray *)creditPlanArr
{
    

}

-(void)eyeCatcherProfileListResult:(NSMutableArray *)eyeCatcherProfilesArr
{
    NSLog(@"eyeCatcherProfilesArr %@",eyeCatcherProfilesArr);
}

-(void)createEyeCatcherResult:(NSString *)str
{

}

-(void)momentListResult:(NSMutableArray *)momentsObjArr
{
    NSLog(@"momentsObjArr %@",momentsObjArr);
//    for(FLRadarObject *radar in momentsObjArr)
//    {
//        NSLog(@"radar.image %@",radar.image);
//    }
}

-(void)albumListResult:(NSMutableArray *)albumListArr
{

    for(id obj in albumListArr)
    {
        FLAlbum *albumObj=(FLAlbum *)obj;
        if (albumObj.moments==1)
        {
            //upload album pic
            FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
            FLImgObj *imgObj=[[FLImgObj alloc] init];
            imgObj.folder_name=IMAGE_DIRECTORY_ALBUM;
            UIImage *originalImage=[UIImage imageNamed:@"flower.jpg"];
            imgObj.imgData=UIImageJPEGRepresentation(originalImage,0.0);
            imgObj.imageName=[NSString stringWithFormat:@"%@.%@",[FLUtil imageNameForUpload:[FLGlobalSettings sharedInstance].current_user_profile.uid],@"jpg"];
            imgObj.imgContentType=@"image/jpeg";
            imgObj.albumID=albumObj.albumID;
            imgObj.title=@"TestImgTitle";
            [webSeviceApi uploadImage:self withImgObj:imgObj];
        }
    }
}

//after upload image update backend
-(void)albumImageUploaded:(FLImgObj *)imgObj
{
    FLPhoto *photoObj=[[FLPhoto alloc] init];
    photoObj.albumID=imgObj.albumID;
    photoObj.title=imgObj.title;
    photoObj.imageName=imgObj.imageName;
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    [webSeviceApi uploadAlbumImage:self withAlbumObj:photoObj];
}


//backend updated sucess response
-(void)albumPhotoUploadedResult:(FLPhoto *)photoObj
{
    NSLog(@"photoObj %@",photoObj.imageName);

    //    [HUD hide:YES];
    //    [albumPicArr addObject:albumObj];
    //    [self.collectionVwPhoto reloadData];
    
//    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
//    [webService albumPhotoList:self withAlbumID:photoObj.albumID];
}


- (IBAction)removeUser:(id)sender {
    [FLUtilUserDefault removeAllUserData];
}


#pragma mark -
#pragma mark webservice api methods

-(void)sendPaymentResult:(NSString *)str
{


}


//meet point created delegate method
-(void)meetPointCreateResult:(FLMeetpoint *)meetPointObj
{
    //upload meetpoint pic
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    FLImgObj *imgObj=[[FLImgObj alloc] init];
    imgObj.folder_name=IMAGE_DIRECTORY_MEETPOINT;
    UIImage *originalImage=[UIImage imageNamed:@"bgimg1.PNG"];
    imgObj.imgData=UIImageJPEGRepresentation(originalImage,0.0);
    imgObj.imageName=meetPointObj.image;
    imgObj.imgContentType=@"image/jpeg";
    [webSeviceApi uploadImage:self withImgObj:imgObj];
    
    
}

//meet point image upload success delegate method
-(void)meetPointImageUploaded:(FLImgObj *)meetPointObj
{
    
    NSLog(@"image uploaded");

    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    NSURL *imgUrl=[webServiceApi getImageFromName:[NSString stringWithFormat:@"%@/%@",meetPointObj.folder_name,meetPointObj.imageName]];
    NSLog(@"imgUrl %@",imgUrl);
}



-(void)radarSearchResult:(NSMutableArray *)radarObjArr
{
    
}

-(void)unlikeToUserResult:(NSString *)str
{
    [self showValidationAlert:str];
}


-(void)likeToUserResult:(NSString *)str
{
 [self showValidationAlert:str];
}


-(void)locationPointCreateResult:(NSString *)str
{
 [self showValidationAlert:str];
}


-(void)radarSearchMeetPointResult:(NSMutableArray *)meetPointObjArr
{

}
-(void)radarSearchGroupResult:(NSMutableArray *)meetPointObjArr
{
    
}
-(void)radarSearchTaxiPointResult:(NSMutableArray *)meetPointObjArr
{
    
}


-(void)forgetPasswodResult:(NSString *)msg
{
    [self showValidationAlert:msg];
}

-(void)taxipointCreateResult:(NSString *)msg
{
    [self showValidationAlert:msg];
}

-(void)meetpointOwnedResult:(NSMutableArray *)meetpointArr
{
    for (id group in meetpointArr) {
        FLMeetpoint *obj=group;
        NSLog(@"obj.created_at %@",obj.created_at);
        NSLog(@"date_time %@",obj.date_time);
        NSLog(@"obj.description %@",obj.description);
        NSLog(@"obj.group_id %@",obj.point_id);
        NSLog(@"obj.image %@",obj.image);
        NSLog(@"latitude %@",obj.latitude);
        NSLog(@"longitude %@",obj.longitude);
    }
}


-(void)groupOwnedResult:(NSMutableArray *)createdGroupsArr
{
    for (id group in createdGroupsArr) {
        FLCreatedGroup *obj=group;
        NSLog(@"obj.created_at %@",obj.created_at);
        NSLog(@"obj.description %@",obj.description);
        NSLog(@"obj.group_id %@",obj.group_id);
        NSLog(@"obj.image %@",obj.image);
        NSLog(@"obj.name %@",obj.name);
    }
    
}

-(void)groupUpdateResult:(NSString *)msg
{
    [self showValidationAlert:msg];
}

-(void)groupListResult:(NSMutableArray *)createdGroupsArr
{
    for (id group in createdGroupsArr) {
        FLCreatedGroup *obj=group;
        NSLog(@"obj.created_at %@",obj.created_at);
        NSLog(@"obj.description %@",obj.description);
        NSLog(@"obj.group_id %@",obj.group_id);
        NSLog(@"obj.image %@",obj.image);
        NSLog(@"obj.latitude %@",obj.latitude);
        NSLog(@"obj.longitude %@",obj.longitude);
        NSLog(@"obj.name %@",obj.name);
        NSLog(@"obj.owner_full_name %@",obj.owner_full_name);
        NSLog(@"obj.owner_user_id %@",obj.owner_user_id);
    }
    
}


-(void)groupCreateResult:(NSString *)msg
{
    [self showValidationAlert:msg];
}

-(void)currentUserProfileResult:(FLProfile *)profileObj
{
    NSLog(@"profileObjArr %@",profileObj.full_name);
    
}

-(void)profileSearchResult:(NSMutableArray *)profileObjArr
{
    NSLog(@"profileObjArr %@",profileObjArr);
}

-(void)userLocationSetResult:(NSString *)message
{
    [self showValidationAlert:message];
}

-(void)createFriendshipResult:(NSString *)message
{
    [self showValidationAlert:message];
}


-(void)currentUserResult:(FLProfile *)me
{
    NSLog(@"me %@",me.email);
    NSLog(@"me %@",me.uid);
}

-(void)signOutUserResult:(NSString *)message
{
    [self showValidationAlert:message];
}

-(void)profileUpdateResult:(NSString *)msg
{
    [self showValidationAlert:msg];
}

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
