//
//  TimeUtils.h
//  QiTalk
//
//  Created by Terry Zhao on 16/6/7.
//  Copyright © 2016年 Keylert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtils : NSObject

+ (NSTimeInterval)systemUpTime;

+ (NSString *)timeFormatted:(int)totalSeconds;
+ (NSDate*)dateWithTimeOffset:(NSString *)timeOffset;

+ (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;
+ (NSInteger)getHoursFrom:(NSDate *)beginDate To:(NSDate *)endDate;
+ (NSInteger)getSecondsFrom:(NSDate *)beginDate To:(NSDate *)endDate;
+ (NSInteger)getYearsFrom:(NSDate *)beginDate To:(NSDate *)endDate;

+ (NSInteger)nowDateSecond;
+ (BOOL)hasAMPM;

@end
