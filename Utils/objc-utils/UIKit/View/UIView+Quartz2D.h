//
//  UIView+Quartz2D.h
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 在 drawRect 内部使用的方法 */
@interface UIView (Quartz2D)

/**
 简单全视图填充颜色
 @param color 填充的颜色
 */
- (void)quartz2D_FillColor:(UIColor *)color;

/**
 绘制正方形网格图
 @param spacing 网格间距
 @param strokeWidth 网格线宽
 @param strokeColor 网格线颜色
 @param fillColor 填充颜色
 */
- (void)quartz2D_addGridPatternSpacing:(CGFloat)spacing
                           strokeWidth:(CGFloat)strokeWidth
                           strokeColor:(UIColor *)strokeColor
                             fillColor:(UIColor *)fillColor;

/** 线性渐变
 在当前上下文对象中绘制径向渐变，需要在 drawRect: 方法中调用
 @param colors 渐变颜色数组
 @param locations 关键点数组，与渐变颜色数组配合，数组个数相同
 @param startPoint 渐变起始点
 @param endPoint 渐变终点
 @param clipToRects 裁剪区域设置
 @param options 渐变填充方式
 */
- (void)quartz2D_addColorGradientEffectLinearColors:(NSArray<UIColor *> *)colors
                                          locations:(NSArray<NSNumber *> *)locations
                                         startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
                                        clipToRects:(NSArray<NSValue *> *)clipToRects
                                            options:(CGGradientDrawingOptions)options;

/** 径向渐变
 在当前上下文对象中绘制径向渐变，需要在 drawRect: 方法中调用
 @param colors 渐变颜色数组
 @param locations 关键点数组，与渐变颜色数组配合，数组个数相同
 @param startPoint 渐变起始点
 @param startRadius 渐变半径
 @param endPoint 渐变终点
 @param endRadius 渐变半径
 @param clipToRects 裁剪区域设置
 @param options 渐变填充方式
 */
- (void)quartz2D_addColorGradientEffectRadialColors:(NSArray<UIColor *> *)colors
                                          locations:(NSArray<NSNumber *> *)locations
                                         startPoint:(CGPoint)startPoint
                                        startRadius:(CGFloat)startRadius
                                           endPoint:(CGPoint)endPoint
                                          endRadius:(CGFloat)endRadius
                                        clipToRects:(NSArray<NSValue *> *)clipToRects
                                            options:(CGGradientDrawingOptions)options;

@end

NS_ASSUME_NONNULL_END
