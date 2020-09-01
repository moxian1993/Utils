//
//  UIImage+Utils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/28.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIImage+Utils.h"

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


- (UIImage *)autoSize:(CGSize)size {
    float imageWidth;
    float imageHeight;
    if (self.size.width < self.size.height) {
        if (self.size.width > size.width) {
            imageWidth = size.width;
            imageHeight = size.width*(self.size.height/self.size.width);
        } else {
            imageWidth = self.size.width;
            imageHeight = self.size.height;
        }
    } else {
        if (self.size.height > size.height) {
            imageWidth = size.height*(self.size.width/self.size.height);
            imageHeight = size.height;
        } else {
            imageWidth = self.size.width;
            imageHeight = self.size.height;
        }
    }
    
    CGSize targetSize = CGSizeMake(imageWidth, imageHeight);
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (UIImage *)imageScalingAndCroppingForSize:(CGSize)size {
    UIImage *sourceImage = self;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    UIImage *newImage = nil;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin.x=(int)thumbnailPoint.x;
    thumbnailRect.origin.y=(int)thumbnailPoint.y;
    thumbnailRect.size.width  = (int)targetSize.width;
    thumbnailRect.size.height = (int)targetSize.height;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
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


- (UIImage *)imageRotation:(UIImageOrientation)orientation {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}


/// 判断图片格式
/// @param data image data
+ (NSString *)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

/// image 转 data
- (NSData *)getImageData {
    NSData *imageData;
    //png
    if (UIImagePNGRepresentation(self) != nil) {
        imageData = UIImagePNGRepresentation(self);
    }else {
        //jpeg
        imageData = UIImageJPEGRepresentation(self, 1.0);
    }
    return imageData;
}


/// 图片切圆角
/// @param radius 角度
- (UIImage *)imageWithCornerRadius:(CGFloat)radius {
    
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    //1, 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    //2, 获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //4, 创建路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    //5, 添加路径
    CGContextAddPath(ctx, path.CGPath);
    //6, 裁减
    CGContextClip(ctx);
    [self drawInRect:rect];
    //7, 获取最终图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //3, 关闭上下文
    UIGraphicsEndImageContext();
    return image;
}


/// 绘制圆形图片
/// @param icon 源图片
/// @param imageSize 目标尺寸
/// @param fillColor 填充色
/// @param borderColor 边框颜色
/// @param borderWidth 边框宽度
+ (UIImage *)circleImageWithIcon:(UIImage *)icon
                       imageSize:(CGSize)imageSize
                       fillColor:(UIColor *)fillColor
                     borderColor:(UIColor *)borderColor
                     borderWidth:(float)borderWidth {
    int w = imageSize.width * [UIScreen mainScreen].scale;
    int h = imageSize.height * [UIScreen mainScreen].scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    
    //绘制圆形正文
    CGContextBeginPath(context);
    if(fillColor) {
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
    }
    if(borderColor) {
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    }
    if(borderWidth > 0) {
        CGContextSetLineWidth(context, borderWidth * [UIScreen mainScreen].scale);
    }
    
    CGContextAddArc(context, w / 2, h / 2, (w - borderWidth * 2) / 2, 0, 360, 0);
    
    if(borderWidth > 0) {
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextSetLineWidth(context, borderWidth);
    } else {
        CGContextDrawPath(context, kCGPathFill);
    }
    CGContextDrawPath(context, kCGPathFill);
    
    //绘制icon
    if(icon) {
        CGImageRef iconRef = icon.CGImage;
        float iconWidth = CGImageGetWidth(iconRef);
        float iconHeight = CGImageGetHeight(iconRef);
        CGContextDrawImage(context, CGRectMake((w - iconWidth) / 2, (h - iconHeight) / 2, iconWidth, iconHeight), iconRef);
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage* img = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return img;
}


/// 生成角标图片
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
/// @param icon 角标图标
/// @param direction 角标所处位置
- (UIImage *)cornerIconImageWithBorderWidth:(float)borderWidth
                                borderColor:(UIColor *)borderColor
                                 cornerIcon:(UIImage *)icon
                        cornerIconDirection:(UIImageCornerIconDirection)direction {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -self.size.height);
    CGContextDrawImage(effectInContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    CGContextSetStrokeColorWithColor(effectInContext, borderColor.CGColor);
    CGContextSetLineWidth(effectInContext, borderWidth);
    
    CGContextMoveToPoint(effectInContext, self.size.width, self.size.width - borderWidth);
    
    
    //    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    
    //    UIRectFill(bounds);
    
    //Draw the tinted image in context
    //    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    //    if (blendMode != kCGBlendModeDestinationIn) {
    //        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //    }
    
    
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outImage;
}


@end
