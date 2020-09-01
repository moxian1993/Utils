//
//  NumberFormatterUtils.h
//  Utils
//
//  Created by Mo on 2017/8/22.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberFormatterUtils : NSObject

/**
 得到过滤后的纯数字字符串(负数带"-")
 
 @param number string
 @return filtered number string
 */
+ (NSString *)numberFilteredWithString:(NSString *)number;


/**
 money格式化(zh_CN)
 
 @param number money
 @return formatted monery string
 */
+ (NSString *)moneyFormatWithString:(NSString *)number;


/**
 money格式化(zh_CN)
 
 @param value money value
 @return formatted monery value
 */
+ (double)moneyFormatWithValue:(double)value;




@end
