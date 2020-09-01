//
//  UIViewController+CurrentVC.h
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CurrentVC)

/**
 获取当前实现的ViewController(非navVC、tabBarVC)
 
 @return currentVC
 */
+ (UIViewController *)getCurrentVC;

@end

NS_ASSUME_NONNULL_END
