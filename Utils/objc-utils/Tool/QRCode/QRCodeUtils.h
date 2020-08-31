//
//  QRCodeUtils.h
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, kCodeImageType) {
    kCodeImageTypeQRCode = 0,    //type for QRCode
    kCodeImageTypeBarCode,       //type for BarCode
};

@interface QRCodeUtils : NSObject
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
               backgroundColor:(UIColor *)backgroundColor;


@end

NS_ASSUME_NONNULL_END
