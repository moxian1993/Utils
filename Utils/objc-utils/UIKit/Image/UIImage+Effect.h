//
//  UIImage+Effect.h
//  Utils
//
//  Created by Mo on 2017/7/28.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Effect)

/**
 对图片进行滤镜处理
 
 @param image origin image
 @param name effect name
 
 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
 CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
 
 @return image
 */
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;


/**
 对图片进行模糊处理
 
 @param image origin image
 @param name effect name
 
 CIGaussianBlur ---> 高斯模糊
 CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
 CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
 CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
 CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
 
 @param radius radius
 @return image
 */
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;


/**
 调整图片饱和度, 亮度, 对比度

 @param image      目标图片
 @param saturation 饱和度
 @param brightness 亮度: -1.0 ~ 1.0
 @param contrast   对比度
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;



@end
