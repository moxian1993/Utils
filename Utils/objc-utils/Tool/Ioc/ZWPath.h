//
//  ZWPath.h
//  DictPublishAssistant
//
//  Created by zhuwei on 15/2/11.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWSingleton.h"

/**
 路径管理器
 
 */
@interface ZWPath : NSObject

INTERFACE_SINGLETON(ZWPath);
/**
 获取bundle的路径
 
 @param bundle: bundle对象
 
 @param relativePath: 相对路径
 
 @return 返回路径
 */
- (NSString *)pathForBundle:(NSBundle *)bundle relativePath:(NSString *)relativePath;

/**
 获取主bundle路径
 
 @param relativePath: 相对路径
 
 @return 返回路径
 */
- (NSString *)pathForMainBundleRelativePath:(NSString *)relativePath;

/**
 获取主bundle路径
 
 @return 返回路径
 */
- (NSString *)pathForMainBundle;

/**
 获取主document路径
 
 @param relativePath: 相对路径
 
 @return 返回路径
 */
- (NSString *)pathForDocumentRelativePath:(NSString *)relativePath;

/**
 获取主document路径
 
 @return 返回路径
 */
- (NSString *)pathForDocument;

/**
 获取主cache路径
 
 @param relativePath: 相对路径
 
 @return 返回路径
 */
- (NSString *)pathForCachesRelativePath:(NSString *)relativePath;

/**
 获取主cache路径
 
 @return 返回路径
 */
- (NSString *)pathForCaches;
@end
