//
//  ZWORMHelpers.m
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "ZWORMHelpers.h"


NSString *ZWORMLowerCamelCaseFromSnakeCase(NSString *input)
{
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [input length]; idx += 1) {
        unichar c = [input characterAtIndex:idx];
        if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

NSString *ZWORMUpperCamelCaseFromSnakeCase(NSString *input)
{
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [input length]; idx += 1) {
        unichar c = [input characterAtIndex:idx];
        if (idx == 0) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
        } else if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}


NSString *ZWORMDefaultTableNameFromModelName(NSString *input,NSString* prefixString)
{
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    
    BOOL isAlreadyRemovedPrefix = NO;
    
    if(prefixString && ![[prefixString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        if([input hasPrefix:prefixString]) {
            input = [input substringFromIndex:prefixString.length - 1];
        }
    }
    
    for (NSInteger idx = 0; idx < [input length]; idx += 1) {
        unichar c = [input characterAtIndex:idx];
        unichar nc = 0;
        if (idx < ([input length] - 1)) {
            nc = [input characterAtIndex:idx + 1];
        }
        
        if ([uppercase characterIsMember:c] && [uppercase characterIsMember:nc] && !isAlreadyRemovedPrefix) {
            // remove prefix.
        } else if ([uppercase characterIsMember:c]) {
            if (!isAlreadyRemovedPrefix) {
                isAlreadyRemovedPrefix = YES;
                [output appendFormat:@"%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
            } else {
                [output appendFormat:@"_%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
            }
        } else {
            if (!isAlreadyRemovedPrefix) {
                isAlreadyRemovedPrefix = YES;
            }
            [output appendFormat:@"%C", c];
        }
    }
    
    // To plural form
    [output appendString:@"s"];
    
    return output;
}

SEL ZWORMSetterSelectorFromColumnName(NSString *input)
{
    return NSSelectorFromString([NSString stringWithFormat:@"set%@:", ZWORMUpperCamelCaseFromSnakeCase(input)]);
}