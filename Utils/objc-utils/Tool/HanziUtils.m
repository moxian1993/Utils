//
//  HanziUtils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "HanziUtils.h"

@implementation HanziUtils

+ (NSString *)hanziToPinyin:(NSString *)hanzi {
    NSMutableString *mutableString = [NSMutableString stringWithString:hanzi];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

@end
