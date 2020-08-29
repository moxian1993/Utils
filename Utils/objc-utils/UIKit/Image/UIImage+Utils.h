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


/// resize
/// @param size size
- (UIImage *)resize:(CGSize)size;

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


/// imageWithData
/// @param data data
/// @param size size
+ (UIImage *)imageWithData:(NSData *)data size:(CGSize)size;


/// 获得单位颜色图片
/// @param color color
+ (UIImage *)imageWithColor:(UIColor *)color;
   

/// 按坐标截出image
/// @param rect rect
- (UIImage *)cropImageToRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
