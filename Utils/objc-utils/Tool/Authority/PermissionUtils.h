//
//  PermissionUtils.h
//  Utils
//
//  Created by Mo on 2017/7/31.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermissionUtils : NSObject

/**
 检测是否获取麦克风权限
 (在info.plist中配置 App Transport Security Settings -> Privacy - Microphone Usage Description)
 @param failureOperation 没有权限之后需要做的操作
 @return yes/no
 */
+ (BOOL)isAccessMicrophonePermissionAndFailureOperation:(void(^)())failureOperation;


/**
 检测是否获取相机和相册的权限
(在info.plist中配置 App Transport Security Settings -> Privacy - Camera Usage Description & Privacy - Photo Library Usage Description)
 @param failureOperation 没有权限之后需要做的操作
 @return yes/no
 */
+ (BOOL)isAccessCameraPermissionAndFailureOperation:(void(^)())failureOperation;


/**
 检测是否获取读写联系人的权限
 (在info.plist中配置 App Transport Security Settings -> Privacy - Contacts Usage Description)
 @param failureOperation 没有权限之后需要做的操作
 @return yes/no
 */
+ (BOOL)isAccessContactPermissionAndFailureOperation:(void(^)())failureOperation;

@end
