//
//  FileUtils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "FileUtils.h"

@implementation NSString (Path)

- (NSString *)utils_appendDocumentDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)utils_appendCacheDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)utils_appendTempDir {
    NSString *dir = NSTemporaryDirectory();
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

@end


@implementation FileUtils

/**
 返回资源文件(Data)
 
 @param resourceName 资源名
 @param type 拓展名
 @param bundleName 文件夹名(mainBundle写nil)
 @return resourceData
 */
+ (NSData *)dataWithName:(NSString *)resourceName type:(NSString *)type  bundleName:(NSString * __nullable)bundleName {
    
    NSURL *url = [self URLWithName:resourceName type:type bunleName:bundleName];
    return [NSData dataWithContentsOfURL:url];
}


/**
 返回资源文件路径(path)
 
 @param resourceName 资源名
 @param type 拓展名
 @param bundleName 文件夹名(mainBundle写nil)
 @return resourcePath
 */
+ (NSString *)pathWithName:(NSString *)resourceName type:(NSString *)type  bundleName:(NSString * __nullable)bundleName {
    
    if (bundleName == nil || bundleName.length == 0) {
        return [[NSBundle mainBundle] pathForResource:resourceName ofType:type];
    }
    
    if (![bundleName hasSuffix:@".bundle"] && ![bundleName hasSuffix:@".Bundle"]) {
        bundleName = [bundleName stringByAppendingString:@".bundle"];
    }
    return [[NSBundle bundleWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:bundleName]] pathForResource:resourceName ofType:type];
}


/**
 返回资源文件路径(url)
 
 @param resourceName 资源名
 @param type 拓展名
 @param bundleName 文件夹名(mainBundle写nil)
 @return resourceUrl
 */
+ (NSURL *)URLWithName:(NSString *)resourceName type:(NSString *)type bunleName:(NSString * __nullable)bundleName {
    
    if (bundleName == nil || bundleName.length == 0) {
        return [[NSBundle mainBundle] URLForResource:resourceName withExtension:type];
    }
    
    if (![bundleName hasSuffix:@".bundle"] && ![bundleName hasSuffix:@".Bundle"]) {
        bundleName = [bundleName stringByAppendingString:@".bundle"];
    }
    return [[NSBundle bundleWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:bundleName]] URLForResource:resourceName withExtension:type];
}


/**
 获取磁盘总空间的大小
 @return disk size
 */
+ (CGFloat)diskOfAllSizeMBytes {
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error != nil) {
        NSLog(@"error: %@", error.localizedDescription);
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}


/**
 获取磁盘可用空间大小
 @return disk of free size
 */
+ (CGFloat)diskOfFreeSizeMBytes {
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemFreeSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}



/**
 获取指定路径下某个文件的大小
 @param filePath filePath
 @return file size
 */
+ (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) return 0;
    return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
}


/**
 获取文件夹下所有文件的大小
 @param folderPath folderPath
 @return folder size
 */
+ (long long)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *filesEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folerSize = 0;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folerSize += [self fileSizeAtPath:filePath];
    }
    return folerSize;
}


@end
