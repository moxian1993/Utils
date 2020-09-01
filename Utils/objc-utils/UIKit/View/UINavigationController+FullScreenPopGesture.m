//
//  UINavigationController+FullScreenPopGesture.m
//  Copyright © 2018年 Mo. All rights reserved.
//

#import "UINavigationController+FullScreenPopGesture.h"
#import <objc/runtime.h>

@interface FullScreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation FullScreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    //当为根控制器时，手势不执行
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    //当push、pop动画正在执行时，手势不执行
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    //向左边(反方向)拖动，手势不执行
    CGPoint translation = [gestureRecognizer  translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    return YES;
}
@end


@implementation UINavigationController (FullScreenPopGesture)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(my_pushViewController:animated:);
        
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
    
}

- (void)my_pushViewController:(UIViewController *)viewController animated:(BOOL)animeted {
    
    //从所有的交互式手势里面找，如果自定义手势没有包含在内，就将其加入
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.my_popGestureRecognizer]) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.my_popGestureRecognizer];
        /*
         新建一个UIPanGestureRecognizer，让它的触发和系统的这个手势相同，
         这就需要利用runtime获取系统手势的target和action。
         */
        //用KVC取出target和action
        //用自定义手势替代系统原有的handleNavigationTransition:方法
        NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [targets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        
        //  将自定义的代理（手势执行条件）传给手势的delegate
        self.my_popGestureRecognizer.delegate = [self my_fullScreenPopGestureRecognizerDelegate];
        //  将target和action传给手势
        [self.my_popGestureRecognizer addTarget:internalTarget action:internalAction];
        
        //  设置系统的为NO
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    //禁用系统的交互手势
    if (![self.viewControllers containsObject:viewController]) {
        [self my_pushViewController:viewController animated:animeted];
    }
}

- (FullScreenPopGestureRecognizerDelegate *)my_fullScreenPopGestureRecognizerDelegate {
    FullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [[FullScreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

/**
 懒加载一个自定义pan手势

 @return my_popGestureRecognizer
 */
- (UIPanGestureRecognizer *)my_popGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (panGestureRecognizer == nil) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

@end
