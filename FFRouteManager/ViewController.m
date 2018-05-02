//
//  ViewController.m
//  FFRouteManager
//
//  Created by LiXiangCheng on 16/10/14.
//  Copyright © 2016年 wanda. All rights reserved.
//

#import "ViewController.h"
#import "FFRouteManager.h"
#import "FFDemoView.h"
#import "FFRoute.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
    
    FFDemoView *demoView = [FFDemoView new];
    demoView.frame= CGRectMake(50, 50, 100, 100);
    demoView.backgroundColor = [UIColor redColor];
    [demoView setupView];
    [self.view addSubview:demoView];
    
   
   
}

-(void) test
{
    //url没有任何参数
    NSString* urlstr = @"wandaappfeifan://common/scan/";
    NSURL * url = [NSURL URLWithString:urlstr];
    if([FFRouteManager canRouteURL:url])
    {
        [FFRouteManager routeURL: url];
    }
    
    
//    //url带简单参数
//    urlstr = @"wandaappfeifan://marketing/scan?adddd=dafdf&afdfsadfsdf=123445";
//    url = [NSURL URLWithString:urlstr];
//    if([FFRouteManager canRouteURL:url])
//    {
//        [FFRouteManager routeURL: url];
//    }
//    
//    //带复杂参数
//    urlstr = @"wandaappfeifan://common/demo";
//    url = [NSURL URLWithString:urlstr];
//    if([FFRouteManager canRouteURL:url])
//    {
//        [FFRouteManager routeURL: url withParameters:@{@"userinfo":self}];
//    }
//    
//    //代码分类测试
//    urlstr = @"wandaappfeifan://marketing/ext/test";
//    url = [NSURL URLWithString:urlstr];
//    if([FFRouteManager canRouteURL:url])
//    {
//        [FFRouteManager routeURL: url];
//    }
//    
    //测试带block的参数
//    urlstr = @"wandaappfeifan://common/demo";
//    url = [NSURL URLWithString:urlstr];
//    if([FFRouteManager canRouteURL:url])
//    {
//        [FFRouteManager routeURL: url withParameters:nil completed:^(id result) {
//            NSLog(@"执行block:relust:%@",result);
//        }];
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
