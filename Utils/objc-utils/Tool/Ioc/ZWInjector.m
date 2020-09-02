//
//  ZWInjector.m
//  DictPublishAssistant
//
//  Created by zhuwei on 15/4/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "ZWInjector.h"
#import "objc/runtime.h"
#import "ZWPath.h"
#import "NSObject+Perform.h"
//#import <CocoaLumberjack/CocoaLumberjack.h>


@interface ZWInjector (PRIVATE)

/**
 *  初始化所有的注入的类
 */
- (void)setupInjectedClasses;

/**
 *  初始化拦截器
 */
- (void)setupIntercepter;

/**
 *  注册注入的类
 *
 *  @param cls 注册注入的类
 */
- (void)registerInjectedClass:(Class)cls;

@end

@implementation ZWInjector {
    NSMutableDictionary*    _injectedClasses;
    
}


IMPLEMENTATION_SINGLETON(ZWInjector)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _injectedClasses = [NSMutableDictionary dictionary];
        [self setupInjectedClasses];
    }
    return self;
}

#pragma mark - 私有方法 -
/**
 *  全局查询需要注入的类
 *
 *  @return 返回所有需要注入的类的集合
 */
- (NSArray *)queryInjectedClasses {
    NSMutableArray* injectedClasses = [NSMutableArray array];
    int numClasses;
    Class * classes = NULL;
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0 )
    {
        Protocol* iocProtocol = @protocol(ZWInjectedClassProtocol);
        
        classes = (Class *)malloc(sizeof(Class) * numClasses);
        
        numClasses = objc_getClassList(classes, numClasses);
        for (NSInteger i = 0; i < numClasses; i++)
        {
            Class cls = classes[i];
            
            for ( Class thisClass = cls; nil != thisClass ; thisClass = class_getSuperclass( thisClass ) )
            {
                if(class_conformsToProtocol(thisClass, iocProtocol)) {
                    [injectedClasses addObject:cls];
                }
            }
        }
        free(classes);
    }
    
    return injectedClasses;
}

/**
 *  绑定协议和注入类
 *
 *  @param protocol 协议
 *  @param cls      注入类
 */
- (void)bindProtocol:(Protocol *)protocol Class:(Class)cls {
    
    if(protocol == nil) return;
    
    
    
    //注册当前的协议类
    NSString* protocolString = NSStringFromProtocol(protocol);
    if(protocolString == nil || [protocolString isEqualToString:@"NSObject"] || [protocolString isEqualToString:@"ZWIntercepterProtocol"] || protocol_isEqual(protocol, @protocol(ZWInjectedClassProtocol))) return;
    
    
//    //判断注册的类如果是已注册类的父类，那么就不注册该类了
//    Class oldCls = [_injectedClasses objectForKey:protocolString];
//    if(oldCls != nil && [oldCls isSubclassOfClass:cls]) {
//        return;
//    }
    
    //注册类
    NSMutableArray *_protocolClasses = _injectedClasses[protocolString];
    if(_protocolClasses == nil) {
        _protocolClasses = [NSMutableArray array];
        [_injectedClasses setObject:_protocolClasses forKey:protocolString];
    }
    
    if([_protocolClasses containsObject:cls]) return;
    
    //把子类实现放在父类实现的前面
    BOOL added = NO;
    for (NSInteger i = 0; i < [_protocolClasses count]; i ++) {
        Class existedProtocolCls = _protocolClasses[i];
        if([cls isSubclassOfClass:existedProtocolCls]) {
            [_protocolClasses insertObject:cls atIndex:i];
            added = YES;
            break;
        }
    }
    if(!added) {
        [_protocolClasses addObject:cls];
    }
    
    
//    [_injectedClasses setObject:cls forKey:protocolString];
    
//    DDLogDebug(@"register imp class %@ => %@",protocolString,NSStringFromClass(cls));
    
    //注册子协议
    uint protocolListCount = 0;
    Protocol * const *pArrProtocols = protocol_copyProtocolList(protocol,&protocolListCount);
    if(pArrProtocols != NULL && protocolListCount > 0) {
        for (int i = 0; i < protocolListCount; i++) {
            Protocol *subprotocol = *(pArrProtocols + i);
            [self bindProtocol:subprotocol Class:cls];
        }
        free((void *)pArrProtocols);
    }
    
}

/**
 *  注册注入的类
 *
 *  @param cls 注册注入的类
 */
- (void)registerInjectedClass:(Class)cls {
    
    NSMutableArray * classStack = [NSMutableArray array];
    for ( Class thisClass = cls; nil != thisClass; thisClass = class_getSuperclass( thisClass ) )
    {
        [classStack addObject:thisClass];
    }
    
    for ( Class thisClass in classStack )
    {
        uint protocolListCount = 0;
        Protocol * const *pArrProtocols = class_copyProtocolList(thisClass,&protocolListCount);
        if(pArrProtocols != NULL && protocolListCount > 0) {
            for (int i = 0; i < protocolListCount; i++) {
                Protocol *protocol = *(pArrProtocols + i);
                [self bindProtocol:protocol Class:cls];
            }
            free((void *)pArrProtocols);
        }
    }
}

/**
 *  初始化所有的注入的类
 */
- (void)setupInjectedClasses {
    
    //查询所有定义注入的类
    NSArray* injectedClasses = [self queryInjectedClasses];
    
    //向注入器注册注入的类
    [injectedClasses enumerateObjectsUsingBlock:^(id cls, NSUInteger idx, BOOL *stop) {
        [self registerInjectedClass:cls];
    }];
    
}

#pragma mark - 公共方法 -

/**
 *  初始化IoC
 */
+ (void)setup {
    [ZWInjector sharedInstance];
}



/**
 *  通过接口查询实现类
 *
 *  @param protocol 接口
 *
 *  @return 返回的实现接口的类
 */
- (id)instanceForProtocol:(Protocol *)protocol {
    if(protocol == nil) return nil;
    NSString* protocolString = NSStringFromProtocol(protocol);
    if(protocolString == nil) return nil;
    
    //获取注入的类
    NSMutableArray *_protocolClasses = _injectedClasses[protocolString];
    if(_protocolClasses == nil || _protocolClasses.count == 0) return nil;
    Class cls = _protocolClasses.firstObject;
    if(cls == nil) {
//        DDLogError(@"protocol:%@ => injected class unregister",protocolString);
        return nil;
    }
    
    id instance = nil;
    //判断是否是单例模式，如果是单例模式就取单例方法
    SEL sharedInstanceMethod = NSSelectorFromString(@"sharedInstance");
    Method method = class_getClassMethod(cls, sharedInstanceMethod);
    if ( method )
    {
        IMP imp = method_getImplementation( method );
        id (*func)(id, SEL) = (void *)imp;
        if ( func )
        {
            instance = func(cls, sharedInstanceMethod);
        }
    } else {
        instance = [[cls alloc] init];
    }
    return instance;
}

/**
 *  通过接口获取实现类的集合
 *
 *  @param protocol 接口
 *
 *  @return 通过接口获取实现类的集合
 */
- (NSArray *)instancesForProtocol:(Protocol *)protocol {
    if(protocol == nil) return nil;
    NSString* protocolString = NSStringFromProtocol(protocol);
    if(protocolString == nil) return nil;
    
    //获取注入的类
    NSMutableArray *_protocolClasses = _injectedClasses[protocolString];
    if(_protocolClasses == nil || _protocolClasses.count == 0) return nil;
   
    NSMutableArray *instances = [NSMutableArray array];
    for (Class cls in _protocolClasses) {
        if(cls == nil) {
//            DDLogError(@"protocol:%@ => injected class unregister",protocolString);
            return nil;
        }
        
        id instance = nil;
        //判断是否是单例模式，如果是单例模式就取单例方法
        SEL sharedInstanceMethod = NSSelectorFromString(@"sharedInstance");
        Method method = class_getClassMethod(cls, sharedInstanceMethod);
        if ( method )
        {
            IMP imp = method_getImplementation( method );
            id (*func)(id, SEL) = (void *)imp;
            if ( func )
            {
                instance = func(cls, sharedInstanceMethod);
            }
        } else {
            instance = [[cls alloc] init];
        }
        [instances addObject:instance];
    }
    return instances;
}

/**
 *  通过协议返回实现类
 *
 *  @param protocol 协议名
 *
 *  @return 返回类名
 */
- (Class)classForProtocol:(Protocol *)protocol {
    if(protocol == nil) return nil;
    NSString* protocolString = NSStringFromProtocol(protocol);
    if(protocolString == nil) return nil;
    
    NSMutableArray *_protocolClasses = _injectedClasses[protocolString];
    if(_protocolClasses == nil || _protocolClasses.count == 0) return nil;
    //获取注入的类
    Class cls = _protocolClasses.firstObject;
    return cls;
}

/**
 *  返回实现协议的所有类
 *
 *  @param protocol 协议名称
 *
 *  @return 实现协议的所有类
 */
- (NSArray *)classesForProtocol:(Protocol *)protocol {
    if(protocol == nil) return nil;
    NSString* protocolString = NSStringFromProtocol(protocol);
    if(protocolString == nil) return nil;
    return _injectedClasses[protocolString];;
}

@end
