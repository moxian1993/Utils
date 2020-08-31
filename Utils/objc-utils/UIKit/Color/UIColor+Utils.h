//
//  UIColor+Utils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEXCOLOR(a)            [UIColor utils_colorWithHex:(a)]
#define RANDOMCOLOR            [UIColor utils_randomColor]

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Utils)

// 使用 16 进制数字创建颜色，例如 0xFF0000 创建红色
+ (UIColor *)utils_colorWithHex:(uint32_t)hex;
+ (UIColor *)utils_colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha;
+ (UIColor *)utils_colorWithHexStr:(NSString *)hexString;

// 生成随机颜色
+ (UIColor *)utils_randomColor;
+ (UIColor *)utils_randomColorWithAlpha:(CGFloat)alpha;

@end


@interface UIColor (Component)

// 判断是否是亮色(未验证)
- (BOOL)utils_isLightColor;

// 获取RGB值(未验证)
- (void)utils_getRGBComponents:(CGFloat[_Nullable 3])components;
// 获取色值
- (int)utils_getRed;
- (int)utils_getGreen;
- (int)utils_getBlue;
- (CGFloat)utils_getAlpha;

@end


NS_ASSUME_NONNULL_END
