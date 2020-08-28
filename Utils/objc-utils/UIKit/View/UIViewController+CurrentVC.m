//
//  UIViewController+CurrentVC.m
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIViewController+CurrentVC.h"

@implementation UIViewController (CurrentVC)

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [UIViewController _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [UIViewController _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIViewController _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIViewController _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


@end
