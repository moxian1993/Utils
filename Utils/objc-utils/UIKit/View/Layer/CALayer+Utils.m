//
//  CALayer+Utils.m
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "CALayer+Utils.h"

@implementation CALayer (Utils)

+ (CAGradientLayer *)createGradientLayerWithColors:(NSArray<UIColor *> *)colors
                                         locations:(NSArray<NSNumber *> *)locations
                                        startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
                                             frame:(CGRect)frame {
    NSMutableArray* newColors = [NSMutableArray array];
    for (UIColor* color in colors) {
        [newColors addObject:(id)color.CGColor];
    }
    colors = [newColors copy];

    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.colors = colors;
    layer.locations = locations; //@[@0, @1];
    layer.startPoint = startPoint; //CGPointMake(0, 0);
    layer.endPoint = endPoint; //CGPointMake(1, 1);
    return layer;
}


- (CAShapeLayer *)addDashLineBorderWidth:(CGFloat)borderWidth
                             borderColor:(UIColor *)borderColor
                             dashPattren:(CGFloat)dashPattern
                                 isRound:(BOOL)isRound {

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.cornerRadius = self.cornerRadius;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width -1, self.frame.size.height -1);
    layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    if (isRound) {
        layer.path = [UIBezierPath bezierPathWithRoundedRect:layer.bounds cornerRadius:CGRectGetWidth(layer.bounds)/2].CGPath;
    } else {
        layer.path = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
    }

    layer.lineWidth = borderWidth; //self.borderLayer.lineDashPattern = nil;
    layer.lineDashPattern = @[@(dashPattern), @(dashPattern)];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = borderColor.CGColor;
    return layer;
}


@end
