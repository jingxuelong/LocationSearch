//
//  IFPointAnnotation.h
//  LocationSearch
//
//  Created by JingXueLong on 2017/2/3.
//  Copyright © 2017年 JingXueLong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface IFPointAnnotation : NSObject

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@property (copy, nonatomic) NSString *pointName;

@property (strong, nonatomic) NSDate *createDate;


+ (instancetype)pointAnnotationWithCoordinateValue:(CLLocationCoordinate2D)coordinate andPointName:(NSString*)name;

- (MKPointAnnotation*)changeToMKPointAnnotation;

@end
