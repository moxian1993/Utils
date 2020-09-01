//
//  NetworkUtils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.

/**
 Reachability
 https://github.com/tonymillion/Reachability
 RealReachability
 https://github.com/dustturtle/RealReachability
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkUtils : NSObject
/**
 判断网络是否可用
 (2G环境也划分为无网环境)
*/
+ (BOOL)isNetworkAvailable;

/** 是否在2G网络环境 */
+ (BOOL)isIn2G;

/** 是否在3G\4G网络环境 */
+ (BOOL)isIn4Gor3G;

/** 获取网络连接类型 */
+ (NSString *)getNetconnType;

@end

NS_ASSUME_NONNULL_END
