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




@end
