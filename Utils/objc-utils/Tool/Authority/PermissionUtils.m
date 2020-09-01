//
//  PermissionUtils.m
//  Utils
//
//  Created by Mo on 2017/7/31.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import "PermissionUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>

@implementation PermissionUtils

/**
 是否获取麦克风权限
 (在info.plist中配置 App Transport Security Settings -> Privacy - Microphone Usage Description)
 @param failureOperation 没有权限之后需要做的操作
 @return yes/no
 */
+ (BOOL)isAccessMicrophonePermissionAndFailureOperation:(void(^)())failureOperation {
    //yes -> 需要语音的时候才会弹窗
    //no -> 进入app就会提示用户获取权限
    __block BOOL bCanRecord = NO;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
                [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                    if (granted) {
                        bCanRecord = YES;
                    }
                    else {
                        bCanRecord = NO;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failureOperation != nil) {
                                failureOperation();
                            }
                        });
                    }
                }];
            }
        }];
    }
    return bCanRecord;
}


/**
 检测是否获取相机和相册的权限
 (在info.plist中配置 App Transport Security Settings -> Privacy - Camera Usage Description & Privacy - Photo Library Usage Description)
 @param failureOperation 没有权限之后需要做的操作
 @return yes/no
 */
+ (BOOL)isAccessCameraPermissionAndFailureOperation:(void(^)())failureOperation {
    //读取媒体类型
    NSString *mediaType = AVMediaTypeVideo;
    //读取设备授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        if (failureOperation != nil) {
            failureOperation();
        }
        return NO;
    }
    return YES;
}



/**
 检测是否获取读写联系人的权限
 (在info.plist中配置 App Transport Security Settings -> Privacy - Contacts Usage Description)
 @param failureOperation 没有权限之后需要做的操作
 @return yes/no
 */
+ (BOOL)isAccessContactPermissionAndFailureOperation:(void(^)())failureOperation {
    
    double version = [UIDevice currentDevice].systemVersion.doubleValue;

    __block BOOL bCanContact = NO;
    if (version >= 9.0) {
        //afetr iOS 9.0 use CNContact
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                bCanContact = granted;
                if (!granted) {
                    if (failureOperation != nil) {
                        failureOperation();
                    }
                }
            }];
        } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
            bCanContact = YES;
        } else {
            bCanContact = NO;
        }
    } else {
        //before iOS 9.0 use AddressBook
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        if (authStatus != kABAuthorizationStatusAuthorized) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error != nil) {
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                    } else {
                        bCanContact = granted;
                        if (!granted) {
                            if (failureOperation != nil) {
                                failureOperation();
                            }
                        }
                    }
                });
            });
        } else {
            bCanContact = YES;
        }
    }
    return bCanContact;
}


@end
