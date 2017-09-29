//
//  FLNAnnotation.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLNAnnotation.h"

@implementation FLNAnnotation
@synthesize coordinate,annotationId, title;

-(id) initWithAnnotationId:(NSNumber *) aId title:(NSString *) atitle coordinate:(CLLocationCoordinate2D) acoordinate;{
    self = [super init];
    if (self) {
        self.annotationId = aId;
        self.title = title;
        self.coordinate = acoordinate;
    }
    
    return self;
}


@end
