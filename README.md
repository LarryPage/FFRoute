# FFRoute
route  路由方案

* JLRoutes ios  查找 URL 的实现不够高效，通过遍历而不是匹配,功能偏多
* Routable ios&android 
* HHRouter  路由两种类型：viewcontroller & block闭包  基于匹配，所以会更高效,但跟 ViewController 绑定地过于紧密，一定程度上降低了灵活性
* MGJRouter 蘑菇街,和HHRouter相似,且进行了改进,基于匹配，所以会更高效,且灵活 √ viewcontroller & protocol
* CTMediator 基于Mediator,利用了Target-Action简单粗暴的思想，利用Runtime解决解耦

##使用方式：

1.调度方式统一使用NSURL

2.URL的Scheme统一为：greenbaby,
内部：greenbabyin，
外部：greenbabyout 
例如：

```
greenbabyin://marketing/scan?adddd=dafdf&afdfsadfsdf=123445
```
3.绑定URL和事件处理回调Block，在程序初始化时，直接在内存中绑定事件URL和具体事件回调block的方式:

```
+ (void)addRoute:(NSString *)routePattern handler:(BOOL (^)(NSDictionary *parameters))handlerBlock impClass:(Class)impClass;
```

4.执行Route操作

```
+ (BOOL)routeURL:(NSURL *)URL;
```
 
备注：
支持模糊匹配，模糊匹配符为"*"
例如 

```
greenbabyin://marketing/scan?adddd=dafdf&afdfsadfsdf=123445
```
能被greenbabyin://marketing/ * 匹配 
也能被greenbabyin:// * /scan匹配
模糊匹配优先级低于精确匹配

