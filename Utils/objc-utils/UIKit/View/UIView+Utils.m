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

@end
