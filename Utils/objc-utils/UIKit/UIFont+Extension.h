//
//  UIFont+Extension.h
//  Utils
//
//  Created by Xian Mo on 2020/9/2.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Extension)

/** register font with specified path */
+ (void)registerFontWithFontName:(NSString *)fontName inBundle:(NSBundle *)bundle;

/** 获取系统拥有的所有字体的名称数组 */
+ (NSArray *)allFontNames;


/**
 获取导入的自定义字体的名称
 并注册自定义字体到系统字体库，在程序启动后调用一次即可
 适用字体类型：ttf，otf

 @param path 字体文件存放路径，
 @return 自定义字体的名称
 */
+ (NSString *)customFontNameWithPath:(NSString *)path;


/**
 获取导入的自定义字体的名称数组
 并注册自定义字体到系统字体库，在程序启动后调用一次即可
 适用字体类型：ttc

 @param path 字体文件存放路径
 @return 自定义字体的名称数组
 */
+ (NSArray *)customFontNameArrayWithPath:(NSString *)path;


@end

NS_ASSUME_NONNULL_END
