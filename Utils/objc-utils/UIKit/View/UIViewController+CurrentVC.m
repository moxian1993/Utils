//
//  UIViewController+CurrentVC.m
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIViewController+CurrentVC.h"

@implementation UIViewController (CurrentVC)

+ (UIViewController *)getCurrentVC {
    UIViewController *targetVC;
    targetVC = [UIViewController findCurrentVC:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (targetVC.presentedViewController) {
        targetVC = [UIViewController findCurrentVC:targetVC.presentedViewController];
    }
    return targetVC;
}

+ (UIViewController *)findCurrentVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIViewController findCurrentVC:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIViewController findCurrentVC:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


///** 获取当前控制器 */
//+ (UIViewController *)getCurrentVC {
//
//    UIViewController *currentVC = nil;
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//
//    if (window.windowLevel != UIWindowLevelNormal) {
//        //statusBar,alert
//        NSArray <UIWindow *> *windows = [[UIApplication sharedApplication] windows];
//        for (UIWindow *tempWin in windows) {
//            //search a normal window
//            if (tempWin.windowLevel == UIWindowLevelNormal) {
//                window = tempWin;
//                break;
//            }
//        }
//    }
//    id nextResponder;
//
//    if (@available(iOS 10.0, *)) {
//        window = AppDelegate.window;
//         UIViewController *vc = window.rootViewController;
//         nextResponder =  vc;
//    }else{
//
//         UIView *fontView = [[window subviews] objectAtIndex:0];
//         nextResponder = [fontView nextResponder];
//    }
//    if ([nextResponder isKindOfClass:[UIViewController class]]) {
//        currentVC = nextResponder;
//    } else {
//        currentVC = window.rootViewController;
//    }
//    return currentVC;
//}



@end
