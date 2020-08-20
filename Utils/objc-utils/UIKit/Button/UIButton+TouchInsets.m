//
//  UIButton+TouchInsets.m
//  Utils
//
//  Created by Xian Mo on 2020/8/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIButton+TouchInsets.h"
#import "UtilsPrivate.h"

@implementation UIButton (TouchInsets)

UTILS_SYNTHESIZE_STRUCT(touchInsets, setTouchInsets, UIEdgeInsets);

+ (void)load {
    [self utils_swizzleMethod:@selector(pointInside:withEvent:) withMethod:@selector(utils_pointInsied:withEvent:)];
}

- (BOOL)utils_pointInsied:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchInsets = self.touchInsets;
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, touchInsets);
    return CGRectContainsPoint(rect, point);
}







@end
