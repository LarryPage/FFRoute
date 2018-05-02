//
//  FFCommonRouteImp.m
//  FFRouteManager
//
//  Created by LiXiangCheng on 16/10/14.
//  Copyright © 2016年 wanda. All rights reserved.
//

#import "FFCommonRouteImp.h"
#import "FFRoute.h"


@implementation FFCommonRouteImp
-(void) registerRoute
{
    //扫一扫业务逻辑
    [FFRouteManager addRoute:COMMON_SCAN handler:^id(NSDictionary *parameters)  {
        
        NSLog(@"扫一扫哈哈啊啊");
        
        return nil;
    } impClass:[self class]];
    
    //Demo
    [FFRouteManager addRoute:COMMON_DEMO handler:^id(NSDictionary *parameters) {
        
        NSLog(@"DEMO拉夫安师大发生的发的速度%@",parameters);
        
        void (^completion)(id result) = parameters[kFFRouteCompleteBlockKey];
        if(completion)
        {
            completion(nil);
        }
        
        return nil;
    } impClass:[self class]];
    
    [FFRouteManager addRoute:COMMON_DEMO_TEST handler:^id(NSDictionary *parameters) {
        
        NSLog(@"COMMON_DEMO_TEST拉夫安师大发生的发的速度%@",parameters);
        
        return nil;
    } impClass:[self class]];
    
}
@end
