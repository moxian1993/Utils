//
//  UIView+Utils.h
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Utils)


// 找到当前 view 所在的 viewController
- (UIViewController *)findViewController;
- (UIWindow *)findWindow;

// 使用 path 添加阴影可减少离屏渲染，但每次frame 改变都需要重绘
- (void)addShadowWithColor:(UIColor *)color
                    offset:(CGSize)offset
                      path:(UIBezierPath *)path
                   opacity:(CGFloat)opacity;

// 相对 window(或屏幕) 位置
- (CGRect)getRelativeFrame;

// 某点的颜色
- (UIColor *)colorAtPixelPoint:(CGPoint)point Alpha:(CGFloat)alpha;

// view transform to image
- (UIImage *)transformToImage;

@end

NS_ASSUME_NONNULL_END
