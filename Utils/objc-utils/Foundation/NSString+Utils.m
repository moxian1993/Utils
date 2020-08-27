//
//  NSString+Utils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/27.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

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

- (NSString *)utils_trim {
    if ([self utils_isEmpty]) {
        return @"";
    } else
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


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
    NSString *str = [NSString stringWithCString:ch encoding:NSUTF8StringEncoding];
    if (str) {
        NSArray *result = [self componentsSeparatedByString:str];
        return result;
    }
    else return nil;
}

- (NSString*)utils_substringWithinBoundsLeft:(NSString*)strLeft right:(NSString*)strRight {
    NSRange rangeSub;
    NSString *strSub;
    
    NSRange range;
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




@end
