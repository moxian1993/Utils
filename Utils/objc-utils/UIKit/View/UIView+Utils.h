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

/**  起点x坐标  */
@property (nonatomic, assign) CGFloat x;
/**  起点y坐标  */
@property (nonatomic, assign) CGFloat y;
/**  中心点x坐标  */
@property (nonatomic, assign) CGFloat centerX;
/**  中心点y坐标  */
@property (nonatomic, assign) CGFloat centerY;
/**  宽度  */
@property (nonatomic, assign) CGFloat width;
/**  高度  */
@property (nonatomic, assign) CGFloat height;
/**  顶部  */
@property (nonatomic, assign) CGFloat top;
/**  底部  */
@property (nonatomic, assign) CGFloat bottom;
/**  左边  */
@property (nonatomic, assign) CGFloat left;
/**  右边  */
@property (nonatomic, assign) CGFloat right;
/**  size  */
@property (nonatomic, assign) CGSize size;
/**  origin */
@property (nonatomic, assign) CGPoint origin;


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

/// 创建一张实时模糊效果 View (毛玻璃效果)
/// @param frame frame
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;

/// 绘制虚线
/// @param lineFrame 虚线的 frame
/// @param length 虚线中短线的宽度
/// @param spacing 虚线中短线之间的间距
/// @param color 虚线中短线的颜色
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
