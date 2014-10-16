//
//  SJAnnotation.h
//  CloudKitDemo
//
//  Created by SHIJIAN on 14-10-15.
//  Copyright (c) 2014年 SHIJIAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface SJAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


-(id) initAnnotationWithTitle:(NSString *) title andSubtitle:(NSString *) subtitle andCoordinate2D:(CLLocationCoordinate2D) coordinate;

@end
