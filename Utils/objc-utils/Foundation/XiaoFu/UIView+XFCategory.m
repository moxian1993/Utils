//
//  UIView+XFCategory.m
//  XiaoFuTechBasic
//
//  Created by xiaofutech on 2017/9/25.
//  Copyright © 2017年 XiaoFu. All rights reserved.
//

#import "UIView+XFCategory.h"

@implementation UIView (XFCategory)

+ (UIView *)XF_ViewWithColor:(UIColor *)color Frame:(CGRect)frame {
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

#pragma mark - Quartz2D
#pragma mark ==================== Public ====================
#pragma mark === 填充颜色 ===
- (void)xfQuartz2D_FillColor:(UIColor *)color {
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

#pragma mark === 绘制网格图 ===
- (void)xfQuartz2D_AddGridPatternSpacing:(CGFloat)spacing
                             StrokeWidth:(CGFloat)strokeWidth
                             StrokeColor:(UIColor *)strokeColor
                               FillColor:(UIColor *)fillColor {
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

#pragma mark === 线性渐变 ===
- (void)xfQuartz2D_AddColorGradientEffectLinearColors:(NSArray<UIColor *> *)colors
                                      Locations:(NSArray<NSNumber *> *)locations
                                     StartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint
                                    ClipToRects:(NSArray<NSValue *> *)clipToRects
                                        Options:(CGGradientDrawingOptions)options {
    if (!colors || !locations || (colors.count!=locations.count)) return;
    [self xfQuartz2D_AddColorGradientEffectRadial:NO Colors:colors Locations:locations
                                       StartPoint:startPoint StartRadius:0
                                         EndPoint:endPoint EndRadius:0
                                      ClipToRects:clipToRects Options:options];
}

#pragma mark === 径向渐变 ===
- (void)xfQuartz2D_AddColorGradientEffectRadialColors:(NSArray<UIColor *> *)colors
                                            Locations:(NSArray<NSNumber *> *)locations
                                           StartPoint:(CGPoint)startPoint
                                          StartRadius:(CGFloat)startRadius
                                             EndPoint:(CGPoint)endPoint
                                            EndRadius:(CGFloat)endRadius
                                          ClipToRects:(NSArray<NSValue *> *)clipToRects
                                              Options:(CGGradientDrawingOptions)options {
    if (!colors || !locations || (colors.count!=locations.count)) return;
    [self xfQuartz2D_AddColorGradientEffectRadial:YES Colors:colors Locations:locations
                                       StartPoint:startPoint StartRadius:startRadius
                                         EndPoint:endPoint EndRadius:endRadius
                                      ClipToRects:clipToRects Options:options];
}

#pragma mark ==================== Private ====================
#pragma mark === 线性 & 径向 渐变生成统一方法 ===
- (void)xfQuartz2D_AddColorGradientEffectRadial:(BOOL)radial
                                         Colors:(NSArray<UIColor *> *)colors
                                      Locations:(NSArray<NSNumber *> *)locations
                                     StartPoint:(CGPoint)startPoint
                                    StartRadius:(CGFloat)startRadius
                                       EndPoint:(CGPoint)endPoint
                                      EndRadius:(CGFloat)endRadius
                                    ClipToRects:(NSArray<NSValue *> *)clipToRects
                                        Options:(CGGradientDrawingOptions)options {
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

#pragma mark - Other Quick Methods
+ (UIImage *)XF_GenerateColorGradientEffectImageColors:(NSArray<UIColor *> *)colors
                                             Locations:(NSArray<NSNumber *> *)locations
                                            StartPoint:(CGPoint)startPoint
                                              EndPoint:(CGPoint)endPoint
                                                  Size:(CGSize)size {

    UIView *colorGradientEffectImageView = [UIView XF_ViewWithColor:[UIColor clearColor]
                                                              Frame:CGRectMake(0, 0, size.width,
                                                                               size.height)];

    [colorGradientEffectImageView xf_AddColorGradientEffectColors:colors Locations:locations
                                                       StartPoint:startPoint EndPoint:endPoint
                                                            Frame:colorGradientEffectImageView.bounds];
    UIImage *colorGradientEffectImage = [colorGradientEffectImageView xf_TransformToImage];
    return colorGradientEffectImage;
}

- (void)xf_AddShadowEffectColor:(UIColor *)color Offset:(CGSize)offset Radius:(CGFloat)radius
                        Opacity:(CGFloat)opacity {

    self.layer.shadowColor  = color.CGColor;
    self.layer.shadowOffset  = offset;
    self.layer.shadowRadius  = radius;
    self.layer.shadowOpacity = opacity;
}
- (void)xf_AddShadowEffectColor:(UIColor *)color Offset:(CGSize)offset Path:(UIBezierPath *)path
                        Opacity:(CGFloat)opacity {

    self.layer.shadowColor  = color.CGColor;
    self.layer.shadowOffset  = offset;
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowOpacity = opacity;
}

- (CAGradientLayer *)xf_AddColorGradientEffectColors:(NSArray<UIColor *> *)colors
                                           Locations:(NSArray<NSNumber *> *)locations
                                          StartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint
                                               Frame:(CGRect)frame {

    //[NSArray arrayWithObjects:(id)ESColor(0x17d8a8, 1.0f).CGColor, \
                                (id)ESColor(0x00bfbb, 1.0f).CGColor];
    NSMutableArray* newColors = [NSMutableArray array];
    for (UIColor* color in colors) {
        [newColors addObject:(id)color.CGColor];
    }
    colors = [newColors copy];

    CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.colors = colors;
    gradient.locations = locations;//@[@0, @1];
    gradient.startPoint = startPoint;//CGPointMake(0, 0);
    gradient.endPoint = endPoint;//CGPointMake(1, 1);
    [self.layer insertSublayer:gradient atIndex:0];
    return gradient;
}

- (CAShapeLayer *)xf_AddDashLineBorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor
                                DashPattren:(CGFloat)dashPattern IsRound:(BOOL)isRound {

    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.cornerRadius = self.layer.cornerRadius;
    borderLayer.bounds = CGRectMake(0, 0, self.frame.size.width-1, self.frame.size.height-1);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    if (isRound)
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds
                                                      cornerRadius:CGRectGetWidth(borderLayer.bounds)/2].CGPath;
    else
        borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;

    borderLayer.lineWidth = borderWidth; //self.borderLayer.lineDashPattern = nil;
    borderLayer.lineDashPattern = @[@(dashPattern), @(dashPattern)];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    [self.layer addSublayer:borderLayer];
    return borderLayer;
}

- (UIColor *)xf_ColorAtPixelPoint:(CGPoint)point Alpha:(CGFloat)alpha {
    if (!CGRectContainsPoint(self.bounds, point)) {
        return nil;
    }

    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedLast);

    CGContextTranslateCTM(context, -point.x, -point.y);

    [self.layer renderInContext:context];

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    CGFloat red   = pixel[0]/255.0;
    CGFloat green = pixel[1]/255.0;
    CGFloat blue  = pixel[2]/255.0;
    //CGFloat alpha = pixel[3]/255.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIImage *)xf_TransformToImage {
    //  下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。 \
        第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIViewController *)xf_FindViewController {
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}
- (UIWindow *)xf_FindWindow {
    UIViewController *viewController = [self xf_FindViewController];
    return viewController.view.window;
}
- (CGRect)xf_GetRelativeFrame {
    UIWindow* selfWindow = [self xf_FindWindow];
    if (selfWindow) {
        CGRect rect = [self.superview convertRect:self.frame toView:selfWindow];
        rect = [selfWindow convertRect:self.frame fromView:self.superview];
        return rect;
    }

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (!([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)) screenHeight -= 20;

    UIView* view = self;
    CGFloat x = 0;
    CGFloat y = 0;

    while (YES) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;

        view = view.superview;

        if (view == nil || [view isKindOfClass:[UIWindow class]]) break;

        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    CGRect r = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
    return r;
}

#pragma mark - basics
- (CGFloat)xf_GetX {
    return CGRectGetMinX(self.frame);
}
- (CGFloat)xf_GetY {
    return CGRectGetMinY(self.frame);
}
- (CGFloat)xf_GetWidth {
    return CGRectGetWidth(self.frame);
}
- (CGFloat)xf_GetHeight {
    return CGRectGetHeight(self.frame);
}
- (CGFloat)xf_GetTop {
    return [self xf_GetY];
}
- (CGFloat)xf_GetLeft {
    return [self xf_GetX];
}
- (CGFloat)xf_GetBottom {
    return [self xf_GetY]+[self xf_GetHeight];
}
- (CGFloat)xf_GetRight {
    return [self xf_GetX]+[self xf_GetWidth];
}
- (void)xf_SetX:(CGFloat)x {
    self.frame = CGRectMake(x, [self xf_GetY], [self xf_GetWidth], [self xf_GetHeight]);
}
- (void)xf_SetY:(CGFloat)y {
    self.frame = CGRectMake([self xf_GetX], y, [self xf_GetWidth], [self xf_GetHeight]);
}
- (void)xf_SetWidth:(CGFloat)width {
    self.frame = CGRectMake([self xf_GetX], [self xf_GetY], width, [self xf_GetHeight]);
}
- (void)xf_SetHeight:(CGFloat)height {
    self.frame = CGRectMake([self xf_GetX], [self xf_GetY], [self xf_GetWidth], height);
}

@end
