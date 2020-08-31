//
//  UIView+Quartz2D.m
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIView+Quartz2D.h"

@implementation UIView (Quartz2D)

// 填充颜色
- (void)quartz2D_FillColor:(UIColor *)color {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextAddLineToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, 0, 0);
    
    CGContextSetLineWidth(context, 0.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
}


// 绘制网格图
- (void)quartz2D_addGridPatternSpacing:(CGFloat)spacing
                           strokeWidth:(CGFloat)strokeWidth
                           strokeColor:(UIColor *)strokeColor
                             fillColor:(UIColor *)fillColor {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGSize size = self.bounds.size;
    int rowCount = size.width/spacing;
    int column = size.height/spacing;
    
    CGFloat x = 0;
    for (int i = 0; i < rowCount; i++) {
        CGContextMoveToPoint(context, x, 0);
        CGContextAddLineToPoint(context, x, size.height);
        x += spacing;
    }
    CGFloat y = 0;
    for (int i = 0; i < column; i++) {
        CGContextMoveToPoint(context, 0, y);
        CGContextAddLineToPoint(context, size.width, y);
        y += spacing;
    }
    
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
}

// 线性渐变
- (void)quartz2D_addColorGradientEffectLinearColors:(NSArray<UIColor *> *)colors
                                          locations:(NSArray<NSNumber *> *)locations
                                         startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
                                        clipToRects:(NSArray<NSValue *> *)clipToRects
                                            options:(CGGradientDrawingOptions)options {
    if (!colors || !locations || (colors.count!=locations.count)) return;
    [self quartz2D_addColorGradientEffectRadial:NO
                                         colors:colors
                                      locations:locations
                                     startPoint:startPoint
                                    startRadius:0
                                       endPoint:endPoint
                                      endRadius:0
                                    clipToRects:clipToRects
                                        options:options];
}

// 径向渐变
- (void)quartz2D_addColorGradientEffectRadialColors:(NSArray<UIColor *> *)colors
                                          locations:(NSArray<NSNumber *> *)locations
                                         startPoint:(CGPoint)startPoint
                                        startRadius:(CGFloat)startRadius
                                           endPoint:(CGPoint)endPoint
                                          endRadius:(CGFloat)endRadius
                                        clipToRects:(NSArray<NSValue *> *)clipToRects
                                            options:(CGGradientDrawingOptions)options {
    if (!colors || !locations || (colors.count!=locations.count)) return;
    [self quartz2D_addColorGradientEffectRadial:YES
                                         colors:colors
                                      locations:locations
                                     startPoint:startPoint
                                    startRadius:startRadius
                                       endPoint:endPoint
                                      endRadius:endRadius
                                    clipToRects:clipToRects
                                        options:options];
}


#pragma mark - private
// 线性 & 径向 渐变生成统一方法
- (void)quartz2D_addColorGradientEffectRadial:(BOOL)radial
                                       colors:(NSArray<UIColor *> *)colors
                                    locations:(NSArray<NSNumber *> *)locations
                                   startPoint:(CGPoint)startPoint
                                  startRadius:(CGFloat)startRadius
                                     endPoint:(CGPoint)endPoint
                                    endRadius:(CGFloat)endRadius
                                  clipToRects:(NSArray<NSValue *> *)clipToRects
                                      options:(CGGradientDrawingOptions)options {
    /// 步骤：1.  创建颜色空间 2.  创建渐变 3.  设置裁剪区域 4.  绘制渐变 5.  释放对象
    
    /// 创建/获取一个上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);/// CGContextSaveGState() + CGContextRestoreGState() 研究一下作用...
    
    /* a.创建颜色空间
     1. 在计算机设置中，直接选择rgb即可，其他颜色空间暂时不用考虑。
     */
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /* b.创建渐变, 参数：
     1. CGColorSpaceRef space : 颜色空间 rgb
     2. const CGFloat *components ： 数组 每四个一组 表示一个颜色 ｛r,g,b,a ,r,g,b,a｝
     3. const CGFloat *locations:表示渐变的开始位置
     */
    CGFloat componentsX[colors.count*4];
    for (int i = 0; i < colors.count; i++) {
        UIColor *color = colors[i];
        CGColorRef colorRef = color.CGColor;
        const CGFloat *sComponents = CGColorGetComponents(colorRef);
        for (int j = 0; j < 4; j++) {
            componentsX[i*4+j] = sComponents[j];
        }
    }
    CGFloat locationsX[locations.count];
    for (int i = 0; i < locations.count; i++) {
        locationsX[i] = [locations[i] doubleValue];
    }
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 componentsX,
                                                                 locationsX,
                                                                 locations.count);
    
    /* c.设置裁剪区域
     1. 渐变区域裁剪
     */
    if (clipToRects) {
        if (clipToRects.count==1) {
            CGRect clipToRect = [clipToRects.firstObject CGRectValue];
            CGContextClipToRect(context, clipToRect);
        } else {
            CGRect clipToRect[clipToRects.count];
            for (int i = 0; i < clipToRects.count; i++) {
                CGRect rect = [clipToRects[i] CGRectValue];
                clipToRect[i] = rect;
            }
            CGContextClipToRects(context, clipToRect, clipToRects.count);
        }
    }
    
    /* d.绘制渐变, 参数：
     1. context 当前上下文对象
     2. gradient 创建的渐变对象
     3. statCenter 起始中心点
     4. sartRadius 起始半径 指定为0  从圆心渐变  否则  中心位置不渐变
     5. endCenter  结束中心点（通常与起始专心点重合）
     6. endRadius  结束半径
     7. 渐变填充方式
     */
    if (radial) {/// Linear
        CGContextDrawRadialGradient(context, gradient,
                                    startPoint, startRadius,
                                    endPoint, endRadius,
                                    options);
    } else {
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, options);
    }
    
    /* f.释放对象
     */
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
}






@end
