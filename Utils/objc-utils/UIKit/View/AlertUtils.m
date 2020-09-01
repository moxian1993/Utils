//
//  AlertUtils.m
//  Utils
//
//  Created by Mo on 2017/8/2.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import "AlertUtils.h"

@implementation AlertUtils

/**
 快捷创建弹窗
 
 @param title 标题
 @param message 内容
 @param preferredStyle 样式
 @param actionArray @[@{@"title":@"按钮文字", @"style":@"0是default,1是取消", @"color":@"按钮颜色"}];
 @param defaultHandler 确认handler
 @param cancelHandler 取消handler
 @return instance of UIAlertController
 */
+ (UIAlertController *)createAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actionArray:(NSArray <NSDictionary *> *)actionArray defaultHandler:(void(^)(UIAlertAction *action))defaultHandler cancelHandler:(void(^)(UIAlertAction *action))cancelHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    for (NSDictionary *dict in actionArray) {
        NSString *title = dict[@"title"];
        NSString *style = dict[@"style"];
        UIColor *color = dict[@"color"];
        
        UIAlertAction *action;
        if (style.length == 0 || [style isEqualToString:@"0"] || [style isEqualToString:@"UIAlertActionStyleDefault"] ) {
            action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:defaultHandler];
        } else {
            action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:cancelHandler];
        }
        [action setValue:color forKey:@"_titleTextColor"];
        [alert addAction:action];
    }
    return alert;
}


/**
 快捷创建自定义文案弹窗
 
 @param attributedTitle 属性本文标题
 @param attributedMessage 属性文本内容
 @param preferredStyle 样式
 @param actionArray @[@{@"title":@"按钮文字", @"style":@"0是default,1是取消", @"color":@"按钮颜色"}];
 @param defaultHandler 确认handler
 @param cancelHandler 取消handler
 @return instance of UIAlertController
 */
+ (UIAlertController *)createAlertControllerWithAttributedTitle:(NSMutableAttributedString *)attributedTitle attributedMessage:(NSMutableAttributedString *)attributedMessage preferredStyle:(UIAlertControllerStyle)preferredStyle actionArray:(NSArray <NSDictionary *> *)actionArray defaultHandler:(void(^)(UIAlertAction *action))defaultHandler cancelHandler:(void(^)(UIAlertAction *action))cancelHandler {
    
    UIAlertController *alert = [self createAlertControllerWithTitle:nil message:nil preferredStyle:preferredStyle actionArray:actionArray defaultHandler:defaultHandler cancelHandler:cancelHandler];
    
    [alert setValue:attributedTitle forKey:@"attributedTitle"];
    [alert setValue:attributedMessage forKey:@"attributedMessage"];
    
    return alert;
}


@end
