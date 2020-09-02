//
//  ZWORMTableVersion.m
//  Pods
//
//  Created by zhuwei on 15/7/21.
//
//

#import "ZWORMTableVersion.h"
#import "FMDatabase.h"

@implementation ZWORMTableVersion

#pragma mark - 数据库表构建 -
/**
 *  初始化表的结构
 *
 *  @param db      数据库对象
 *  @param version 数据库表版本
 *
 *  @return 返回最新版本号
 */
- (NSInteger)setupTableWithDatabase:(FMDatabase *)db tableVersion:(NSInteger)version {
    if(db == nil) return 0;
    NSString* sql = @"                      \
    create table if not exists              \
    orm_tableversions (                     \
    tableName         TEXT                , \
    version           INT                 , \
    PRIMARY KEY (tableName)                 \
    )";
    [db executeUpdate:sql];
    return 1;
}


#pragma mark - 数据库映射方法 -
/**
 构建数据库映射
 
 */
- (void)schema:(ZWORMTableMap *)table {
    [table setTableName:@"orm_tableversions"];
    [table setColumnName:@"tableName" type:ZWORMColumnMapTypeString isPrimaryKey:YES isIncrements:NO];
    [table setColumnName:@"version" type:ZWORMColumnMapTypeInt];
}

@end
