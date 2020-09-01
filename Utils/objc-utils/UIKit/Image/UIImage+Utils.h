//
//  UIImage+Utils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utils)

/// 图片切圆角
/// @param radius 角度
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;


/// resize
/// @param size size
- (UIImage *)resize:(CGSize)size;
- (UIImage *)autoSize:(CGSize)size;
- (UIImage *)imageScalingAndCroppingForSize:(CGSize)size;


/// 绘制文字图片
/// @param text text
/// @param targetSize targetSize
/// @param font font
/// @param color color
/// @param fillColor fillColor
+ (UIImage *)imageFromText:(NSString *)text
                      size:(CGSize)targetSize
                      font:(UIFont *)font
                     color:(UIColor *)color
                 fillColor:(UIColor *)fillColor;


/// 按尺寸绘制一个二进制图片
/// @param data data
/// @param size size
+ (UIImage *)imageWithData:(NSData *)data size:(CGSize)size;


/// 获得单位颜色图片
/// @param color color
+ (UIImage *)imageWithColor:(UIColor *)color;
   

/// 按坐标截出image
/// @param rect rect
- (UIImage *)cropImageToRect:(CGRect)rect;


/// 图片方向旋转
/// @param orientation orientation
- (UIImage *)imageRotation:(UIImageOrientation)orientation;


/// 判断图片格式
/// @param data image data
+ (NSString *)typeForImageData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
