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

/** 判断字符串是否全部为数字 */
- (BOOL)utils_isAllNum;

/** 判断是否仅有空格和换行符 */
- (BOOL)utils_isBlank;


#pragma mark -
#pragma mark - convert
/** 字符串反转1 */
- (NSString *)utils_reverseWords;
/** 字符串反转2 */
- (NSString *)utils_reverseWholeString;

/// 替换字符串中部分文本
/// @param replacedPart 被替换部分
/// @param replacement 替换为
- (NSString *)utils_replace:(NSString *)replacedPart with:(NSString *)replacement;

/// 用指定字符串替换第一个匹配字符串
/// @param replacedPart replaced string
/// @param replacement replacement
- (NSString *)utils_replaceFirstPart:(NSString *)replacedPart with:(NSString *)replacement;

/// 替换字符串中部分文本(array)
/// @param replacedParts 被替换部分(array)
/// @param replacements 替换为(array)
- (NSString *)utils_replaceParts:(NSArray <NSString *> *)replacedParts withParts:(NSArray <NSString *> *)replacements;


/// 清除字符串中的部分文本
/// @param strings 需要清除的字符串集合
- (NSString *)utils_cleaner:(NSArray <NSString *> *)strings;


#pragma mark -
#pragma mark - trim
/** 去空格 */
- (NSString *)utils_trim;

/** 首字母大写其他保持不变 */
- (NSString *)utils_capitalizedOriginalString;
/** 只转换ascii码的大小写 */
- (NSString *)utils_lowerLetterString;

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
- (NSString *)utils_substringWithinBoundsLeft:(NSString*)strLeft right:(NSString*)strRight;

- (NSString *)utils_substringFromString:(NSString *)str;
- (NSString *)utils_substringToString:(NSString*)str;
- (NSString *)utils_substringFromIndex:(NSInteger)begin toIndex:(NSInteger)end;


#pragma mark -
#pragma mark - jsonStr
- (NSDictionary *)utils_jsonStrTurnDictionary;


#pragma mark -
#pragma mark - safety
/// 返回安全字符串
/// @param origin origin
/// @param string 默认值
+ (NSString *)safecheck:(id)origin defaultString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
