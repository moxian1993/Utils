//
//  UIColor+Utils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (UIColor *)utils_colorWithHex:(uint32_t)hex {
    return [self utils_colorWithHex:hex alpha:1.0];
}

+ (UIColor *)utils_colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha {
    uint8_t r = (hex & 0xff0000) >> 16;
    uint8_t g = (hex & 0x00ff00) >> 8;
    uint8_t b = hex & 0x0000ff;
    return [self utils_colorWithRed:r green:g blue:b alpha: alpha];
}

+ (UIColor *)utils_colorWithHexStr:(NSString *)hexString {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // 判断前缀
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        NSAssert(false, @"HexString should be 6 or 8 characters");
        return nil;
    }
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+ (UIColor *)utils_randomColor {
    return [self utils_colorWithRed:arc4random_uniform(256) green:arc4random_uniform(256) blue:arc4random_uniform(256) alpha:1.0];
}

+ (UIColor *)utils_randomColorWithAlpha:(CGFloat)alpha {
    return [self utils_colorWithRed:arc4random_uniform(256) green:arc4random_uniform(256) blue:arc4random_uniform(256) alpha:alpha];
}

+ (UIColor *)utils_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}


@end


@implementation UIColor (Component)

// 判断是否是亮色(未验证)
- (BOOL)utils_isLightColor {
    CGFloat components[3];
    [self utils_getRGBComponents:components];
    
    CGFloat num = components[0] + components[1] + components[2];
    return num >= 382;
}

// 获取RGB值(未验证)
- (void)utils_getRGBComponents:(CGFloat[_Nullable 3])components {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 bitmapInfo);
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component];
    }
}

// 获取色值
- (int)utils_getRed {
    int     r_i, g_i, b_i;
    CGFloat r_c, g_c, b_c, a_c;// a_c极限是一个小数点后6位的小数
    
    [self getRed:&r_c green:&g_c blue:&b_c alpha:&a_c];
    r_i = r_c*255;
    g_i = g_c*255;
    b_i = b_c*255;

    return r_i;
}

- (int)utils_getGreen {
    int     r_i, g_i, b_i;
    CGFloat r_c, g_c, b_c, a_c;// a_c极限是一个小数点后6位的小数

    [self getRed:&r_c green:&g_c blue:&b_c alpha:&a_c];
    r_i = r_c*255;
    g_i = g_c*255;
    b_i = b_c*255;

    return g_i;
}

- (int)utils_getBlue {
    int     r_i, g_i, b_i;
    CGFloat r_c, g_c, b_c, a_c;// a_c极限是一个小数点后6位的小数

    [self getRed:&r_c green:&g_c blue:&b_c alpha:&a_c];
    r_i = r_c*255;
    g_i = g_c*255;
    b_i = b_c*255;

    return b_i;
}


- (CGFloat)utils_getAlpha {
    int     r_i, g_i, b_i;
    CGFloat r_c, g_c, b_c, a_c;// a_c极限是一个小数点后6位的小数

    [self getRed:&r_c green:&g_c blue:&b_c alpha:&a_c];
    r_i = r_c*255;
    g_i = g_c*255;
    b_i = b_c*255;

    return a_c;
}

@end
