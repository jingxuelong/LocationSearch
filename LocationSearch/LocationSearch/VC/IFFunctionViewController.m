//
//  IFFunctionViewController.m
//  LocationSearch
//
//  Created by JingXueLong on 2017/2/6.
//  Copyright © 2017年 JingXueLong. All rights reserved.
//

#import "IFFunctionViewController.h"
#import <objc/runtime.h>


@interface IFFunctionViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation IFFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
//    self.webView.delegate = self;
//    
//    unsigned int conut = 0;
//    Ivar *p = class_copyIvarList(NSClassFromString(@"UIView"), &conut);
//    for (int i =0; i< conut; i++) {
//        const char *name = ivar_getName(p[i]);
//        const char *type = ivar_getTypeEncoding(p[i]);
//        NSLog(@"%s---%s", name, type);
//        
//    }
//    unsigned int newConut = 0;
//    objc_property_t *objc = class_copyPropertyList(NSClassFromString(@"UIView"), &newConut);
//    for (int i =0; i< newConut; i++) {
//        const char *newname = property_getName(objc[i]);
//        const char *newtype = property_getAttributes(objc[i]);
//        NSLog(@"NEW---%s---%s", newname, newtype);
//        
//    }
    
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 4;
    for (int i = 0; i<100; i++) {
        NSInvocationOperation *invocation = [NSInvocationOperation alloc];
        NSBlockOperation *poer = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:3];
            NSLog(@"---->%d --->%@",i, [NSThread currentThread]);
        }];
        [self.queue addOperation:poer];
    }
    
    
    
    
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    UIScrollView *scroll = webView.scrollView;
    [scroll setContentOffset:CGPointMake(0, 100)];
    //[webView setValue:@"" forKeyPath:@"_internal/scroller/contentOffset"];

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
