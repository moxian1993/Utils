//
//  UIImage+Capture.h
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// view transform to image
// Captured in app, Maybe without considering the Pixels
@interface UIImage (Capture)

/// 全屏截图
+ (UIImage *)captureScreen;

/// 代码截图
/// @param view 支持UIView及其子类
/// @param cropRect 裁剪区域
+ (UIImage *)capture:(id)view cropRect:(CGRect)cropRect;
+ (UIImage *)captureView:(UIView *)view;
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;
+ (UIImage *)captureTableView:(UITableView *)tableView;


@end

NS_ASSUME_NONNULL_END
