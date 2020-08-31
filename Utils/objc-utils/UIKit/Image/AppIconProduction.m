//
//  AppIconProduction.m
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "AppIconProduction.h"

@implementation AppIconProduction

+ (void)generatorAppIconByImage:(UIImage *)image {
    NSArray *expectedInfos = @[@{@"Name":@"iPhone_20@2x", @"Size":@(40)},
                               @{@"Name":@"iPhone_20@3x", @"Size":@(60)},
                               @{@"Name":@"iPhone_29@2x", @"Size":@(58)},
                               @{@"Name":@"iPhone_29@3x", @"Size":@(87)},
                               @{@"Name":@"iPhone_40@2x", @"Size":@(80)},
                               @{@"Name":@"iPhone_40@3x", @"Size":@(120)},
                               @{@"Name":@"iPhone_60@2x", @"Size":@(120)},
                               @{@"Name":@"iPhone_60@3x", @"Size":@(180)},
                               /* iPad */
                               @{@"Name":@"iPad_20@1x", @"Size":@(20)},
                               @{@"Name":@"iPad_20@2x", @"Size":@(40)},
                               @{@"Name":@"iPad_29@1x", @"Size":@(29)},
                               @{@"Name":@"iPad_29@2x", @"Size":@(58)},
                               @{@"Name":@"iPad_40@1x", @"Size":@(40)},
                               @{@"Name":@"iPad_40@2x", @"Size":@(80)},
                               @{@"Name":@"iPad_76@1x", @"Size":@(76)},
                               @{@"Name":@"iPad_76@2x", @"Size":@(152)},
                               @{@"Name":@"iPad_83.5@2x", @"Size":@(167)},
                               /* appStore */
                               @{@"Name":@"AppStore_1024@1x", @"Size":@(1024)}];

    for (NSDictionary *expInfo in expectedInfos) {
        NSString *name = expInfo[@"Name"];
        CGFloat size = [expInfo[@"Size"] floatValue];
        UIImage *targetImage = [self image:image autoSize:CGSizeMake(size, size)];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[name stringByAppendingString:@".jpg"]];
        [UIImageJPEGRepresentation(targetImage, 0.9f) writeToFile:filePath atomically:YES];
        NSLog(@"path: %@", filePath);
    }
}


+ (UIImage *)image:(UIImage *)image autoSize:(CGSize)size {
    float imageWidth;
    float imageHeight;
    if (image.size.width < image.size.height) {
        if (image.size.width > size.width) {
            imageWidth = size.width;
            imageHeight = size.width*(image.size.height/image.size.width);
        } else {
            imageWidth = image.size.width;
            imageHeight = image.size.height;
        }
    } else {
        if (image.size.height > size.height) {
            imageWidth = size.height*(image.size.width/image.size.height);
            imageHeight = size.height;
        } else {
            imageWidth = image.size.width;
            imageHeight = image.size.height;
        }
    }

    CGSize targetSize = CGSizeMake(imageWidth, imageHeight);
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
