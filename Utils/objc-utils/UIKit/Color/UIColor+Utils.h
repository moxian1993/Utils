//
//  UIColor+Utils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Utils)

/// 使用 16 进制数字创建颜色，例如 0xFF0000 创建红色
///
/// @param hex 16 进制无符号32位整数
///
/// @return 颜色
+ (instancetype)utils_colorWithHex:(uint32_t)hex;

/// 生成随机颜色
///
/// @return 随机颜色
+ (instancetype)utils_randomColor;

/// 使用 R / G / B 数值创建颜色
///
/// @param red   red
/// @param green green
/// @param blue  blue
///
/// @return 颜色
+ (instancetype)utils_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;





@end

NS_ASSUME_NONNULL_END
