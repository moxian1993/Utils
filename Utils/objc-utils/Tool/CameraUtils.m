//
//  CameraUtils.m
//  Utils
//
//  Created by Mo on 2017/8/22.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import "CameraUtils.h"
#import "UIViewController+CurrentVC.h"
#import "PermissionUtils.h"

@interface CameraUtils () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, copy) FinishHandler finishedHandler;

@end

@implementation CameraUtils

- (instancetype)initWithFinishedHandler:(FinishHandler)finishedHandler {
    if (self = [super init]) {
        _finishedHandler = finishedHandler;
        _currentVC = [UIViewController getCurrentVC];
    }
    return self;
}


- (void)showPhotoOperationAlertHasResetAction:(BOOL)hasResetAction resetHandler:(void(^)(UIAlertAction *resetAction))resetHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takingPictures = [UIAlertAction actionWithTitle:@"拍照照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takingPictures];
    }];
    UIAlertAction *selectPhotos = [UIAlertAction actionWithTitle:@"选图图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhontos];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [takingPictures setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [selectPhotos setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [alertController addAction:takingPictures];
    [alertController addAction:selectPhotos];
    [alertController addAction:cancelAction];
    
    if (hasResetAction) {
        UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"还原为默认" style:UIAlertActionStyleDestructive handler:resetHandler];
        [alertController addAction:resetAction];
    }
    
    [_currentVC presentViewController:alertController animated:YES completion:nil];
}


- (void)takingPictures {
    
    // 判断当前的sourceType是否可用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 实例化UIImagePickerController控制器
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        // 设置资源来源（相册、相机、图库之一）
        imagePickerVC.sourceType =UIImagePickerControllerSourceTypeCamera;
        
        /**
         设置可用的媒体类型、默认只包含kUTTypeImage，如果想选择视频，请添加kUTTypeMovie
         imagePickerVC.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
         如果选择的是视屏，允许的视屏时长为20秒
         imagePickerVC.videoMaximumDuration = 20;
         允许的视屏质量（如果质量选取的质量过高，会自动降低质量）
         imagePickerVC.videoQuality = UIImagePickerControllerQualityTypeHigh;
         相机获取媒体的类型（照相、录制视屏）
         imagePickerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
         使用前置还是后置摄像头
         imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceRear;
         是否看起闪光灯
         imagePickerVC.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
         imagePickerVC.showsCameraControls = NO;
         */
        
        // 设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
        imagePickerVC.delegate = self;
        // 是否允许编辑
        imagePickerVC.allowsEditing = YES;
        
        [_currentVC presentViewController:imagePickerVC animated:YES completion:nil];
    }
}


- (void)selectPhontos {
    //从图库获取与从相册获取一样，只不过 sourceType 换成 UIImagePickerControllerSourceTypeSavedPhotosAlbum
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        // 设置资源来源
        imagePickerVC.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        
        /**
         设置可用的媒体类型、默认只包含kUTTypeImage，如果想选择视频，请添加kUTTypeMovie
         如果选择的是视屏，允许的视屏时长为20秒
         imagePickerVC.videoMaximumDuration = 20;
         imagePickerVC.videoQuality = UIImagePickerControllerQualityTypeHigh;
         imagePickerVC.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
         */
        
        //设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
        imagePickerVC.delegate = self;
        // 是否允许编辑（YES：图片选择完成进入编辑模式)
        imagePickerVC.allowsEditing = YES;
        // model出控制器
        [_currentVC presentViewController:imagePickerVC animated:YES completion:nil];
    }
}


#pragma mark - UIImagePickerControllerDelegate
// 选择图片成功调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //没有权限 照片不生效
    if (![PermissionUtils isAccessCameraPermissionAndFailureOperation:nil]) {
        [_currentVC dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    // 选择的图片信息存储于info字典中
    NSLog(@"%@", info);
    /**
     注：info中可能包含的key的含义
     UIImagePickerControllerCropRect // 编辑裁剪区域
     UIImagePickerControllerEditedImage // 编辑后的UIImage
     UIImagePickerControllerMediaType // 返回媒体的媒体类型
     UIImagePickerControllerMediaMetadata // UIImage的原始数据(拍照特有)
     UIImagePickerControllerOriginalImage // 原始的UIImage
     UIImagePickerControllerReferenceURL // 图片地址 (photoLibrary特有)
     */
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //如果是拍照，那么将图片保存到相册
    if (info[UIImagePickerControllerReferenceURL] == nil) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    if (self.finishedHandler != nil) {
        self.finishedHandler(info);
    }
    
    [_currentVC dismissViewControllerAnimated:YES completion:nil];
}


// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if (self.cancelHandle != nil) {
        self.cancelHandle(picker);
    }
    // dismiss UIImagePickerController
    [_currentVC dismissViewControllerAnimated:YES completion:nil];
}


/**
 // Adds a photo to the saved photos album.  The optional completionSelector should have the form:
 // 照片保存相册需要实现(可以空实现)
 //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
 UIKIT_EXTERN void UIImageWriteToSavedPhotosAlbum(UIImage *image, __nullable id completionTarget, __nullable SEL completionSelector, void * __nullable contextInfo) __TVOS_PROHIBITED;
 
 // Is a specific video eligible to be saved to the saved photos album?
 UIKIT_EXTERN BOOL UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(NSString *videoPath) NS_AVAILABLE_IOS(3_1) __TVOS_PROHIBITED;
 
 // Adds a video to the saved photos album. The optional completionSelector should have the form:
 // 视频保存相册需要实现（可以空实现）
 //  - (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
 UIKIT_EXTERN void UISaveVideoAtPathToSavedPhotosAlbum(NSString *videoPath, __nullable id completionTarget, __nullable SEL completionSelector, void * __nullable contextInfo) NS_AVAILABLE_IOS(3_1) __TVOS_PROHIBITED;
 
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}


#pragma mark - UINavigationControllerDelegate
//实现圆形覆盖
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //选取图片的时候 naviVC.viewControllers.count == 3
    if ([navigationController.viewControllers count] == 3) {
        
        UIView *plCropOverlay = [[[viewController.view.subviews objectAtIndex:1]subviews] objectAtIndex:0];
        plCropOverlay.hidden = YES;
        int position = (screenHeight - screenWidth + 20)/2.0;
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        
        UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:
                               CGRectMake(10.0f, position, screenWidth -20, screenWidth -20)];
        [path2 setUsesEvenOddFillRule:YES];
        
        [circleLayer setPath:[path2 CGPath]];
        
        [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, screenWidth, screenHeight-72) cornerRadius:0];
        
        [path appendPath:path2];
        [path setUsesEvenOddFillRule:YES];
        
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillRule = kCAFillRuleEvenOdd;
        fillLayer.fillColor = [UIColor blackColor].CGColor;
        fillLayer.opacity = 0.7;
        [viewController.view.layer addSublayer:fillLayer];
        
        UILabel *moveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, screenWidth, 50)];
        [moveLabel setText:@"移动和缩放"];
        [moveLabel setTextAlignment:NSTextAlignmentCenter];
        [moveLabel setTextColor:[UIColor whiteColor]];
        moveLabel.center = CGPointMake(viewController.view.center.x, position /2.0);
        [viewController.view addSubview:moveLabel];
    }
}




@end
