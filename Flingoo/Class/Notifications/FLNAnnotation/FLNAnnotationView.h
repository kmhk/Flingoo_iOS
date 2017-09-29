//
//  FLNAnnotationView.h
//  Flingoo
//
//  Created by Thilina Hewagama on 11/21/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface FLNAnnotationView : MKAnnotationView
-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
