//
//  NSString+Utils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/27.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

#pragma mark -
#pragma mark - judge

- (BOOL)utils_isEmpty {
    if ([self isKindOfClass:[NSNull class]] ||
        self == nil ||
        self.length <= 0) {
        return YES;
    }
    return NO;
}

- (BOOL)utils_isNotEmpty {
    return ![self utils_isEmpty];
}

- (BOOL)utils_isEqualTo:(NSString *)str {
    if (self == nil && str == nil) {
        return YES;
    }
    else if(str != nil) {
        return [self isEqualToString:str];
    }
    return NO;
}


/** 判断字符串是否全部为数字 */
- (BOOL)utils_isAllNum {
    unichar c;
    for (int i = 0; i < self.length; i++) {
        c = [self characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

/** 判断是否仅有空格和换行符 */
- (BOOL)utils_isBlank; {
    if([[self utils_trim] isEqualToString:@""])
        return YES;
    return NO;
}


#pragma mark -
#pragma mark - convert
/** 字符串反转1 */
- (NSString *)utils_reverseWords {
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:self.length];
    for (NSInteger i = self.length - 1; i >= 0 ; i --)
    {
        unichar ch = [self characterAtIndex:i];
        [newString appendFormat:@"%c", ch];
    }
    return newString;
}


/** 字符串反转2 */
- (NSString *)utils_reverseWholeString {
    NSMutableString *reverString = [NSMutableString stringWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reverString appendString:substring];
    }];
    return reverString;
}


/// 替换字符串中部分文本
/// @param replacedPart 被替换部分
/// @param replacement 替换为
- (NSString *)utils_replace:(NSString *)replacedPart with:(NSString *)replacement {
    if (!replacement) {
        return self;
    }
    return [self stringByReplacingOccurrencesOfString:replacedPart withString: replacement];
}

/// 用指定字符串替换第一个匹配字符串
/// @param replacedPart replaced string
/// @param replacement replacement
- (NSString *)utils_replaceFirstPart:(NSString *)replacedPart with:(NSString *)replacement {
    if (!replacement) {
        return self;
    }
    NSRange replacedRange = [self rangeOfString: replacedPart];
    NSString *result;
    if (replacedRange.location != NSNotFound) {
        result = [self stringByReplacingCharactersInRange: replacedRange withString:replacement];
    }
    return result;
}

/// 替换字符串中部分文本(array)
/// @param replacedParts 被替换部分(array)
/// @param replacements 替换为(array)
- (NSString *)utils_replaceParts:(NSArray <NSString *> *)replacedParts withParts:(NSArray <NSString *> *)replacements {
    NSUInteger count = replacedParts.count;
    NSAssert(count != replacements.count, @"two arrays can't match each other");
    
    NSString *temp = self;
    for (int i = 0; i < count; i++) {
        temp = [self utils_replace:replacedParts[i] with:replacements[i]];
    }
    return temp;
}


/// 清除字符串中的部分文本
/// @param strings 需要清除的字符串集合
- (NSString *)utils_cleaner:(NSArray <NSString *> *)strings {
    NSUInteger count = strings.count;
    if (count == 0) {
        return self;
    }
    
    NSString *temp = self;
    for (NSString *string in strings) {
        temp = [self utils_replace:string with:@""];
    }
    return temp;
}




#pragma mark -
#pragma mark - trim

- (NSString *)utils_trim {
    if ([self utils_isEmpty]) {
        return @"";
    } else
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/** 首字母大写其他保持不变 */
- (NSString *)utils_capitalizedOriginalString; {
    NSMutableString* str = [NSMutableString string];
    if(self.length == 0) {
        return str;
    }
    for (NSUInteger i = 0; i < self.length; i ++) {
        if(i == 0) {
            NSString *capitalizedChar = [[self substringToIndex:1] uppercaseString];
            [str appendString:capitalizedChar];
        } else {
            [str appendFormat:@"%c",[self characterAtIndex:i]];
        }
    }
    return str;
}

/** 只转换ascii码的大小写 */
- (NSString *)utils_lowerLetterString {
    NSMutableString *newStr = [NSMutableString string];
    for (NSInteger i = 0; i < self.length; i ++) {
        unichar ch = [self characterAtIndex:i];
        if(ch >= 'A' && ch <= 'Z') {
            [newStr appendFormat:@"%c",ch + ('a' - 'A')];
        } else {
            
            [newStr appendString:[NSString stringWithCharacters:&ch length:1]];
        }
    }
    return newStr;
}

#pragma mark -
#pragma mark - substring

- (NSInteger)utils_indexOfString:(NSString *)str {
    return [self utils_indexOfString:str options:NSCaseInsensitiveSearch];
}

- (NSInteger)utils_lastIndexOfString:(NSString *)str {
    return [self utils_indexOfString:str options:NSCaseInsensitiveSearch | NSBackwardsSearch];
}

- (NSInteger)utils_indexOfString:(NSString *)str options:(NSStringCompareOptions)options {
    if ([str utils_isNotEmpty]) {
        NSRange range = [self rangeOfString:str options: options];
        if (range.length == 0) {
            return -1;
        }
        return range.location;
    }
    return -1;
}


- (NSArray *)utils_splitOnChar:(char *)ch {
    if (!ch) {
        return nil;
    }
    NSString *str = [NSString stringWithCString:ch encoding:NSUTF8StringEncoding];
    if (str) {
        NSArray *result = [self componentsSeparatedByString:str];
        return result;
    } else {
        return nil;
    }
}

- (NSString*)utils_substringWithinBoundsLeft:(NSString*)strLeft right:(NSString*)strRight {
    NSRange rangeSub;
    NSString *strSub;
    
    NSRange range;
    if (!strLeft || !strRight) {
        return nil;
    }
    range = [self rangeOfString:strLeft options:0];
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    rangeSub.location = range.location + range.length;
    
    range.location = rangeSub.location;
    range.length = [self length] - range.location;
    range = [self rangeOfString:strRight options:0 range:range];
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    rangeSub.length = range.location - rangeSub.location;
    strSub = [[self substringWithRange:rangeSub] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return strSub;
}


- (NSString *)utils_substringFromString:(NSString *)str {
    if (str) {
        NSRange range = [self rangeOfString:str];
        if (range.length > 0) {
            return [self substringFromIndex:range.location + range.length];
        } else {
            return nil;
        }
    }
    return nil;
}

- (NSString *)utils_substringToString:(NSString*)str {
    if (str) {
        NSArray *component = [self componentsSeparatedByString:str];
        return component[0];
    } else {
        return self;
    }
}

- (NSString *)utils_substringFromIndex:(NSInteger)begin toIndex:(NSInteger)end {
    if (end <= begin) {
        return @"";
    }
    NSRange range = NSMakeRange(begin, end - begin);
    return [self substringWithRange:range];
}


#pragma mark -
#pragma mark - jsonStr
- (NSDictionary *)utils_jsonStrTurnDictionary {
    if ([self utils_isEqualTo:self]) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData == nil) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    return dic;
}


#pragma mark -
#pragma mark - safety
+ (NSString *)safecheck:(id)origin defaultString:(NSString *)string {
    if ([origin respondsToSelector:@selector(length)]) {
        NSString *s = origin;
        return s.length == 0 ? string : origin;
    }
    if (origin == nil || [origin isKindOfClass:[NSNull class]]) {
        return string;
    }
    return nil;
}

@end
