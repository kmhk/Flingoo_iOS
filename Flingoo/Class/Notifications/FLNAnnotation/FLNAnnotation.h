//
//  FLNAnnotation.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FLNAnnotation : NSObject<MKAnnotation>
{
    NSNumber *annotationId;
    NSString *title;
    CLLocationCoordinate2D coordinate;
    
}

@property (nonatomic, strong) NSNumber * annotationId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) int tag;

-(id) initWithAnnotationId:(NSNumber *) aId title:(NSString *) atitle coordinate:(CLLocationCoordinate2D) acoordinate;

@end
