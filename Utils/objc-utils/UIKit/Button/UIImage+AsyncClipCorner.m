//  Created by Mo on 2018/3/18.
//  Copyright © 2018年 Mo. All rights reserved.
//

#import "UIImage+AsyncClipCorner.h"

@implementation UIImage (AsyncClipCorner)

/**
 同步绘制圆角
 
 @param size 目标尺寸
 @param color 切掉圆角部分的填充色(颜色应与背景色一致)
 @return image
 */
- (UIImage *)sync_clipImageWithSize:(CGSize)size fillColor:(UIColor *)color {
    /** 利用绘图建立上下文 */
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    /** 设置填充颜色 */
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [color setFill];
    UIRectFill(rect);
    
    /** 利用bezier的裁剪效果 */
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];
    
    /** 绘制图像 */
    [self drawInRect:rect];
    
    /** 取得结果 */
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    /** 关闭上下文 */
    UIGraphicsEndImageContext();
    return result;
}

/**
  异步绘制圆角
 
 @param size 目标尺寸
 @param color 切掉圆角部分的填充色(颜色应与背景色一致)
 @param completed 异步绘制的结果回调
 */
- (void)clipImageWithSize:(CGSize)size fillColor:(UIColor *)color completed:(void(^)(UIImage *))completed {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        /** 利用绘图建立上下文 */
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        
        /** 设置填充颜色 */
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        [color setFill];
        UIRectFill(rect);
        
        /** 利用bezier的裁剪效果 */
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [path addClip];
        
        /** 绘制图像 */
        [self drawInRect:rect];
        
        /** 取得结果 */
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        /** 关闭上下文 */
        UIGraphicsEndImageContext();
        
        /** 回调结果 */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completed != nil) {
                completed(result);
            }
        });
    });
}


/**
 异步绘制角度(矩形绘制圆角)

 @param size 目标尺寸
 @param radius 切圆角的角度
 @param color 切掉圆角部分的填充色(颜色应与背景色一致)
 @param completed 异步绘制的结果回调
 */
- (void)clipImageWithSize:(CGSize)size Radius:(CGFloat)radius fillColor:(UIColor *)color completed:(void(^)(UIImage *))completed  {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        /** 利用绘图建立上下文 */
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        
        /** 设置填充颜色 */
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        [color setFill];
        UIRectFill(rect);
        
        /** 利用bezier的裁剪效果 */
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
        [path addClip];
        
        /** 绘制图像 */
        [self drawInRect:rect];
        
        /** 取得结果 */
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        /** 关闭上下文 */
        UIGraphicsEndImageContext();
        
        /** 回调结果 */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completed != nil) {
                completed(result);
            }
        });
    });
}

@end
