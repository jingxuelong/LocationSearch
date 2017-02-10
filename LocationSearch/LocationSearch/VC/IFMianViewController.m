//
//  IFMianViewController.m
//  LocationSearch
//
//  Created by JingXueLong on 2017/2/4.
//  Copyright © 2017年 JingXueLong. All rights reserved.
//

#import "IFMianViewController.h"
#import <MapKit/MapKit.h>
#import "TopView.h"
#import "IFPointsLocalManager.h"
#import "IFPointAnnotation.h"
#import <kingpin.h>

#define POINT_MANAGER_ARRAY         [IFPointsLocalManager shareManager].pointsArray
#define POINT_MANAGER               [IFPointsLocalManager shareManager]

@interface IFMianViewController ()<MKMapViewDelegate, KPClusteringControllerDelegate>


@property (strong, nonatomic) MKMapView *mapView;

@property (strong, nonatomic) UILabel *bottomLabel;


@property (strong, nonatomic) UIView *centerView;

@property (assign, nonatomic) CLLocationCoordinate2D coord;

@property (strong, nonatomic) TopView *topView;


//

@property (strong, nonatomic) CLLocationManager *manager;

@property (strong, nonatomic) KPClusteringController *clusteringController;


@end

@implementation IFMianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.bottomLabel];
    [self.view addSubview:self.topView];
    
    if ([CLLocationManager  authorizationStatus] == kCLAuthorizationStatusNotDetermined ) {
        _manager = [[CLLocationManager alloc] init];
        [_manager requestWhenInUseAuthorization];
    }
    
    
    KPGridClusteringAlgorithm *algorithm = [KPGridClusteringAlgorithm new];
    algorithm.annotationSize = CGSizeMake(25, 50);
    algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategyTwoPhase;
    
    self.clusteringController = [[KPClusteringController alloc] initWithMapView:self.mapView
                                                            clusteringAlgorithm:algorithm];
    self.clusteringController.delegate = self;
    
    self.clusteringController.animationOptions = UIViewAnimationOptionCurveEaseOut;
    

    
    
    
    [self refreshPointsAndShowAll:YES];
}




#pragma mark-- <Actions>

- (void)leftBarButtonClick:(id)sender{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"AddPoint" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder  = @"PointName";
    }];
    
    [alter addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addPoint:alter.textFields.firstObject.text];
    }]];
    
    [alter addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    
    [self.navigationController presentViewController:alter animated:YES completion:nil];
    
}

- (void)rightBarButtonClick:(id)sender{
    
}


- (void)addPoint:(NSString*)name{
    
    if (name.length) {
        IFPointAnnotation *point = [IFPointAnnotation pointAnnotationWithCoordinateValue:self.coord andPointName:name];
        [POINT_MANAGER_ARRAY addObject:point];
        [POINT_MANAGER savePoint];
        [self refreshPointsAndShowAll:NO];
    }
}

- (void)refreshPointsAndShowAll:(BOOL)show{
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.mapView.annotations];
    
    if (tmpArr.count) {
        [tmpArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[MKPointAnnotation class]]) {
                [self.mapView removeAnnotation:obj];
            }
        }];
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [POINT_MANAGER_ARRAY enumerateObjectsUsingBlock:^(IFPointAnnotation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MKPointAnnotation *annotation = [obj changeToMKPointAnnotation];
//        [self.mapView addAnnotation:annotation];
        [arr addObject:annotation];
    }];
    [self.clusteringController setAnnotations:arr];
    
//    if (show) {
//        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
//    }
}




#pragma mark-- <MKMapViewDelegate>


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    self.coord = [mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
    [self refreshLabel];
    [self.clusteringController refresh:YES];

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[KPAnnotation class]]) {
        
        KPAnnotation *cluster = (KPAnnotation *)view.annotation;
        
        if (cluster.annotations.count > 1){
            [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(cluster.coordinate,
                                                                       cluster.radius * 2.5f,
                                                                       cluster.radius * 2.5f)
                           animated:YES];
        }
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    static NSString *cellIdentifier = @"cellIdentifier";
    MKPinAnnotationView *annotationView = nil;

//    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
//        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:cellIdentifier];
//        [annotationView setCanShowCallout:YES];
//        return annotationView;
//    }
    if ([annotation isKindOfClass:[KPAnnotation class]]) {
        KPAnnotation *a = (KPAnnotation *)annotation;
        
        if ([annotation isKindOfClass:[MKUserLocation class]]){
            return nil;
        }
        
        if (a.isCluster) {
            annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
            
            if (annotationView == nil) {
                annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:a reuseIdentifier:@"cluster"];
            }
            
            annotationView.pinColor = MKPinAnnotationColorPurple;
        }
        
        else {
            annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
            
            if (annotationView == nil) {
                annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:[a.annotations anyObject]
                                                                 reuseIdentifier:@"pin"];
            }
            
            annotationView.pinColor = MKPinAnnotationColorRed;
        }
        
        annotationView.canShowCallout = YES;
    }
    
//    else if ([annotation isKindOfClass:[MyAnnotation class]]) {
//        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"nocluster"];
//        annotationView.pinColor = MKPinAnnotationColorGreen;
//    }
    
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!POINT_MANAGER_ARRAY.count) {
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
            [self.mapView setRegion:region];
        }
    });
}


#pragma mark - <KPClusteringControllerDelegate>

- (void)clusteringController:(KPClusteringController *)clusteringController configureAnnotationForDisplay:(KPAnnotation *)annotation {
    annotation.title = [NSString stringWithFormat:@"%lu custom annotations", (unsigned long)annotation.annotations.count];
    annotation.subtitle = [NSString stringWithFormat:@"%.0f meters", annotation.radius];
}

- (BOOL)clusteringControllerShouldClusterAnnotations:(KPClusteringController *)clusteringController {
    return YES;
}

- (void)clusteringControllerWillUpdateVisibleAnnotations:(KPClusteringController *)clusteringController {
    NSLog(@"Clustering controller %@ will update visible annotations", clusteringController);
}

- (void)clusteringControllerDidUpdateVisibleMapAnnotations:(KPClusteringController *)clusteringController {
    NSLog(@"Clustering controller %@ did update visible annotations", clusteringController);
}

- (void)clusteringController:(KPClusteringController *)clusteringController performAnimations:(void (^)())animations withCompletionHandler:(void (^)(BOOL))completion {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:animations
                     completion:completion];
}



#pragma mark- <Setters and Getters>


- (MKMapView *)mapView{
    if (_mapView == nil) {
        //        CGFloat y = CGRectGetHeight(self.navigationController.navigationBar.frame);
        //        CGFloat tabbarY = CGRectGetHeight(self.tabBarController.tabBar.frame);
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        [_mapView setRotateEnabled:NO];
        [_mapView setPitchEnabled:NO];
        
        if ([_mapView respondsToSelector:@selector(setShowsCompass:)]) {
            [_mapView setShowsCompass:YES];
        }
        [_mapView setShowsUserLocation:YES];
        [_mapView addSubview:self.centerView];
        self.centerView.center = _mapView.center;
    }
    return _mapView;
}


- (UILabel *)bottomLabel{
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel  alloc] initWithFrame:CGRectMake(40, HEIGHT-110, WIDE-80, 45)];
        [_bottomLabel setBackgroundColor:[UIColor whiteColor]];
        [_bottomLabel setTextAlignment:NSTextAlignmentCenter];
        [_bottomLabel setFont:[UIFont systemFontOfSize:14 weight:15]];
        [_bottomLabel.layer setCornerRadius:10];
        [_bottomLabel.layer setMasksToBounds:YES];
    }
    return  _bottomLabel;
}


- (UIView *)centerView{
    if (_centerView == nil) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [_centerView setBackgroundColor:[UIColor blueColor]];
        [_centerView.layer setCornerRadius:5];
    }
    return _centerView;
}

- (void)refreshLabel{
    [self.bottomLabel setText:[NSString stringWithFormat:@"经度:%.4f  纬度:%.4f",    self.coord.latitude,self.coord.longitude]];
    
}

- (TopView *)topView{
    if (_topView == nil) {
        //        _topView = [[TopView alloc] initWithFrame:CGRectMake(20, 20, WIDE-40, 60)];
    }
    return _topView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

