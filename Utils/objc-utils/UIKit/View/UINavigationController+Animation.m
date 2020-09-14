//
//  UINavigationController+Animation.m
//  Community
//
//  Created by xujia on 16/4/29.
//  Copyright © 2016年 MaryKayChina. All rights reserved.
//

#import "UINavigationController+Animation.h"

//@interface UINavigationController () <CAAnimationDelegate>
//
//@end

@implementation UINavigationController (Animation)

- (void)pushViewController:(UIViewController *)viewController from:(NSString *)direction {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = direction;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:@"push"];
    [self pushViewController:viewController animated:NO];
}

- (void)popViewControllerFrom:(NSString *)direction {
    [self addPopAnimation:direction];
    [self popViewControllerAnimated:NO];
}

- (void)popToRootViewControllerFrom:(NSString *)direction {
    [self addPopAnimation:direction];
    [self popToRootViewControllerAnimated:NO];
}

- (void)addPopAnimation:(NSString *)direction {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = direction;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:@"pop"];
}

@end
