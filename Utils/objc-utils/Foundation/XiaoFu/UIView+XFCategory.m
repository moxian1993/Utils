//
//  UIView+XFCategory.m
//  XiaoFuTechBasic
//
//  Created by xiaofutech on 2017/9/25.
//  Copyright © 2017年 XiaoFu. All rights reserved.
//

#import "UIView+XFCategory.h"

@implementation UIView (XFCategory)

#pragma mark - basics
- (CGFloat)xf_GetX {
    return CGRectGetMinX(self.frame);
}
- (CGFloat)xf_GetY {
    return CGRectGetMinY(self.frame);
}
- (CGFloat)xf_GetWidth {
    return CGRectGetWidth(self.frame);
}
- (CGFloat)xf_GetHeight {
    return CGRectGetHeight(self.frame);
}
- (CGFloat)xf_GetTop {
    return [self xf_GetY];
}
- (CGFloat)xf_GetLeft {
    return [self xf_GetX];
}
- (CGFloat)xf_GetBottom {
    return [self xf_GetY]+[self xf_GetHeight];
}
- (CGFloat)xf_GetRight {
    return [self xf_GetX]+[self xf_GetWidth];
}
- (void)xf_SetX:(CGFloat)x {
    self.frame = CGRectMake(x, [self xf_GetY], [self xf_GetWidth], [self xf_GetHeight]);
}
- (void)xf_SetY:(CGFloat)y {
    self.frame = CGRectMake([self xf_GetX], y, [self xf_GetWidth], [self xf_GetHeight]);
}
- (void)xf_SetWidth:(CGFloat)width {
    self.frame = CGRectMake([self xf_GetX], [self xf_GetY], width, [self xf_GetHeight]);
}
- (void)xf_SetHeight:(CGFloat)height {
    self.frame = CGRectMake([self xf_GetX], [self xf_GetY], [self xf_GetWidth], height);
}

@end
