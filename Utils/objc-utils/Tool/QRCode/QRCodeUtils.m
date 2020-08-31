//
//  QRCodeUtils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "QRCodeUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+Utils.h"

#define kGenerationType  1

@implementation QRCodeUtils

/**
 生成 二维码 & 条形码
 @param type 将要生成的码类型
 @param content 需要二维码携带的信息（二维码，一般是url；条形码，一般是一个有规则的字母数字混合字符串）
 @param size 二维码 & 条形码 大小
 @param foregroundColor 前景色（必须是暗色）
 @param backgroundColor 背景色（必须是亮色）
 @return 二维码 & 条形码 图片数据
 */
+ (UIImage *)codeImageWithType:(kCodeImageType)type
                       content:(NSString *)content
                          size:(CGSize)size
               foregroundColor:(UIColor *)foregroundColor
               backgroundColor:(UIColor *)backgroundColor {
    if (!content || ![content isKindOfClass:NSString.class]) {
        NSLog(@"无法创建 二维码 & 条形码，content参数有误");
        return nil;
    }
    
    CIImage *codeCIImage;
    switch (type) {
        case kCodeImageTypeQRCode:
            // 手动验证二维码的尺寸
            if (size.width != size.height) {
                size = CGSizeMake(size.width, size.width);
            }
            codeCIImage = [self qrcodeImageWithContent:content];
            break;
        case kCodeImageTypeBarCode:
            codeCIImage = [self barCodeImageWithContent:content];
            break;
    }
    
    // 当前2种方式生成二维码 采用方法2会模糊胡
    if (kGenerationType) {
        return [self codeFillColorWithCIImage:codeCIImage
                                         size:size
                              foregroundColor:foregroundColor
                              backgroundColor:backgroundColor];
    } else {
        return [self codeChangeColorWithCIImage:codeCIImage
                                           size:size
                                foregroundColor:foregroundColor
                                backgroundColor:backgroundColor];
    }
}

#pragma mark - 核心代码
+ (CIImage *)qrcodeImageWithContent:(NSString *)content {
    //1.创建二维码滤镜
    CIFilter* qrCIFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.还原滤镜默认属性
    [qrCIFilter setDefaults];
    //3.设置 需要携带的信息数据(二进制数据) 到滤镜中
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrCIFilter setValue:data forKey:@"inputMessage"];
    [qrCIFilter setValue:@"H" forKey:@"inputCorrectionLevel"];//容错等级 Q M H

    CIImage *ciimage = qrCIFilter.outputImage;
    return ciimage;
}

+ (CIImage *)barCodeImageWithContent:(NSString *)content {
    //1.创建条形码滤镜
    CIFilter *barCIFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    //2.还原滤镜默认属性
    [barCIFilter setDefaults];
    //3.设置 需要携带的信息数据(二进制数据) 到滤镜中
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [barCIFilter setValue:data forKey:@"inputMessage"];
    [barCIFilter setValue:@(0.00) forKey:@"inputQuietSpace"];

    CIImage *ciimage = barCIFilter.outputImage;
    return ciimage;
}


/** GenerationType 1*/
+ (UIImage *)codeFillColorWithCIImage:(CIImage *)ciImage
                                 size:(CGSize)size
                      foregroundColor:(UIColor *)foregroundColor
                      backgroundColor:(UIColor *)backgroundColor {
    CIFilter* colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:@"inputImage", ciImage,
                             @"inputColor0", [CIColor colorWithCGColor:foregroundColor.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor], nil];
    //从滤镜中取出生成好的二维码图片
    CIImage* newCIImage = colorFilter.outputImage;
    //生成图片数据
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:newCIImage
                                                                  fromRect:newCIImage.extent];
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);

    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;
}


/** GenerationType 2*/
// 改变码的尺寸 & 改变码的颜色
+ (UIImage *)codeChangeColorWithCIImage:(CIImage *)ciImage
                                   size:(CGSize)size
                        foregroundColor:(UIColor *)foregroundColor
                        backgroundColor:(UIColor *)backgroundColor{
    // 改变尺寸
    UIImage *image = [self changeScaleWithCIImage:ciImage size:size];
    
    // 改变颜色
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);

    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);

    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) { // 将白色变成透明
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = [foregroundColor utils_getRed]; //0~255
            ptr[2] = [foregroundColor utils_getGreen];
            ptr[1] = [foregroundColor utils_getBlue];
            ptr[0] = 255;
        } else {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = [backgroundColor utils_getRed]; //0~255
            ptr[2] = [backgroundColor utils_getGreen];
            ptr[1] = [backgroundColor utils_getBlue];
            ptr[0] = 255;
        }
    }

    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, providerReleaseData);

    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];

    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return resultUIImage;
}

void providerReleaseData (void *info, const void *data, size_t size) {
    free((void*)data);
}


+ (UIImage *)changeScaleWithCIImage:(CIImage *)ciImage size:(CGSize)size {
    CGRect extentRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size.width / CGRectGetWidth(extentRect), size.height / CGRectGetHeight(extentRect));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extentRect) * scale;
    size_t height = CGRectGetHeight(extentRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);

    CIContext *context = [CIContext contextWithOptions:nil];

    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);

    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);

    /* 当前是黑白图片 */
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    return newImage;
}


@end
