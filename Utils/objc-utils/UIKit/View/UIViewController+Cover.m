//
//  UIViewController+Cover.m
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIViewController+Cover.h"
#import <objc/runtime.h>
#import <NerdyUI.h>

static void *coverKey = @"coverKey";
static void *boardKey = @"boardKey";
static void *modeKey = @"modeKey";
static void *bottomMarginKey = @"bottomMarginKey";

@implementation UIViewController (Cover)

- (UIView *)cover {
    return objc_getAssociatedObject(self, coverKey);
}


- (void)setBoard:(UIView *)board contentMode:(kBoardContentMode)mode margin:(CGFloat)margin {
    UIView *cover = View.bgColor(@"black, 0.6");
    board.addTo(cover);
    
    if (mode == kBoardContentModeCenter) {
        board.makeCons(^{
            make.center.equal.superview.constants(0);
        });
    } else {
        board.makeCons(^{
            make.centerX.equal.superview.constants(0);
            make.bottom.equal.superview.constants(-margin);
        });
    }
    
    cover.alpha = 0;
    board.alpha = 0;
    
    objc_setAssociatedObject(board, modeKey, @(mode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(board, bottomMarginKey, @(margin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, boardKey, board, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, coverKey, cover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)coverShowUp {
    UIView *cover = objc_getAssociatedObject(self, coverKey);
    UIView *board = objc_getAssociatedObject(self, boardKey);
    cover.embedIn(UIApplication.sharedApplication.keyWindow);
    
    kBoardContentMode mode = [objc_getAssociatedObject(board, modeKey) integerValue];
    if (mode == kBoardContentModeCenter) {
        [UIView animateWithDuration:0.3 animations:^{
            board.alpha = 1;
            cover.alpha = 1;
        }];
    } else {
        CGFloat h = board.h;
        if (h <= 0) {
            [board layoutIfNeeded];
            h = board.h;
        }
        
        CGFloat margin = [objc_getAssociatedObject(board, bottomMarginKey) floatValue];
        board.transform = CGAffineTransformMakeTranslation(0, h + margin);
        [UIView animateWithDuration:0.3 animations:^{
            board.transform = CGAffineTransformIdentity;
            board.alpha = 1;
            cover.alpha = 1;
        }];
    }
}


- (void)coverDisappear {
    UIView *cover = objc_getAssociatedObject(self, coverKey);
    UIView *board = objc_getAssociatedObject(self, boardKey);
    
    kBoardContentMode mode = [objc_getAssociatedObject(board, modeKey) integerValue];
    if (mode == kBoardContentModeCenter) {
        [UIView animateWithDuration:0.3 animations:^{
            cover.alpha = 0;
            board.alpha = 0;
        } completion:^(BOOL finished) {
            [board removeFromSuperview];
            [cover removeFromSuperview];
        }];
        
    } else {
        CGFloat h = board.h;
        if (h <= 0) {
            [board layoutIfNeeded];
            h = board.h;
        }
        
        CGFloat margin = [objc_getAssociatedObject(board, bottomMarginKey) floatValue];
        [UIView animateWithDuration:0.3 animations:^{
            board.transform = CGAffineTransformMakeTranslation(0, h + margin);
            cover.alpha = 0;
            board.alpha = 0;
        } completion:^(BOOL finished) {
            [board removeFromSuperview];
            [cover removeFromSuperview];
        }];
    }
}


@end
