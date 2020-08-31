//
//  UIImage+Color.h
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

/** 为图片填充自定义颜色 */
- (UIImage *)utils_imageWithTintColor:(UIColor *)tintColor;
/** 为图片填充自定义颜色,保留灰度信息 */
- (UIImage *)utils_imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *)utils_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

/**
 取图片上某个像素点的颜色值
 @param point 像素点
 @param alpha 修改该颜色的透明度
 @return 获取修改完成的颜色值
 */
- (UIColor *)utils_colorAtPixelPoint:(CGPoint)point alpha:(CGFloat)alpha;

/** 将图片转换成灰度图片 */
- (UIImage *)utils_grayImage;

/** 判断图片是否偏黑 (mk，正确性有待验证) */
- (BOOL)isBlackImage;


@end

NS_ASSUME_NONNULL_END
