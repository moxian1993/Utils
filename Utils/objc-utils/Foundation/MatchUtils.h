//
//  MatchUtils.h
//  Utils
//
//  Created by Mo on 2017/7/28.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchUtils : NSObject

/// 判断手机号码格式是否正确
/// @param mobile mobile
+ (BOOL)verifyMobile:(NSString *)mobile;

/// 判断email格式是否正确
/// @param email email
+ (BOOL)verifyEmail:(NSString *)email;

@end
