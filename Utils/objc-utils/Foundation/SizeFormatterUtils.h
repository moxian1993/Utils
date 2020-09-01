//
//  SizeFormatterUtils.h
//  Utils
//
//  Created by Mo on 2017/8/9.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SizeFormatterUtils : NSObject

/**
 格式化容量数据
 
 @param size size
 @return formatted size string
 */
+ (NSString *)sizeFormatter:(NSUInteger)size;

/**
 获取文件大小
 
 @param filePath 文件路径
 @return formatted size string
 */
+ (NSString *)fileSizeWithFilePath:(NSString *)filePath;



@end
