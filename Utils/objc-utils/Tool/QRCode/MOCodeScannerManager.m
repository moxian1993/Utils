//
//  MOCodeScannerManager.m
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOCodeScannerManager.h"

#define SESSION    ([MOCodeScannerManager shared].session)

static MOCodeScannerManager *_instance;

@interface MOCodeScannerManager () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;

@end

@implementation MOCodeScannerManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)scannerWithType:(kCodeScannerType)type
                success:(void(^)(CALayer *layer))success
                failure:(void(^)(AVAuthorizationStatus status, NSString *errorMessage))failure {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self setup:type];
                if (success) {
                    success(self.layer);
                }
            } else {
                if (failure) {
                    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    failure(status, @"未获得权限");
                }
            }
        });
    }];
}


- (void)setup:(kCodeScannerType)type {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ([device hasTorch]) {
        device.torchMode = AVCaptureTorchModeAuto;
    }
    [device unlockForConfiguration];

    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [AVCaptureSession new];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
        output.metadataObjectTypes = [self targetType:type];
        
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.layer = layer;
    }
}


- (void)start:(void(^ __nullable)(void))handle {
    if (!self.session) return;
    [self.session startRunning];
    if (handle) {
        handle();
    }
}

- (void)stop:(void(^ __nullable)(void))handle {
    if (!self.session) return;
    [self.session stopRunning];
    if (handle) {
        handle();
    }
}

- (void)invalidate {
    [self stop:nil];
    [self.layer removeFromSuperlayer];
}

- (void)setScanRect:(CGRect)rect {
    //设置识别区域，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    AVCaptureMetadataOutput *output = self.session.outputs.lastObject;
    output.rectOfInterest = CGRectMake(rect.origin.y/Screen_Height,
                                       rect.origin.x/Screen_Width,
                                       rect.size.height/Screen_Height,
                                       rect.size.width/Screen_Width);
}

- (void)setScanScale:(CGFloat)scale {
    AVCaptureDeviceInput *input = self.session.inputs.lastObject;
    
    AVCaptureDevice *device = input.device;
    [device lockForConfiguration:nil];
    //device.videoZoomFactor = scale;///硬过渡
    [device rampToVideoZoomFactor:scale withRate:10.0];///平滑过渡
    [device unlockForConfiguration];
    
    /* 改变焦距，对于 self.layer 的父视图，可能需要
     superView.clipsToBounds = YES;
     superLayer.masksToBounds = YES;
     */
    //        AVCaptureMetadataOutput *output = weakSelf.session.outputs.lastObject;
    //        AVCaptureConnection *connect = [output connectionWithMediaType:AVMediaTypeVideo];
    //        connect.videoScaleAndCropFactor = scale;
    //
    //        [CATransaction begin];
    //        [CATransaction setAnimationDuration:0.2];
    //        [weakSelf.layer setAffineTransform:CGAffineTransformMakeScale(scale, scale)];
    //        [CATransaction commit];
}

- (NSArray *)targetType:(kCodeScannerType)scannerType {
    NSArray *qrCodeTypes = @[AVMetadataObjectTypeQRCode];
    NSArray *barCodeTypes = @[AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code];
    if (scannerType == kCodeScannerTypeQRCode) {
        return qrCodeTypes;
    }
    else if (scannerType == kCodeScannerTypeBarCode) {
        return barCodeTypes;
    }
    else {
        NSMutableArray *array = NSMutableArray.array;
        [array addObjectsFromArray:qrCodeTypes];
        [array addObjectsFromArray:barCodeTypes];
        return array.copy;
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
        if (obj.stringValue) {
            if ([self.delegate respondsToSelector:@selector(codeScannerCaptureDidOutputObject:)]) {
                [self.delegate codeScannerCaptureDidOutputObject:obj.stringValue];
            }
        }
    }
}



@end
