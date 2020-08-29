//
//  NSDate+Convert.m
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "NSDate+Convert.h"

@implementation NSDate (Convert)


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
