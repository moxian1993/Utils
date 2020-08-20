//
//  UtilsPrivate.m
//  Utils
//
//  Created by Xian Mo on 2020/8/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UtilsPrivate.h"

@implementation NSObject (UtilsPrivate)

+ (BOOL)utils_swizzleMethod:(SEL)selector1 withMethod:(SEL)selector2 {
    Method m1 = class_getInstanceMethod(self, selector1);
    Method m2 = class_getInstanceMethod(self, selector2);
    
    if (!m1 || !m2) {
        return NO;
    }

    class_addMethod(self, selector1, method_getImplementation(m1), method_getTypeEncoding(m1));
    class_addMethod(self, selector2, method_getImplementation(m2), method_getTypeEncoding(m2));

    m1 = class_getInstanceMethod(self, selector1);
    m2 = class_getInstanceMethod(self, selector2);
    method_exchangeImplementations(m1, m2);

    return YES;
}

@end

