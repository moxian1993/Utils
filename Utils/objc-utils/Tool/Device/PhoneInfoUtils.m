//
//  PhoneInfoUtils.m
//  Copyright © 2017年 Mo. All rights reserved.
//

#import "PhoneInfoUtils.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "UIDevice+TSHardwareVersion.h"
#import <AdSupport/AdSupport.h>

@implementation PhoneInfoUtils

/**
 判断系统是否为中文环境

 @return yes/no
 */
+ (BOOL)isSystemLanguageChinese {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    if ([preferredLang hasPrefix:@"zh"]) {
        return YES;
    }
    return NO;
}

/**
 判断系统是否为繁体中文环境
 
 @return yes/no
 */
+ (BOOL)isSystemLanguageChineseTraditional {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    if ([preferredLang hasPrefix:@"zh-Hant"]) {
        return YES;
    }
    return NO;
}


/**
 获取APP版本号

 @return version
 */
+ (NSString *)getClientVersion {
    NSDictionary *infoDictionary =[[NSBundle mainBundle]infoDictionary];
    NSString * version = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return version;
}


/**
 获取APP纯数字版本号(一般不需要)
 可用情况：与相关人员规定版本号 每段一样长: xx.yy.zz
 
 @return versionNumberString
 */
+ (NSString *)getClientVersionNumberString {
    NSString *version = [self getClientVersion];
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, version.length)];

    return version;
}


/**
 获取网络运营商名称(有可能获取不到)

 @return carrier name
 */
+ (NSString *)getPhoneNetworkCarrierName {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *simOperator = carrier.carrierName;
    
    return simOperator;
}


/**
 获取准确机型

 @return device model name
 */
+ (NSString *)getDeviceModel {
    UIDevice *device = [[UIDevice alloc] init];
    return [device modelName];
}


/**
 获得适配机型,用来进行性能的适配：5c = 5, se = 6
 
 @return device model type name
 */
+ (NSString *)getDeviceType {
    NSString *deviceModel = [self getDeviceModel];
    if ([deviceModel containsString:@"5"]) {
        if ([deviceModel containsString:@"5s"]) {
            return @"iPhone5s";
        }
        if ([deviceModel containsString:@"5c"]) {
            // 5c = 5
            return @"iPhone5";
        }
        return @"iPhone5";
    }
    
    if ([deviceModel containsString:@"6"]) {
        if ([deviceModel containsString:@"6s"]) {
            if ([deviceModel containsString:@"Plus"]) {
                return @"iPhone6sPlus";
            }
            return @"iPhone6s";
        } else {
            if ([deviceModel containsString:@"Plus"]) {
                return @"iPhone6Plus";
            }
            return @"iPhone6";
        }
    }
    
    if ([deviceModel containsString:@"7"]) {
        if ([deviceModel containsString:@"Plus"]) {
            return @"iPhone7Plus";
        }
        return @"iPhone7";
    }
    
    if ([deviceModel containsString:@"SE"]) {
        return @"iPhone6";
    }
    return nil;
}


/**
 获取APP安装在手机上的UUID
 (每次APP删了重装UUID都不同)
 
 @return deviceId
 */
+ (NSString *)getSerialNumber {
    UIDevice *device = [[UIDevice alloc] init];
    NSString * deviceId = [[device identifierForVendor] UUIDString];
    return deviceId;
}


/**
 获取国家名称(缩写)

 @return country ISO
 */
+ (NSString *)getCountryIso {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *countryIso = carrier.isoCountryCode;
//    NSString *simOperator = carrier.carrierName;
//    NSString *networkOperator = carrier.mobileNetworkCode;
//
//    NSLog(@"carrier = %@,countryIso = %@, simOperator = %@, networkOperator = %@",carrier,countryIso,simOperator,networkOperator);
    
    if(countryIso == nil || countryIso.length == 0) {
        countryIso = [self getLocalCountryIso];
    }
    return countryIso;
}

/**
 获取本地国家名称(缩写)
 
 @return local country ISO
 */
+ (NSString *)getLocalCountryIso{
    NSLocale *locale = [NSLocale currentLocale];
    return locale.countryCode;
}


/**
 获取广告标示符

 @return IDFA
 */
+ (NSString *)getIDFA{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
}
@end

