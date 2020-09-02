//
//  ZWORMHelpers.h
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 从下划线分割转换成驼峰式
 如：aaa_bbb => aaaBbb
 */
NSString *ZWORMLowerCamelCaseFromSnakeCase(NSString *input);

/**
 从下划线分割转换成第一个字母大写
 如：aaa_bbb => AaaBbb
 */
NSString *ZWORMUpperCamelCaseFromSnakeCase(NSString *input);

/**
 通过类名称获取表名称
 如：
    input => DCClass
    prefixString => DC
    结果 => Class
 
 @param input: 类名称
 
 @param prefixString: 类前缀
 
 */
NSString *ZWORMDefaultTableNameFromModelName(NSString *input,NSString* prefixString);

/**
 通过输入的字符串构建
 
 */
SEL ZWORMSetterSelectorFromColumnName(NSString *input);