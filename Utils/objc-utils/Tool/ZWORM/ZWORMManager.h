//
//  ZWORMManager.h
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "ZWSingleton.h"

@class ZWORMTableMap;
@class ZWORMQuery;

@interface ZWORMManager : NSObject

#pragma mark - 初始化 -

INTERFACE_SINGLETON(ZWORMManager)

#pragma mark - 属性-

/** 表类的前缀 */
@property (strong, nonatomic) NSString* classPrefixString;

#pragma mark  - FM数据库管理 -

/**
 通过FMDB对象设置ORM
 
 */
- (void)setDefaultDatabase:(FMDatabase *)database;

/**
 获取FMDB默认数据库对象
 
 */
- (FMDatabase *)defaultDatabase;

#pragma mark - 数据库表 -
- (ZWORMTableMap *)tableForModel:(Class)modelClass;

#pragma mark - 查询对象 -
- (ZWORMQuery *)queryForModel:(Class)modelClass;
@end
