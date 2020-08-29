//
//  TimeUtils.m
//  QiTalk
//
//  Created by Terry Zhao on 16/6/7.
//  Copyright © 2016年 Keylert. All rights reserved.
//

#import "TimeUtils.h"

@implementation TimeUtils

+ (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if(hours < 1)
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    else
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


+ (NSTimeInterval)systemUpTime {

    return [NSProcessInfo processInfo].systemUptime;
    
}

+ (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

+ (NSDate*)dateWithTimeOffset:(NSString *)timeOffset {
    NSTimeInterval timeInterVal = timeOffset.longLongValue;
    NSTimeInterval dateTimeInterVal = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval totalTimeInterVal = dateTimeInterVal + timeInterVal;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:totalTimeInterVal];
    return date;
}

+ (NSInteger)getHoursFrom:(NSDate *)beginDate To:(NSDate *)endDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitHour startDate:&fromDate interval:NULL forDate:beginDate];
    
    [gregorian rangeOfUnit:NSCalendarUnitHour startDate:&toDate interval:NULL forDate:endDate];
    
    NSDateComponents *hourComponents = [gregorian components:NSCalendarUnitHour fromDate:fromDate toDate:toDate options:0];

    return hourComponents.hour;
}


+ (NSInteger)getSecondsFrom:(NSDate *)beginDate To:(NSDate *)endDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitSecond startDate:&fromDate interval:NULL forDate:beginDate];
    
    [gregorian rangeOfUnit:NSCalendarUnitSecond startDate:&toDate interval:NULL forDate:endDate];
    
    NSDateComponents *hourComponents = [gregorian components:NSCalendarUnitSecond fromDate:fromDate toDate:toDate options:0];
    
    return hourComponents.second;
}


+ (NSInteger)getYearsFrom:(NSDate *)beginDate To:(NSDate *)endDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉月日时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitYear startDate:&fromDate interval:NULL forDate:beginDate];
    
    [gregorian rangeOfUnit:NSCalendarUnitYear startDate:&toDate interval:NULL forDate:endDate];
    
    NSDateComponents *hourComponents = [gregorian components:NSCalendarUnitYear fromDate:fromDate toDate:toDate options:0];
    
    return hourComponents.year;

}


+ (NSInteger)nowDateSecond {
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *hourComponents = [gregorian components:NSCalendarUnitSecond fromDate:now];
    return hourComponents.second;
}

+ (BOOL)hasAMPM {
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    return hasAMPM;
}

@end
