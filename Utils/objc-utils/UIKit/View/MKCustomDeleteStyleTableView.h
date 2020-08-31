//
//  MKCustomDeleteStyleTableView.h
//  SkinAnalyzerNative-iOS
//
//  Created by hsx on 2019/2/27.
//

#import "MKRefreshTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCustomDeleteStyleTableView : MKRefreshTableView

- (instancetype)initWithDeleteIcon:(UIImage *)icon iconSize:(CGSize)size iconBgColor:(nonnull UIColor *)color;

/** 实现以下方法开启侧滑删除功能 并兼容 iOS 11 之前版本
#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 兼容iOS 10(1): 点击按钮cell归位
    tableView.editing = NO;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"       " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    // 此处要给颜色
    action.backgroundColor = target color;
    return @[action];
}

 // 兼容iOS 10(2): 在cell的实现中重写
- (void)didTransitionToState:(UITableViewCellStateMask)state {
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        if (@available(iOS 11.0, *)) {
            return;
        }
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
                UIButton *metaBtn = view.subviews[0];
                ImageView.img(Img(@"icon_clear_feedback").resize(24 *MKScale, 22 *MKScale)).addTo(metaBtn).fitSize.makeCons(^{
                    make.center.equal.superview.constants(0);
                });
            }
        }
    }
}
 */

@end

NS_ASSUME_NONNULL_END
