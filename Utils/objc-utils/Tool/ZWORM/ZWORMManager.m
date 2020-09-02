//
//  ZWORMManager.m
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "ZWORMManager.h"
#import "ZWORMTableMap.h"
#import "ZWORMHelpers.h"
#import "ZWORMModel.h"
#import "ZWORMQuery.h"
#import "ZWORMTableVersion.h"

static ZWORMManager *sharedInstance = nil;

@implementation ZWORMManager {
    FMDatabase*             _db;
    NSMutableDictionary*    _tables;
    
    NSMutableDictionary*    _setupTables;
}

#pragma - 初始化 -

IMPLEMENTATION_SINGLETON(ZWORMManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _db = nil;
        _tables = [[NSMutableDictionary alloc] init];
        _setupTables = [[NSMutableDictionary alloc] init];
        _classPrefixString = nil;
    }
    return self;
}

#pragma mark - 私有方法 -
/**
 *  是否已经安装表
 *
 *  @param tableName 表明
 *
 *  @return 返回已经安装返回yes
 */
- (BOOL)isSetupTable:(NSString *)tableName {
    NSNumber* isSetup = [_setupTables objectForKey:tableName];
    if(isSetup) {
        return [isSetup boolValue];
    }
    return NO;
}

- (void)setupTable:(NSString *)tableName {
    [_setupTables setObject:@1 forKey:tableName];
}

#pragma mark - FM数据库管理 -
/**
 通过FMDB对象设置ORM
 
 */
- (void)setDefaultDatabase:(FMDatabase *)database {
    _db = database;
}

/**
 获取FMDB默认数据库对象
 
 */
- (FMDatabase *)defaultDatabase {
    return _db;
}

#pragma mark - 数据库表 -
- (ZWORMTableMap *)tableForModel:(Class)modelClass
{
    if(modelClass == nil || ![modelClass isSubclassOfClass:[ZWORMModel class]]) {
        return nil;
    }
    
    ZWORMTableMap *table = [_tables objectForKey:NSStringFromClass(modelClass)];
    if (!table) {
        table = [[ZWORMTableMap alloc] init];
        table.database = @"default";
        table.tableName = ZWORMDefaultTableNameFromModelName(NSStringFromClass(modelClass),_classPrefixString);
        
        ZWORMModel* model = [[modelClass alloc] init];
        //初始化映射
        [model schema:table];
        
        //通过版本初始化数据库表
        FMDatabase* db = [self defaultDatabase];
        if(db && [NSStringFromClass(modelClass) isEqualToString:@"ZWORMTableVersion"]) {
            if(![self isSetupTable:table.tableName]) {
                [model setupTableWithDatabase:db tableVersion:1];
                [self setupTable:table.tableName];
            }
            
        } else {
            if(db && ![self isSetupTable:table.tableName] && [model respondsToSelector:@selector(setupTableWithDatabase:tableVersion:)]) {
                NSInteger version = 0;
                ZWORMTableVersion* tableVersion = (ZWORMTableVersion *)[ZWORMTableVersion modelWhere:[NSString stringWithFormat:@"tableName = :tableName"] parameters:@{@"tableName":table.tableName}];
                if(tableVersion) {
                    version = [tableVersion.version integerValue];
                } else {
                    tableVersion = [[ZWORMTableVersion alloc] init];
                    tableVersion.tableName = table.tableName;
                }
                NSInteger newVersion = [model setupTableWithDatabase:db tableVersion:version];
                if(newVersion > 0) {
                    tableVersion.version = @(newVersion);
                    if(newVersion > version) {
                        [tableVersion save];
                    }
                }
                [self setupTable:table.tableName];
            }
        }
        
        [_tables setObject:table forKey:NSStringFromClass(modelClass)];
    }
    return table;
}

#pragma mark - 查询对象 -
- (ZWORMQuery *)queryForModel:(Class)modelClass
{
    return [[ZWORMQuery alloc] initWithModelClass:modelClass];
}
@end
