//
//  CALayer+Utils.h
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Utils)


/// 创建渐变色layer
/// @param colors 颜色
/// @param locations 位置 @[@0, @1]
/// @param startPoint 起点
/// @param endPoint 终点
/// @param frame frame
+ (CAGradientLayer *)createGradientLayerWithColors:(NSArray<UIColor *> *)colors
                                         locations:(NSArray<NSNumber *> *)locations
                                        startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
                                             frame:(CGRect)frame;






@end

NS_ASSUME_NONNULL_END
