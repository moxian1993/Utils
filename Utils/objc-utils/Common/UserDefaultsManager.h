//
//  UserDefaultsManager.h
//  Utils
//
//  Created by Mo on 2017/8/22.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * Preference;

#define USER_DEFAULTS                 [NSUserDefaults standardUserDefaults]
#define PREFERENCE_SET(key, value)    [UserDefaultsManager set:value for:key]
#define PREFERENCE_GET(key, default)  [UserDefaultsManager getValueForKey:key defaultValue:default]
#define PREFERENCE_GET_ARRAY(key)     [UserDefaultsManager getArrayForKey:key]
#define PREFERENCE_GET_DICT(key)      [UserDefaultsManager getDictionaryForKey:key]
#define PREFERENCE_GET_DATA(key)      [UserDefaultsManager getDataForKey:key]

@interface UserDefaultsManager : NSObject

+ (void)set:(id)preference for:(NSString *)key;
+ (NSString *)getValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
+ (NSData *)getDataForKey:(NSString *)key;
+ (NSArray *)getArrayForKey:(NSString *)key;
+ (NSDictionary *)getDictionaryForKey:(NSString *)key;

@end
