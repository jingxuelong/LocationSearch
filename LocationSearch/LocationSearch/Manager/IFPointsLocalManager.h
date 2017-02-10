//
//  IFPointsLocalManager.h
//  LocationSearch
//
//  Created by JingXueLong on 2017/2/3.
//  Copyright © 2017年 JingXueLong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFPointAnnotation.h"

@interface IFPointsLocalManager : NSObject

@property (strong, nonatomic) NSMutableArray<IFPointAnnotation*>* pointsArray;


+ (instancetype)shareManager;

- (BOOL)savePoint;

@end
