//
//  IFPointAnnotation.m
//  LocationSearch
//
//  Created by JingXueLong on 2017/2/3.
//  Copyright © 2017年 JingXueLong. All rights reserved.
//

#import "IFPointAnnotation.h"

@implementation IFPointAnnotation

+ (instancetype)pointAnnotationWithCoordinateValue:(CLLocationCoordinate2D)coordinate andPointName:(NSString *)name{
    
    IFPointAnnotation *point = [[self alloc] init];
    point.latitude = coordinate.latitude;
    point.longitude = coordinate.longitude;
    point.pointName = name;
    point.createDate = [NSDate date];
    return point;
}


- (MKPointAnnotation *)changeToMKPointAnnotation{
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.title = self.pointName;
    point.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    return point;
}

@end
