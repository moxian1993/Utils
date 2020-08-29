//
//  FileUtils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "FileUtils.h"

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


@end
