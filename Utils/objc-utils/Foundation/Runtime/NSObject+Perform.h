//
//  NSObject+Perform.h
//  DictPublishAssistant
//
//  Created by zhuwei on 15/3/6.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Perform)

/// 正向调用 self.class -> self.superClass -> ... -> NSObject
/// @param sel sel
- (void)performSelectorAlongChain:(SEL)sel;

/// 反向调用
/// @param sel NSObject -> ... -> self.class
- (void)performSelectorAlongChainReversed:(SEL)sel;

- (void)performMsgSendWithTarget:(id)target sel:(SEL)sel signal:(id)signal;
- (BOOL)performMsgSendWithTarget:(id)target sel:(SEL)sel;

@end
