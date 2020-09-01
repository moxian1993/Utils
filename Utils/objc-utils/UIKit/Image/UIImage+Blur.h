//
//  UIImage+Blur.h
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Blur)

/// 绘制一个高斯模糊图片
/// @param image 源图片
/// @param blur 高斯模糊因数
+ (UIImage *)boxblurImage:(UIImage *)image blurFactor:(CGFloat)blur;


// 需整理
+ (UIImage *)utils_coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
+ (UIImage *)utils_boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
+ (UIImage *)utils_blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
- (UIImage *)utils_blurryWithBlurLevel:(CGFloat)blur;
- (UIImage *)utils_applyLightEffect;
- (UIImage *)utils_applyExtraLightEffect;
- (UIImage *)utils_applyDarkEffect;
- (UIImage *)utils_applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)utils_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end

NS_ASSUME_NONNULL_END
