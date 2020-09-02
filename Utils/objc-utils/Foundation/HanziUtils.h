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

/// 获取中文字符串的发音
/// @param stripDiacritics 是否显示声调
- (NSString *)zhCNPhoneticWithStripDiacritics:(BOOL)stripDiacritics;

/// 获取字符串(或汉字)首字母
/// @param string 字符串(或汉字)
+ (NSString *)firstCharacterWithString:(NSString *)string;

/// 判断字符串中是否含有中文
/// @param string string
+ (BOOL)isHaveChineseInString:(NSString *)string;

/// 阿拉伯数字转中文格式
/// @param arebic 12345
+ (NSString *)translation:(NSString *)arebic;

@end

NS_ASSUME_NONNULL_END
