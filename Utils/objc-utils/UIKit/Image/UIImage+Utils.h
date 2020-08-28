//
//  UIImage+Utils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kCoppingType) {
    kCoppingTypeTopLeft,
    kCoppingTypeTopCenter,
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utils)

- (UIImage *)resize:(CGSize)size;

/// 绘制文字图片
/// @param text 内容
/// @param targetSize 目标大小
/// @param font 字体
/// @param color 颜色
/// @param fillColor 背景色
+ (UIImage *)imageFromText:(NSString *)text
                      size:(CGSize)targetSize
                      font:(UIFont *)font
                     color:(UIColor *)color
                 fillColor:(UIColor *)fillColor;


+ (UIImage *)imageWithData:(NSData *)data size:(CGSize)size;


/// 获得单位颜色图片
/// @param color 颜色
+ (UIImage *)imageWithColor:(UIColor *)color;
   

@end

NS_ASSUME_NONNULL_END
