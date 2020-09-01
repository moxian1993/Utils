//
//  PhoneInfoUtils.h
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneInfoUtils : NSObject

/**
 判断系统是否为中文环境
 
 @return yes/no
 */
+ (BOOL)isSystemLanguageChinese;


/**
 判断系统是否为繁体中文环境

 @return yes/no
 */
+ (BOOL)isSystemLanguageChineseTraditional;


/**
 获取APP版本号
 
 @return version
 */
+ (NSString *)getClientVersion;


/**
 获取APP纯数字版本号(一般不需要)
 可用情况：与相关人员规定版本号 每段一样长: xx.yy.zz
 
 @return versionNumberString
 */
+ (NSString *)getClientVersionNumberString;


/**
 获取网络运营商名称(有可能获取不到)
 
 @return NetworkCarrierName
 */
+ (NSString *)getPhoneNetworkCarrierName;


/**
 获取准确机型
 
 @return device model name
 */
+ (NSString *)getDeviceModel;


/** 
 获得适配机型,用来进行性能的适配：5c = 5, se = 6
 
 @return device model type name
 */
+ (NSString *)getDeviceType;


/**
 获取APP安装在手机上的UUID
 (每次APP删了重装UUID都不同)
 
 @return deviceId
 */
+ (NSString *)getSerialNumber;


/**
 获取国家名称(缩写)
 
 @return country ISO
 */
+ (NSString *)getCountryIso;


/**
 获取广告标示符
 
 @return IDFA
 */
+ (NSString *)getIDFA;



@end
