//
//  AlertUtils.h
//  Utils
//
//  Created by Mo on 2017/8/2.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertUtils : NSObject

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
+ (UIAlertController *)createAlertControllerWithTitle:(NSString *)title
                                              message:(NSString *)message
                                       preferredStyle:(UIAlertControllerStyle)preferredStyle
                                          actionArray:(NSArray <NSDictionary *> *)actionArray
                                       defaultHandler:(void(^)(UIAlertAction *action))defaultHandler
                                        cancelHandler:(void(^)(UIAlertAction *action))cancelHandler;


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
+ (UIAlertController *)createAlertControllerWithAttributedTitle:(NSMutableAttributedString *)attributedTitle
                                              attributedMessage:(NSMutableAttributedString *)attributedMessage
                                                 preferredStyle:(UIAlertControllerStyle)preferredStyle
                                                    actionArray:(NSArray <NSDictionary *> *)actionArray
                                                 defaultHandler:(void(^)(UIAlertAction *action))defaultHandler
                                                  cancelHandler:(void(^)(UIAlertAction *action))cancelHandler;

@end
