//
//  UIViewController+Cover.h
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, kBoardContentMode) {
    kBoardContentModeBottom,
    kBoardContentModeCenter,
};

@interface UIViewController (Cover)

@property (nonatomic, readonly ,weak) UIView *cover;

- (void)setBoard:(UIView *)board contentMode:(kBoardContentMode)mode margin:(CGFloat)margin;

- (void)coverShowUp;
- (void)coverDisappear;


@end

NS_ASSUME_NONNULL_END
