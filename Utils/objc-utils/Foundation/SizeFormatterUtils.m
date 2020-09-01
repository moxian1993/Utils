//
//  SizeFormatterUtils.m
//  Utils
//
//  Created by Mo on 2017/8/9.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import "SizeFormatterUtils.h"

@implementation SizeFormatterUtils

/**
 格式化容量数据

 @param size size
 @return formatted size string
 */
+ (NSString *)sizeFormatter:(NSUInteger)size {
    
    NSString *sizeStr;
    if (size >= (1024.0 * 1024.0 * 1024.0)) {
        // size >= 1GB
        sizeStr = [NSString stringWithFormat:@"%.2fGB", size / (1024.0 * 1024.0 * 1024.0)];
    } else if (size >= (1024.0 * 1024.0)) {
        // 1GB > size >= 1MB
        sizeStr = [NSString stringWithFormat:@"%.2fMB", size / (1024.0 * 1024.0)];
    } else if (size >= 1024.0) {
        // 1MB > size >= 1KB
        sizeStr = [NSString stringWithFormat:@"%.2fKB", size / 1024.0];
    } else {
        // 1KB > size
        sizeStr = [NSString stringWithFormat:@"%zdB", size];
    }
    return sizeStr;
}


/**
 获取文件大小

 @param filePath 文件路径
 @return formatted size string
 */
+ (NSString *)fileSizeWithFilePath:(NSString *)filePath {
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSDictionary *attrs = [mgr attributesOfItemAtPath:filePath error:nil];
    // 如果这个文件或者文件夹不存在,或者路径不正确
    if (attrs == nil) {
        return @"error file";
    }
    
    unsigned long long size = 0;
    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) {
        // 如果是文件夹
        // 获得文件夹的大小 == 获得文件夹中所有文件的总大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:filePath];
        for (NSString *subpath in enumerator) {
            // 全路径 累加文件大小
            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        return [self sizeFormatter:size];
    }
    // 如果是文件
    return [self sizeFormatter:attrs.fileSize];
}

@end
