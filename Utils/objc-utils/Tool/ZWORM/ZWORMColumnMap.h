//
//  ZWORMColumnMap.h
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZWORMColumnMapType) {
    ZWORMColumnMapTypeInt = 0,
    ZWORMColumnMapTypeLong,
    ZWORMColumnMapTypeLongLongInt,
    ZWORMColumnMapTypeUnsignedLongLongInt,
    ZWORMColumnMapTypeBool,
    ZWORMColumnMapTypeDouble,
    ZWORMColumnMapTypeString,
    ZWORMColumnMapTypeDate,
    ZWORMColumnMapTypeData
};

@interface ZWORMColumnMap : NSObject

#pragma mark - 属性 -
/** 字段名 */
@property (strong, nonatomic) NSString *name;

/** 字段类型 */
@property (assign, nonatomic) ZWORMColumnMapType type;

/** 是否是自动增长类型 */
@property (assign, nonatomic) BOOL increments;

#pragma mark - 方法 -

/** 
 初始化映射字段
 
 @param name: 字段名
 
 @param type: 字段类型
 
 */
- (id)initWithName:(NSString *)name type:(ZWORMColumnMapType)type;

/**
 属性名称
 
 */
- (NSString *)propertyName;
@end
