//
//  FLTaxiPointViewController.m
//  Flingoo
//
//  Created by Prasad De Zoysa on 12/16/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import "FLTaxiPointViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FLNAnnotationView.h"
#import "FLNAnnotation.h"
#import "FLTaxiPoint.h"
#import "FLWebServiceApi.h"

@interface FLTaxiPointViewController ()

@end

@implementation FLTaxiPointViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSMutableString *nibName = [nibNameOrNil mutableCopy];
    
    if (IS_IPHONE_5) {
        [nibName appendString:@"-586h"];
    }
    
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set navigationbar back button
    UIImage* btnBackImg = [UIImage imageNamed:@"back_btn"];
    
    CGRect frame = CGRectMake(0, 0, btnBackImg.size.width, btnBackImg.size.height);
    UIButton* backButton = [[UIButton alloc]initWithFrame:frame];
    [backButton setBackgroundImage:btnBackImg forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [[_navigation.items objectAtIndex:0] setLeftBarButtonItem:cancelBarButton];
    
    
    UIImage* loginBtnImg = [UIImage imageNamed:@"createBtn"];
    CGRect frameLogin = CGRectMake(0, 0, loginBtnImg.size.width, loginBtnImg.size.height);
    UIButton* loginBtn = [[UIButton alloc]initWithFrame:frameLogin];
    [loginBtn setBackgroundImage:loginBtnImg forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(createTaxiPoint:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* logininBarButton = [[UIBarButtonItem alloc] initWithCustomView:loginBtn];
    [[_navigation.items objectAtIndex:0] setRightBarButtonItem:logininBarButton];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_viewForm.bounds];
    _viewForm.layer.masksToBounds = NO;
    _viewForm.layer.shadowColor = [UIColor blackColor].CGColor;
    _viewForm.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    _viewForm.layer.shadowOpacity = 0.5f;
    _viewForm.layer.shadowPath = shadowPath.CGPath;
    
    [self.mapView.userLocation addObserver:self
                                   forKeyPath:@"location"
                                      options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                      context:NULL];
    
    [self initMain];
}

-(void)viewWillDisappear:(BOOL)animated{
//    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
}

-(void)initMain{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
}

-(void)goBack:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions
#pragma mark -

- (IBAction)setTime:(UIButton *)sender {
    [self createActionSheet:NO];
    [self createUIDatePicker];
}

- (IBAction)setNoOfSeats:(UIButton *)sender {
    [self createActionSheet:YES];
    [self createSeatPicker];
}

-(void)createTaxiPoint:(UIButton*)sender{
    //Create taxi point
    
    if ([_txtStartTime.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"oops", @"") message:NSLocalizedString(@"start_time_missing", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_txtNoOfSeats.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"oops", @"") message:NSLocalizedString(@"seats_missing", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_lblStartAddress.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"oops", @"") message:NSLocalizedString(@"start_point_missing", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_lblDestinationAddress.text length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"oops", @"") message:NSLocalizedString(@"destination_point_missing", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"taxi_creating", @"");
    [HUD show:YES];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:_selectedTaxiPointDate];
    NSLog(@"Date: %@", dateString);
    
    FLWebServiceApi *webSeviceApi=[[FLWebServiceApi alloc] init];
    FLTaxiPoint *taxiPointObj =[[FLTaxiPoint alloc] init];
    taxiPointObj.start_time = dateString;
    taxiPointObj.no_of_seats=[NSNumber numberWithInt:noOfSeats];
    taxiPointObj.start_address = _lblStartAddress.text;
    taxiPointObj.destination_address = _lblDestinationAddress.text;
    taxiPointObj.start_latitude = [NSString stringWithFormat:@"%f", startPoint.coordinate.latitude];
    taxiPointObj.start_longitude = [NSString stringWithFormat:@"%f", startPoint.coordinate.longitude];
    taxiPointObj.destination_latitude = [NSString stringWithFormat:@"%f", endPoint.coordinate.latitude];
    taxiPointObj.destination_longitude = [NSString stringWithFormat:@"%f", endPoint.coordinate.longitude];
    [webSeviceApi taxiPointCreate:self withGroupObj:taxiPointObj];
}

#pragma mark - FLWebServiceDelegate
#pragma mark -

-(void)taxipointCreateResult:(NSString *)msg{
    NSLog(@"RES %@", msg);
    HUD.labelText = NSLocalizedString(@"taxi_success", @"");
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    [HUD hide:YES afterDelay:1.5f];
    
    [self performSelector:@selector(close) withObject:nil afterDelay:1.5f];
}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)requestFailCall:(NSString *)errorMsg{
    NSLog(@"Faild %@", errorMsg);
    [HUD hide:YES];
}

-(void)unknownFailureCall{
    NSLog(@"unknownFailureCall");
    [HUD hide:YES];
}

#pragma mark - MapView delegate
#pragma mark -

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(FLNAnnotation *)annotation{
    NSLog(@"");
    //skip current location
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    
    static NSString* customannotationIdentifier = @"CustomAnnotationView";
    FLNAnnotationView *pinView = (FLNAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:customannotationIdentifier];
    if(!pinView){
        pinView = [[FLNAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customannotationIdentifier];
    }
    
    pinView.tag = annotation.tag;
    
    pinView.draggable = YES;
    
    pinView.image = [UIImage imageNamed:@"TaxiPoint"];
    
    
    //add custom callout
    //    UIView *callout = [self getCustomCallout];
    //    NSLog(@"calloutview: %@", callout);
    //    callout.center = CGPointMake(pinView.center.x, pinView.center.y - (callout.frame.size.height/2.0f) - 2);
    //    [pinView addSubview:callout];
    pinView.canShowCallout = NO;
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
        [self getAddressForAnnotation:annotationView.annotation];
        
        //Clear the previous route
        if (self.objPolyline) {
            [self.mapView removeOverlay:self.objPolyline];
            [self.mapView setNeedsDisplay];
        }
        
        [self initializeRouteDisplayKit];
        
        NSLog(@"TAF %d", annotationView.tag);
    }
}

- (MKOverlayView*)mapView:(MKMapView*)theMapView viewForOverlay:(id <MKOverlay>)overlay{
    MKPolylineView *view = [[MKPolylineView alloc] initWithPolyline:self.objPolyline];
    UIColor *pathColor = [UIColor colorWithRed:47/255.0f green:162/255.0f blue:209/255.0f alpha:0.7f];;
    view.fillColor = pathColor;
    view.strokeColor = pathColor;
    view.lineWidth = 6;
    return view;
}

#pragma mark - Longpress delegate
#pragma mark -

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    if (_tagCount == 2) {
        _tagCount = 0;
        for (id ann in [self.mapView annotations]) {
            if ([ann isKindOfClass:[FLNAnnotation class]]) {
                [self.mapView removeAnnotation:ann];
            }
        }
        
        [_lblStartAddress setText:@""];
        [_lblDestinationAddress setText:@""];
        
        //Clear the previous route
        if (self.objPolyline) {
            [self.mapView removeOverlay:self.objPolyline];
            [self.mapView setNeedsDisplay];
        }
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    FLNAnnotation *annot = [[FLNAnnotation alloc] init];
    annot.tag = _tagCount;
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
    
    [self getAddressForAnnotation:annot];
    
    if (_tagCount == 1) {
        NSLog(@"show route");
        [self initializeRouteDisplayKit];
        
    }
    
    _tagCount++;
}

-(void)getAddressForAnnotation:(FLNAnnotation*)annotation{
    
    CLGeocoder *gc = [[CLGeocoder alloc] init];
    __block NSMutableString *formattedAddress = nil;
    
    [gc reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude] completionHandler:^(NSArray *placemark, NSError *error) {
        CLPlacemark *pm = [placemark objectAtIndex:0];
        NSDictionary *address = pm.addressDictionary;
        NSArray*frm = [address valueForKey:@"FormattedAddressLines"];
        
        NSLog(@"add %@", address);
        NSLog(@"AAA %@", frm);
        
        formattedAddress = [[NSMutableString alloc] init];
        
        for (int i = 0; i < frm.count; i++) {
            NSLog(@"int %d", i);
            if (i == frm.count - 1) {
                [formattedAddress appendString:[NSString stringWithFormat:@"%@",[frm objectAtIndex:i]]];
            }else{
                [formattedAddress appendString:[NSString stringWithFormat:@"%@,",[frm objectAtIndex:i]]];
            }
            NSLog(@"Formatted %@", formattedAddress);
        }
        
        switch (annotation.tag) {
            case 0:{
                NSLog(@"Load start address");
                [_lblStartAddress setText:formattedAddress];
                break;
            }
                
            case 1:{
                NSLog(@"Load dest address");
                [_lblDestinationAddress setText:formattedAddress];
                break;
            }
                
            default:
                break;
        }
    }];
}

#pragma mark -
#pragma mark Draw route on MapView

- (void) initializeRouteDisplayKit{
    
    NSLog(@"Drawing path");
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"Routing...";
    [HUD show:YES];
    
    for (FLNAnnotation *ann in [self.mapView annotations]) {
        
        if ([ann isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        switch (ann.tag) {
            case 0:
                startPoint = ann;
                break;
                
            case 1:
                endPoint = ann;
                break;
                
            default:
                break;
        }
    }
    
    if (!startPoint || !endPoint) {
        return;
    }
    
    self.arrRoutePoints = [self getRoutePointFrom:startPoint to:endPoint];
    NSLog(@"self.arrRoutePoints %@",self.arrRoutePoints);
    
    if ([self.arrRoutePoints count] > 0) {
        [self drawRoute];
        [self centerMap];
    }else{
        
        [HUD hide:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"oops", @"") message:NSLocalizedString(@"invalid_destination", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (NSArray*)getRoutePointFrom:(FLNAnnotation *)origin to:(FLNAnnotation *)destination{
    NSLog(@"");
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
    
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
    NSLog(@"decodePolyLine");
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
        
        [self.mapView addOverlay:self.objPolyline];
        [self.mapView setNeedsDisplay];
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
    
    [self.mapView setRegion:region animated:YES];
    
    NSLog(@"End drawing");
    [HUD hide:YES afterDelay:1.5f];
}

#pragma mark - Date picker
#pragma mark -

- (void)createActionSheet:(BOOL)isSeats {
    
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
        [doneBtn setTag:isSeats ? 1 : 0];
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
    
    if (_selectedTaxiPointDate) {
        [theDatePicker setDate:_selectedTaxiPointDate];
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
    
    UIBarButtonItem *btn = sender;
    if (btn.tag == 1) {
        
        if (noOfSeats == 0) {
            noOfSeats = 1;
        }
        
        [_txtNoOfSeats setText:[NSString stringWithFormat:@"%d Seats", noOfSeats]];
        
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        
        actionSheet = nil;
    }else{
        _selectedTaxiPointDate = [theDatePicker date];
        //    NSLog(@"pickerSelectedIndex111 %i",pickerSelectedIndex);
        //    [self updateDetails:selectedIndexPath withObject:selectedDetailObj withNewAnswer:[selectedDetailObj.answers objectAtIndex:pickerSelectedIndex]];
        
        if (IS_IPHONE || IS_IPHONE_5)
        {
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            
            actionSheet = nil;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MMM-dd '@' HH:mm"];
            NSString *dateString = [dateFormat stringFromDate:_selectedTaxiPointDate];
            
            [_txtStartTime setText:dateString];
            
        }
        /*else if(IS_IPAD)
         {
         [popOver dismissPopoverAnimated:YES];
         popOver=nil;
         }
         [tblMyDetails reloadData];*/
    }
}

#pragma mark - Date picker
#pragma mark -

-(void)createSeatPicker{
    seatPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    seatPicker.delegate = self;
    seatPicker.showsSelectionIndicator = YES;
    
    if (IS_IPHONE || IS_IPHONE_5)
	{
        [actionSheet addSubview:seatPicker];
    }
    
    [seatPicker selectRow:noOfSeats - 1 inComponent:0 animated:YES];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    noOfSeats = row + 1;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 10;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [@"" stringByAppendingFormat:@"%d",row + 1];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

#pragma mark - MapView Location Oberver
#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    self.arrRoutePoints = [[NSArray alloc] initWithObjects:self.mapView.userLocation.location, nil];
    [self centerMap];
    
//    if (self.mapView.userLocation) {
//        <#statements#>
//    }
    
    @try{
        [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
