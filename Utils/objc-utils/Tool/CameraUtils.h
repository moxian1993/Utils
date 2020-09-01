//
//  CameraUtils.h
//  Utils
//
//  Created by Mo on 2017/8/22.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^FinishHandler)(NSDictionary *info);
typedef void(^CancelHandler)(UIImagePickerController *picker);

@interface CameraUtils : NSObject

/**
 init

 @param finishedHandler void(^FinishHandler)(NSDictionary *info)
 @return instance of CameraManager
 */
- (instancetype)initWithFinishedHandler:(FinishHandler)finishedHandler;


/**
 普通弹窗

 @param hasResetAction 是否需要重置头像这个功能
 @param resetHandler 重置头像操作
 */
- (void)showPhotoOperationAlertHasResetAction:(BOOL)hasResetAction resetHandler:(void(^)(UIAlertAction *resetAction))resetHandler;

/**
 如果取消过程中需要特殊操作，就实现cancelHandle
 */
@property (nonatomic, copy) CancelHandler cancelHandle;


@end
