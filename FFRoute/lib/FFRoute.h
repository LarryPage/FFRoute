//
//  FFRoute.h
//  FFRouter
//
//  Created by 陆锋平 on 16/10/13.
//  Copyright © 2016年 wanda. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kFFRoutePatternKey = @"FFRoutePattern";
static NSString *const kFFRouteURLKey = @"FFRouteURL";
static NSString *const kFFRouteSchemeKey = @"FFRouteScheme";

@interface FFRoute : NSObject

@property (nonatomic, copy) NSString *scheme;

+ (instancetype)routeForScheme:(NSString *)scheme;

- (void)addRoute:(NSString *)routePattern handler:(BOOL (^)(NSDictionary *parameters))handlerBlock;

- (void)removeRoute:(NSString *)routePattern;

- (BOOL)routeURL:(NSURL *)URL;

- (BOOL)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters;

- (BOOL)canRouteURL:(NSURL *)URL;

@end
