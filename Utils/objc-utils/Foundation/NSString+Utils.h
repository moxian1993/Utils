//
//  NSString+Utils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/27.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Utils)

#pragma mark -
#pragma mark - judge
/** string 非空 */
- (BOOL)utils_isNotEmpty;
- (BOOL)utils_isEmpty;

/** 判断字符串相等 (特殊：两个nil也算相等) */
- (BOOL)utils_isEqualTo:(NSString *)str;


#pragma mark -
#pragma mark - trim
/** 去空格 */
- (NSString *)utils_trim;


#pragma mark -
#pragma mark - substring
/** 子串的index (忽略大小写)*/
- (NSInteger)utils_indexOfString:(NSString *)str;
- (NSInteger)utils_lastIndexOfString:(NSString *)str;
- (NSInteger)utils_indexOfString:(NSString *)str options:(NSStringCompareOptions)options;

/** split */
- (NSArray *)utils_splitOnChar:(char *)ch;

/// 获得特定字符串的中字符串
/// @param strLeft 左边匹配字符串
/// @param strRight 右边匹配字符串
- (NSString*)utils_substringWithinBoundsLeft:(NSString*)strLeft right:(NSString*)strRight;
@end

NS_ASSUME_NONNULL_END
