# 飞凡APP(iOS)事件分发策略优化

## 为啥要用事件分发：
1.代码解耦
2.独立模块间进行通讯
3.事件的统一处理

## 当前事件分发策略现状和问题：

### 当前的核心实现：
1.定义事件调度器：WDEventScheduler，
2.定义事件处理器handler:实现WDEventHandlerProtocol协议
3.具体业务自定义调度事件：例如处理广告调度的FFAdvertiseEvent
4.在主程序中，绑定事件调度器和事件处理器handler
5.事件调度器对自定义事件进行调度，依次遍历绑定的事件处理器handler，当找到可以处理的handler之后停止事件分发。
6.执行事件处理器handler中的事件处理函数，进行事件处理。

### 当前策略遇到的问题：
1.在事件处理器handler处理事件回调时，需要对自定义调度事件进行逻辑判断才能确定具体执行的代码。我们的对自定义调度事件对象是个id类型的，所以导致handler里面的逻辑处理极其复杂，具体可参考webview的jumpHandler的业务代码：为了确定具体的调度事件，有的逻辑是基于url的host的，有的是基于scheme的，甚至还有的是基于path的。

2.由于自定义调度事件定义的不明确，而我们的义事件调度器对事件处理的检索方式是线性遍历的，所以很容易出现一个特定的调度事件，被一个通用的调度处理器处理了，导致需要进行处理的调度管理器没有收到处理请求，无法进行处理，当遇到这类问题时，调试解决问题的成本也非常高

3.由于现在一个调度管理器Handler的事件处理事件都集中在`handleEvent`函数里面，对于查找和维护指定的事件处理回调需要很高的成本。

## 事件分发策略优化方案具体实现

1.事件分发统一使用NSURL，并规范URL格式如下：
例：

```
@"wandaappfeifan://marketing/scan?adddd=dafdf&afdfsadfsdf=123445"
```
URL的Scheme统一为：内部：wandaappfeifan，外部：wandafeifanapp

URL的Host统一区分落位业务:每个业务模块统一自己的Host，比如：公共基础功能的Host为"common",营销业务的Host为"marketing"等

URL的Path统一区分一个业务模块下的具体功能，支持多级：比如"scan"扫码、"map/location"表示地图下的定位功能等

URL的参数都可以进行简单的拼接，这些参数都会在事件处理回调的时,以字典NSDictionay形式被处理。

2.绑定URL和事件处理回调Block，在程序初始化时，直接在内存中绑定事件URL和具体事件回调block的方式。
例：

```
[FFRouteManager addRoute:COMMON_DEMO handler:^BOOL(NSDictionary *parameters) {
        //DO SOME
        void (^completion)(id result) = parameters[kFFRouteCompleteBlockKey];
        if(completion)
        {
            completion(nil);
        }
        
        return YES;
    } impClass:[self class]];
```
其中具体的URL定义请按照1中规范进行定义，存放位置，建议每个业务仓都统一在一个.h文件中，并写好具体的注释，方便后续检索和管理，
例：

```
#ifndef FFMarketingRouteURL_h
#define FFMarketingRouteURL_h
#define MARKETING_SCAN            @"marketing/scan"  //营销扫一扫
#define MARKETING_EXT_TEST            @"marketing/ext/test"  //营销ext/test
#endif
```
为了保证一个URL只会绑定一个Block回调，会在绑定函数`addRoute`中进行逻辑判断，如果当前的url被抢注，会报错，这样能保证一个url只会被一个回调Block所处理。


3.为了实现模块解耦，会在commonService仓实现一个FFRouteManager类，提供分发接口供业务仓调用，同时需要各业务仓实现`FFRouteImpPtotocol`协议：

```
@protocol FFRouteImpPtotocol <NSObject>
@required
-(void) registerRoute;
@end
```
用于绑定URL和事件处理回调Block。这里要注意的是：当业务不断发展，这是可能需要注册的url会愈来愈多，这就导致了`registerRoute`这函数里面的代码会愈来愈多，为了提高可维护性，这个时候我们需要对具体的业务再做一层抽象细化，通过OC的category对`registerRoute`函数进行按功能拆分，方便后续管理维护。

FFRouteManager类提供以下接口：

```
//初始化函数，在主程序中调用一次
+(void) addRouteImps:(NSArray <id<FFRouteImpPtotocol>>*) Imps;
//用于FFRouteImp绑定处理回调
+ (void)addRoute:(NSString *)routePattern handler:(BOOL (^)(NSDictionary *parameters))handlerBlock;
//用于FFRouteImp去除绑定回调
+ (void)removeRoute:(NSString *)routePattern;
//执行Route操作
+ (id)routeURL:(NSURL *)URL;
//执行Route操作
+ (id)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters;
//执行Route操作，route完成后执行block
+ (id)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters completed:(void (^)(id result))completedBlock;
//判断当前URL是否可以Route
+ (BOOL)canRouteURL:(NSURL *)URL;
//内部跳转Scheme
+ (NSString *)APPInScheme;
//外部跳转Scheme
+ (NSString *)APPOutScheme;
```
4.在appDelegate中需要调用`addRouteImps`绑定具体的Route业务实现类

```
[FFRouteManager addRouteImps:@[[FFCommonRouteImp new],[FFMarketingRouteImp new]]];
```

5.发起事件调度时，只要调用以下代码就可以实现：

例如 wandaappfeifan://marketing/scan?adddd=dafdf&afdfsadfsdf=123445 能被wandaappfeifan://marketing/* 匹配 也能被wandaappfeifan://* /scan匹配
        模糊匹配优先级低于精确匹配

```
//url没有任何参数
NSString* urlstr = @"wandaappfeifan://common/scan";
NSURL * url = [NSURL URLWithString:urlstr];
if([FFRouteManager canRouteURL:url])
{
    [FFRouteManager routeURL: url];
}

//url带简单参数
urlstr = @"wandaappfeifan://marketing/scan?adddd=dafdf&afdfsadfsdf=123445";
url = [NSURL URLWithString:urlstr];
if([FFRouteManager canRouteURL:url])
{
    [FFRouteManager routeURL: url];
}

//带复杂参数
urlstr = @"wandaappfeifan://common/demo";
url = [NSURL URLWithString:urlstr];
if([FFRouteManager canRouteURL:url])
{
    [FFRouteManager routeURL: url withParameters:@{@"userinfo":self}];
}
    
//代码分类测试
urlstr = @"wandaappfeifan://marketing/ext/test";
url = [NSURL URLWithString:urlstr];
if([FFRouteManager canRouteURL:url])
{
    [FFRouteManager routeURL: url];
}

//测试带block的参数
urlstr = @"wandaappfeifan://common/demo";
    url = [NSURL URLWithString:urlstr];
    if([FFRouteManager canRouteURL:url])
    {
        [FFRouteManager routeURL: url withParameters:nil completed:^(id result) {
            NSLog(@"执行block:relust:%@",result);
        }];
    }

```

## 源代码
具体源码在commonService下的commonServiceLib/FFEventSechedulerKit下













