//
//  UIView+Transform.h
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Transform)

/**
代码截图
@param view 支持UIView及其子类
@param cropRect 裁剪区域
@return 裁剪完成的图片
*/
// Captured in app, Maybe without considering the Pixels
+ (UIImage *)capture:(id)view cropRect:(CGRect)cropRect;
+ (UIImage *)captureView:(UIView *)view;
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;
+ (UIImage *)captureTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
