//
//  FFMarketingRouteImp+ext.m
//  FFRouteManager
//
//  Created by LiXiangCheng on 16/10/17.
//  Copyright © 2016年 wanda. All rights reserved.
//

#import "FFMarketingRouteImp+ext.h"

@implementation FFMarketingRouteImp (ext)


-(void) registerExtRoute
{
    [FFRouteManager addRoute:MARKETING_EXT_TEST handler:^id(NSDictionary *parameters) {
        
        NSLog(@"EXT_TEST事件回调逻辑实现%@",parameters);
        
        return nil;
    } impClass:[self class]];
}
@end
