//
//  UserDefaultsManager.m
//  Utils
//
//  Created by Mo on 2017/8/22.
//  Copyright © 2017年 Mo. All rights reserved.
//


#import "UserDefaultsManager.h"

@implementation UserDefaultsManager

+ (void)set:(id)preference for:(NSString *)key {
    [USER_DEFAULTS setObject:preference forKey:key];
    [USER_DEFAULTS synchronize];
}


+ (NSString *)getValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    NSString *value = [USER_DEFAULTS objectForKey:key];
    return value == nil ? defaultValue : [NSString stringWithFormat:@"%@",value];
}


+ (NSData *)getDataForKey:(NSString *)key {
    return [USER_DEFAULTS dataForKey:key];
}


+ (NSArray *)getArrayForKey:(NSString *)key {
    return [USER_DEFAULTS arrayForKey:key];
}


+ (NSDictionary *)getDictionaryForKey:(NSString *)key {
    return [USER_DEFAULTS dictionaryForKey:key];
}


+ (void)cleanAllCache {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [USER_DEFAULTS removePersistentDomainForName:appDomain];
    [USER_DEFAULTS synchronize];
}


@end
