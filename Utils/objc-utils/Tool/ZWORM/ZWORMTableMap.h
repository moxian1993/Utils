//
//  ZWORMTableMap.h
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWORMColumnMap.h"

@interface ZWORMTableMap : NSObject

/** 数据库名 */
@property (strong, nonatomic) NSString *database;

/** 表名 */
@property (strong, nonatomic) NSString *tableName;

/** 表字段列表 */
@property (readonly, nonatomic) NSMutableDictionary *columns;

/** 主键名 */
@property (strong, nonatomic) NSString *primaryKeyName;

#pragma mark - 字段操作 -
/** 
 设置表映射字段 
 
 @param columnName: 字段名
 
 @param type: 字段类型
 */
- (void)setColumnName:(NSString *)columnName
                 type:(ZWORMColumnMapType)type;

/**
 设置表映射字段
 
 @param columnName: 字段名
 
 @param type: 字段类型
 */
- (void)setColumnName:(NSString *)columnName
                 type:(ZWORMColumnMapType)type
         isPrimaryKey:(BOOL)isPrimaryKey
         isIncrements:(BOOL)isIncrements;

/**
 获取主键字段
 
 */
- (ZWORMColumnMap *)columnForPrimaryKey;

@end
