//
//  MORollingView.h
//  Utils
//
//  Created by Xian Mo on 2020/8/27.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 走马灯 */
@interface MORollingView : UIView

- (instancetype)initWithText:(NSString *)text
                        font:(UIFont *)font
                   textColor:(UIColor *)color
               startLocation:(CGFloat) location
                     spacing:(CGFloat)spacing
                       speed:(CGFloat)speed;

- (void)start;
- (void)pause;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
