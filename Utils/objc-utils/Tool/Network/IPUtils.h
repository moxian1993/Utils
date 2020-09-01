//
//  IPUtils.h
//  Utils
//
//  Created by Mo on 2017/7/28.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPUtils : NSObject

/** 获取设备 IP 地址 */
+ (NSString *)getIPAddress;
/** 获取Publick IP */
+ (NSString *)getPublicIP;

/** 获取 WiFi 信息 */
- (NSDictionary *)fetchSSIDInfo;

/** 获取广播地址、本机地址、子网掩码、端口信息 */
- (NSMutableDictionary *)getLocalInfoForCurrentWiFi;

/** 获取网络运营商名称 */
+ (NSString *)getPhoneNetworkCarrierName;

/** 国家码 */
+ (NSString *)getCountryISO;
+ (NSString *)getLocalCountryISO;

@end
