//
//  UIView+TransactionFromTo.h
//  Pods
//
//  Created by guanxiaobai on 15/12/14.
//
//

#import <UIKit/UIKit.h>

@interface UIView (TransactionFromTo)

/**
*  放大动画效果
*
*  @param fromView      从那个视图
*  @param toView        目标视图
*  @param originalPoint 从哪个点开始放大
*  @param duration      动画时间
*  @param block         动画完成执行时间
*/
+ (void)inflateTransitionFromView:(UIView *)fromView
                           toView:(UIView *)toView
                    originalPoint:(CGPoint)originalPoint
                         duration:(NSTimeInterval)duration
                       completion:(void (^)(void))block;

+ (void)animationFromView:(UIView *)fromView
                   ToView:(UIView *)toView
             successBlock:(void(^)())successBlock;

@end
