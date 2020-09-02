//
//  NSString+URL.h
//  CommonFramework
//
//  Created by zhuwei on 15/2/7.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 URL编码解码扩展
 
 */
@interface NSString (URL)

/**
 url编码
 
 @return 返回编码后的字符串
 */
- (NSString *)encodeURL;

/**
 url解码
 
 @return 返回解码后的字符串
 */
- (NSString *)decodeURL;

@end
