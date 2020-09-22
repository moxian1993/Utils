//
//  NSArray+HighOrderFunc.h
//  Utils
//
//  Created by Xian Mo on 2020/9/22.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (HighOrderFunc)

/// 处理数组中的每个元素，并返回一个新的结果数组
/// @param hanlde rule
- (NSArray *)_map:(id(^)(id obj))hanlde;


/// 按照规则返回过滤之后的数组
/// @param handle rule
- (NSArray *)_filter:(BOOL(^)(id obj))handle;


/// 按照规则将数组元素一一合并
/// @param handle rule
/// @param initial 初始值
- (id)_reduce:(id(^)(id obj1, id obj2))handle initial:(id)initial;

/**
 Usages:
    [subviews _forEach:^(UIView *view) {
        [view removeFromSuperview];
    }];
 */

/// 对组中每个元素做操作
/// @param handle rule
- (void)_forEach:(void(^)(id obj))handle;


@end

NS_ASSUME_NONNULL_END
