//
//  FMDatabase+Ext.h
//  Pods
//
//  Created by zhuwei on 15/7/22.
//
//

#import "FMDatabase.h"

/**
 *  FMDatabase扩展
 */
@interface FMDatabase (Ext)

/**
 *  在数据库表中是否存在指定字段
 *
 *  @param column 字段名
 *  @param table  表名
 *
 *  @return 存在返回YES
 */
- (BOOL)hasExistColumn:(NSString *)column inTable:(NSString *)table;

@end
