//
//  NumberFormatterUtils.m
//  Utils
//
//  Created by Mo on 2017/8/22.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import "NumberFormatterUtils.h"

@implementation NumberFormatterUtils


/**
 得到过滤后的纯数字字符串(负数带"-")

 @param number string
 @return filtered number string
 */
+ (NSString *)numberFilteredWithString:(NSString *)number {
    
    if (number == nil || number.length == 0) {
        return number;
    }
    NSString *prefix = [number hasPrefix:@"-"] ? @"-" : @"";
    NSMutableString *filter = [NSMutableString string];
    for(int i = 0; i < number.length; i ++) {
        char c = [number characterAtIndex:i];
        if( ( c < '0' || c > '9' ) && c != '.') {
            continue;
        }
        [filter appendString:[NSString stringWithUTF8String:&c]];
    }
    return [prefix stringByAppendingString:filter.copy];
}


/**
 money格式化(zh_CN)

 @param number money
 @return formatted monery string
 */
+ (NSString *)moneyFormatWithString:(NSString *)number {
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    
    NSLocale *zhLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [format setLocale:zhLocale];
    
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setRoundingMode:NSNumberFormatterRoundHalfUp];
    [format setMaximumFractionDigits:2];
    [format setMinimumFractionDigits:2];
    
    NSString *string =[format stringFromNumber:@(number.doubleValue)];
    return [self numberFilteredWithString:string];
}


/**
 money格式化(zh_CN)

 @param value money value
 @return formatted monery value
 */
+ (double)moneyFormatWithValue:(double)value {
    return [self moneyFormatWithString:[NSString stringWithFormat:@"%lf",value]].doubleValue;
}






@end
