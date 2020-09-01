//
//  UIImage+Capture.m
//  Utils
//
//  Created by Xian Mo on 2020/9/1.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIImage+Capture.h"

@implementation UIImage (Capture)

/// 全屏截图
+ (UIImage *)captureScreen {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)capture:(id)view cropRect:(CGRect)cropRect {
    UIImage *image = nil;
    /* 转换成完整图片 */
    if ([view isKindOfClass:[UITableView class]]) {
        image = [self captureTableView:view];
    } else if ([view isKindOfClass:[UIScrollView class]]) {
        image = [self captureScrollView:view];
    } else if ([view isKindOfClass:[UIView class]]) {
        image = [self captureView:view];
    } else {
        return nil;
    }
    /* 截图操作 */
    if (cropRect.size.width>0
        && cropRect.size.height>0) {
        cropRect = CGRectMake(cropRect.origin.x*image.scale,
                              cropRect.origin.y*image.scale,
                              cropRect.size.width*image.scale,
                              cropRect.size.height*image.scale);

        CGImageRef sourceImageRef = image.CGImage;
        CGImageRef targetImageRef = CGImageCreateWithImageInRect(sourceImageRef, cropRect);
        image = [UIImage imageWithCGImage:targetImageRef];
        CGImageRelease(sourceImageRef);
        CGImageRelease(targetImageRef);
    }
    return image;
}


+ (UIImage *)captureView:(UIView *)view {
    /**
     第一个参数表示区域大小。
     第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。
     第三个参数就是屏幕密度了，关键就是第三个参数
     */
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)captureScrollView:(UIScrollView *)scrollView {
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame =  scrollView.frame;

        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);

        [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();

        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)captureTableView:(UITableView *)tableView {
    CGPoint savedContentOffset = tableView.contentOffset;
    ///计算画布所需实际高度
    CGFloat contentHeight = 0;
    if (tableView.tableHeaderView)
        contentHeight += tableView.tableHeaderView.frame.size.height;
    {
        NSInteger sections = tableView.numberOfSections;
        for (NSInteger i = 0; i < sections; i++) {
            contentHeight += [tableView rectForHeaderInSection:i].size.height;

            NSInteger rows = [tableView numberOfRowsInSection:i];
            {
                for (NSInteger j = 0; j < rows; j++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    contentHeight += cell.frame.size.height;
                }
            }
            contentHeight += [tableView rectForFooterInSection:i].size.height;
        }
    }
    if (tableView.tableFooterView)
        contentHeight += tableView.tableFooterView.frame.size.height;

    ///创建画布
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tableView.frame.size.width, contentHeight), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    ///把所有的视图 render到CGContext上
    if (tableView.tableHeaderView) {
        contentHeight = tableView.tableHeaderView.frame.size.height;
        tableView.contentOffset = CGPointMake(0, contentHeight);
        [tableView.tableHeaderView.layer renderInContext:ctx];
        CGContextTranslateCTM(ctx, 0, tableView.tableHeaderView.frame.size.height);
    }

    NSInteger sections = tableView.numberOfSections;
    for (NSInteger i = 0; i < sections; i++) {
        ///sectionHeader
        contentHeight += [tableView rectForHeaderInSection:i].size.height;
        tableView.contentOffset = CGPointMake(0, contentHeight);
        UIView *headerView = [tableView headerViewForSection:i];
        if (headerView) {
            [headerView.layer renderInContext:ctx];
            CGContextTranslateCTM(ctx, 0, headerView.frame.size.height);
        }
        ///Cell
        NSInteger rows = [tableView numberOfRowsInSection:i];
        {
            for (NSInteger j = 0; j < rows; j++) {
                //讓該cell被正確的產生在tableView上, 之後才能在CGContext上正確的render出來
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                contentHeight += cell.frame.size.height;
                [cell.layer renderInContext:ctx];
                CGContextTranslateCTM(ctx, 0, cell.frame.size.height);
            }
        }
        ///sectionFooter
        contentHeight += [tableView rectForFooterInSection:i].size.height;
        tableView.contentOffset = CGPointMake(0, contentHeight);
        UIView *footerView = [tableView footerViewForSection:i];
        if (footerView) {
            [footerView.layer renderInContext:ctx];
            CGContextTranslateCTM(ctx, 0, footerView.frame.size.height);
        }
    }

    if (tableView.tableFooterView) {
        tableView.contentOffset = CGPointMake(0, tableView.contentSize.height-tableView.frame.size.height);
        [tableView.tableFooterView.layer renderInContext:ctx];
        //CGContextTranslateCTM(ctx, 0, tableView.tableFooterView.frame.size.height);
    }

    ///生成UIImage对象
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    tableView.contentOffset = savedContentOffset;
    return image;
}

@end
