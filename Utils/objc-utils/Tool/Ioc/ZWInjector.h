//
//  ZWInjector.h
//  DictPublishAssistant
//
//  Created by zhuwei on 15/4/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWSingleton.h"

/**
 *  返回实现协议的类的宏
 *
 *  @param __protocol 协议
 *
 *  @return 返回实现协议的类
 */
#undef	ZWInjectedInstanceForProtocol
#define ZWInjectedInstanceForProtocol( __protocol )   \
((id<__protocol>)([[ZWInjector sharedInstance] instanceForProtocol:@protocol(__protocol)]))

/**
 *  返回实现协议的类的宏
 *
 *  @param __protocol 协议
 *
 *  @return 返回实现协议的类
 */
#undef	_ZWIoC
#define _ZWIoC( __protocol ) ZWInjectedInstanceForProtocol( __protocol )

/**
 *  统一注入接口
 */
@protocol ZWInjectedClassProtocol <NSObject>


@end

/**
 *  IoC工厂
 */
@interface ZWInjector : NSObject

INTERFACE_SINGLETON(ZWInjector)

#pragma mark - 公共方法 -
/**
 *  初始化IoC
 */
+ (void)setup;

/**
 *  通过接口查询实现类
 *
 *  @param protocol 接口
 *
 *  @return 返回的实现接口的类
 */
- (id)instanceForProtocol:(Protocol *)protocol;

/**
 *  通过接口获取实现类的集合
 *
 *  @param protocol 接口
 *
 *  @return 通过接口获取实现类的集合
 */
- (NSArray *)instancesForProtocol:(Protocol *)protocol;

/**
 *  通过协议返回实现类
 *
 *  @param protocol 协议名
 *
 *  @return 返回类名
 */
- (Class)classForProtocol:(Protocol *)protocol;

/**
 *  返回实现协议的所有类
 *
 *  @param protocol 协议名称
 *
 *  @return 实现协议的所有类
 */
- (NSArray *)classesForProtocol:(Protocol *)protocol;

@end
