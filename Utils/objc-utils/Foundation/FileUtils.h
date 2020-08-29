//
//  FileUtils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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


@end

NS_ASSUME_NONNULL_END
