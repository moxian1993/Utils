//
//  ZWORMQuery.m
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "ZWORMQuery.h"
#import "ZWORMManager.h"
#import "ZWORMModel.h"
#import "ZWORMTableMap.h"
#import "ZWORMColumnMap.h"

@interface ZWORMQuery (PRIVATE)

@property (readwrite) Class modelClass;

@end

@implementation ZWORMQuery

- (id)initWithModelClass:(Class)aClass
{
    self = [super init];
    if (self) {
        self.modelClass = aClass;
    }
    return self;
}


#pragma mark - 条件查询语句 -
/**
 主键查询
 
 */
- (ZWORMModel *)modelByPrimaryKey:(id)primaryKeyValue
{
    ZWORMModel *model = nil;
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[ZWORMManager sharedInstance] defaultDatabase];
    if(
       db == nil ||
       table == nil ||
       self.modelClass == nil ||
       ![self.modelClass isSubclassOfClass:[ZWORMModel class]]
       ) {
        return nil;
    }
    
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from `%@` where `%@` = ?",
                                        table.tableName,
                                        table.primaryKeyName], primaryKeyValue];
    if ([rs next]) {
        model = [self.modelClass modelWithResultSet:rs];
    }
    
    return model;
}

- (ZWORMModel *)modelWhere:(NSString *)conditions
                parameters:(NSDictionary *)parameters {
    ZWORMModel *model = nil;
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[ZWORMManager sharedInstance] defaultDatabase];

    if(!db) {
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ limit 1",
                     table.tableName,
                     [self validatedConditionsString:conditions]];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    if ([rs next]) {
        model = [self.modelClass modelWithResultSet:rs];
    }
    
    return model;
}

- (ZWORMModel *)modelWhere:(NSString *)conditions
                parameters:(NSDictionary *)parameters
                   orderBy:(NSString *)orderBy {
    if (orderBy == nil) {
        return [self modelWhere:conditions parameters:parameters];
    }
    
    ZWORMModel *model = nil;
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[ZWORMManager sharedInstance] defaultDatabase];
    
    if(!db) {
        return nil;
    }

    NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ order by %@ limit 1",
                     table.tableName,
                     [self validatedConditionsString:conditions],
                     orderBy
                     ];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    if ([rs next]) {
        model = [self.modelClass modelWithResultSet:rs];
    }
    
    return model;
}

- (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters
{
    NSMutableArray *models = [[NSMutableArray alloc] init];
    
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[ZWORMManager sharedInstance] defaultDatabase];
    
    if(!db) {
        return models;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@",
                     table.tableName,
                     [self validatedConditionsString:conditions]];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    while ([rs next]) {
        [models addObject:[self.modelClass modelWithResultSet:rs]];
    }
    
    return models;
}

- (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters
                 orderBy:(NSString *)orderBy
{
    if (orderBy == nil) {
        return [self modelsWhere:conditions parameters:parameters];
    }
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[ZWORMManager sharedInstance] defaultDatabase];
    
    if(!db) {
        return models;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ order by %@",
                     table.tableName,
                     [self validatedConditionsString:conditions],
                     orderBy
                     ];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    while ([rs next]) {
        [models addObject:[self.modelClass modelWithResultSet:rs]];
    }
    
    return models;
}


- (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters
                 orderBy:(NSString *)orderBy
                   limit:(NSInteger)limit
{
    NSMutableArray *models = [[NSMutableArray alloc] init];
    
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[ZWORMManager sharedInstance] defaultDatabase];
    
    if(!db) {
        return models;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ order by %@ limit %ld",
                     table.tableName,
                     [self validatedConditionsString:conditions],
                     orderBy,
                     (long)limit
                     ];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    while ([rs next]) {
        [models addObject:[self.modelClass modelWithResultSet:rs]];
    }
    
    return models;
}

- (NSInteger)countWhere:(NSString *)conditions
             parameters:(NSDictionary *)parameters
{
    NSInteger count = 0;
    
    ZWORMTableMap *table = [[ZWORMManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[ZWORMManager sharedInstance] defaultDatabase];
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) as count from `%@` where %@",
                     table.tableName,
                     [self validatedConditionsString:conditions]];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    if ([rs next]) {
        count = [rs intForColumn:@"count"];
    }
    
    return count;
}

#pragma mark - 工具方法 -
- (NSString *)validatedConditionsString:(NSString *)conditions
{
    if (conditions == nil || [conditions isEqualToString:@""]) {
        conditions = [NSString stringWithFormat:@"1 = 1"];
    }
    
    return conditions;
}

@end
