//
//  MOCodeScannerManager.h
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MOCodeScannerManagerDelegate <NSObject>
/** 接收扫描出的字符串 */
- (void)codeScannerCaptureDidOutputObject:(NSString *)codeString;
@end

typedef NS_ENUM(NSInteger, kCodeScannerType) {
    kCodeScannerTypeAll = 0,     //default, scan QRCode and barcode
    kCodeScannerTypeQRCode,      //scan QRCode only
    kCodeScannerTypeBarCode,     //scan barcode only
};

@interface MOCodeScannerManager : NSObject
@property (nonatomic, weak) id<MOCodeScannerManagerDelegate> delegate;

+ (instancetype)shared;
/** 二维码 & 条形码 扫描器 */
- (void)scannerWithType:(kCodeScannerType)type
                success:(void(^)(CALayer *layer))success
                failure:(void(^)(AVAuthorizationStatus status, NSString *errorMessage))failure;

- (void)start:(void(^ __nullable)(void))handle;
- (void)stop:(void(^ __nullable)(void))handle;
- (void)invalidate;

//设置识别区域，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
- (void)setScanRect:(CGRect)rect;
- (void)setScanScale:(CGFloat)scale;


@end

NS_ASSUME_NONNULL_END
