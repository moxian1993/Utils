//
//  NetworkUtils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.

// Reachability
// https://github.com/tonymillion/Reachability

// RealReachability
// https://github.com/dustturtle/RealReachability

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkUtils : NSObject

/// 获取网络运营商名称
+ (NSString *)getPhoneNetworkCarrierName;

/// 国家码
+ (NSString *)getCountryISO;
+ (NSString *)getLocalCountryISO;

@end

NS_ASSUME_NONNULL_END
