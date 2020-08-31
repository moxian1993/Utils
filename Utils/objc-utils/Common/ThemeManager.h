//
//  ThemeManager.h
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZWSingleton.h"

#define _ThemeManager ([ThemeManager sharedInstance])

#define LANGUAGE(__KEY__)   ([_ThemeManager localizedStringWithKey:(__KEY__)])
#define IMAGE(__NAME__)     ([_ThemeManager imageName: (__NAME__)])

NS_ASSUME_NONNULL_BEGIN

@interface ThemeManager : NSObject

INTERFACE_SINGLETON(ThemeManager)

@property (nonatomic, strong) UIColor *themeColor;

- (NSString *)localizedStringWithKey:(NSString *)key;
- (UIImage *)imageName:(NSString *)imageName;


/// 检测多语言文件是否缺少LanguageKey(DEBUG环境)
/// @param tablePath 当前.string 文件路径
+ (void)checkMissingLanguageKeyWithCurrentTablePath:(NSString *)tablePath;

@end

NS_ASSUME_NONNULL_END
