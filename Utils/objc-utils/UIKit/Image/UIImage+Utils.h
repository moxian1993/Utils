//
//  UIImage+Utils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UIImageCornerIconDirection) {
    UIImageCornerIconDirectionUpRight,
    UIImageCornerIconDirectionUpLeft,
    UIImageCornerIconDirectionDownRight,
    UIImageCornerIconDirectionDownLeft
};

@interface UIImage (Utils)

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

/// image 转 data
- (NSData *)getImageData;


/// 图片切圆角
/// @param radius 角度
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

/// 绘制圆形图片
/// @param icon 源图片
/// @param imageSize 目标尺寸
/// @param fillColor 填充色
/// @param borderColor 边框颜色
/// @param borderWidth 边框宽度
+ (UIImage *)circleImageWithIcon:(UIImage *)icon
                       imageSize:(CGSize)imageSize
                       fillColor:(UIColor *)fillColor
                     borderColor:(UIColor *)borderColor
                     borderWidth:(float)borderWidth;

/// 生成角标图片
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
/// @param icon 角标图标
/// @param direction 角标所处位置
- (UIImage *)cornerIconImageWithBorderWidth:(float)borderWidth
                                borderColor:(UIColor *)borderColor
                                 cornerIcon:(UIImage *)icon
                        cornerIconDirection:(UIImageCornerIconDirection)direction;

@end

NS_ASSUME_NONNULL_END
