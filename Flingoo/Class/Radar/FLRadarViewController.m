//
//  FLRadarViewController.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 11/26/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLRadarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FLRadarItem.h"
#import "FLWebServiceApi.h"
#import "FLGlobalSettings.h"
#import "FLOtherProfile.h"
#import "FLButtonWithProfile.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "FLTaxiPointViewController.h"
#import "CLImageEditor.h"
#import "FLRadarObject.h"
#import "FLUtil.h"
#import "FLMomentView.h"
#import "FLGroupChatScreenViewController.h"
#import "Config.h"
#import "FLCameraOverlay.h"

#define radianConst M_PI/180.0
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / (float)M_PI * 180.0f)
#define degreesToRadians(x) (M_PI * x / 180.0)
#define RADIANS_TO_DEGREES(radians) ((radians) * 180.0 / M_PI)

@interface FLRadarViewController ()
<CLImageEditorDelegate, CLImageEditorThemeDelegate>


// basic CADisplayLink properties

@property (nonatomic, strong) CADisplayLink  *displayLink;
@property (nonatomic)         CFTimeInterval  startTime;

// display link state properties

@property (nonatomic)         CFTimeInterval  animationDuration;
@property (nonatomic)         CGFloat         startAngle;
@property (nonatomic)         CGFloat         targetAngle;

@end

@implementation FLRadarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSMutableString *nibName = [nibNameOrNil mutableCopy];
    
    if (IS_IPHONE_5) {
        [nibName appendString:@"-586h"];
    }
//    else if(IS_IPAD_DEVICE || IS_IPAD_SIMULATOR){
//        [nibName appendString:@"~ipad"];
//    }
    
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    CLLocationDegrees emptyLocation = -1000.0;
//    _selectedLocation = CLLocationCoordinate2DMake(emptyLocation, emptyLocation);
    
    
    
    
    
    //Initialize things
    if (IS_IPAD) {
        [_scrRadar setContentSize:CGSizeMake(756, 705)];
    }else{
        [_scrRadar setContentSize:CGSizeMake(320, IS_IPHONE_5 ? 505 : 419)];
    }
    
    
    //Add refresh controller
    UIRefreshControl *refreshControll = [[UIRefreshControl alloc] init];
    refreshControll.tintColor = [UIColor lightGrayColor];
    [refreshControll addTarget:self action:@selector(refreshRadar:) forControlEvents:UIControlEventValueChanged];
    [_scrRadar addSubview:refreshControll];
    
    //Radar sides
    _viewRadarBack.layer.doubleSided = NO;
    [_viewRadarBase addSubview:_viewRadarBack];
    
    _viewRadarFront.layer.doubleSided = NO;
    [_viewRadarBase addSubview:_viewRadarFront];
    
    //Flip back view
    CALayer *backLayer = _viewRadarBack.layer;
    CATransform3D flipTransform = CATransform3DIdentity;
    flipTransform.m34 = -0.002f;
    flipTransform = CATransform3DRotate(flipTransform, M_PI, 0.0f, 1.0f, 0.0f);
    backLayer.transform = flipTransform;
    
    //Bring all buttons to front
    [self bringToFront];
    
    //Add slider gesture
    _sldGesture.slider = _sldDistanceFilter;
    
    //Add flip gesture
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_pan setDelegate:self];
    [self.view addGestureRecognizer:_pan];
    
    //Start scan
    [self startScanRadar];
    
    //Setup compass
    [self setupComapss];
    
    //Start panaroma
    [self startPanaroma];
    
//    [self radarServiceCall];
    
    //setup radar loading text
    [self setupRadarLoader];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUserCenterImage];
}

-(void)viewDidAppear:(BOOL)animated{
    if (IS_IPAD) {
        [_scrPanaroma setContentSize:CGSizeMake(3582, 751)];
    }else{
        [_scrPanaroma setContentSize:CGSizeMake(2255, 504)];
    }
    
}

#pragma mark - Radar main gestures
#pragma mark -

- (void)handlePan:(UIPanGestureRecognizer*)gesture{
    CGPoint translation = [gesture translationInView:self.view];
    
    double percentageOfWidth = translation.x / (gesture.view.frame.size.width / 2) * 1.2;
    
    float angle = (percentageOfWidth * 100) * M_PI / 180.0f;
    float angle2 = (percentageOfWidth * 100) * M_PI/ 180.0f;
    
    if (_turnedRight) {
        angle = angle + M_PI;
        angle2  = angle2 + M_PI;
    }else if(_turnedLeft){
        angle = angle - M_PI;
        angle2  = angle2 - M_PI;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateChanged){
        
        [self stopDisplayLink];
        
        CALayer *layer = _viewRadarFront.layer;
        CATransform3D flipTransform = CATransform3DIdentity;
        flipTransform.m34 = -0.002f;
        flipTransform = CATransform3DRotate(flipTransform, angle, 0.0f, 1.0f, 0.0f);
        layer.transform = flipTransform;
        
        CALayer *layer2 = _viewRadarBack.layer;
        CATransform3D flipTransform2 = CATransform3DIdentity;
        flipTransform2.m34 = -0.002f;
        flipTransform2 = CATransform3DRotate(flipTransform2, angle2 + M_PI, 0.0f, 1.0f, 0.0f);
        layer2.transform = flipTransform2;

    }
    
    self.startAngle = angle;
    
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled){
        
        if (percentageOfWidth >= M_PI_4) {
            
            self.targetAngle = _turnedRight ? (M_PI * 2): _turnedLeft ? 0 : M_PI;
            
            if (!_turnedLeft) {
                if (_turnedRight) {
                    _turnedRight = NO;
                }else{
                    _turnedRight = YES;
                } 
            }
            
            [_viewRadarBase exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            _turnedLeft = NO;
            
            [self startDisplayLink];
            
        }else if (percentageOfWidth <= -M_PI_4){
            
            self.targetAngle = _turnedLeft ? (-M_PI * 2) : _turnedRight ? 0 : -M_PI;
            
            if (!_turnedRight) {
                if (_turnedLeft) {
                    _turnedLeft = NO;
                }else{
                    _turnedLeft = YES;
                } 
            }
            
            [_viewRadarBase exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
            _turnedRight = NO;
            
            [self startDisplayLink];
            
        }else{
            
            if (_turnedRight) {
                self.targetAngle = M_PI;
            }else if(_turnedLeft){
                self.targetAngle = -M_PI;
            }else{
                self.targetAngle = 0.0;
            }
            
            [self startDisplayLink];
            
        }
        
    }
}

//This will only allow flipt horizontally
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    //Condition to avoid crsh when use the TapGesturerecognizer to hide the preview view
    if ([panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        return fabs(translation.y) < fabs(translation.x);
    }else{
        return YES;
    }
    
}

#pragma mark - Radar beam
#pragma mark -

-(void)startScanRadar{
    
    _imgBeamBack.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _imgBeamFront.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = 3.5f;
    fullRotation.repeatCount = MAXFLOAT;
    fullRotation.removedOnCompletion = NO;
    
    [_imgBeamBack.layer addAnimation:fullRotation forKey:@"360"];
    [_imgBeamFront.layer addAnimation:fullRotation forKey:@"360"];
    
    [self.view setNeedsDisplay];
}

#pragma mark - Panaroma
#pragma mark -

-(void)startPanaroma{
    motionManager = [[CMMotionManager alloc] init];
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:[NSOperationQueue currentQueue]
                                                   withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                       
                                                       [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                   }];
    
    [motionManager startGyroUpdates];
}

- (void)handleDeviceMotion:(CMDeviceMotion*)motion {
    //    CMAttitude      *attitude = motion.attitude;
    
    if (xValue == 0.0) {
        xValue = _scrPanaroma.contentOffset.x;
    }
    
    float rate = motionManager.gyroData.rotationRate.z;
    
    if (fabs(rate) > .2) {
        
        
//        NSLog(@"YAW %f", rate);
        
        float direction = rate > 0 ? 1 : -1;
        
        if (direction == -1) {
            xValue++;
//            _lblDirection.text = @"Right";
        }else{
            xValue--;
//            _lblDirection.text = @"Left";
        }
        
//        _xVal.text = [NSString stringWithFormat:@"%f", xValue];
        [_scrPanaroma setContentOffset:CGPointMake(xValue, 0) animated:NO];
        
//        _lblValue.text = [NSString stringWithFormat:@"%f", rate];
    }
    
    
}

#pragma mark - Compass
#pragma mark -

-(void)setupComapss{
    // Set up location manager
    _locationManager=[[CLLocationManager alloc] init];
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // We listen to events from the locationManager
    _locationManager.delegate = self;
    
    // Start listening to events from locationManager
    [_locationManager startUpdatingHeading];
    
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
 
    // Update variable updateHeading to be used in updater method
    _updatedHeading = newHeading.magneticHeading;
    float headingFloat = 0 - newHeading.magneticHeading;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _viewFrontRadarSet.transform = CGAffineTransformMakeRotation((headingFloat + _northOffest)*radianConst);
    _viewBackRadarSet.transform = CGAffineTransformMakeRotation((headingFloat + _northOffest)*radianConst);
    _btnUserProfilePic.transform = CGAffineTransformMakeRotation(-(headingFloat + _northOffest)*radianConst);
    _imgUserProfileRadar.transform = CGAffineTransformMakeRotation(-(headingFloat + _northOffest)*radianConst);
    _btnCamera.transform = CGAffineTransformMakeRotation(-(headingFloat + _northOffest)*radianConst);
    [UIView commitAnimations];
    
    _radarItemAngle = -(headingFloat + _northOffest)*radianConst;
    
    for (FLRadarObject *item in _radarItems) {
        
        switch (item.radarType) {
            case TYPE_MOMENT:{
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.25];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                
                item.viewMoment.transform = CGAffineTransformMakeRotation(-(headingFloat + _northOffest)*radianConst);
                
                [UIView commitAnimations];
                break;
            }
                
            default:{
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.25];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                
                item.button.transform = CGAffineTransformMakeRotation(-(headingFloat + _northOffest)*radianConst);
                
                [UIView commitAnimations];
                break;
            }
        }
        
        
    }
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"failed_get_your_location", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
    [errorAlert show];
    
    [UIView animateWithDuration:0.4f animations:^{
        
        _viewRadarLoadingMessage.alpha = 0;
        
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        FLUserLocation *userLocationObj=[[FLUserLocation alloc] init];
        userLocationObj.latitude=[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        userLocationObj.longitude=[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        userLocationObj.is_online=YES;
        [_locationManager stopUpdatingLocation];
        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
        [webService userLocationSet:self withUserData:userLocationObj];
        
        [self getAddressForLocation:currentLocation];
    }
}


#pragma mark - Display links
#pragma mark -

- (void)startDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    self.startTime = CACurrentMediaTime();
    self.animationDuration = M_PI_2 * 0.4f;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink{
    NSLog(@"GOO");
    if ([FLUtil roundFloat:self.targetAngle] == [FLUtil roundFloat:self.startAngle]) {
        [self stopDisplayLink];
    }
    
    if (self.targetAngle >= self.startAngle) {
        if (self.targetAngle >= M_PI <= self.startAngle) {
            self.startAngle = self.startAngle + 0.1;
        }else if(self.targetAngle == 0 <= self.startAngle){
            self.startAngle = self.startAngle + 0.1;
        }else if(self.targetAngle <= -M_PI){
            self.startAngle = self.startAngle + 0.1;
        }
        
        CALayer *layer = _viewRadarFront.layer;
        CATransform3D flipTransform = CATransform3DIdentity;
        flipTransform.m34 = -0.002f;
        flipTransform = CATransform3DRotate(flipTransform, self.startAngle, 0.0f, 1.0f, 0.0f);
        layer.transform = flipTransform;
        
        CALayer *layer2 = _viewRadarBack.layer;
        CATransform3D flipTransform2 = CATransform3DIdentity;
        flipTransform2.m34 = -0.002f;
        flipTransform2 = CATransform3DRotate(flipTransform2, self.startAngle + M_PI, 0.0f, 1.0f, 0.0f);
        layer2.transform = flipTransform2;
        
    }else if (self.targetAngle <= self.startAngle){
        
        if (self.targetAngle <= -M_PI >= self.startAngle) {
            self.startAngle = self.startAngle - 0.1;
        }else if(self.targetAngle <= 0){
            self.startAngle = self.startAngle - 0.1;
        }if(self.targetAngle >= M_PI){
            self.startAngle = self.startAngle - 0.1;
        }
        
        CALayer *layer = _viewRadarFront.layer;
        CATransform3D flipTransform = CATransform3DIdentity;
        flipTransform.m34 = -0.002f;
        flipTransform = CATransform3DRotate(flipTransform, self.startAngle, 0.0f, 1.0f, 0.0f);
        layer.transform = flipTransform;
        
        CALayer *layer2 = _viewRadarBack.layer;
        CATransform3D flipTransform2 = CATransform3DIdentity;
        flipTransform2.m34 = -0.002f;
        flipTransform2 = CATransform3DRotate(flipTransform2, self.startAngle + M_PI, 0.0f, 1.0f, 0.0f);
        layer2.transform = flipTransform2;
        
    }else{
        [self stopDisplayLink];
    }
    
}

- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - Radar scan
#pragma mark -

-(void)scanRadar{
//    float currentLat = 6.889234;
//    float currentLng = 79.966643;
//    int middleCircleRadiance = 65;//This is the radiance of middle circle which we need to ignore
//    int availableDistance = 65;
//    float distance = 450;//1KM - 450KM
//    float divider = availableDistance / distance;
//    
//    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentLat longitude:currentLng];
//    
//    _radarItems = [[NSMutableArray alloc] init];
    //First pin

//    FLRadarItem *r1 = [[FLRadarItem alloc] init];
//    r1.type = TYPE_MEET_POINT;
//    CLLocation *firstPin = [[CLLocation alloc] initWithLatitude:6.723022 longitude:80.126038];
//    [r1 setLocation:firstPin];
//    [_radarItems addObject:r1];
}

#pragma mark - Radar service
#pragma mark -

-(void)radarServiceCall{//Sample
    
    [UIView animateWithDuration:0.4f animations:^{
        
        _viewRadarLoadingMessage.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [_viewRadarLoadingMessage startWithText:NSLocalizedString(@"Your radar is looking for new people...", @"")];
        
    }];
    
    
    //    Radar: Search
    FLWebServiceApi *webSeviceApi = [[FLWebServiceApi alloc] init];
    
    FLRadar *radarObj=[[FLRadar alloc] init];
    radarObj.radius=@"500";
    radarObj.groups=YES;
    radarObj.meet_points=YES;
    radarObj.taxi_points=YES;
    radarObj.location_points=YES;
    radarObj.profiles=YES;
    radarObj.age_gteq=[NSNumber numberWithInt:1];
    radarObj.age_lteq=[NSNumber numberWithInt:80];
    radarObj.looking_for_eq=@"women";
    radarObj.who_looking_for_eq=@"both";
    [webSeviceApi radarSearch:self withRadar:radarObj];
}

-(void)radarSearchResult:(NSMutableArray *)radarObjArr{
    NSLog(@"RADAR OBJECTS %@", radarObjArr);
    NSLog(@"COUNT ===== ==== ==== === == = Prior %d", [radarObjArr count]);
    
    for (FLRadarObject *item in _radarItems) {
        NSLog(@"item.viewMoment %@", item.viewMoment);
        if (item.button) {
            [item.button removeFromSuperview];
        }else if (item.viewMoment){
            [item.viewMoment removeFromSuperview];
        }
    }
    
    [_radarItems removeAllObjects];
    
    NSLog(@"ARRAY PRINT %@", _radarItems);
    
    if (!_radarItems) {
        _radarItems = [[NSMutableArray alloc] init];
    }
    
    [_radarItems addObjectsFromArray:radarObjArr];
    
    [self loadMomentsFromService];
    
//    FLRadarObject *moment1 = [[FLRadarObject alloc] init];
//    moment1.radarType = TYPE_MOMENT;
//    moment1.image = @"overlay_category_icon_food";
//    moment1.location = [[CLLocation alloc] initWithLatitude:6.910067 longitude:79.9169];//6.892259, 79.964577
//    [radarObjArr addObject:moment1];
    
//    FLRadarObject *moment2 = [[FLRadarObject alloc] init];
//    moment2.radarType = TYPE_MOMENT;
//    moment2.image = @"filter_preview_pittsburgh";
//    moment2.location = [[CLLocation alloc] initWithLatitude:6.997652 longitude:80.003418];
//    [radarObjArr addObject:moment2];
    
    
    
    [_viewRadarLoadingMessage completeWithText:NSLocalizedString(@"Your radar has been updated.", @"")];
    [self performSelector:@selector(hideRadarLabel) withObject:nil afterDelay:3.0f];
}

-(void)hideRadarLabel{
    [UIView animateWithDuration:0.4f animations:^{
       
        _viewRadarLoadingMessage.alpha = 0;
        
    }];
}

#pragma mark - Radar Actions
#pragma mark -

-(void)itemSelected:(FLButtonWithRadarItem*)sender{
    
//    [sender setBackgroundColor:[UIColor greenColor]];
    _scrRadar.scrollEnabled = NO;
    [_pan setEnabled:NO];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    NSLog(@"ITEM SELECTED");
    _selectedRadarObject = sender.radarItem;
    switch (_selectedRadarObject.radarType) {
        case TYPE_GROUP:{
            [_selectedRadarObject.button setBackgroundImage:[UIImage imageNamed:@"SelectedGroupPoint"] forState:UIControlStateNormal];
//            for (FLRadarObject *item in _radarItems) {
//                if (CGRectIntersectsRect(sender.radarItem.button.frame, item.button.frame) ) {
//                    NSLog(@"INT - YES IT INTERSECTS");
//                    if (item.radarType == TYPE_GROUP) {
//                        [item.button setBackgroundImage:[UIImage imageNamed:@"SelectedGroupPoint"] forState:UIControlStateNormal];
////                        [profilesToShow addObject:item];
//                    }
//                }else{
//                    NSLog(@"INT - NO ITs NOT INTERSECTING");
//                }
//            }
            
//            FLWebServiceApi *webSeviceApi = [[FLWebServiceApi alloc] init];
//            
//            [webSeviceApi showGroup:self withGroupId:_selectedRadarObject.radarID];
            
            
            
            [_scrViewGroupMembers setContentSize:CGSizeMake(224, 48)];
            
            [FLWebServiceBlocks showGroupByID:_selectedRadarObject.radarID :^(FLGroup *group, id error) {
                
                _selectedGroup = group;
                
                NSLog(@"GROUP > %@", group);
                
                //set owner profile pic
                [self setOwnerImage:TYPE_GROUP withProfile:group.owner];
                
                _imgGroupPic.layer.cornerRadius = 10;
                _imgGroupPic.layer.masksToBounds = YES;
                [_imgGroupPic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", group.image]]];
                
                //set members
                
                if ([group.group_memberships_attributes count] > 3) {
                    [_scrViewGroupMembers setContentSize:CGSizeMake(62 * [group.group_memberships_attributes count], 48)];
                }
                
                //loop friends
                int count = 0;
                for (FLOtherProfile *prof in group.group_memberships_attributes) {
                    
                    int x = count == 0 ? 16 : 16 + (16 + 40) * count;
                    NSLog(@"X > %d", x);
                    
                    CGRect rect = CGRectMake(x , IS_IPAD ? 15 : 1, 46, 46);
                    
                    
                    FLFriendView *frnd = [[FLFriendView alloc] initWithFrame:rect andProfile:prof];
                    frnd.tag = count;
                    frnd.scrollParent = _scrFriends;
                    frnd.mainView = _viewRadarFront;
                    //        frnd.delegate = self;
                    frnd.imgv.contentMode = UIViewContentModeScaleAspectFill;
                    
                    [frnd setBackgroundColor:[UIColor clearColor]];
//                    [_friendsArray addObject:frnd];
                    [_scrViewGroupMembers addSubview:frnd];
                    
                    count++;
                    
                }
                
                //checkfor owner
                NSLog(@"UID : %d", [group.owner.uid intValue]);
                if ([((NSNumber*)([FLGlobalSettings sharedInstance].current_user_profile.uid)) intValue] == [group.owner.uid intValue]) {
                    NSLog(@"USER SAME");
                    _btnEditGroup.hidden = NO;
                }else{
                    NSLog(@"USER NOT SAME");
                    _btnEditGroup.hidden = YES;
                }
                
            }];
            
            _lblGroupName.text = _selectedRadarObject.name;
            _txtVGroupDesc.text = _selectedRadarObject.desc;
            
            
            
            NSLog(@"GROUP %@ %@", _selectedRadarObject.name, _viewGroupPreview);
            _viewGroupPreview.alpha = 0;
            
            _viewGroupPreview.frame = CGRectMake(0, IS_IPHONE_5 ? 268 : 180, _viewGroupPreview.frame.size.width, _viewGroupPreview.frame.size.height);
            
            [self.view addSubview:_viewGroupPreview];
            
            [UIView animateWithDuration:0.4f animations:^{
                
                _viewGroupPreview.alpha = 1;
                
            }];
            break;
            
        }
        case TYPE_MEET_POINT:{
            [sender setBackgroundImage:[UIImage imageNamed:@"SelectedGroupPoint"] forState:UIControlStateNormal];
            NSLog(@"MEET %@", _selectedRadarObject.name);
            
            _lblMeetingName.text = _selectedRadarObject.name;
            _txtVMeetingDesc.text = _selectedRadarObject.desc;
            _ViewMeetingPreview.alpha = 0;
            
            _ViewMeetingPreview.frame = CGRectMake(0, IS_IPHONE_5 ? 268 : 180, _ViewMeetingPreview.frame.size.width, _ViewMeetingPreview.frame.size.height);
            
            [self.view addSubview:_ViewMeetingPreview];
            
            [UIView animateWithDuration:0.4f animations:^{
                
                _ViewMeetingPreview.alpha = 1;
                
            }];
            
        }
            break;
        case TYPE_TAXI_POINT:
            [sender setBackgroundImage:[UIImage imageNamed:@"SelectedGroupPoint"] forState:UIControlStateNormal];
            NSLog(@"TAXI %@", _selectedRadarObject.name);
            break;
            
        case TYPE_PROFILE:{
            
            NSMutableArray *profilesToShow = [[NSMutableArray alloc] init];
//            [profilesToShow addObject:_selectedRadarObject];
            
            NSLog(@"Profile selected");
            [sender setBackgroundImage:[UIImage imageNamed:@"SelectedGroupPoint"] forState:UIControlStateNormal];
            for (UIView *view in _scrProfileList.subviews) {
                [view removeFromSuperview];
            }
            
            for (FLRadarObject *item in _radarItems) {
                if (CGRectIntersectsRect(sender.radarItem.button.frame, item.button.frame) ) {
                    NSLog(@"INT - YES IT INTERSECTS");
                    if (item.radarType == TYPE_PROFILE) {
                        [item.button setBackgroundImage:[UIImage imageNamed:@"SelectedGroupPoint"] forState:UIControlStateNormal];
                        [profilesToShow addObject:item];
//                        [profilesToShow addObject:item];
//                        [profilesToShow addObject:item];
//                        [profilesToShow addObject:item];
//                        [profilesToShow addObject:item];
                    }
                }else{
                    NSLog(@"INT - NO ITs NOT INTERSECTING");
                }
            }
            
            _viewProfileList.alpha = 0;
            _viewProfileList.frame = CGRectMake(0, IS_IPHONE_5 ? 350 : 270, _viewProfileList.frame.size.width, _viewProfileList.frame.size.height);
            [self.view addSubview:_viewProfileList];
            
            [UIView animateWithDuration:0.4f animations:^{
                
                _viewProfileList.alpha = 1;
                
                NSLog(@"SHOW count %d", [profilesToShow count]);
                
                [_scrProfileList setContentSize:CGSizeMake(321, 133)];
                
                if ([profilesToShow count] == 1) {
                    FLProfileUserView *user1 = [[FLProfileUserView alloc] initWithRadarItem:_selectedRadarObject andDelegate:self];
                    [user1 setCenter:CGPointMake(_scrProfileList.center.x, _scrProfileList.center.y)];
                    [_scrProfileList addSubview:user1];
                }else if ([profilesToShow count] == 2){
                    int x = _scrProfileList.frame.size.width / 3;
                    int profileCount = 1;
                    
                    for (FLRadarObject *radarItem in profilesToShow) {
                        FLProfileUserView *user1 = [[FLProfileUserView alloc] initWithRadarItem:radarItem andDelegate:self];
                        float xVal = x * profileCount;
                        NSLog(@"XVAL %f", xVal);
                        [user1 setCenter:CGPointMake(xVal, _scrProfileList.center.y)];
                        [_scrProfileList addSubview:user1];
                        profileCount++;
                    }
                }else{
                    int x = 53;//106/2
                    int profileCount = 1;
                    
                    [_scrProfileList setContentSize:CGSizeMake(106 * [profilesToShow count], 133)];
                    
                    for (FLRadarObject *radarItem in profilesToShow) {
                        FLProfileUserView *user1 = [[FLProfileUserView alloc] initWithRadarItem:radarItem andDelegate:self];
                        x += (profileCount == 1 ? 0 : 106);
                        NSLog(@"XVAL %d", x);
                        [user1 setCenter:CGPointMake(x, _scrProfileList.center.y)];
                        [_scrProfileList addSubview:user1];
                        profileCount++;
                    }
                }
                
            }];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Radar refresh control
#pragma mark -

-(void)refreshRadar:(UIRefreshControl *)refreshControl {
    
    
    
    [UIView animateWithDuration:0.4f animations:^{
        
        _viewRadarLoadingMessage.alpha = 1;
        
    } completion:^(BOOL finished) {
        
//        [self setupRadarLoader];
        [_viewRadarLoadingMessage startWithText:NSLocalizedString(@"Your radar is looking for new people...", @"")];
        
    }];

    
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Your radar is updating..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        [NSThread sleepForTimeInterval:3];
        [self radarServiceCall];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
            
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
            
            [refreshControl endRefreshing];
//            refreshing = NO;
            
            [UIView animateWithDuration:0.6f animations:^{
                
//                _viewControlSection.alpha = 1;
                
            }];
            
            NSLog(@"refresh end");
        });
    });
}

-(void)bringToFront{
    [_viewRadarBase bringSubviewToFront:_btnGroupPoint];
    [_viewRadarBase bringSubviewToFront:_btnHomePoint];
    [_viewRadarBase bringSubviewToFront:_btnMeetPoint];
    [_viewRadarBase bringSubviewToFront:_btnTaxiPoint];
    [_viewRadarBase bringSubviewToFront:_sldGesture];
    [_viewRadarBase bringSubviewToFront:_viewControlPanel];
}

#pragma mark - Distance slider
#pragma mark -

- (IBAction)slided:(UISlider *)sender {
    
    /*
    NSLog(@"SLDD");
    
    if (_imgRedLayer.alpha >= 0.5) {
        [UIView animateWithDuration:0.4f animations:^{
            
            _imgRedLayer.alpha = 0;
            _imgSlidingRedLayer.alpha = 0.5;
        }];
    }
    
    CGRect frame = _imgSlidingRedLayer.frame;
    
    
    
    
    
//    float prop = frame.size.width
    
    frame.size.width = sender.value;// + 15;
    _imgSlidingRedLayer.frame = frame;
     
     */
     
//    .frame = CGRectMake(0, 0, sld.value, [UIScreen mainScreen].bounds.size.height);
    
    
    
    
//    int discreteValue = roundl([sender value]); // Rounds float to an integer
//    [sender setValue:(float)discreteValue];
//    
//    for (FLRadarObject *item in _radarItems) {
//        
//        NSValue *locationValue = [[item.points objectAtIndex:discreteValue] objectForKey:@"point"];
//        CGPoint location = locationValue.CGPointValue;
//        float distanceInApp = [[[item.points objectAtIndex:discreteValue] objectForKey:@"distanceApp"] floatValue];
//        
//        [UIView animateWithDuration:0.01f animations:^{
//            
//            item.button.center = location;
//            
//        }];
//        
//        
//        
//        NSLog(@"VAL %d || %f", discreteValue, distanceInApp);
//        if (distanceInApp > 65) {
//            [item.button removeFromSuperview];
//            item.button = nil;
//        }else{
//            if (!item.button) {
//                [_viewFrontRadarSet addSubview:[FLUtil getButtonForRadarItem:item withItemPoint:location]];
//            }
//            
//        }
//        
//    }
    
    
    //you can use any string instead "com.mycompany.myqueue"
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueuee", 0);
    
    dispatch_async(backgroundQueue, ^{
        //        int result = <some really long calculation that takes seconds to complete>;
        
        //        NSLog(@"VALUE %f", sender.value);
        int discreteValue = roundl([sender value]); // Rounds float to an integer
        [sender setValue:(float)discreteValue];
        
        NSLog(@"POINT %d", discreteValue);
        
//        [_lblDistance setText:[NSString stringWithFormat:@"%d", discreteValue]];
        
        NSLog(@"COUNT ===== ==== ==== === == = %d", [_radarItems count]);
        
        for (FLRadarObject *item in _radarItems) {
            
            NSValue *locationValue = [[item.points objectAtIndex:discreteValue] objectForKey:@"point"];
            CGPoint location = locationValue.CGPointValue;
            float distanceInApp = [[[item.points objectAtIndex:discreteValue] objectForKey:@"distanceApp"] floatValue];
//            NSLog(@"DIA %f", distanceInApp);
            
            if (distanceInApp > 65 || distanceInApp == 0.0) {
                [item.button removeFromSuperview];
                item.button = nil;
            }else{
            
                if (item.button) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [UIView animateWithDuration:0.01f animations:^{
                            
                            item.button.center = location;
                            
                        }];
                    });
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        FLButtonWithRadarItem *btn = [FLUtil getButtonForRadarItem:item withItemPoint:location];
                        [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
                        btn.transform = CGAffineTransformMakeRotation(_radarItemAngle);
                        [_viewFrontRadarSet addSubview:btn];
                        
                    });
                }
            }
            
//            if (distanceInApp > 65) {
//                
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [item.button removeFromSuperview];
//                    item.button = nil;
//                    
//                    
//                });
//                
//            }else{
////                if (!item.button) {
////                
////                    UIButton *btn = [FLUtil getButtonForRadarItem:item withItemPoint:location];
////                    
////                    dispatch_async(dispatch_get_main_queue(), ^{
////                        
//////                        [UIView animateWithDuration:0.01f animations:^{
////                        
////                            [_viewFrontRadarSet addSubview:btn];
////                            
//////                        }];
////                        
////                        
////                    });
////                }else{
//                    NSLog(@"NOT NULL");
//                
////                }
//            }
            
            
            
        }
        
        
    });
    
}

- (IBAction)dragEnter:(UISlider *)sender {
    NSLog(@"Drag enter");
    
//    CGRect frame = _imgSlidingRedLayer.frame;
//    frame.size.width = sender.value + 15;
//    _imgSlidingRedLayer.frame = frame;
    
    [UIView animateWithDuration:0.4f animations:^{
        
        
        
        _imgSlidingRedLayer.alpha = 0;
        _imgRedLayer.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
//    [UIView animateWithDuration:0.4f animations:^{
//        
//        _imgRedLayer.alpha = 0.5;
//        
//    }];
}


- (IBAction)exit:(id)sender {
    NSLog(@"Exit");
}

#pragma mark - TapGesture
#pragma mark -

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_ViewMeetingPreview]){
        return NO;
    }else if ([touch.view isDescendantOfView:_viewGroupPreview]){
        return NO;
    }else{
        return YES;
    }
}

-(void)handleTap:(UITapGestureRecognizer*)gesture{
    NSLog(@"TAPP %f", _viewProfileList.alpha);
    
    
    UIView* view = gesture.view;
    CGPoint loc = [gesture locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    NSLog(@"VIEW %d", [subview superview].tag);
    
    if ([subview superview].tag == 1110) {
        return;
    }
    
    _isGroupUpdating = NO;
    
    _scrRadar.scrollEnabled = YES;
    [_pan setEnabled:YES];
    
    if (_viewGroupPreview.alpha == 1) {
        [UIView animateWithDuration:0.4f animations:^{
            
            _viewGroupPreview.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            for (UIView *view in _scrViewGroupMembers.subviews) {
                [view removeFromSuperview];
            }
            
            [_imgGroupPic setImage:nil];
            
            [_viewGroupPreview removeFromSuperview];
        }];
    }
    
    if (_ViewMeetingPreview.alpha == 1){
        [UIView animateWithDuration:0.4f animations:^{
            
            _ViewMeetingPreview.alpha = 0;
            
        } completion:^(BOOL finished) {
            [_ViewMeetingPreview removeFromSuperview];
        }];
    }
    
    if (_viewProfileList.alpha == 1){
        [UIView animateWithDuration:0.4f animations:^{
            
            _viewProfileList.alpha = 0;
            
        } completion:^(BOOL finished) {
            [_viewProfileList removeFromSuperview];
        }];
    }
    
    
    [self discardGroupEdit];
    
    //Not yet needed
    for (FLRadarObject *item in _radarItems) {
        [item.button setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
//    [_selectedRadarObject.button setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark - Other
#pragma mark -

-(void)ripple:(FLFriendView*)sender{
    CATransition *animation=[CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:1.75];
    //    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setType:@"rippleEffect"];
    
    [animation setFillMode:kCAFillModeRemoved];
    animation.endProgress=0.99;
    [animation setRemovedOnCompletion:NO];
    [sender.layer addAnimation:animation forKey:nil];
}

-(void)getAddressForLocation:(CLLocation*)location{
    
    CLGeocoder *gc = [[CLGeocoder alloc] init];
    
    [gc reverseGeocodeLocation:location completionHandler:^(NSArray *placemark, NSError *error) {
        CLPlacemark *pm = [placemark objectAtIndex:0];
        NSDictionary *address = pm.addressDictionary;
        NSString*frm = [address valueForKey:@"Street"];
        
        NSLog(@"add %@", address);
        NSLog(@"AAA %@", frm);
        
        if (frm) {
            self.navigationItem.title = frm;
        }
    }];
}

-(void)userLocationSetResult:(NSString *)message{
    NSLog(@"SET LOCATION %@",message);
    [self radarServiceCall];
}

-(void)setupRadarLoader{
    _viewRadarLoadingMessage.textLabel.textAlignment = NSTextAlignmentCenter;
    _viewRadarLoadingMessage.textLabel.textColor = [UIColor whiteColor];
    _viewRadarLoadingMessage.completed = NO;
    _viewRadarLoadingMessage.textLabel.font = [UIFont fontWithName:@"Arial" size:IS_IPAD ? 14 : 11];
    _viewRadarLoadingMessage.backgroundColor = [UIColor clearColor];
    [_viewRadarLoadingMessage.textLabel setText:NSLocalizedString(@"Locating you, Please wait...", @"")];
//    [_viewRadarLoadingMessage layoutSubviews];
}

#pragma mark -
#pragma mark date picker

- (void)createActionSheet {
    
    if ((IS_IPHONE || IS_IPHONE_5) && actionSheet == nil) {
        // setup actionsheet to contain the UIPicker
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone:)];
        [barItems addObject:doneBtn];
        
        [pickerToolbar setItems:barItems animated:YES];
        [actionSheet addSubview:pickerToolbar];
        [actionSheet showInView:self.view];
        [actionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
    /*else if(IS_IPAD && popOver==nil)
    {
        UIViewController* popoverContent = [[UIViewController alloc] init];
        
        UIToolbar *toolbr = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(pickerDone:)];
        popoverView = [[UIView alloc] init];   //view
        popoverView.backgroundColor = [UIColor blackColor];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:editButton];
        toolbr.items = items;
        [popoverView addSubview:toolbr];
        ///
        
        ////
        //[popoverView addSubview:theDatePicker];
        
        popoverContent.view = popoverView;
        popOver = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        //    popOver.delegate=self;
        
        [popOver setPopoverContentSize:CGSizeMake(320, 260) animated:NO];
        
    }
     */
}

-(void)createUIDatePicker
{
    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    if (_selectedMeetingDate) {
        [theDatePicker setDate:_selectedMeetingDate];
    }else{
        [theDatePicker setDate:[NSDate date]];
    }
    
    if (IS_IPHONE || IS_IPHONE_5)
	{
        [actionSheet addSubview:theDatePicker];
    }
    /*else if(IS_IPAD)
    {
        [popoverView addSubview:theDatePicker];
        
        CGRect frm = btnBirthday.frame;
        //        frm.origin.y = frm.origin.y ;
        
        [popOver presentPopoverFromRect:frm inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        [theDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    }
     */
    
}


-(void)dateChanged:(id)sender
{
    /*if(IS_IPAD)
    {
        selectedDatePickerDate=[theDatePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // changed line in your code
        NSString *dateText = [dateFormatter stringFromDate:selectedDatePickerDate];
        [btnBirthday setTitle:dateText forState: UIControlStateNormal];
    }*/
}

- (void)pickerDone:(id)sender
{
    _selectedMeetingDate = [theDatePicker date];
//    NSLog(@"pickerSelectedIndex111 %i",pickerSelectedIndex);
//    [self updateDetails:selectedIndexPath withObject:selectedDetailObj withNewAnswer:[selectedDetailObj.answers objectAtIndex:pickerSelectedIndex]];
    
    if (IS_IPHONE || IS_IPHONE_5)
	{
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        
        actionSheet = nil;
        
    }
    /*else if(IS_IPAD)
    {
        [popOver dismissPopoverAnimated:YES];
        popOver=nil;
    }
    [tblMyDetails reloadData];*/
}

#pragma mark - User
#pragma mark -

- (IBAction)profileButtonClicked:(id)sender {
    
    if (_isGroupCreating) {
        RIButtonItem *cancelItem = [RIButtonItem item];
        cancelItem.label = NSLocalizedString(@"cancel", @"");
        cancelItem.action = ^
        {
            //do nothing
        };
        
        RIButtonItem *buyStars = [RIButtonItem item];
        buyStars.label = NSLocalizedString(@"discard", @"");
        buyStars.action = ^
        {
            [self discardGroup];
        };
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"cancel_group", @"") cancelButtonItem:cancelItem otherButtonItems:buyStars, nil] show];
    }else if (_isMeetingCreating){
        RIButtonItem *cancelItem = [RIButtonItem item];
        cancelItem.label = NSLocalizedString(@"cancel", @"");
        cancelItem.action = ^
        {
            //do nothing
        };
        
        RIButtonItem *buyStars = [RIButtonItem item];
        buyStars.label = NSLocalizedString(@"discard", @"");
        buyStars.action = ^
        {
            [self discardMeeting];
        };
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"cancel_meeting", @"") cancelButtonItem:cancelItem otherButtonItems:buyStars, nil] show];
    }
    
}

-(void)setUserImage:(FLRadarType)type{
    
    __block FLProfilePicView *pictureView = nil;
    
    switch (type) {
        case TYPE_GROUP:
            pictureView = _imgGroupOwnerProfilePic;
            break;
            
        case TYPE_MEET_POINT:
            pictureView = _imgMeetingOwnerProfilePic;
            break;
            
        default:
            break;
    }
    
    [pictureView setImage:M_PLACE_HOLDER_IMAGE];
    
    FLWebServiceApi *webServiceApi = [[FLWebServiceApi alloc] init];
    NSArray *foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
    NSString *imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
    NSURL *profilePicUrl = [webServiceApi getImageFromName:imgNameWithPath];
    
    
    //get previous indicator out
    UIView *act = [pictureView viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(pictureView.bounds.size.width/2.0, pictureView.bounds.size.height/2.0);
    activityIndicatorView.tag = ACT_INDICATOR_TAG;
    
    [pictureView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    [pictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl]
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           pictureView.image = image;
                                           [activityIndicatorView removeFromSuperview];
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                           [activityIndicatorView removeFromSuperview];
                                       }];
}

-(void)setUserCenterImage{
    
//    if (_imgProfilePicRadar.currentBackgroundImage) {
//        return;
//    }
    
    [_imgUserProfileRadar setImage:M_PLACE_HOLDER_IMAGE];
    _imgUserProfileRadar.layer.cornerRadius = 50;
    _imgUserProfileRadar.layer.masksToBounds = YES;
    
//    [_btnUserProfilePic setBackgroundImage:M_PLACE_HOLDER_IMAGE forState:UIControlStateNormal];
//    self.btnUserProfilePic.layer.cornerRadius = 50;
//    self.btnUserProfilePic.layer.masksToBounds = YES;
    
    //get previous indicator out
    UIView *act = [_btnUserProfilePic viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(_btnUserProfilePic.bounds.size.width/2.0, _btnUserProfilePic.bounds.size.height/2.0);
    activityIndicatorView.tag = ACT_INDICATOR_TAG;
    
    [_btnUserProfilePic addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
        
    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    NSString *imgNameWithPath = [[FLGlobalSettings sharedInstance].current_user_profile.image stringByReplacingOccurrencesOfString:UNWANTED_IMG_URL_PART withString:@""];
    NSURL *profilePicUrl = [webServiceApi getImageFromName:imgNameWithPath];
    
    __weak UIImageView *weakImgView = _imgUserProfileRadar;
    
    [_imgUserProfileRadar setImageWithURLRequest:[FLUtil imageRequestWithURL:profilePicUrl] placeholderImage:M_PLACE_HOLDER_IMAGE success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakImgView setImage:image];
        [activityIndicatorView removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
        NSLog(@"FAIL IMAGE %@", [error localizedDescription]);
        
    }];
    
    /*
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    
    dispatch_async(backgroundQueue, ^{
        
        FLWebServiceApi *webServiceApi = [[FLWebServiceApi alloc] init];
        NSArray *foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
        NSString *imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
        NSURL *profilePicUrl = [webServiceApi getImageFromName:imgNameWithPath];
        
        NSData *imageData = [NSData dataWithContentsOfURL:profilePicUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicatorView removeFromSuperview];
            [_btnUserProfilePic setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
            
        });
    });
    */
    
    
}

-(void)setOwnerImage:(FLRadarType)type withProfile:(FLOtherProfile *)profile{
    
    __block FLProfilePicView *pictureView = nil;
    
    switch (type) {
        case TYPE_GROUP:
            if (_isGroupUpdating) {
                pictureView = _imgGroupOwnerProfilePic;
            }else{
                pictureView = _imgOwnerPic;
            }
            
            break;
            
        case TYPE_MEET_POINT:
            if (_isMeetingUpdating) {
                pictureView = _imgMeetingOwnerProfilePic;
            }else{
                pictureView = _imgMeetingOwnerPic;
            }
            
            break;
            
        default:
            break;
    }
    
//    NSURL *profilePicUrl;
//    
//    if ([item isKindOfClass:[FLGroup class]]) {
//        [pictureView setImage:M_PLACE_HOLDER_IMAGE];
//        
//        FLWebServiceApi *webServiceApi = [[FLWebServiceApi alloc] init];
//        NSArray *foo = [[FLGlobalSettings sharedInstance].current_user_profile.image componentsSeparatedByString: @"/"];
//        NSString *imgNameWithPath = [NSString stringWithFormat:@"%@/%@",[foo objectAtIndex:3],[foo objectAtIndex:4]];
//        profilePicUrl = [webServiceApi getImageFromName:imgNameWithPath];
//    }
    
    
    
//    _selectedRadarObject.
    
    
    //get previous indicator out
    UIView *act = [pictureView viewWithTag:ACT_INDICATOR_TAG];
    
    //if has, then remove it
    if(act){
        [act removeFromSuperview];
    }
    
    __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(pictureView.bounds.size.width/2.0, pictureView.bounds.size.height/2.0);
    activityIndicatorView.tag = ACT_INDICATOR_TAG;
    
    [pictureView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    [pictureView setImageWithURLRequest:[FLUtil imageRequestWithURL:[NSURL URLWithString:profile.image]]
                       placeholderImage:nil
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    pictureView.image = image;
                                    [activityIndicatorView removeFromSuperview];
                                }
                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                    [activityIndicatorView removeFromSuperview];
                                }];
    
}

#pragma mark - Friends
#pragma mark -

-(void)setupFriendsListAndShow:(BOOL)flag withButton:(UIButton*)button{
    
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    
    [webSeviceApi friendshipFriendList:self];
    
    if (!flag) {
        
        [UIView animateWithDuration:0.4f animations:^{
            
            _viewGroupAddFriends.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            
            button.tag = 0;
            
            _scrRadar.scrollEnabled = YES;
            if (_panGroup) {
                [self.view removeGestureRecognizer:_panGroup];
            }
            
            [_viewGroupAddFriends removeFromSuperview];
            
            for (UIView *view in _scrFriends.subviews) {
                [view removeFromSuperview];
            }
            
        }];
        
    }else{
        
        //add gesture recognizer
        _panGroup = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGroupFrienPan:)];
        [self.view addGestureRecognizer:_panGroup];
        
        button.tag = 1;
        _scrRadar.scrollEnabled = NO;
    }
    
    //Rest will perform in friend list delegate method
}

-(void)profileFriendshipFriendListResult:(NSMutableArray *)profileObjArr{
    [_scrFriends setContentSize:CGSizeMake((80 * [profileObjArr count]) +1, 80)];
    
    if (IS_IPAD) {
//        748, 135
    }
    
    _friendItemsArray = profileObjArr;
    _friendsArray = [[NSMutableArray alloc] init];
    
    //loop friends
    int count = 0;
    for (FLOtherProfile *prof in _friendItemsArray) {
        
        NSLog(@"UP IMAGE %@", prof.image);
        
        int x = count == 0 ? 16 : 16 + (16 + 60) * count;
        NSLog(@"X > %d", x);
        
        CGRect rect = CGRectMake(x , IS_IPAD ? 15 : 10, 60, 60);
        
        
        FLFriendView *frnd = [[FLFriendView alloc] initWithFrame:rect andProfile:prof];
        frnd.tag = count;
        frnd.scrollParent = _scrFriends;
        frnd.mainView = _viewRadarFront;
        //        frnd.delegate = self;
        frnd.imgv.contentMode = UIViewContentModeScaleAspectFill;
        
        [frnd setBackgroundColor:[UIColor clearColor]];
        
        if (_isGroupUpdating) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %d", [prof.uid intValue]];
            NSArray *arr = [_selectedGroup.group_memberships_attributes filteredArrayUsingPredicate:predicate];
            if ([arr count] > 0) {
                
//                if (!_selectedGroupFriends) {
//                    _selectedGroupFriends = [[NSMutableArray alloc] init];
//                }
//                
//                if (!_selectedGroupDelButton) {
//                    _selectedGroupDelButton = [[NSMutableArray alloc] init];
//                }
//                
//                frnd.groupSelectedIndex = [_selectedGroupFriends count];
//                [_selectedGroupFriends addObject:frnd];
                
                continue;
            }else{
                [_friendsArray addObject:frnd];
                [_scrFriends addSubview:frnd];
            }
        }else{
            [_friendsArray addObject:frnd];
            [_scrFriends addSubview:frnd];
        }
        
        
        
        count++;
        
    }
    
    if (IS_IPHONE_5) {
        [_viewGroupAddFriends setFrame:CGRectMake(0, 45, 320, 120)];
    }else if (IS_IPAD){
        [_viewGroupAddFriends setFrame:CGRectMake(0, 78, 756, 135)];
    }
    
    [self.view addSubview:_viewGroupAddFriends];
    
    
    if (_isGroupUpdating || _isMeetingUpdating) {
        _imgDragToNote.alpha = 0;
    }else{
        _imgDragToNote.alpha = 1;
    }
    
    [UIView animateWithDuration:0.4f animations:^{
        
        _viewGroupAddFriends.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        if (_isGroupUpdating || _isMeetingUpdating) {
            [self populateGroupComposer];
        }
        
    }];
}

-(BOOL) isInsideCenterPoint:(FLFriendView *)button touching:(BOOL)finished;
{
    //    CGPoint newLoc = [self.view convertPoint:self.btnProfilePic.frame.origin toView:self.view];
    CGRect binFrame = self.btnUserProfilePic.frame;
    //    binFrame.origin = newLoc;
    
    if (CGRectIntersectsRect(binFrame, button.frame) == TRUE){
        if (finished){
            
            //remove orange strip and reduce the height of scroller;
            if (_imgDragToNote.superview && _imgDragToNote.alpha == 1) {
                NSLog(@"USER HERE");
                
                [_scrRadar setContentOffset:CGPointMake(0, _imgDragToNote.frame.size.height - 17) animated:YES];
                
                [UIView animateWithDuration:0.4f animations:^{
                    
                    _imgDragToNote.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    //                    [_imgDragToNote removeFromSuperview];
                }];
                
                
                if (_isGroupCreating || _isGroupUpdating) {
                    
                    if (!_selectedGroupFriends) {
                        _selectedGroupFriends = [[NSMutableArray alloc] init];
                    }
                    
                    if (!_selectedGroupDelButton) {
                        _selectedGroupDelButton = [[NSMutableArray alloc] init];
                    }
                    
                    button.groupSelectedIndex = 0;
                    [_selectedGroupFriends addObject:button];
                    
                    //set user profile pic
                    [self setUserImage:TYPE_GROUP];
                    
                    //Add create button
                    UIImage* filterBtnImg = [UIImage imageNamed:@"createBtn.png"];
                    CGRect frameFilter = CGRectMake(0, 0, filterBtnImg.size.width, filterBtnImg.size.height);
                    UIButton* filterBtn = [[UIButton alloc]initWithFrame:frameFilter];
                    [filterBtn setBackgroundImage:filterBtnImg forState:UIControlStateNormal];
                    [filterBtn setTag:1003];//1003 is for nreate new and 1004 for update existing group
                    [filterBtn addTarget:self action:@selector(createGroup:) forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem* filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
                    self.navigationItem.rightBarButtonItem=filterBarButton;
                    
                    //Show group composer
                    _viewGroupComposer.alpha = 0;
                    
                    _viewGroupComposer.frame = CGRectMake(0, IS_IPHONE_5 ? 235 : 177, _viewGroupComposer.frame.size.width, _viewGroupComposer.frame.size.height);
                    
                    [self.view addSubview:_viewGroupComposer];
                    [UIView animateWithDuration:0.4f animations:^{
                        
                        _viewGroupComposer.alpha = 1;
                        
                    } completion:^(BOOL finished) {
                        button.alpha = 1;
                        
                        [_scrGroupMembers setContentSize:CGSizeMake(224, 48)];
                        [button setCenter:CGPointMake(0, 0)];
                        [button setFrame:CGRectMake(0, 2, 46, 46)];
                        FLButtonWithProfile *btnDel = [[FLButtonWithProfile alloc] initWithFrame:CGRectMake(35, -2, 20, 20)];
                        [btnDel setFriendView:button];
                        [btnDel setTag:button.tag];
                        [btnDel addTarget:self action:@selector(deleteGroupMember:) forControlEvents:UIControlEventTouchUpInside];
                        [btnDel setImage:[UIImage imageNamed:@"removeIcon"] forState:UIControlStateNormal];
                        [btnDel setAlpha:0];
                        [_scrGroupMembers addSubview:button];
                        [_scrGroupMembers addSubview:btnDel];
                        [_selectedGroupDelButton addObject:btnDel];
                        
                        [UIView animateWithDuration:1.0f animations:^{
                            
                            [btnDel setAlpha:1];
                            
                        }];
                        
                        [self ripple:button];
                        
                    }];
                }else if (_isMeetingCreating || _isMeetingUpdating){
                    
                    if (!_selectedMeetingFriends) {
                        _selectedMeetingFriends = [[NSMutableArray alloc] init];
                    }
                    
                    if (!_selectedMeetingDelButton) {
                        _selectedMeetingDelButton = [[NSMutableArray alloc] init];
                    }
                    
                    button.groupSelectedIndex = 0;
                    [_selectedMeetingFriends addObject:button];
                    
                    //set user profile pic
                    [self setUserImage:TYPE_MEET_POINT];
                    
                    //Add create button
                    UIImage* filterBtnImg = [UIImage imageNamed:@"createBtn.png"];
                    CGRect frameFilter = CGRectMake(0, 0, filterBtnImg.size.width, filterBtnImg.size.height);
                    UIButton* filterBtn = [[UIButton alloc]initWithFrame:frameFilter];
                    [filterBtn setBackgroundImage:filterBtnImg forState:UIControlStateNormal];
                    [filterBtn addTarget:self action:@selector(createMeeting:) forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem* filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
                    self.navigationItem.rightBarButtonItem = filterBarButton;
                    
                    //Show meeting composer
                    _viewMeetingComposer.alpha = 0;
                    
                    _viewMeetingComposer.frame = CGRectMake(0, IS_IPHONE_5 ? 235 : 177, _viewMeetingComposer.frame.size.width, _viewMeetingComposer.frame.size.height);
                    
                    [self.view addSubview:_viewMeetingComposer];
                    [UIView animateWithDuration:0.4f animations:^{
                        
                        _viewMeetingComposer.alpha = 1;
                        
                    } completion:^(BOOL finished) {
                        
                        button.alpha = 1;
                        
                        [_scrMeetingMembers setContentSize:CGSizeMake(241, 65)];
                        
                        [button setCenter:CGPointMake(0, 0)];
                        [button setFrame:CGRectMake(0, 7, 50, 50)];
                        
                        [_scrMeetingMembers addSubview:button];
                        
                        FLButtonWithProfile *btnDel = [[FLButtonWithProfile alloc] initWithFrame:CGRectMake(30, 0, 29, 30)];
                        [btnDel setFriendView:button];
                        [btnDel setTag:button.tag];
                        [btnDel addTarget:self action:@selector(deleteMeetingMember:) forControlEvents:UIControlEventTouchUpInside];
                        [btnDel setImage:[UIImage imageNamed:@"removeIcon"] forState:UIControlStateNormal];
                        [btnDel setAlpha:0];
                        [_scrMeetingMembers addSubview:btnDel];
                        [_selectedMeetingDelButton addObject:btnDel];
                        
                        [UIView animateWithDuration:1.0f animations:^{
                            
                            [btnDel setAlpha:1];
                            
                        }];
                        
                        [self ripple:button];
                        
                    }];
                }
                
                
                
            }else{
                
                if (_isGroupCreating || _isGroupUpdating) {
                    
                    [_selectedGroupFriends addObject:button];
                    
                    NSLog(@"FRN COUNT %d", [_friendItemsArray count]);
                    NSLog(@"SEL COUNT %d", [_selectedGroupFriends count]);
                    if ([_friendItemsArray count] == [_selectedGroupFriends count]) {
                        NSLog(@"EQUAL");
                        [self removeFriendListView];
                    }else{
                        NSLog(@"NO EQUAL");
                    }
                    
                    //                [button setCenter:CGPointMake(0, 0)];
                    NSLog(@"ITEMS %d", [_selectedGroupFriends count]);
                    
                    button.groupSelectedIndex = [_selectedGroupFriends count];
                    int x = (10 + 50) * ([_selectedGroupFriends count] - 1);
                    NSLog(@"XXX %d", x);
                    [button setFrame:CGRectMake(x, 2, 46, 46)];
                    [_scrGroupMembers addSubview:button];
                    [UIView animateWithDuration:0.4f animations:^{
                    } completion:^(BOOL finished) {
                        //just wanted 0.4 ms delay ;)
                        button.alpha = 1;
                        [self ripple:button];
                        
                    }];
                    
                    if ([_selectedGroupFriends count] > 3) {
                        
                        [_scrGroupMembers setContentSize:CGSizeMake(60 * [_selectedGroupFriends count], 48)];
                        NSLog(@"More than 3 %f", _scrGroupMembers.contentSize.width);
                        [_scrGroupMembers setContentOffset:CGPointMake(50 * ([_selectedGroupFriends count] - 3), 0) animated:YES];
                    }
                    
                    FLButtonWithProfile *btnDel = [[FLButtonWithProfile alloc] initWithFrame:CGRectMake(x + 35, -2, 20, 20)];
                    [btnDel setFriendView:button];
                    [btnDel setTag:button.tag];
                    [btnDel addTarget:self action:@selector(deleteGroupMember:) forControlEvents:UIControlEventTouchUpInside];
                    [btnDel setAlpha:0];
                    [btnDel setImage:[UIImage imageNamed:@"removeIcon"] forState:UIControlStateNormal];
                    [_scrGroupMembers addSubview:btnDel];
                    [_selectedGroupDelButton addObject:btnDel];
                    
                    [UIView animateWithDuration:1.0f animations:^{
                        
                        [btnDel setAlpha:1];
                        
                    }];
                }else if (_isMeetingCreating || _isMeetingUpdating){
                    [_selectedMeetingFriends addObject:button];
                    
                    if ([_friendItemsArray count] == [_selectedMeetingFriends count]) {
                        NSLog(@"EQUAL");
                        [self removeFriendListView];
                    }else{
                        NSLog(@"NO EQUAL");
                    }
                    
                    button.groupSelectedIndex = [_selectedMeetingFriends count];
                    int x = (10 + 50) * ([_selectedMeetingFriends count] - 1);
                    NSLog(@"XXXX %d", x);
                    [button setFrame:CGRectMake(x, 7, 50, 50)];
                    [_scrMeetingMembers addSubview:button];
                    [UIView animateWithDuration:0.4f animations:^{
                    } completion:^(BOOL finished) {
                        //just wanted 0.4 ms delay ;)
                        button.alpha = 1;
                        [self ripple:button];
                        
                    }];
                    
                    if ([_selectedMeetingFriends count] > 4) {
                        
                        [_scrMeetingMembers setContentSize:CGSizeMake(60 * [_selectedMeetingFriends count], 65)];
                        NSLog(@"More than 3 %f", _scrMeetingMembers.contentSize.width);
                        [_scrMeetingMembers setContentOffset:CGPointMake(50 * ([_selectedMeetingFriends count] - 4), 0) animated:YES];
                    }
                    
                    FLButtonWithProfile *btnDel = [[FLButtonWithProfile alloc] initWithFrame:CGRectMake(x + 30, 0, 29, 30)];
                    [btnDel setFriendView:button];
                    [btnDel setTag:button.tag];
                    [btnDel addTarget:self action:@selector(deleteMeetingMember:) forControlEvents:UIControlEventTouchUpInside];
                    [btnDel setAlpha:0];
                    [btnDel setImage:[UIImage imageNamed:@"removeIcon"] forState:UIControlStateNormal];
                    [_scrMeetingMembers addSubview:btnDel];
                    [_selectedMeetingDelButton addObject:btnDel];
                    
                    [UIView animateWithDuration:1.0f animations:^{
                        
                        [btnDel setAlpha:1];
                        
                    }];
                    
                }
                
            }
            
        }
        NSLog(@"INNNN");
        return YES;
    }
    else {
        return NO;
    }
    //    return NO;
}

#pragma mark - Radar screen text input
#pragma mark -

- (IBAction)addText:(UIButton *)sender {
    
    AHDescriptionViewController *desc = [[AHDescriptionViewController alloc] initWithNibName:@"AHDescriptionViewController" bundle:nil];
    
    if (_isGroupCreating || _isGroupUpdating) {
        if (sender.tag == 0) {
            [desc setTxtField:_txtGroupName];
        }else{
            [desc setTxtField:_txtGroupDesc];
        }
    }else if (_isMeetingCreating){
        if (sender.tag == 0) {
            [desc setTxtField:_txtMeetingName];
        }else{
            [desc setTxtField:_txtMeetingDesc];
        }
    }
    
    [self presentViewController:desc animated:YES completion:^{
        
        [_scrRadar setContentOffset:CGPointMake(0, _imgDragToNote.frame.size.height - 17) animated:YES];
        
    }];
}

#pragma mark - Groups
#pragma mark -

- (IBAction)newGroup:(UIButton *)sender {
    
    if (sender.tag == 1) {
        _isGroupCreating = NO;
        [self setupFriendsListAndShow:NO withButton:sender];
        return;
    }else{
        _isGroupCreating = YES;
        [self setupFriendsListAndShow:YES withButton:sender];
    }
    
}

- (void)handleGroupFrienPan:(UIPanGestureRecognizer*)gesture{
    NSLog(@"TAPP");
    
    CGPoint point = [gesture locationInView:self.scrFriends];
    CGPoint point2 = [gesture locationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan){
        
        for (UIView *control in self.scrFriends.subviews)
            if (CGRectContainsPoint(control.frame, point))
                objectToDrag = control;
        
        if (!objectToDrag)
        {
            _inDragView = NO;
            return;
        }else{
            _inDragView = YES;
            _originalOutsidePosition = [_scrFriends convertPoint:objectToDrag.center toView:self.view];;
        }
        
        _originalPosition = objectToDrag.center;
        
        NSLog(@"OBJECT %@", objectToDrag);
        
        [objectToDrag removeFromSuperview];
        objectToDrag.center = point2;
        [self.view addSubview:objectToDrag];
        
    }else if (gesture.state == UIGestureRecognizerStateChanged && _inDragView){
        NSLog(@"OBJECT DRAGING%@", objectToDrag);
        
        [UIView animateWithDuration:0.001f animations:^{
            
            objectToDrag.center = point2;
            
        }];
    }else if (gesture.state == UIGestureRecognizerStateEnded && _inDragView){
        NSLog(@"finish");
        
        
        if (![self isInsideCenterPoint:(FLFriendView*)objectToDrag touching:YES]) {
            NSLog(@"OUT POINT");
            [UIView animateWithDuration:0.35f animations:^{
                
                objectToDrag.center = _originalOutsidePosition;
                
            } completion:^(BOOL finished) {
                NSLog(@"FIN");
                [objectToDrag removeFromSuperview];
                objectToDrag.center =_originalPosition;
                NSLog(@"FIN OBJ %@", objectToDrag);
                [_scrFriends addSubview:objectToDrag];
                objectToDrag = nil;
                
            }];
        }else{
            NSLog(@"IN POINT");
            
            [UIView animateWithDuration:0.4f animations:^{
                objectToDrag.alpha = 0;
            } completion:^(BOOL finished) {
                [self repositionFrom:(FLFriendView*)objectToDrag];
                //Note
//                [objectToDrag removeFromSuperview];
                objectToDrag = nil;
            }];
        }
    }
    
}

-(void)repositionFrom:(FLFriendView*)my{
    
    [_friendsArray removeObject:my];
    
    NSLog(@"REMOVED %d", my.tag);
    for (FLFriendView *my2 in _friendsArray) {
        if (my2.tag > my.tag) {
            NSLog(@"REM %d", my2.tag);
            
            CGRect rect = my2.frame;
            
            rect.origin.x = rect.origin.x - 76;
            
            [UIView animateWithDuration:0.4f animations:^{
                my2.frame = rect;
                
            } completion:^(BOOL finished) {
            }];
            
        }
    }
}



-(void)removeFriendListView{
    [UIView animateWithDuration:0.4f animations:^{
        
        _viewGroupAddFriends.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [_viewGroupAddFriends removeFromSuperview];
        
        for (UIView *view in _scrFriends.subviews) {
            [view removeFromSuperview];
        }
        
    }];
}

-(void)closeGroupComposer{
    
    [_selectedGroupDelButton removeAllObjects];
    [_selectedGroupFriends removeAllObjects];
    
    //Enable radar
    [_scrRadar setContentOffset:CGPointMake(0, 0) animated:YES];
    _scrRadar.scrollEnabled = YES;
    if (_panGroup) {
        [self.view removeGestureRecognizer:_panGroup];
    }
    
    [_viewGroupAddFriends removeFromSuperview];
    
    for (UIView *view in _scrFriends.subviews) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in _scrGroupMembers.subviews) {
        [view removeFromSuperview];
    }
    
    [UIView animateWithDuration:0.4f animations:^{
        
        _viewGroupComposer.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [_viewGroupComposer removeFromSuperview];
        
    }];
    
    //remove navigation bar 'create' button
    self.navigationItem.rightBarButtonItem = nil;;
}

-(void)deleteGroupMember:(FLButtonWithProfile*)sender{
    NSLog(@"DELETE IT %d", sender.tag);
//    [_selectedGroupFriends removeObject:sender.tag];
    FLFriendView *frnd = sender.friendView;
    [self repositionGroupMembersFrom:frnd andButton:sender];
    [frnd removeFromSuperview];
    [sender removeFromSuperview];
}

-(void)repositionGroupMembersFrom:(FLFriendView*)frnd andButton:(FLButtonWithProfile*)buttonDeleted{
    
    
    [_selectedGroupFriends removeObject:frnd];
    [_selectedGroupDelButton removeObject:buttonDeleted];
    
    
    NSLog(@"REMOVED %d", frnd.tag);
    for (FLFriendView *my2 in _selectedGroupFriends) {
        
        //Group selected index used because the UIView's tag is already occupied by friend list
        if (my2.groupSelectedIndex > frnd.groupSelectedIndex) {
            NSLog(@"REM %d", my2.tag);
            
            int index = [_selectedGroupFriends indexOfObject:my2];
            FLButtonWithProfile *btn = [_selectedGroupDelButton objectAtIndex:index];
            NSLog(@"DEL BUTTTON %@", btn);
            
            CGRect rect = my2.frame;
            CGRect rect2 = btn.frame;
            
            rect.origin.x = rect.origin.x - 60;
            rect2.origin.x = rect2.origin.x - 60;
            
            [UIView animateWithDuration:0.4f animations:^{
               
                btn.frame = rect2;
                
            }];
            
            [UIView animateWithDuration:0.4f animations:^{
                my2.frame = rect;
                
                
            } completion:^(BOOL finished) {
            }];
            
        }
        
    }
    
    if ([_selectedGroupFriends count] <= 3) {
        NSLog(@"ITS 3 or less than 3");
        if (_scrGroupMembers.contentSize.width > 224) {
            [_scrGroupMembers setContentSize:CGSizeMake(224, 87)];
        }
    }
    
}

-(void)createGroup:(UIButton*)sender{
    
    if ([_txtGroupName.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"oops", @"") message:NSLocalizedString(@"grp_name_missing", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
        //NSLocalizedString(@"grp_desc_missing", @"") 
    }
    
    if ([_txtGroupDesc.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"oops", @"") message:NSLocalizedString(@"grp_desc_missing", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
    
    if (sender.tag == 1004) {//if yes, then update it
        HUD.labelText = @"Updating group";
    }else{
        NSLog(@"Group Creating");
        HUD.labelText = @"Creating group";
    }
    
    [HUD show:YES];
    
    //upload the image first
    //upload group pic
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    FLImgObj *imgObj=[[FLImgObj alloc] init];
    imgObj.folder_name = IMAGE_DIRECTORY_GROUP;
    UIImage *originalImage= _imgGroupPicture.image;
    imgObj.imgData=UIImageJPEGRepresentation(originalImage,0.0);
    imgObj.imageName = [NSString stringWithFormat:@"%@.%@",[FLUtil imageNameForUpload:[FLGlobalSettings sharedInstance].current_user_profile.uid],@"jpg"];
    imgObj.imgContentType=@"image/jpeg";
    [webSeviceApi uploadImage:self withImgObj:imgObj];
    
    
}

-(void)groupImageUploaded:(FLImgObj *)groupImgObj{
    NSLog(@"image uploaded %@", groupImgObj.imageName);
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    //Create/Update the group now
    
    if (_selectedGroup) {
        
        _selectedGroup.name = _txtGroupName.text;
        _selectedGroup.desc = _txtGroupDesc.text;
        _selectedGroup.image = groupImgObj.imageName;
        
        NSMutableArray *friendsList = [[NSMutableArray alloc] init];
        
        NSLog(@"_selectedGroupFriends %@", _selectedGroupFriends);
        
        for (FLFriendView *friendView in _selectedGroupFriends) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %d", [friendView.profile.uid intValue]];
            
            NSArray *resArr = [_selectedGroup.group_memberships_attributes filteredArrayUsingPredicate:predicate];
            
            if ([resArr count] > 0) {
                //ignore
            }else{
                [friendsList addObject:friendView.profile.uid];
            }
            
        }
        
        _selectedGroup.group_memberships_attributes = [[NSArray alloc] initWithArray:friendsList];
        
        [webSeviceApi groupUpdate:self withGroupObj:_selectedGroup withGroupID:_selectedGroup.gid];
        
    }else{
        //Groups: Create
        FLGroup *newGroup = [[FLGroup alloc] init];
        newGroup.name = _txtGroupName.text;
        newGroup.desc = _txtGroupDesc.text;
        newGroup.image = groupImgObj.imageName;
        
        NSMutableArray *friendsList = [[NSMutableArray alloc] init];
        
        for (FLFriendView *friendView in _selectedGroupFriends) {
            [friendsList addObject:friendView.profile.uid];
        }
        
        newGroup.group_memberships_attributes = [[NSArray alloc] initWithArray:friendsList];
        [webSeviceApi groupCreate:self withGroupObj:newGroup];
    }
    
    
    
    //    [webSeviceApi groupUpdate:self withGroupObj:groupImgObj withGroupID:@""];
    
    //    FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
    //    NSURL *imgUrl=[webServiceApi getImageFromName:[NSString stringWithFormat:@"%@/%@",groupImgObj.folder_name,meetPointObj.imageName]];
    //    NSLog(@"imgUrl %@",imgUrl);
}

-(void)groupCreateResult:(FLGroup *)msg
{
    
    _isGroupCreating = NO;
    
    NSLog(@"Response %@", msg);
    HUD.labelText = NSLocalizedString(@"grp_success", @"");
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    [HUD hide:YES afterDelay:1.0f];
    
    
    _txtGroupName.text = @"";
    _txtGroupDesc.text = @"";
    
    [self removeFriendListView];
    
    [self closeGroupComposer];
}

-(void)groupUpdateResult:(NSString *)msg{
    _isGroupUpdating = NO;
    
    NSLog(@"Update Response %@", msg);
    HUD.labelText = NSLocalizedString(@"grp_update_success", @"");
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    [HUD hide:YES afterDelay:1.0f];
    
    
    _txtGroupName.text = @"";
    _txtGroupDesc.text = @"";
    
    [self removeFriendListView];
    
    [self closeGroupComposer];
}

-(void)discardGroup{
    [self removeFriendListView];
    [self closeGroupComposer];
    [_imgGroupPicture setImage:nil];
    _isGroupCreating = NO;
}

-(void)requestFailCall:(NSString *)errorMsg{
    NSLog(@"Faild %@", errorMsg);
    [HUD hide:YES];
}

-(void)unknownFailureCall{
    NSLog(@"unknownFailureCall");
    [HUD hide:YES];
}

- (IBAction)chatWithGroup:(UIButton *)sender {
    NSLog(@"Group Id %d", [_selectedRadarObject.radarID intValue]);//<##>
    
//    FLGroupChatScreenViewController *chatScreen = [[FLGroupChatScreenViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLChatScreenViewController-568h":@"FLChatScreenViewController" bundle:nil];
//    
//    
//    
//    
//    //        chatScreen.chatObj=(FLChat *)[[FLGlobalSettings sharedInstance].chatArr objectAtIndex:indexPath.row];
//    
////    NSMutableArray *groupChatArr=[FLGlobalSettings sharedInstance].groupChatArr;
//    
//    BOOL tempCheck=NO;
//    for (int x=0; x<[[FLGlobalSettings sharedInstance].chatArr count]; x++)//check exsisting chat
//    {
//        FLChat *chatObj=[[FLGlobalSettings sharedInstance].chatArr objectAtIndex:x];
//        if ([[NSString stringWithFormat:@"%@",chatObj.chatObj_id] isEqualToString:[NSString stringWithFormat:@"%@",_selectedRadarObject.radarID]])
//        {
//            chatScreen.chatUserIndex=x;
//            tempCheck=YES;
//            break;
//        }
//    }
//    if (!tempCheck) {
//        
//        //add new empty chat object
//        FLChat *chatObj=[[FLChat alloc] init];
////        chatObj.username=self.profileObj.full_name;
//        chatObj.chatObj_id=_selectedRadarObject.radarID;
//        //hemalasankas**
//        chatObj.chatObj_image_url=_selectedRadarObject.image;
////        chatObj.is_online=[self.profileObj.is_online boolValue];
//        chatObj.chatMessageArr=[[NSMutableArray alloc] init];
//        [[FLGlobalSettings sharedInstance].chatArr addObject:chatObj];
//        chatScreen.chatUserIndex=[[FLGlobalSettings sharedInstance].chatArr count]-1;//send last index in array
//    }
//    
//    //            [self.navigationController pushViewController:chatScreen animated:YES];
//  
//    ////////////////////////////////////////
    
    FLGroupChatScreenViewController *chatScreen = [[FLGroupChatScreenViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLChatScreenViewController-568h":@"FLChatScreenViewController" bundle:nil];
    
    FLChat *chatObj=[[FLChat alloc] init];
    chatObj.chatObj_id=_selectedRadarObject.radarID;
    chatObj.chatObjName=_selectedRadarObject.name;
//    chatObj.is_online=[self.profileObj.is_online boolValue];
    chatObj.message_type=MSG_TYPE_GROUP;
    //hemalasankas**
    chatObj.chatObj_image_url=[FLGlobalSettings sharedInstance].current_user_profile.image;
    chatObj.chatMessageArr=[[NSMutableArray alloc] init];//updating existing obj
    
    chatScreen.currentChatObj=chatObj;
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:chatScreen];
    
    [self presentViewController:nav animated:YES completion:nil];

    
    
    /////////////////////////////////////////
    
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:chatScreen];
//    [self presentViewController:nav animated:YES completion:nil];
    
}

- (IBAction)addGroupPhoto:(UIButton *)sender {
    
    [UIActionSheet showInView:self.view
                    withTitle:nil
            cancelButtonTitle:@"Cancel"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"Snap It", @"Photo Library"]
                     tapBlock:^(UIActionSheet *actionSheetSelf, NSInteger buttonIndex){
                         
                         NSLog(@"Tapped '%@' at index %d", [actionSheetSelf buttonTitleAtIndex:buttonIndex], buttonIndex);
                         
                         if (buttonIndex != 2) {
                             UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
                             
                             if([UIImagePickerController isSourceTypeAvailable:type]){
                                 if(buttonIndex==0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                                     type = UIImagePickerControllerSourceTypeCamera;
                                 }
                                 
                                 UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                 picker.view.tag = 1001;
                                 picker.allowsEditing = NO;
                                 picker.delegate   = self;
                                 picker.sourceType = type;
                                 
                                 [self presentViewController:picker animated:YES completion:nil];
                             }
                         }
                         
                     }];
    
}

-(void)discardGroupEdit{
//    if (_viewGroupComposer.alpha == 1){
//        [UIView animateWithDuration:0.4f animations:^{
//            
//            _viewGroupComposer.alpha = 0;
//            
//        } completion:^(BOOL finished) {
//            [_viewGroupComposer removeFromSuperview];
//        }];
//    }

    [self discardGroup];
    
    if (self.navigationItem.rightBarButtonItem.tag == 1002) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

/**
 * Populate group composer wIth Selected Group, This function always called for 'GroupPreview'
 */

-(void)populateGroupComposer{
    
    //populate existing members
    
    if (!_selectedGroupFriends) {
        _selectedGroupFriends = [[NSMutableArray alloc] init];
    }
    
    if (!_selectedGroupDelButton) {
        _selectedGroupDelButton = [[NSMutableArray alloc] init];
    }
    
    int count = 0;
    for (FLOtherProfile *prof in _selectedGroup.group_memberships_attributes) {
        
        int x = count == 0 ? 16 : 16 + (16 + 40) * count;
        NSLog(@"X > %d", x);
        
        CGRect rect = CGRectMake(x , IS_IPAD ? 15 : 1, 46, 46);
        
        
        FLFriendView *frnd = [[FLFriendView alloc] initWithFrame:rect andProfile:prof];
        frnd.tag = count;
        frnd.scrollParent = _scrFriends;
        frnd.mainView = _viewRadarFront;
        //        frnd.delegate = self;
        frnd.imgv.contentMode = UIViewContentModeScaleAspectFill;
        
        [frnd setBackgroundColor:[UIColor clearColor]];
        //                    [_friendsArray addObject:frnd];
        [_scrViewGroupMembers addSubview:frnd];
        
        
        frnd.groupSelectedIndex = [_selectedGroupFriends count];
        [frnd setCenter:CGPointMake(0, 0)];
        [frnd setFrame:CGRectMake(x, 2, 46, 46)];
        FLButtonWithProfile *btnDel = [[FLButtonWithProfile alloc] initWithFrame:CGRectMake(x + 35, -2, 20, 20)];
        [btnDel setFriendView:frnd];
        [btnDel setTag:frnd.tag];//here do correction
        [btnDel addTarget:self action:@selector(deleteGroupMember:) forControlEvents:UIControlEventTouchUpInside];
        [btnDel setImage:[UIImage imageNamed:@"removeIcon"] forState:UIControlStateNormal];
        [btnDel setAlpha:1];
        [_scrGroupMembers addSubview:frnd];
        [_scrGroupMembers addSubview:btnDel];
        NSLog(@"_selectedGroupDelButton %@", _selectedGroupDelButton);
        [_selectedGroupDelButton addObject:btnDel];
        
        count++;
        
    }
    
    if (count < 3) {
        [_scrGroupMembers setContentSize:CGSizeMake(224, 48)];
    }else{
        [_scrGroupMembers setContentSize:CGSizeMake((62 * [_selectedGroup.group_memberships_attributes count]), 48)];
        
    }
    
//    int x = (10 + 50) * ([_selectedGroupFriends count] - 1);
//    NSLog(@"COUNZ %d", x);
//    CGRect rect = CGRectMake(x , IS_IPAD ?  10 : 2, 46, 46);
//    int count = 0;
//    for (FLOtherProfile *prof in _selectedGroup.group_memberships_attributes) {
//        
//        NSLog(@"Profile %d", [prof.uid intValue]);
//        
//        FLFriendView *frnd = [[FLFriendView alloc] initWithFrame:rect andProfile:prof];
//        frnd.tag = count;
//        frnd.scrollParent = _scrFriends;
//        frnd.mainView = _viewRadarFront;
//        //        frnd.delegate = self;
//        frnd.imgv.contentMode = UIViewContentModeScaleAspectFill;
//        
//        [frnd setBackgroundColor:[UIColor clearColor]];
//        
//        [_scrGroupMembers setContentSize:CGSizeMake(224, 48)];
//        [frnd setCenter:CGPointMake(0, 0)];
//        [frnd setFrame:CGRectMake(x, 2, 46, 46)];
//        FLButtonWithProfile *btnDel = [[FLButtonWithProfile alloc] initWithFrame:CGRectMake(x + 35, -2, 20, 20)];
//        [btnDel setFriendView:frnd];
//        [btnDel setTag:frnd.tag];//here do correction
//        [btnDel addTarget:self action:@selector(deleteGroupMember:) forControlEvents:UIControlEventTouchUpInside];
//        [btnDel setImage:[UIImage imageNamed:@"removeIcon"] forState:UIControlStateNormal];
//        [btnDel setAlpha:1];
//        [_scrGroupMembers addSubview:frnd];
//        [_scrGroupMembers addSubview:btnDel];
//        [_selectedGroupDelButton addObject:btnDel];
//        
//        count++;
//    }
    
   //Animate group preview view
    _isGroupUpdating = YES;
    
    //set owner profile pic
    [self setOwnerImage:TYPE_GROUP withProfile:_selectedGroup.owner];
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _txtGroupName.text = _selectedRadarObject.name;
        _txtGroupDesc.text = _selectedRadarObject.desc;
        
        _imgGroupPicture.image = _imgGroupPic.image;
        _imgGroupPicture.layer.cornerRadius = 10;
        _imgGroupPicture.layer.masksToBounds = YES;
        
        _viewGroupPreview.frame = CGRectMake(_viewGroupPreview.frame.origin.x - _viewGroupPreview.frame.size.width, _viewGroupPreview.frame.origin.y, _viewGroupPreview.frame.size.width, _viewGroupPreview.frame.size.height);
        _viewGroupPreview.alpha = 0;
    } completion:^(BOOL finished) {
        
        
        _viewGroupComposer.frame = CGRectMake(0, IS_IPHONE_5 ? 260 : 172, _viewGroupComposer.frame.size.width, _viewGroupComposer.frame.size.height);
        __block CGRect position = _viewGroupComposer.frame;
        position.origin.x = 320;
        [self.view addSubview:_viewGroupComposer];
        
        _viewGroupComposer.frame = position;
        
        
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            _viewGroupComposer.alpha = 1;
            
            position.origin.x = -50;
            
            _viewGroupComposer.frame = position;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                position.origin.x = 50;
                
                _viewGroupComposer.frame = position;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    position.origin.x = -15;
                    
                    _viewGroupComposer.frame = position;
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        
                        position.origin.x = 3;
                        
                        _viewGroupComposer.frame = position;
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            position.origin.x = -2;
                            
                            _viewGroupComposer.frame = position;
                            
                        } completion:^(BOOL finished) {
                            
                            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                position.origin.x = 0;
                                
                                _viewGroupComposer.frame = position;
                                
                            } completion:^(BOOL finished) {
                                
                                //Add create button
                                UIImage* filterBtnImg = [UIImage imageNamed:@"createBtn.png"];
                                CGRect frameFilter = CGRectMake(0, 0, filterBtnImg.size.width, filterBtnImg.size.height);
                                UIButton* filterBtn = [[UIButton alloc]initWithFrame:frameFilter];
                                [filterBtn setBackgroundImage:filterBtnImg forState:UIControlStateNormal];
                                [filterBtn setTag:1004];
                                [filterBtn addTarget:self action:@selector(createGroup:) forControlEvents:UIControlEventTouchUpInside];
                                UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
                                filterBarButton.tag = 1002;
                                self.navigationItem.rightBarButtonItem = filterBarButton;
                            }];
                            
                        }];
                        
                    }];
                    
                }];
                
            }];
            
        }];
        
    }];
    
}

- (IBAction)editGroup:(UIButton *)sender {
    
    //Show friends
    _isGroupUpdating = YES;
    
    [self setupFriendsListAndShow:YES withButton:sender];
    
    //Look in 'profileFriendshipFriendListResult' function
}



#pragma mark - Meetings
#pragma mark -


- (IBAction)newMeetingPoint:(UIButton*)sender {
    if (sender.tag == 1) {
        //Clear it
        _isMeetingCreating = NO;
        [self setupFriendsListAndShow:NO withButton:sender];
    }else{
        //Open it
        
        //preload map view
        _map = [[FLMapViewController alloc] initWithNibName:@"FLMapViewController" bundle:nil];
        [_map setDelegate:self];
        [_map setIsPickLocation:YES];
        _map.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        
        _isMeetingCreating = YES;
        [self setupFriendsListAndShow:YES withButton:sender];
    }
    
}

-(void)deleteMeetingMember:(FLButtonWithProfile*)sender{
    NSLog(@"DELETE MEETING MEMBER %d", sender.tag);
    FLFriendView *frnd = sender.friendView;
    [self repositionMeetingMembersFrom:frnd andButton:sender];
    [frnd removeFromSuperview];
    [sender removeFromSuperview];
}

-(void)repositionMeetingMembersFrom:(FLFriendView*)frnd andButton:(FLButtonWithProfile*)buttonDeleted{
    
    
    [_selectedMeetingFriends removeObject:frnd];
    [_selectedMeetingDelButton removeObject:buttonDeleted];
    
    
    NSLog(@"REMOVED %d", frnd.tag);
    for (FLFriendView *my2 in _selectedMeetingFriends) {
        
        //Group selected index used because the UIView's tag is already occupied by friend list
        if (my2.groupSelectedIndex > frnd.groupSelectedIndex) {
            NSLog(@"REM %d", my2.tag);
            
            int index = [_selectedMeetingFriends indexOfObject:my2];
            FLButtonWithProfile *btn = [_selectedMeetingDelButton objectAtIndex:index];
            NSLog(@"DEL BUTTTON %@", btn);
            
            CGRect rect = my2.frame;
            CGRect rect2 = btn.frame;
            
            rect.origin.x = rect.origin.x - 60;
            rect2.origin.x = rect2.origin.x - 60;
            
            [UIView animateWithDuration:0.4f animations:^{
                
                btn.frame = rect2;
                
            }];
            
            [UIView animateWithDuration:0.4f animations:^{
                my2.frame = rect;
                
                
            } completion:^(BOOL finished) {
            }];
            
        }
        
    }
    
    if ([_selectedMeetingFriends count] <= 4) {
        NSLog(@"ITS 3 or less than 3");
        if (_scrMeetingMembers.contentSize.width > 241) {
            [_scrMeetingMembers setContentSize:CGSizeMake(241, 65)];
        }
    }
    
}

-(void)closeMeetingComposer{
    
    [_selectedMeetingDelButton removeAllObjects];
    [_selectedMeetingFriends removeAllObjects];
    
    //Enable radar
    [_scrRadar setContentOffset:CGPointMake(0, 0) animated:YES];
    _scrRadar.scrollEnabled = YES;
    if (_panGroup) {
        [self.view removeGestureRecognizer:_panGroup];
    }
    
    [_viewGroupAddFriends removeFromSuperview];
    
    for (UIView *view in _scrFriends.subviews) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in _scrMeetingMembers.subviews) {
        [view removeFromSuperview];
    }
    
    [UIView animateWithDuration:0.4f animations:^{
        
        _viewMeetingComposer.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [_viewMeetingComposer removeFromSuperview];
        
    }];
    
    //remove navigation bar 'create' button
    self.navigationItem.rightBarButtonItem = nil;;
}

-(void)createMeeting:(UIButton*)sender{
    
    
    if ([_txtMeetingName.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"oops", @"") message:NSLocalizedString(@"meeting_name_missing", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
        //NSLocalizedString(@"grp_desc_missing", @"")
    }
    
    if ([_txtMeetingDesc.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"oops", @"") message:NSLocalizedString(@"meeting_desc_missing", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSLog(@"Creating meeting");
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
//	HUD.delegate = self;
    HUD.labelText = @"Creating meeting";
    [HUD show:YES];
    
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
////  Meet points: Create
//    FLGroup *groupObj=[[FLGroup alloc] init];
//    groupObj.name=@"Meet Point 11133";
//    groupObj.description=@"This is Test Meet point";
//    groupObj.image=@"test_meetpoint.png";
//    groupObj.group_memberships_attributes=[NSArray arrayWithObjects:[NSNumber numberWithInt:26],[NSNumber numberWithInt:27],[NSNumber numberWithInt:45] , nil];
    
    FLMeetpoint *meetPointObj=[[FLMeetpoint alloc] init];
    meetPointObj.name = _txtMeetingName.text;
    meetPointObj.description = _txtMeetingDesc.text;
    meetPointObj.image = @"test_meetpoint.png";
    meetPointObj.latitude = [NSString stringWithFormat:@"%f", _selectedLocation.coordinate.latitude];
    meetPointObj.longitude = [NSString stringWithFormat:@"%f", _selectedLocation.coordinate.longitude];
    [webSeviceApi meetPointCreate:self withMeetPointObj:meetPointObj];
    
    _isMeetingCreating = NO;
    
}

-(void)meetPointCreateResult:(NSString *)str{
    
    NSLog(@"Meeting result %@", str);
    
    _isMeetingCreating = NO;
    
    HUD.labelText = NSLocalizedString(@"meeting_success", @"");
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    [HUD hide:YES afterDelay:1.0f];
    
    
    _txtMeetingName.text = @"";
    _txtMeetingDesc.text = @"";
    
    [self removeFriendListView];
    
    [self closeMeetingComposer];
}

- (IBAction)editMeetingPoint:(id)sender {
    
    NSString *title = nil;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MMM-dd '@' HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:_selectedMeetingDate];
    NSLog(@"Date: %@", dateString);
    
    if (_selectedMeetingDate) {
        title = [NSString stringWithFormat:@"Scheduled : %@", dateString];
    }
    
    NSLog(@"COORDINATE %f, %f", _selectedLocation.coordinate.latitude, _selectedLocation.coordinate.longitude);
    
    if (_selectedLocation) {
        NSLog(@"Coordinate valid");
    } else {
        NSLog(@"Coordinate invalid");
    }
    
    [UIActionSheet showInView:self.view
                    withTitle:title
            cancelButtonTitle:@"Cancel"
       destructiveButtonTitle:nil
            otherButtonTitles:@[_selectedMeetingDate ? @"Change start time" : @"Set start time", _selectedLocation ? @"Change Location" : @"Set Location"]
                     tapBlock:^(UIActionSheet *actionSheetSelf, NSInteger buttonIndex){
                         
                         NSLog(@"Tapped '%@' at index %d", [actionSheetSelf buttonTitleAtIndex:buttonIndex], buttonIndex);
                         
                         switch (buttonIndex) {
                             case 0:{
                                 [self createActionSheet];
                                 [self createUIDatePicker];
                                 break;
                             }
                                 
                             case 1:{
                                 [self presentViewController:_map animated:YES completion:^{
                                     
                                 }];
                                 break;
                             }
                                 
                             default:
                                 break;
                         }
                         
                     }];
}

-(void)locationPicked:(CLLocation *)pickedLoaction{
    NSLog(@"picked location >>>> %@",pickedLoaction);
    _selectedLocation = pickedLoaction;
}

-(void)discardMeeting{
    [self removeFriendListView];
    [self closeMeetingComposer];
    _isMeetingCreating = NO;
}

- (IBAction)navigateToMettingPoint:(UIButton *)sender {
    FLMapViewController *navMap = [[FLMapViewController alloc] initWithNibName:(IS_IPHONE5)?@"FLMapViewController-568h":@"FLMapViewController" bundle:nil];
    [navMap setIsMeetingPoint:YES];
    [navMap setRadarItem:_selectedRadarObject];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:navMap];
    [nav setTitle:_selectedRadarObject.name];
    navMap.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - Taxi Points
#pragma mark -

- (IBAction)showTaxiPointComposer:(UIButton *)sender {
    NSLog(@"HERE :)");
    FLTaxiPointViewController *taxi = [[FLTaxiPointViewController alloc] initWithNibName:@"FLTaxiPointViewController" bundle:nil];
    //taxi.modalPresentationStyle = UIModalPresentationFormSheet;
    taxi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:taxi animated:YES completion:nil];
}

//- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
//{
//    
//}

#pragma mark - Moments
#pragma mark -

-(void)loadMomentsFromService{
    NSLog(@"LOAD 404");
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    [webSeviceApi momentList:self];
}


- (IBAction)newImage:(UIButton *)sender {
    
    [UIActionSheet showInView:self.view
                    withTitle:nil
            cancelButtonTitle:@"Cancel"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"Snap It", @"Photo Library"]
                     tapBlock:^(UIActionSheet *actionSheetSelf, NSInteger buttonIndex){
                         
                         NSLog(@"Tapped '%@' at index %d", [actionSheetSelf buttonTitleAtIndex:buttonIndex], buttonIndex);
                         
                         if (buttonIndex != 2) {
                             UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
                             
                             UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                             picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                             
                             if([UIImagePickerController isSourceTypeAvailable:type]){
                                 if(buttonIndex==0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                                     type = UIImagePickerControllerSourceTypeCamera;
//                                     picker.sourceType = type;
//                                     FLCameraOverlay *overlay = [[FLCameraOverlay alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) andPicker:picker];
//                                     
//                                     picker.showsCameraControls = NO;
//                                     picker.navigationBarHidden = YES;
//                                     picker.toolbarHidden = YES;
//                                     //make the video preview full size
//                                     picker.wantsFullScreenLayout = YES;
//                                     picker.cameraViewTransform =
//                                     CGAffineTransformScale(picker.cameraViewTransform,
//                                                            1,
//                                                            1.12412);
//                                     //set our custom overlay view
//                                     picker.cameraOverlayView = overlay;
                                 }
                                 
                                 
                                 picker.allowsEditing = NO;
                                 picker.delegate   = self;
                                 picker.sourceType = type;
                                 
                                 [self presentViewController:picker animated:YES completion:nil];
                             }
                         }
                         
                     }];
    
}

#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (picker.view.tag == 1001) {
        [_imgGroupPicture setImage:image];
        _imgGroupPicture.layer.cornerRadius = 10;
        _imgGroupPicture.layer.masksToBounds = YES;
//        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText = @"Please wait...";
        [HUD show:YES];
        
        dispatch_queue_t backgroundQueue = dispatch_queue_create("com.flingoo.momentqueue", 0);
        
        dispatch_async(backgroundQueue, ^{
            CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
            editor.delegate = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:editor animated:YES completion:^{
                    
                    [HUD hide:YES];
                    
                }];
            });
        });
        
        
        
//        [self.view pushViewController:editor animated:YES];
        
    }
}

#pragma mark- CLImageEditor delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    NSLog(@"Image Cooked ;) upload the image");
    
    _imgMoment = image;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    //	HUD.delegate = self;
    HUD.labelText = @"Uploading moment";
    [HUD show:YES];
    
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService albumList:self];
    
//    _imageView.image = image;
//    [self refreshImageView];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Moment delegates
#pragma mark -

-(void)albumListResult:(NSMutableArray *)albumListArr
{
    if (!_imgMoment) {
        return;
    }
    
    for(id obj in albumListArr)
    {
        FLAlbum *albumObj=(FLAlbum *)obj;
        if (albumObj.moments==1)
        {
            //upload album pic
            FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
            FLImgObj *imgObj=[[FLImgObj alloc] init];
            imgObj.folder_name=IMAGE_DIRECTORY_ALBUM;
//            UIImage *originalImage=[UIImage imageNamed:@"flower.jpg"];
            
            imgObj.imgData=UIImageJPEGRepresentation(_imgMoment,0.0);
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
    [HUD hide:YES];
    
    //    [HUD hide:YES];
    //    [albumPicArr addObject:albumObj];
    //    [self.collectionVwPhoto reloadData];
    
    //    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    //    [webService albumPhotoList:self withAlbumID:photoObj.albumID];
}

-(void)momentListResult:(NSMutableArray *)momentsObjArr{
    NSLog(@"RADAR COUNT before %d", [_radarItems count]);
    NSLog(@"MOMENTS %@", momentsObjArr);
    
    /*
     * Unwanted code, but i had to use like this because
     * of the web service behaviour
     */
    for (FLRadarObject *item in _radarItems) {
        if (item.viewMoment) {
            [item.viewMoment removeFromSuperview];
        }
    }
    
    [_radarItems addObjectsFromArray:momentsObjArr];
    
    NSLog(@"RADAR COUNT %d", [_radarItems count]);
    
    float distance = 400;//1KM - 450KM
    int availableDistance = 65;//so totsl circle radiance is 130
    float divider = availableDistance / distance;
    int middleCircleRadiance = 65;//This is the radiance of middle circle which we need to ignore
    
    for (FLRadarObject *item in _radarItems) {
        NSLog(@"=========================Start===============================");
        
        NSMutableArray *calculatedDistanceList = [[NSMutableArray alloc] init];
        
        float distanceInKM= [currentLocation distanceFromLocation:item.location] / 1000;
        
        if (distanceInKM > distance) {
            continue;
        }
        
        float distanceInApp = distanceInKM * divider;
        
        NSLog(@"DISTANCE %f", distanceInKM);
        NSLog(@"DISTANCE in app %f", distanceInApp);
        float angle = RADIANS_TO_DEGREES([FLUtil angleFromCoordinate:currentLocation.coordinate toCoordinate:item.location.coordinate]);
        
        [item setCalculatedAngle:angle];
        
        //get the point to place the item
        float totalD = distanceInApp+middleCircleRadiance;
        
        NSLog(@"TOTAL DISTANCE %f", totalD);
        CGPoint itemPoint = [FLUtil getAngle:angle - 90 withDistance:totalD];//adding middle black circle radians, distanceInApp + middleCircleRadiance
        
        //adding to array
        
        for (float i = 0; i < 450; i++) {
            
            float divider = availableDistance / i;
            float distanceInApp = distanceInKM * divider;
            
            CGPoint itemPoint = [FLUtil getAngle:angle - 90 withDistance:distanceInApp+middleCircleRadiance];
            
            NSDictionary *loc = @{@"point": [NSValue valueWithCGPoint:itemPoint], @"distanceApp":[NSNumber numberWithFloat:distanceInApp]};
            [calculatedDistanceList addObject:loc];
            
        }
        
        item.points = calculatedDistanceList;
        
        switch (item.radarType) {
            case TYPE_MOMENT:{
                NSLog(@"MOV__ %@ IMG %@", item.userObj.full_name, item.image);
                FLMomentView *momentView = [[FLMomentView alloc] initWithFrame:CGRectMake(itemPoint.x - 33, itemPoint.y - (77 / 2), 66, 72) andItem:item];
//                [momentView setBackgroundColor:[UIColor greenColor]];
                momentView.transform = CGAffineTransformMakeRotation(_radarItemAngle);
                item.viewMoment = momentView;
                [_viewBackRadarSet addSubview:momentView];
//                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(itemPoint.x - 33, itemPoint.y - (77 / 2), 66, 72)];
//                view.layer.borderWidth = 2;
//                view.layer.borderColor = [UIColor blackColor].CGColor;
//                [view setBackgroundColor:[UIColor greenColor]];
//                view.transform = CGAffineTransformMakeRotation(_radarItemAngle);
//                item.viewMoment = view;
//                [_viewBackRadarSet addSubview:view];
                
                break;
            }
                
            default:{
                
                FLButtonWithRadarItem *btn = [FLUtil getButtonForRadarItem:item withItemPoint:itemPoint];
                btn.transform = CGAffineTransformMakeRotation(_radarItemAngle);
                [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
                
                [_viewFrontRadarSet addSubview:btn];
                
                break;
            }
        }
        
        
        
        NSLog(@"==========================End==============================");
    }
    
}

#pragma mark - Memory mgt
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
