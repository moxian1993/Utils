//
//  UIView+Utils.m
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIView+Utils.h"
#import "UIImage+Capture.h"

@implementation UIView (Utils)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
    
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}


- (CGFloat)bottom {
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}



- (UIViewController *)findViewController {
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:UIViewController.class]) {
            break;
        }
    }
    return target;
}

- (UIWindow *)findWindow {
    UIViewController *viewController = [self findViewController];
    return viewController.view.window;
}


- (void)addShadowWithColor:(UIColor *)color
                    offset:(CGSize)offset
                      path:(UIBezierPath *)path
                   opacity:(CGFloat)opacity {
    self.layer.shadowColor  = color.CGColor;
    self.layer.shadowOffset  = offset;
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowOpacity = opacity;
}


- (CGRect)getRelativeFrame {
    UIWindow* selfWindow = [self findWindow];
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


- (UIColor *)colorAtPixelPoint:(CGPoint)point Alpha:(CGFloat)alpha {
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


- (UIImage *)transformToImage {
    return [UIImage captureView:self];
}


/// 创建一张实时模糊效果 View (毛玻璃效果)
/// @param frame frame
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
    view.frame = frame;
    return view;
}


/// 绘制虚线
/// @param lineFrame 虚线的 frame
/// @param length 虚线中短线的宽度
/// @param spacing 虚线中短线之间的间距
/// @param color 虚线中短线的颜色
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color {
    UIView *dashedLine = [[UIView alloc] initWithFrame:lineFrame];
    dashedLine.backgroundColor = [UIColor clearColor];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:dashedLine.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(dashedLine.frame) / 2, CGRectGetHeight(dashedLine.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(dashedLine.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:length], [NSNumber numberWithInt:spacing], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(dashedLine.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [dashedLine.layer addSublayer:shapeLayer];
    return dashedLine;
}



@end
