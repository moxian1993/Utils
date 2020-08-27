//
//  UIImage+Tint.h
//  Pods
//
//  Created by zhuwei on 15/7/24.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

/**
 *  为图片填充自定义颜色
 *
 *  @param tintColor 需要填充的颜色
 *
 *  @return 填充后的颜色
 */
- (UIImage *)utils_imageWithTintColor:(UIColor *)tintColor;

/**
 *  为图片填充自定义颜色
 *
 *  @param tintColor 需要填充的颜色
 *
 *  @return 填充后的颜色
 */
- (UIImage *)utils_imageWithGradientTintColor:(UIColor *)tintColor;

@end
