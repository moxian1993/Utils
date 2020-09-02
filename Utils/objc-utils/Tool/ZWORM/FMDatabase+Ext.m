//
//  FMDatabase+Ext.m
//  Pods
//
//  Created by zhuwei on 15/7/22.
//
//

#import "FMDatabase+Ext.h"

@implementation FMDatabase (Ext)

/**
 *  在数据库表中是否存在指定字段
 *
 *  @param column 字段名
 *  @param table  表名
 *
 *  @return 存在返回YES
 */
- (BOOL)hasExistColumn:(NSString *)column inTable:(NSString *)table {
    if(column == nil || table == nil) return NO;
    BOOL isExist = NO;
    NSString* sql = [NSString stringWithFormat:@"PRAGMA table_info([%@])",table];
    FMResultSet* reslutSet = [self executeQuery:sql];
    while([reslutSet next]) {
        NSString* clomnName = [reslutSet stringForColumn:@"name"];
        if([column isEqualToString:clomnName]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}

@end
