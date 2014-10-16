//
//  SJAnnotation.m
//  CloudKitDemo
//
//  Created by SHIJIAN on 14-10-15.
//  Copyright (c) 2014年 SHIJIAN. All rights reserved.
//

#import "SJAnnotation.h"

@implementation SJAnnotation

-(id) initAnnotationWithTitle:(NSString *) title andSubtitle:(NSString *) subtitle andCoordinate2D:(CLLocationCoordinate2D) coordinate{
    self = [super init];
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.coordinate = coordinate;
    }
    return self;
}
@end
