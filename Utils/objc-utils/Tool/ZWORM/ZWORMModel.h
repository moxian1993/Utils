//
//  ZWORMModel.h
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWORMTableMap.h"

@class FMResultSet;
@class ZWORMQuery;
@class FMDatabase;
@class FMResultSet;

@interface ZWORMModel : NSObject

#pragma mark - 属性 -
/** 是否是新创建的 */
@property (assign, nonatomic) BOOL isNew;

#pragma mark - 数据库表构建 -
/**
 *  初始化表的结构
 *
 *  @param db      数据库对象
 *  @param version 数据库表版本
 *
 *  @return 返回最新版本号
 */
- (NSInteger)setupTableWithDatabase:(FMDatabase *)db tableVersion:(NSInteger)version;


#pragma mark - 数据库映射方法 -
/**
 构建数据库映射
 
 */
- (void)schema:(ZWORMTableMap *)table;

#pragma mark - 数据库访问基础方法 -
- (void)save;
- (void)saveWithDatabase:(FMDatabase *)db;

- (void)delete;
- (void)deleteWithDatabase:(FMDatabase *)db;


#pragma mark - 查询方法 -
+ (ZWORMModel *)modelWithResultSet:(FMResultSet *)rs;

+ (ZWORMModel *)modelWhere:(NSString *)conditions
                parameters:(NSDictionary *)parameters;

+ (ZWORMModel *)modelWhere:(NSString *)conditions
                parameters:(NSDictionary *)parameters
                   orderBy:(NSString *)orderBy;

+ (ZWORMModel *)modelWithValues:(NSDictionary *)values;

+ (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters;

+ (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters
                 orderBy:(NSString *)orderBy;

+ (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters
                 orderBy:(NSString *)orderBy
                   limit:(NSInteger)limit;

+ (NSInteger)countWhere:(NSString *)conditions
             parameters:(NSDictionary *)parameters;

+ (NSInteger)count;

#pragma mark - 插入方法 -
+ (ZWORMModel *)createWithValues:(NSDictionary *)values;

+ (ZWORMModel *)createWithValues:(NSDictionary *)values
                        database:(FMDatabase *)db;

#pragma mark - 删除方法 -
+ (BOOL)deleteWhere:(NSString *)conditions
         parameters:(NSDictionary *)parameters;

#pragma mark - 获取全局查询对象 -
+ (ZWORMQuery *)query;

@end
