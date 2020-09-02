//
//  ZWORMTableMap.m
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "ZWORMTableMap.h"

@implementation ZWORMTableMap

#pragma mark - 初始化 －
- (instancetype)init
{
    self = [super init];
    if (self) {
        _columns = [[NSMutableDictionary alloc] init];
        _primaryKeyName = nil;
    }
    return self;
}

#pragma mark - 字段操作 -
/**
 设置表映射字段
 
 @param columnName: 字段名
 
 @param type: 字段类型
 */
- (void)setColumnName:(NSString *)columnName
                 type:(ZWORMColumnMapType)type
         isPrimaryKey:(BOOL)isPrimaryKey
         isIncrements:(BOOL)isIncrements {
    ZWORMColumnMap *column = [[ZWORMColumnMap alloc] initWithName:columnName type:type];
    if(isIncrements) column.increments = YES;
    [self.columns setObject:column forKey:columnName];
    if(isPrimaryKey) self.primaryKeyName = columnName;
}
/**
 设置表映射字段
 
 @param columnName: 字段名
 
 @param type: 字段类型
 */
- (void)setColumnName:(NSString *)columnName
                 type:(ZWORMColumnMapType)type {
    [self setColumnName:columnName type:type isPrimaryKey:NO isIncrements:NO];
}

/**
 获取主键字段
 
 */
- (ZWORMColumnMap *)columnForPrimaryKey
{
    return [self.columns objectForKey:self.primaryKeyName];
}

@end
