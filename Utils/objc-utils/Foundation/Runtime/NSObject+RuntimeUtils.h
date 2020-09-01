//
//  NSObject+RuntimeUtils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RuntimeUtils)

/// 返回当前类的属性类别
+ (NSArray <NSString *>*)propertyList;

/// 返回当前类的协议列表
+ (NSArray <NSString *>*)protocalList;

/// 返回当前类的方法列表
+ (NSArray <NSString *>*)methodList;

/// 返回当前类的成员变量
+ (NSArray *)ivarsList;

@end

NS_ASSUME_NONNULL_END
