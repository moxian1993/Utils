//
//  NetworkUtils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "NetworkUtils.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <YYReachability.h>

@implementation NetworkUtils

/**
 判断网络是否可用
 (2G环境也划分为无网环境)
 @return yes or no
 */
+ (BOOL)isNetworkAvailable {
    YYReachability *reachability = [YYReachability reachability];
    if (reachability.status == YYReachabilityStatusNone) {
        return NO;
    }
    if (reachability.status == YYReachabilityStatusWWAN) {
        YYReachabilityWWANStatus status = reachability.wwanStatus;
        if (status == YYReachabilityWWANStatusNone || status == YYReachabilityWWANStatus2G) {
            return NO;
        }
        return YES;
    }
    return YES;
}


/**
 是否在2G网络环境

 @return yes or no
 */
+ (BOOL)isIn2G {
    YYReachability *reachability = [YYReachability reachability];
    if (reachability.status == YYReachabilityStatusWWAN && reachability.wwanStatus == YYReachabilityWWANStatus2G) {
        return YES;
    }
    return NO;
}


/**
 是否在3G\4G网络环境

 @return yes or no
 */
+ (BOOL)isIn4Gor3G {
    YYReachability *reachability = [YYReachability reachability];
    if (reachability.status == YYReachabilityStatusWWAN) {
        if (reachability.wwanStatus == YYReachabilityWWANStatus3G || reachability.wwanStatus == YYReachabilityWWANStatus4G) {
            return YES;
        }
    }
    return NO;
}



/**
 获取网络连接类型

 @return type string
 */
+ (NSString *)getNetconnType {
    
    NSString *netconnType = @"";
    
    YYReachability *reach = [YYReachability reachabilityWithHostname:@"www.apple.com"];
    switch (reach.status) {
        case YYReachabilityStatusNone:
            netconnType = @"no network";
            break;
            
        case YYReachabilityStatusWiFi:
            netconnType = @"Wifi";
            break;
            
        case YYReachabilityStatusWWAN: {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    return netconnType;
}


@end
