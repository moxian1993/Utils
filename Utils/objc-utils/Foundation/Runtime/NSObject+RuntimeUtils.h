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

//得到所有的方法名,所有的实例变量,所有的协议名称
+ (NSArray <NSString *>*)getPropertyNameList;
+ (NSArray <NSString *>*)getProtocalNameList;
+ (NSArray <NSString *>*)getMethodNameList;

@end

NS_ASSUME_NONNULL_END
