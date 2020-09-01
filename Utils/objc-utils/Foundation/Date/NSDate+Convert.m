//
//  NSDate+Convert.m
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "NSDate+Convert.h"

@implementation NSDate (Convert)

/**
由服务器返回的时间戳字符串 转化为需求的时间字符串
(默认规定服务器返回的时间戳格式为"yy-MM-dd HH:mm:ss",需根据实践情况进行更改)

@param dateString 服务器返回的timeStamp(NSString)
@param formatterString 所需的时间字符串格式
@return 目标字符串
*/
+ (NSString *)timeStampStringWithDateString:(NSString *)dateString formatterString:(NSString *)formatterString {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yy-MM-dd HH:mm:ss";
    
    NSDate *date = [formatter dateFromString:dateString];
    
    formatter.dateFormat = formatterString;
    NSString *string = [formatter stringFromDate:date];
    
    return string;
}

+ (NSDate *)dateWithDateString:(NSString *)dateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yy-MM-dd HH:mm:ss";
    
    return [formatter dateFromString:dateString];
}


@end
