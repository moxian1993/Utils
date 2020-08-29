//
//  MOQRCodeController.m
//  Practice
//
//  Created by Xian Mo on 2020/6/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOQRCodeController.h"
#import <AVFoundation/AVFoundation.h>

@interface MOQRCodeController () <AVCaptureMetadataOutputObjectsDelegate>

//@property (nonatomic, strong) AVCaptureSession *session;
//@property (nonatomic, strong) AVCaptureInput *input;
//@property (nonatomic, strong) AVCaptureOutput *output;
@end

@implementation MOQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//    self.input = input;
    
    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    self.output = output;
    
    AVCaptureSession *session = [AVCaptureSession new];
//    self.session = session;
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output]) {
        [session addOutput:output];
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        layer.frame = self.view.bounds;
        [self.view.layer addSublayer:layer];
        
        [session startRunning];
    }

}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
        if (obj.stringValue) {
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:obj.stringValue]];
        }
    }
}



@end
