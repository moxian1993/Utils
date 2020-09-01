//
//  UIImage+Zip.h
//  Utils
//
//  Created by Mo on 2017/7/28.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Zip)

/**
 压缩图片到指定文件大小
 
 @param image image
 @param size size
 @return data
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

@end
