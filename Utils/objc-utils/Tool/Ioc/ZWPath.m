//
//  ZWPath.m
//  DictPublishAssistant
//
//  Created by zhuwei on 15/2/11.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "ZWPath.h"

@implementation ZWPath

IMPLEMENTATION_SINGLETON(ZWPath)

/**
 获取bundle的路径
 
 @param bundle: bundle对象
 
 @param relativePath: 相对路径
 
 @return 返回路径
 */
- (NSString *)pathForBundle:(NSBundle *)bundle relativePath:(NSString *)relativePath {
    NSString* resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle) resourcePath];
    return (nil == relativePath ? resourcePath :[resourcePath stringByAppendingPathComponent:relativePath]);
}

/**
 获取主bundle路径
 
 @param relativePath: 相对路径
 
 @return 返回路径
 */
- (NSString *)pathForMainBundleRelativePath:(NSString *)relativePath {
    return [self pathForBundle:nil relativePath:relativePath];
}

/**
 获取主bundle路径
 
 @return 返回路径
 */
- (NSString *)pathForMainBundle {
    return [self pathForBundle:nil relativePath:nil];
}

/**
 获取主document路径
 
 @param relativePath: 相对路径
 
 @return 返回路径
 */
- (NSString *)pathForDocumentRelativePath:(NSString *)relativePath {
    static NSString* documentsPath = nil;
    if (nil == documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
        documentsPath = [dirs objectAtIndex:0];
    }
    return (nil != relativePath) ? [documentsPath stringByAppendingPathComponent:relativePath] : documentsPath;
}

/**
 获取主document路径
 
 @return 返回路径
 */
- (NSString *)pathForDocument {
    return [self pathForDocumentRelativePath:nil];
}

/**
 获取主cache路径
 
 @param relativePath: 相对路径
 
 @return 返回路径
 */
- (NSString *)pathForCachesRelativePath:(NSString *)relativePath {
    static NSString* cachesPath = nil;
    if (nil == cachesPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                            NSUserDomainMask,
                                                            YES);
        cachesPath = [dirs objectAtIndex:0];
    }
    return (nil != relativePath) ? [cachesPath stringByAppendingPathComponent:relativePath] : cachesPath;
}

/**
 获取主cache路径
 
 @return 返回路径
 */
- (NSString *)pathForCaches {
    return [self pathForCachesRelativePath:nil];
}

@end
