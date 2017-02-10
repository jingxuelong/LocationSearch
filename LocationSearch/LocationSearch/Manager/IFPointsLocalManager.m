//
//  IFPointsLocalManager.m
//  LocationSearch
//
//  Created by JingXueLong on 2017/2/3.
//  Copyright © 2017年 JingXueLong. All rights reserved.
//

#import "IFPointsLocalManager.h"
#import <FMDB.h>

#define POINT_DATA      @"point_data"

@interface IFPointsLocalManager()

@property (copy, nonatomic) NSString *path;


@end

@implementation IFPointsLocalManager

+ (instancetype)shareManager{
    static IFPointsLocalManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isExsist = [fileManager fileExistsAtPath:self.path];
        if (isExsist) {
            manager = [NSKeyedUnarchiver unarchiveObjectWithFile:self.path];
        }else{
            manager = [super allocWithZone:NULL];
            manager.pointsArray = [NSMutableArray arrayWithCapacity:0];
        }
    });
    return manager;
}


- (BOOL)savePoint{
    return [self writeToFile:[[self class] path] atomically:YES];
}


+ (NSString *)path{
    NSString *tmpPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [tmpPath stringByAppendingPathComponent:POINT_DATA];
    return path;
}


@end
