//
//  UIImage+Utils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIImage+Utils.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Utils)

- (UIImage *)resize:(CGSize)size {
    if (CGSizeEqualToSize(self.size, size)) return self;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    BOOL hasAlpha = [UIImage imageHasAlphaChannel:self];
    UIGraphicsBeginImageContextWithOptions(rect.size, !hasAlpha, 0.0f);
    [self drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (BOOL)imageHasAlphaChannel:(UIImage *)image {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}



+ (UIImage *)imageFromText:(NSString *)text
                      size:(CGSize)targetSize
                      font:(UIFont *)font
                     color:(UIColor *)color
                 fillColor:(UIColor *)fillColor {
    UIImage* returnImg = nil;
    
    CGFloat maxWidth = targetSize.width;
    CGFloat maxHeight = targetSize.height;
    
    // 创建一个bitmap的context
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContext(CGSizeMake(maxWidth *scale, maxHeight *scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    CGRect drawRect = CGRectMake(0, 0, maxWidth, maxHeight);
    CGContextClearRect(context,drawRect);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, drawRect);
    
    // 绘制文字
    CGSize sizeTextCanDraw = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    
    CGRect rcTextRect = CGRectMake((targetSize.width - sizeTextCanDraw.width) / 2,
                                   (targetSize.height - sizeTextCanDraw.height) / 2,
                                    sizeTextCanDraw.width,
                                   sizeTextCanDraw.height);

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [text drawInRect:rcTextRect withAttributes:@{NSFontAttributeName :font,
                                                NSParagraphStyleAttributeName:paragraphStyle,
                                                NSForegroundColorAttributeName: color}];
    
    // 从当前context中创建一个改变大小后的图片
    returnImg = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return [UIImage imageWithCGImage:returnImg.CGImage scale:scale orientation:UIImageOrientationUp];
}


+ (UIImage *)imageWithData:(NSData *)data size:(CGSize)size {
    UIImage *image = [UIImage imageWithData:data];
    CGImageRef cgImage = image.CGImage;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)cropImageToRect:(CGRect)rect {
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    // determine the orientation of the image and apply a transformation to the crop rectangle to shift it to the correct position
    CGAffineTransform rectTransform;
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -self.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -self.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -self.size.width, -self.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    // adjust the transformation scale based on the image scale
    rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
    // apply the transformation to the rect to create a new, shifted rect
    CGRect transformedCropSquare = CGRectApplyAffineTransform(rect, rectTransform);
    // use the rect to crop the image
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, transformedCropSquare);
    // create a new UIImage and set the scale and orientation appropriately
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    // memory cleanup
    CGImageRelease(imageRef);
    return result;
}


@end
