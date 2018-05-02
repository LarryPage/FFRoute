//
//  FFDemoView.m
//  FFRoute
//
//  Created by LiXiangCheng on 2016/10/19.
//  Copyright © 2016年 wanda. All rights reserved.
//

#import "FFDemoView.h"

@implementation FFDemoView

-(void) setupView
{
    UIImageView * imageView = [[UIImageView alloc] init];
    //imageView.image = [UIImage imageNamed:@"resource.bundle/app_tabbar_shake"];
    imageView.image = [UIImage imageNamed:@"app_tabbar_shake"];
    imageView.frame = CGRectMake(0, 0, 100, 100);
    [self addSubview:imageView];
}
@end
