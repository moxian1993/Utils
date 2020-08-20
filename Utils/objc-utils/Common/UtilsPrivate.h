//
//  UtilsPrivate.h
//  Utils
//
//  Created by Xian Mo on 2020/8/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define UTILS_SYNTHESIZE_STRUCT(getter, setter, type, ...) \
- (type)getter {\
return [objc_getAssociatedObject(self, _cmd) type##Value];\
}\
\
- (void)setter:(type)getter {\
objc_setAssociatedObject(self, @selector(getter), [NSValue valueWith##type:getter], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
__VA_ARGS__;\
}

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (UtilsPrivate)

+ (BOOL)utils_swizzleMethod:(SEL)selector1 withMethod:(SEL)selector2;

@end

NS_ASSUME_NONNULL_END
