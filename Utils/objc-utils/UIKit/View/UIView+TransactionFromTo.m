//
//  UIView+TransactionFromTo.m
//  Pods
//
//  Created by guanxiaobai on 15/12/14.
//
//

#import "UIView+TransactionFromTo.h"

@implementation UIView (TransactionFromTo)

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
                       completion:(void (^)(void))block {
    UIView* superView = [toView superview];
    UIImage* fromShotCutImage = [fromView shotCutImage];
    UIImage* toShotCutImage = [toView shotCutImage];
    
    UIView* anmiationView = [[UIView alloc] init];
    anmiationView.backgroundColor = [UIColor clearColor];
    [superView addSubview:anmiationView];
    [anmiationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(toView);
    }];
    [anmiationView layoutIfNeeded];
    
    CALayer* fromLayer = [CALayer layer];
    fromLayer.frame = anmiationView.bounds;
    fromLayer.contents = (id)[fromShotCutImage CGImage];
    [anmiationView.layer addSublayer:fromLayer];
    
    CALayer* toLayer = [CALayer layer];
    toLayer.frame = anmiationView.bounds;
    toLayer.contents = (id)[toShotCutImage CGImage];
    [anmiationView.layer addSublayer:toLayer];
    
    float radius = [anmiationView shapeDiameterForPoint:originalPoint];
    CAShapeLayer* toMaskLayer = [CAShapeLayer layer];
    UIBezierPath* toMaskLayerPath = [UIBezierPath bezierPathWithArcCenter:originalPoint radius:radius startAngle:0 endAngle:360 clockwise:YES];
    toMaskLayer.path = toMaskLayerPath.CGPath;
    toMaskLayer.fillColor =[UIColor blackColor].CGColor;
    toMaskLayer.strokeColor = [UIColor blackColor].CGColor;
    toMaskLayer.anchorPoint = CGPointMake(0.0, 0.0);
    toMaskLayer.frame = CGRectMake(originalPoint.x, originalPoint.y, radius + radius, radius + radius);
    
    [anmiationView.layer addSublayer:toMaskLayer];
    toLayer.mask = toMaskLayer;
    
    NSString *timingFunctionName = kCAMediaTimingFunctionDefault;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
    animation.removedOnCompletion = YES;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    animation.duration = duration;
    toMaskLayer.transform = [animation.toValue CATransform3DValue];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [anmiationView removeFromSuperview];
        if(block) block();

    }];
    
    [toMaskLayer addAnimation:animation forKey:nil];
    [CATransaction commit];
}


- (CGFloat)shapeDiameterForPoint:(CGPoint)point {
    CGPoint cornerPoints[] = { {0.0, 0.0}, {0.0, self.bounds.size.height}, {self.bounds.size.width, self.bounds.size.height}, {self.bounds.size.width, 0.0} };
    CGFloat radius = 0.0;
    for (int i = 0; i < sizeof(cornerPoints) / sizeof(CGPoint); i++) {
        CGPoint p = cornerPoints[i];
        CGFloat d = sqrt( pow(p.x - point.x, 2.0) + pow(p.y - point.y, 2.0) );
        if (d > radius) {
            radius = d;
        }
    }
    return radius;
}


+ (void)animationFromView:(UIView *)fromView
                   ToView:(UIView *)toView
             successBlock:(void (^)())successBlock {
    UIView *pView = [[UIApplication sharedApplication] keyWindow];
    //获取cell主视图在当前view中的 frame
    CGRect cellRectInView =  [fromView.superview convertRect:fromView.frame toView:pView];
    
    //截图
    UIGraphicsBeginImageContext(cellRectInView.size);
    [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView* cellImg = [[UIImageView alloc] initWithImage:img];
    cellImg.frame = cellRectInView;
    
    
    //定位起点
    CGPoint startPoint = [fromView.superview convertPoint:fromView.center toView:pView];
    
    //定位终点
    CGRect toRectInView = [toView.superview convertRect:toView.frame toView:pView];
    CGPoint endPoint = CGPointMake(toRectInView.origin.x + toRectInView.size.width / 2, toRectInView.origin.y + toRectInView.size.height / 2);
    
    //创建动画路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    
    //计算时间
    CGFloat fabX = fabs(fabs(endPoint.x) - fabs(startPoint.x));
    CGFloat fabY = fabs(fabs(endPoint.y) - fabs(startPoint.y));
    CGFloat distance = sqrtf(powf(fabX, 2.0) + powf(fabY, 2));
    CGFloat pathVelocity = 1000;
    
    //开始动画
    float duration = (float)distance / (float)pathVelocity;
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setCompletionBlock:^{
        CGPathRelease(path);
        [cellImg removeFromSuperview];
        if (successBlock) successBlock();
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:cellImg];
    CAKeyframeAnimation *pathTransAnimatin = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathTransAnimatin.path = path;
    pathTransAnimatin.duration = duration;
    pathTransAnimatin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [cellImg.layer addAnimation:pathTransAnimatin forKey:@"pathTransAnimatin"];
    
    [CATransaction commit];
}


@end
