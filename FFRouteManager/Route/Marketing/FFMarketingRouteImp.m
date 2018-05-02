//
//  FFMarketingRouteImp.m
//  FFRouteManager
//
//  Created by LiXiangCheng on 16/10/14.
//  Copyright © 2016年 wanda. All rights reserved.
//

#import "FFMarketingRouteImp.h"
#import "FFMarketingRouteImp+ext.h"

@implementation FFMarketingRouteImp

-(void) registerRoute
{
    //扫一扫业务逻辑
    [FFRouteManager addRoute:MARKETING_SCAN handler:^id(NSDictionary *parameters) {
        
        NSLog(@"事件回调逻辑实现%@",parameters);
        
        return nil;
    } impClass:[self class]];
    
    //ext模块注册事件
    [self registerExtRoute];
}


@end
