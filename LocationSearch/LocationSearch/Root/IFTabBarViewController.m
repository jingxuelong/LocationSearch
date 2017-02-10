//
//  IFTabBarViewController.m
//  LocationSearch
//
//  Created by JingXueLong on 2017/2/4.
//  Copyright © 2017年 JingXueLong. All rights reserved.
//

#import "IFTabBarViewController.h"
#import "IFNavigationViewController.h"
#import "IFMianViewController.h"
#import "IFMeViewController.h"
#import "IFFunctionViewController.h"



@interface IFTabBarViewController ()

@end

@implementation IFTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    IFMianViewController *mainVC = [IFMianViewController new];
    [self addChildViewController:mainVC andTitle:@"Main"];
    
    
    IFFunctionViewController *vc = [IFFunctionViewController new];
    [self addChildViewController:vc andTitle:@"test"];
    
    
    IFMeViewController *me = [IFMeViewController new];
    [self addChildViewController:me andTitle:@"Me"];
}

- (void)addChildViewController:(UIViewController*)childController andTitle:(NSString*)title{
    IFNavigationViewController *nav = [[IFNavigationViewController alloc] initWithRootViewController:childController];
    nav.title = title;
    [self addChildViewController:nav];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
