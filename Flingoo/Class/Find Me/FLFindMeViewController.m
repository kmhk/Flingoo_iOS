//
//  FLFindMeViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLFindMeViewController.h"

@interface FLFindMeViewController ()

@end

@implementation FLFindMeViewController

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
    self.navigationItem.title = @"Find Me";
}










#pragma mark - button press events

-(IBAction) findMeButtonPressed:(id)sender;{
    
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Location Service Disabled"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
//    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    lm.distanceFilter = kCLDistanceFilterNone;
    [lm startUpdatingLocation];
    
    CLLocation *location = [lm location];
    
//    CLLocationCoordinate2D coord;
//    coord.longitude = location.coordinate.longitude;
//    coord.latitude = location.coordinate.latitude;
//    // or a one shot fill
//    coord = [location coordinate];
    
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService findme:self withLat:[NSString stringWithFormat:@"%f",location.coordinate.latitude] withLon:[NSString stringWithFormat:@"%f",location.coordinate.longitude]];
}





-(void)enableDisableSliderView:(BOOL)enable
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- webservice delegate method

-(void)findMeResult:(NSString *)str
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - webservice Api Fail

-(void)unknownFailureCall
{
    [self showValidationAlert:NSLocalizedString(@"unknown_error", nil)];
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
