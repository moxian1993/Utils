//
//  MOImageDetectUtils.h
//  Practice
//
//  Created by Xian Mo on 2020/7/7.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOImageDetectUtils : NSObject


/// 人脸检测并标注红框
/// @param imageView 带有图片的imageView
+ (void)detectFaceWithImageView:(UIImageView *)imageView;


@end

NS_ASSUME_NONNULL_END
