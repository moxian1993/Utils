//
//  UIButton+FadeOut.m
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIButton+FadeOut.h"

@implementation UIButton (FadeOut)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.alpha = 0.3;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        }];
    }];
    [super touchesEnded:touches withEvent:event];
}


@end
