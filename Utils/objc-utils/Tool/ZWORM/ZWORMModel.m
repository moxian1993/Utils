//
//  ZWORMModel.m
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "ZWORMModel.h"
#import "ZWORMManager.h"
#import "ZWORMTableMap.h"
#import "ZWORMColumnMap.h"
#import "ZWORMHelpers.h"
#import "ZWORMQuery.h"



@implementation ZWORMModel
- (id)init
{
    self = [super init];
    if (self) {
        self.isNew = YES;
    }
    return self;
}

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
    //需要重新实现代码
    return 0;
}

#pragma mark - 数据库映射方法 -
- (void)schema:(ZWORMTableMap *)table {
    //需要重新实现代码
}

#pragma mark - 数据库基础访问方法 -
/**
 *  Save
 */
- (void)save
{
    [self saveWithDatabase:nil];
}

- (void)saveWithDatabase:(FMDatabase *)db
{
    if (self.isNew) {
        [self insertWithDatabase:db];
    } else {
        [self updateWithDatabase:db];
    }
}

/**
 *  Insert
 */
- (void)insertWithDatabase:(FMDatabase *)db
{
    if (!self.isNew) {
        return;
    }
    
    if(!db) {
        db = [[ZWORMManager sharedInstance] defaultDatabase];
    }
    
    if(!db) return;
    
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:[self class]];
    NSDictionary *columns = table.columns;
    
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (id key in [columns keyEnumerator]) {
        ZWORMColumnMap *column = [columns objectForKey:key];
        id value = [self valueForKey:column.propertyName] ?: NSNull.null;
        
        if ([column.name isEqualToString:table.primaryKeyName] && value == NSNull.null) {
            // Skip to set value and field set of primary key when the primary key is empty.
            // If the primary key has autoincrements attribute. It'OK.
            continue;
        }
        
        [fields addObject:column.name];
        [values addObject:value];
    }
    
    // Build query
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"insert into `%@` ", table.tableName];
    [query appendFormat:@"(`%@`) values (%@?)",
     [fields componentsJoinedByString:@"`,`"],
     [@"" stringByPaddingToLength:((fields.count - 1) * 2) withString:@"?," startingAtIndex:0]
     ];
    
    [db executeUpdate:query withArgumentsInArray:values];
    
    SEL selector = ZWORMSetterSelectorFromColumnName(table.primaryKeyName);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:@([db lastInsertRowId])];
#pragma clang diagnostic pop
    }
    
    self.isNew = NO;
}

/**
 *  Update
 */
- (void)updateWithDatabase:(FMDatabase *)db
{
    if (self.isNew) {
        return;
    }
    
    if(!db) {
        db = [[ZWORMManager sharedInstance] defaultDatabase];
    }
    
    if(!db) return;
    
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:[self class]];
    if (![self valueForKey:[table columnForPrimaryKey].propertyName]) {
        return;
    }
    NSDictionary *columns = table.columns;
    
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (id key in [columns keyEnumerator]) {
        ZWORMColumnMap *column = [columns objectForKey:key];
        id value = [self valueForKey:column.propertyName] ?: NSNull.null;
        
        if ([column.name isEqualToString:table.primaryKeyName]) {
            // Skip to set value and field set of primary key.
            continue;
        }
        
        [fields addObject:column.name];
        [values addObject:value];
    }
    
    // The primary key value needs to be last value.
    [values addObject:[self valueForKey:[table columnForPrimaryKey].propertyName] ?: NSNull.null];
    
    // Build query
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"update `%@` set ", table.tableName];
    [query appendFormat:@"`%@` = ? ", [fields componentsJoinedByString:@"`=?,`"]];
    [query appendFormat:@"where `%@` = ?", table.primaryKeyName];
    
    [db executeUpdate:query withArgumentsInArray:values];
}

- (void)delete
{
    [self deleteWithDatabase:nil];
}

/**
 *  Delete
 */
- (void)deleteWithDatabase:(FMDatabase *)db
{
    if (self.isNew) {
        return;
    }
    
    if(!db) {
        db = [[ZWORMManager sharedInstance] defaultDatabase];
    }
    
    if(!db) return;
    
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:[self class]];
    if (![self valueForKey:[table columnForPrimaryKey].propertyName]) {
        return;
    }
    
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"delete from `%@` ", table.tableName];
    [query appendFormat:@"where `%@` = ?", table.primaryKeyName];
    
    
    [db executeUpdate:query, [self valueForKey:[table columnForPrimaryKey].propertyName]];
}

#pragma mark - 查询方法 -
+ (ZWORMModel *)modelWithResultSet:(FMResultSet *)rs
{
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:self];
    if(!table) {
        return nil;
    }
    NSDictionary *columns = table.columns;
    ZWORMModel *model = [[self alloc] init];
    model.isNew = NO;
    
    for (id key in [columns keyEnumerator]) {
        ZWORMColumnMap *column = [columns objectForKey:key];
        
        id value = nil;
        if (column.type == ZWORMColumnMapTypeInt) {
            value = [NSNumber numberWithInt:[rs intForColumn:column.name]];
        } else if (column.type == ZWORMColumnMapTypeLong) {
            value = [NSNumber numberWithLong:[rs longForColumn:column.name]];
        } else if (column.type == ZWORMColumnMapTypeDouble) {
            value = [NSNumber numberWithDouble:[rs doubleForColumn:column.name]];
        } else if (column.type == ZWORMColumnMapTypeString) {
            value = [rs stringForColumn:column.name];
        } else if (column.type == ZWORMColumnMapTypeBool) {
            value = [NSNumber numberWithBool:[rs boolForColumn:column.name]];
        } else if (column.type == ZWORMColumnMapTypeDate) {
            value = [rs dateForColumn:column.name];
        } else if (column.type == ZWORMColumnMapTypeData) {
            value = [rs dataForColumn:column.name];
        }
        
        if (value) {
            SEL selector = ZWORMSetterSelectorFromColumnName(column.name);
            if ([model respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [model performSelector:selector withObject:value];
#pragma clang diagnostic pop
            }
        }
    }
    return model;
}

+ (ZWORMModel *)modelWithValues:(NSDictionary *)values;
{
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:self];
    NSDictionary *columns = table.columns;
    
    ZWORMModel *model = [[self alloc] init];
    
    // TODO:
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd'T'HH:mm:ssZ"];
    
    for (id key in [columns keyEnumerator]) {
        ZWORMColumnMap *column = [columns objectForKey:key];
        id value = values[column.name];
        
        if (column.type == ZWORMColumnMapTypeInt) {
            // Nothing to do;
        } else if (column.type == ZWORMColumnMapTypeLong) {
            // Nothing to do;
        } else if (column.type == ZWORMColumnMapTypeDouble) {
            // Nothing to do;
        } else if (column.type == ZWORMColumnMapTypeString) {
            // Nothing to do;
        } else if (column.type == ZWORMColumnMapTypeBool) {
            // Nothing to do;
        } else if (column.type == ZWORMColumnMapTypeDate && [value isKindOfClass:[NSString class]]) {
            value = [formatter dateFromString:value];
        } else if (column.type == ZWORMColumnMapTypeData) {
            // Nothing to do;
        }
        
        if (value) {
            SEL selector = ZWORMSetterSelectorFromColumnName(column.name);
            if ([model respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [model performSelector:selector withObject:value];
#pragma clang diagnostic pop
            }
        }
    }
    
    return model;
}

+ (ZWORMModel *)modelWhere:(NSString *)conditions
                parameters:(NSDictionary *)parameters {
    return [[self query] modelWhere:conditions parameters:parameters];
}

+ (ZWORMModel *)modelWhere:(NSString *)conditions
                parameters:(NSDictionary *)parameters
                   orderBy:(NSString *)orderBy {
    return [[self query] modelWhere:conditions
                         parameters:parameters
                            orderBy:orderBy];
}

+ (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters
{
    return [[self query] modelsWhere:conditions
                          parameters:parameters];
}

+ (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters
                 orderBy:(NSString *)orderBy
{
    return [[self query] modelsWhere:conditions
                          parameters:parameters
                             orderBy:orderBy];
}

+ (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters
                 orderBy:(NSString *)orderBy
                   limit:(NSInteger)limit
{
    return [[self query] modelsWhere:conditions
                          parameters:parameters
                             orderBy:orderBy
                               limit:limit];
}

+ (NSInteger)countWhere:(NSString *)conditions
             parameters:(NSDictionary *)parameters
{
    return [[self query] countWhere:conditions
                         parameters:parameters];
}

+ (NSInteger)count
{
    return [self countWhere:nil parameters:nil];
}

#pragma mark - 插入方法 -
+ (ZWORMModel *)createWithValues:(NSDictionary *)values {
    return [self createWithValues:values database:nil];
}

+ (ZWORMModel *)createWithValues:(NSDictionary *)values
                        database:(FMDatabase *)db {
    ZWORMModel *model = [self modelWithValues:values];
    [model saveWithDatabase:db];
    return model;
}

#pragma mark - 删除方法 -
+ (BOOL)deleteWhere:(NSString *)conditions
         parameters:(NSDictionary *)parameters {
    NSMutableArray *models = [[NSMutableArray alloc] init];
    
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:[self class]];
    FMDatabase *db = [[ZWORMManager sharedInstance] defaultDatabase];
    
    if(!db) {
        return models;
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from `%@` where %@",
                     table.tableName,
                     conditions];
    return [db executeUpdate:sql withParameterDictionary:parameters];
}

#pragma mark - 获取全局查询对象 -
+ (ZWORMQuery *)query
{
    return [[ZWORMManager sharedInstance] queryForModel:self];
}

@end

