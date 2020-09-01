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

+ (CAGradientLayer *)createGradientLayerWithColors:(NSArray<UIColor *> *)colors
                                         locations:(NSArray<NSNumber *> *)locations
                                        startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
                                             frame:(CGRect)frame;


/** 添加边缘虚线 */
- (CAShapeLayer *)addDashLineBorderWidth:(CGFloat)borderWidth
                             borderColor:(UIColor *)borderColor
                             dashPattren:(CGFloat)dashPattern
                                 isRound:(BOOL)isRound;



@end

NS_ASSUME_NONNULL_END
