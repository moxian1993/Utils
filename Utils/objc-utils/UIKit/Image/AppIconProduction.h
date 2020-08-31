//
//  AppIconProduction.h
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppIconProduction : NSObject
/**
 image标准大小，建议 1024*1024
 */
+ (void)generatorAppIconByImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
