//
//  MKCustomDeleteStyleTableView.m
//  SkinAnalyzerNative-iOS
//
//  Created by hsx on 2019/2/27.
//

#import "MKCustomDeleteStyleTableView.h"
#import <NerdyUI.h>

@implementation MKCustomDeleteStyleTableView {
    UIImage *_icon;
    UIColor *_color;
    CGSize _size;
}

- (instancetype)initWithDeleteIcon:(UIImage *)icon iconSize:(CGSize)size iconBgColor:(nonnull UIColor *)color {
    if (self = [super init]) {
        _icon = icon;
        _color = color;
        _size = size;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (@available(iOS 11.0, *)) {
        [self configIOS11ForCustomCellButton];
    }
}

- (void)configIOS11ForCustomCellButton{
    for (UIView *subview in self.subviews) {
        if([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]){
            subview.backgroundColor = _color;
            NSArray* btns = subview.subviews.filter(^(UIView* kidView) {
                return [kidView isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")];
            });
            
            for (UIButton* btn in btns) {
                for (UIView* v in btn.subviews) {
                    v.backgroundColor = _color;
                }

                btn.str(nil);
                [btn setValue:_color forKey:@"_defaultBackgroundColor"];
                [btn setValue:_color forKey:@"_highlightedBackgroundColor"];
            }
            
            CGFloat btnW = 74;
            CGFloat left = (btnW - _size.width)/2.0;
            ImageView.img(_icon).addTo(subview).fixWH(_size.width, _size.height).makeCons(^{
                make.centerY.equal.superview.constants(0);
                make.left.equal.superview.constants(left);
            });
        }
    }
}


@end
