//
//  YYImage+LoopCount.m
//  Utils
//
//  Created by Mo on 2017/8/4.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import "YYImage+LoopCount.h"
#import <objc/runtime.h>

@implementation YYImage (LoopCount)

- (void)setLoopCount:(NSUInteger)loopCount {
    objc_setAssociatedObject(self, @selector(loopCount), @(loopCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)loopCount {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

/** 分类的前向引用 */
- (NSUInteger)animatedImageLoopCount {
    return self.loopCount;
}



@end
