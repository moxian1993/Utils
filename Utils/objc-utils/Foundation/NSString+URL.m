//
//  NSString+URL.m
//  CommonFramework
//
//  Created by zhuwei on 15/2/7.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

/**
 url编码
 
 @return 返回编码后的字符串
 */
- (NSString *)encodeURL {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/**
 url解码
 
 @return 返回解码后的字符串
 */
- (NSString *)decodeURL {
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
