//
//  FileUtils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Path)

/// 给当前文件追加文档路径
- (NSString *)utils_appendDocumentDir;

/// 给当前文件追加缓存路径
- (NSString *)utils_appendCacheDir;

/// 给当前文件追加临时路径
- (NSString *)utils_appendTempDir;
@end

@interface FileUtils : NSObject

/**
 返回资源文件(Data)
 
 @param resourceName 资源名
 @param type 拓展名
 @param bundleName 文件夹名(mainBundle写nil)
 @return resourceData
 */
+ (NSData *)dataWithName:(NSString *)resourceName type:(NSString *)type  bundleName:(NSString * __nullable)bundleName;


/**
 返回资源文件路径(path)
 
 @param resourceName 资源名
 @param type 拓展名
 @param bundleName 文件夹名(mainBundle写nil)
 @return resourcePath
 */
+ (NSString *)pathWithName:(NSString *)resourceName type:(NSString *)type  bundleName:(NSString * __nullable)bundleName;


/**
 返回资源文件路径(url)
 
 @param resourceName 资源名
 @param type 拓展名
 @param bundleName 文件夹名(mainBundle写nil)
 @return resourceUrl
 */
+ (NSURL *)URLWithName:(NSString *)resourceName type:(NSString *)type bunleName:(NSString * __nullable)bundleName;


/**
 获取磁盘总空间的大小
 @return disk size
 */
+ (CGFloat)diskOfAllSizeMBytes;


/**
 获取磁盘可用空间大小
 @return disk of free size
 */
+ (CGFloat)diskOfFreeSizeMBytes;


/**
 获取指定路径下某个文件的大小
 @param filePath filePath
 @return file size
 */
+ (long long)fileSizeAtPath:(NSString *)filePath;


/**
 获取文件夹下所有文件的大小
 @param folderPath folderPath
 @return folder size
 */
+ (long long)folderSizeAtPath:(NSString *)folderPath;


@end

NS_ASSUME_NONNULL_END
