//
//  HanziUtils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HanziUtils : NSObject
/// 汉字转拼音
/// @param hanzi hanzi
+ (NSString *)hanziToPinyin:(NSString *)hanzi;

@end

NS_ASSUME_NONNULL_END
