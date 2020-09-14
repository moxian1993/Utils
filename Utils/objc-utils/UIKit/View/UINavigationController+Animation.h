//
//  UINavigationController+Animation.h
//  Community
//
//  Created by xujia on 16/4/29.
//  Copyright © 2016年 MaryKayChina. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (Animation) <CAAnimationDelegate>

/*!
 *  @author xujia, 16-04-29 11:04:08
 *
 *  @brief push or pop viewController from different directions
 *
 *  @param viewController the viewController which you want to push
 *  @param direction    Please use:  kCATransitionFromRight
									 kCATransitionFromLeft
									 kCATransitionFromTop
									 kCATransitionFromBottom
 */
- (void)pushViewController:(UIViewController *)viewController from:(NSString *)direction;
- (void)popViewControllerFrom:(NSString *)direction;
- (void)popToRootViewControllerFrom:(NSString *)direction;

@end
