//  Created by Mo on 2018/3/18.
//  Copyright © 2018年 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AsyncClipCorner)

/**
 同步绘制圆角
 
 @param size 目标尺寸
 @param color 切掉圆角部分的填充色(颜色应与背景色一致)
 @return image
 */
- (UIImage *)sync_clipImageWithSize:(CGSize)size fillColor:(UIColor *)color;

/**
 异步绘制圆角
 
 @param size 目标尺寸
 @param color 切掉圆角部分的填充色(颜色应与背景色一致)
 @param completed 异步绘制的结果回调
 */
- (void)clipImageWithSize:(CGSize)size fillColor:(UIColor *)color completed:(void(^)(UIImage *))completed;

/**
 异步绘制角度(矩形绘制圆角)
 
 @param size 目标尺寸
 @param radius 切圆角的角度
 @param color 切掉圆角部分的填充色(颜色应与背景色一致)
 @param completed 异步绘制的结果回调
 */
- (void)clipImageWithSize:(CGSize)size Radius:(CGFloat)radius fillColor:(UIColor *)color completed:(void(^)(UIImage *image))completed;

@end
