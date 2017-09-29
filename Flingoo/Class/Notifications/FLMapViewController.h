//
//  FLMapViewController.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLParentSliderViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FLRadarObject.h"
#import <MapKit/MapKit.h>

@protocol FLLocationSelectDelegate;

@interface FLMapViewController : FLParentSliderViewController<MKMapViewDelegate>
@property (nonatomic, copy) NSString *calloutText;
@property(nonatomic, assign) CLLocationCoordinate2D toCoordinate;
@property(assign) BOOL isPickLocation;
@property(assign) BOOL isMeetingPoint;
@property (strong, nonatomic) CLLocation *droppedAt;
@property (strong, nonatomic) IBOutlet UIView *viewSetLocation;
@property (strong, nonatomic) FLRadarObject *radarItem;
@property (assign) id delegate;

-(void) setDestinationCoordinates:(NSData *) destination;

@end

@protocol FLLocationSelectDelegate
-(void)locationPicked:(CLLocation*)pickedLoaction;
@end
