//
//  ZWORMQuery.h
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZWORMModel;

@interface ZWORMQuery : NSObject

@property (assign, nonatomic) Class modelClass;

- (id)initWithModelClass:(Class)aClass;

#pragma mark - 条件查询语句 -
/**
 主键查询
 
 */
- (ZWORMModel *)modelByPrimaryKey:(id)primaryKeyValue;

- (ZWORMModel *)modelWhere:(NSString *)conditions
                parameters:(NSDictionary *)parameters;

- (ZWORMModel *)modelWhere:(NSString *)conditions
                parameters:(NSDictionary *)parameters
                   orderBy:(NSString *)orderBy;

- (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters;

- (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters
                 orderBy:(NSString *)orderBy;

- (NSArray *)modelsWhere:(NSString *)conditions
              parameters:(NSDictionary *)parameters
                 orderBy:(NSString *)orderBy
                   limit:(NSInteger)limit;

- (NSInteger)countWhere:(NSString *)conditions
             parameters:(NSDictionary *)parameters;

@end
