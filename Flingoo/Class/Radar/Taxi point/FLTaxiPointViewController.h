//
//  FLTaxiPointViewController.h
//  Flingoo
//
//  Created by Prasad De Zoysa on 12/16/13.
//  Copyright (c) 2013 Copyright (c) 2013 SmartDevelopments - http://www.prasad.ws. All rights reserved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "FLNAnnotation.h"
#import "FLWebServiceDelegate.h"

@interface FLTaxiPointViewController : UIViewController<MKMapViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, FLWebServiceDelegate>{
    MBProgressHUD *HUD;
    
    //Date picker
    UIDatePicker *theDatePicker;
    NSDate *selectedDatePickerDate;
    UIActionSheet *actionSheet;
    UIPopoverController *popOver;
    UIView *popoverView;
    
    //Seat picker
    UIPickerView *seatPicker;
    int noOfSeats;
    
    FLNAnnotation *startPoint;
    FLNAnnotation *endPoint;
}


@property (strong, nonatomic) IBOutlet UINavigationBar *navigation;
@property (strong, nonatomic) IBOutlet UIView *viewForm;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) int tagCount;
@property (strong, nonatomic) IBOutlet UILabel *lblStartAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblDestinationAddress;
@property (strong, nonatomic) NSDate *selectedTaxiPointDate;
@property (strong, nonatomic) IBOutlet UITextField *txtStartTime;
@property (strong, nonatomic) IBOutlet UITextField *txtNoOfSeats;

//Route
@property(nonatomic, strong) NSArray *arrRoutePoints;
@property (nonatomic, strong) MKPolyline *objPolyline;
@property (nonatomic, strong) MKUserLocation *currentUserLocation;


@end
