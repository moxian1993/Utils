//
//  NSString+Encrypt.h
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Encrypt)

/** SHA-256加密 */
- (NSString *)encryptSHA256;
+ (NSString *)encryptSHA256:(NSData *)keyData;

/** SHA-1加密 */
- (NSString *)encryptSHA1;
+ (NSString *)encryptSHA1:(NSData *)keyData;


/** MD5加密 */
- (NSString *)encryptMD5;

@end

NS_ASSUME_NONNULL_END
