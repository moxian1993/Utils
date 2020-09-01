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
