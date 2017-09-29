//
//  FLMapViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMapViewController.h"
#import "FLNAnnotationView.h"
#import "FLNAnnotation.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import <QuartzCore/QuartzCore.h>



@interface FLMapViewController ()<MKMapViewDelegate>
@property(weak, nonatomic) IBOutlet MKMapView *objMapView;
@property(nonatomic, strong) NSArray *arrRoutePoints;
@property (nonatomic, strong) MKPolyline *objPolyline;
@property (nonatomic, strong) MKUserLocation *currentUserLocation;
@end



@implementation FLMapViewController



#pragma mark -
#pragma mark Initialize
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





#pragma mark - View Lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
            NSLog(@"");
    
    //back button
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
    if (_isPickLocation) {
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
        [self.objMapView addGestureRecognizer:lpgr];
    }else if (_isMeetingPoint){
        self.navigationItem.title = _radarItem.name;
    }
}

-(void) viewDidAppear:(BOOL)animated{
            NSLog(@"");
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}

-(void) setDestinationCoordinates:(NSData *) destination;{
            NSLog(@"");
    if(destination){
        CLLocationCoordinate2D coordinate;
        [destination getBytes:&coordinate length:sizeof(coordinate)];
        self.toCoordinate = coordinate;
    }
}


-(void) goBack{
            NSLog(@"");
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) viewWillAppear:(BOOL)animated{
//    if (!_isPickLocation) {
        [self.objMapView.userLocation addObserver:self
                                       forKeyPath:@"location"
                                          options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                          context:NULL];
//    }else{
//        
//    }

    
    [self.objMapView setShowsUserLocation:YES];
    
    
}

-(void) viewDidDisappear:(BOOL)animated{
            NSLog(@"");
    
    @try{
        if (!_isPickLocation) {
            [self.objMapView.userLocation removeObserver:self forKeyPath:@"location"];
        }
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
    
    

    [self.objMapView setShowsUserLocation:NO];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
//    if (CLLocationCoordinate2DIsValid(_droppedAt)) {
//        NSLog(@"Hello");
//    }else{
//        NSLog(@"Ohh");
//    }
}

#pragma mark - Longpress delegate

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    for (id ann in [self.objMapView annotations]) {
        if ([ann isKindOfClass:[FLNAnnotation class]]) {
            [self.objMapView removeAnnotation:ann];
        }
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.objMapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.objMapView convertPoint:touchPoint toCoordinateFromView:self.objMapView];
    
    FLNAnnotation *annot = [[FLNAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    [self.objMapView addAnnotation:annot];
}


#pragma mark - MapView Location Oberver

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    NSLog(@"Observer calls");
    
    if (_isPickLocation) {
        
        self.arrRoutePoints = [[NSArray alloc] initWithObjects:self.objMapView.userLocation.location, nil];
        [self centerMap];
        //        if (!_isPickLocation) {
        //            [self.objMapView.userLocation removeObserver:self forKeyPath:@"location"];
        //        }
        //        FLNAnnotation *destination = [[FLNAnnotation alloc] init];
        //        destination.coordinate = self.objMapView.userLocation.coordinate;
        //        destination.title = @"You are here";
        //        [self.objMapView addAnnotation:destination];
    }else if(_isMeetingPoint){
        NSLog(@"latitude %@ Longitude %@", _radarItem.latitude, _radarItem.longitude);
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_radarItem.latitude floatValue], [_radarItem.longitude floatValue]);
        
        FLNAnnotation *annot = [[FLNAnnotation alloc] init];
        annot.coordinate = coordinate;
        annot.title = _radarItem.name;
        [self.objMapView addAnnotation:annot];
        
        [self.objMapView selectAnnotation:annot animated:YES];
        
        self.arrRoutePoints = [self getRoutePointFrom:_objMapView.userLocation.coordinate to:CLLocationCoordinate2DMake([_radarItem.latitude floatValue], [_radarItem.longitude floatValue])];
        [self drawRoute];
        [self centerMap];
    }else{
        if ([self.objMapView showsUserLocation]) {
            if(!self.currentUserLocation){
                self.currentUserLocation = self.objMapView.userLocation;
                [self initializeRouteDisplayKit];
            }else{
                if([self.currentUserLocation.location distanceFromLocation:self.objMapView.userLocation.location]>50){
                    self.currentUserLocation = self.objMapView.userLocation;
                    //draw route
                    [self initializeRouteDisplayKit];
                }
            }
        }
    }
    
    @try{
         [self.objMapView.userLocation removeObserver:self forKeyPath:@"location"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
    
}



#pragma mark -
#pragma mark Draw route on MapView

- (void) initializeRouteDisplayKit{
    
            NSLog(@"");
    
    FLNAnnotation *origin = [[FLNAnnotation alloc] init];
    origin.coordinate = self.currentUserLocation.location.coordinate;

    
    FLNAnnotation *destination = [[FLNAnnotation alloc] init];
    destination.coordinate = self.toCoordinate;
    destination.title = @"Anna is here";
    
    if(self.arrRoutePoints) // Remove all annotations
        [self.objMapView removeAnnotations:[self.objMapView annotations]];
    
     [self.objMapView addAnnotation:destination];
    
    self.arrRoutePoints = [self getRoutePointFrom:origin.coordinate to:destination.coordinate];
    [self drawRoute];
    [self centerMap];
}


- (MKOverlayView*)mapView:(MKMapView*)theMapView viewForOverlay:(id <MKOverlay>)overlay{
            NSLog(@"");
    MKPolylineView *view = [[MKPolylineView alloc] initWithPolyline:self.objPolyline];
    UIColor *pathColor = [UIColor colorWithRed:47/255.0f green:162/255.0f blue:209/255.0f alpha:0.7f];;
    view.fillColor = pathColor;
    view.strokeColor = pathColor;
    view.lineWidth = 6;
    return view;
}


- (NSArray*)getRoutePointFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination{
            NSLog(@"");
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", origin.latitude, origin.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", destination.latitude, destination.longitude];
    
    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    
    NSError *error;
    NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSUTF8StringEncoding error:&error];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"points:\\\"([^\\\"]*)\\\"" options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:apiResponse options:0 range:NSMakeRange(0, [apiResponse length])];
    NSString *encodedPoints = [apiResponse substringWithRange:[match rangeAtIndex:1]];
    
    return [self decodePolyLine:[encodedPoints mutableCopy]];
}

- (NSMutableArray *)decodePolyLine:(NSMutableString *)encodedString{
            NSLog(@"");
    [encodedString replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                      options:NSLiteralSearch
                                        range:NSMakeRange(0, [encodedString length])];
    NSInteger len = [encodedString length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encodedString characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encodedString characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        printf("\n[%f,", [latitude doubleValue]);
        printf("%f]", [longitude doubleValue]);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:loc];
    }
    return array;
}

- (void)drawRoute{
            NSLog(@"");
    int numPoints = [self.arrRoutePoints count];

    if (numPoints > 1)
    {
        CLLocationCoordinate2D* coords = malloc(numPoints * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < numPoints; i++)
        {
            CLLocation* current = [self.arrRoutePoints objectAtIndex:i];
            coords[i] = current.coordinate;
        }
        
        self.objPolyline = [MKPolyline polylineWithCoordinates:coords count:numPoints];
        free(coords);
        
        [self.objMapView addOverlay:self.objPolyline];
        [self.objMapView setNeedsDisplay];
    }
}

- (void)centerMap{
            NSLog(@"");
    int numPoints = [self.arrRoutePoints count];
    if (numPoints == 0) return;
    
    MKCoordinateRegion region;
    
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    
    for(int idx = 0; idx < self.arrRoutePoints.count; idx++)
    {
        CLLocation* currentLocation = [self.arrRoutePoints objectAtIndex:idx];
        
        if(!CLLocationCoordinate2DIsValid(currentLocation.coordinate)) return;
        
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }
    
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    region.span.latitudeDelta  = maxLat - minLat;
    region.span.longitudeDelta = maxLon - minLon;
    
    [self.objMapView setRegion:region animated:YES];
}











#pragma mark - MapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;{
            NSLog(@"");
    //skip current location
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    
    static NSString* customannotationIdentifier = @"CustomAnnotationView";
    FLNAnnotationView *pinView = (FLNAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:customannotationIdentifier];
    if(!pinView){
        pinView = [[FLNAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customannotationIdentifier];
    }
    
    //set pin image here,
    if (_isPickLocation) {
//        pinView.animatesDrop = YES;
        pinView.draggable = YES;
        pinView.image = [UIImage imageNamed:@"find_me_pin.png"];
    }else if(_isMeetingPoint){
        pinView.image = [UIImage imageNamed:@"MeetPoint"];
    }else{
        pinView.image = [UIImage imageNamed:@"find_me_pin.png"];
    }
    
    
    
    
    //add custom callout
//    UIView *callout = [self getCustomCallout];
//    NSLog(@"calloutview: %@", callout);
//    callout.center = CGPointMake(pinView.center.x, pinView.center.y - (callout.frame.size.height/2.0f) - 2);
//    [pinView addSubview:callout];
    if (_isMeetingPoint) {
        pinView.canShowCallout = YES;
    }else{
        pinView.canShowCallout = NO;
    }
    
    pinView.clipsToBounds = NO;
    
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        
        _droppedAt = [[CLLocation alloc] initWithLatitude:annotationView.annotation.coordinate.latitude longitude:annotationView.annotation.coordinate.longitude];
        
        
        
        CGRect frame = _viewSetLocation.frame;
        NSLog(@"YYY %f", frame.origin.y);
        
        if (frame.origin.y >= 475) {
            frame.origin.y = frame.origin.y - 100;
            
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                _viewSetLocation.frame = frame;
                
            } completion:^(BOOL finished) {
                
                
            }];
        }
//        _latitude = @"Hlllll";
        
        NSLog(@"Pin dropped at %f,%f", _droppedAt.coordinate.latitude, _droppedAt.coordinate.longitude);
        
    }
}






#pragma mark - Helper Methods
-(UIView *) getCustomCallout{
            NSLog(@"");
    CGSize maximumSize = CGSizeMake(300, 9999);
    NSString *myString = self.calloutText;
    UIFont *myFont = [UIFont systemFontOfSize:14.0f];
    CGSize myStringSize = [myString sizeWithFont:myFont
                               constrainedToSize:maximumSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat padding = 5;
    CGRect frame = CGRectMake(0, 0, myStringSize.width + (padding *2), myStringSize.height + (padding * 2));
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = myString;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    return view;
}






#pragma mark -
#pragma mark - Others

- (IBAction)setLocation:(UIButton *)sender {
    
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = NSLocalizedString(@"no", @"");
    cancelItem.action = ^
    {
        //do nothing
    };
    
    RIButtonItem *buyStars = [RIButtonItem item];
    buyStars.label = NSLocalizedString(@"yes", @"");
    buyStars.action = ^
    {
        
        if (_delegate && _droppedAt) {
            [_delegate locationPicked:_droppedAt];
        }else{
            NSLog(@"nil delegate!!!");
        }
        
        CGRect frame = _viewSetLocation.frame;
        NSLog(@"YYY %f", frame.origin.y);
        
        if (frame.origin.y <= 375) {
            frame.origin.y = frame.origin.y + 100;
            
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                _viewSetLocation.frame = frame;
                
            } completion:^(BOOL finished) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];
        }
    };
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"meeting_conform_title", @"") message:NSLocalizedString(@"confirm_location", @"") cancelButtonItem:cancelItem otherButtonItems:buyStars, nil] show];
    
    
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
