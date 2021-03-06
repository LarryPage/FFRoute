//
//  FFRouteManager.m
//  FFRouteManager
//
//  Created by LiXiangCheng on 16/10/14.
//  Copyright © 2016年 wanda. All rights reserved.
//

#import "FFRouteManager.h"
#import "FFRoute.h"

static NSArray <id<FFRouteImpProtocol>>* routeImpsArray;
static NSArray<NSString *> *supportSchemes;
static NSMutableDictionary<NSString*, FFRoute *> *routeMap;

@implementation FFRouteManager

+(void) addRouteImps:(NSArray <id<FFRouteImpProtocol>>*) Imps
{
    routeImpsArray  = Imps;
    [FFRouteManager setupRoute];
}

+(void) setupRoute
{
    if(!supportSchemes)
    {
        supportSchemes = @[[FFRouteManager APPInScheme] ,[FFRouteManager APPOutScheme],[FFRouteManager APPScheme]];
    }
    if(!routeMap)
    {
        routeMap = [NSMutableDictionary dictionaryWithCapacity:3];
        for(NSString * scheme in supportSchemes)
        {
            FFRoute * route = [FFRoute routeForScheme:scheme];
            [routeMap setObject:route forKey:scheme];
        }
    }
    
    if(routeImpsArray.count > 0)
    {
        for (id routeImp in routeImpsArray)
        {
            [routeImp registerRoute];
        }
    }
}

+ (void)addRoute:(NSString *)routePattern handler:(id (^)(NSDictionary *parameters))handlerBlock impClass:(Class)impClass
{
    if(routePattern.length > 0)
    {
        NSAssert(impClass, @"为了方便定位问题，impClass不能为空");
        for (FFRoute * route in routeMap.allValues) {
            [route addRoute:routePattern handler:handlerBlock impClass:impClass];
        }
    }
}

+ (void)removeRoute:(NSString *)routePattern
{
    if(routePattern.length > 0)
    {
        for (FFRoute * route in routeMap.allValues) {
            [route removeRoute:routePattern];
        }
    }
}

+ (id)routeURL:(NSURL *)URL
{
    return [FFRouteManager routeURL:URL withParameters:nil];
}

+ (id)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters
{
    return [FFRouteManager routeURL:URL withParameters:parameters completed:nil];
}

+ (id)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters completed:(void (^)(id result))completedBlock
{
    if(!URL)
    {
        if(FF_ROUTE_LOG_ENABLED)
        {
            NSLog(@"URL为空");
        }
        return nil;
    }
    NSString * scheme = URL.scheme;
    FFRoute * route = [routeMap objectForKey:scheme];
    if(!route)
    {
        if(FF_ROUTE_LOG_ENABLED)
        {
            NSLog(@"没有找到对应的Route");
        }
        return nil;
    }
    return [route routeURL:URL withParameters:parameters completed:completedBlock];
}

+ (id)routeURLStr:(NSString *)URLStr
{
    return [FFRouteManager routeURLStr:URLStr withParameters:nil];
}

+ (id)routeURLStr:(NSString *)URLStr withParameters:(NSDictionary *)parameters
{
    return [FFRouteManager routeURLStr:URLStr withParameters:parameters completed:nil];

}
+ (id)routeURLStr:(NSString *)URLStr withParameters:(NSDictionary *)parameters completed:(void (^)(id result))completedBlock
{
    NSURL * url = [FFRouteManager urlStrToNSURL:URLStr];
    NSAssert(url, @"url格式错误，请检查url格式:%@",URLStr);
    return [FFRouteManager routeURL:url withParameters:parameters completed:completedBlock];
}

+ (BOOL)canRouteURL:(NSURL *)URL
{
    if(!URL)
    {
        return NO;
    }
    NSString * scheme = URL.scheme;
    FFRoute * route = [routeMap objectForKey:scheme];
    if(!route)
    {
        return NO;
    }
    return [route canRouteURL:URL];
}

+ (BOOL)canRouteURLStr:(NSString *)URLStr
{
    NSURL * url = [self urlStrToNSURL:URLStr];
    return [FFRouteManager canRouteURL:url];
}

+ (NSString *)APPInScheme
{
    return @"wandaappfeifan";
}

+ (NSString *)APPOutScheme
{
    return @"wandafeifanapp";
}

+ (NSString *)APPScheme
{
    return @"wandaapp";
}

+(NSURL *) urlStrToNSURL:(NSString *)urlStr
{
    NSURL * url = nil;
    if([urlStr hasPrefix:[FFRouteManager APPInScheme]] || [urlStr hasPrefix:[FFRouteManager APPOutScheme]])
    {
        url = [NSURL URLWithString:urlStr];
    }
    else
    {
         url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@",[FFRouteManager APPInScheme],urlStr]];
    }
    return url;
}

@end
