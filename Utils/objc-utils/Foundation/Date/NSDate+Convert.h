//
//  NSDate+Convert.h
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Convert)

+ (NSString *)timeStampStringWithDateString:(NSString *)dateString formatterString:(NSString *)formatterString;

+ (NSDate *)dateWithDateString:(NSString *)dateString;

@end

NS_ASSUME_NONNULL_END
