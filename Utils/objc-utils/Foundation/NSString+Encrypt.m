//
//  NSString+Encrypt.m
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonDigest.h>

@interface NSObject (NotNull)

@end

@implementation NSObject (NotNull)

- (BOOL)isNotNull {
    if (self == nil) {
        return NO;
    }
    else if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    else if ([self isKindOfClass:[NSString class]] ||
             [self isKindOfClass:[NSData class]]) {
        if (((NSString *)self).length == 0) {
            return NO;
        }
    }
    return YES;
}
@end


@implementation NSString (Encrypt)

- (NSString *)encryptSHA256 {
    if (![self isNotNull]) return nil;

    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];

    return [NSString encryptSHA256:keyData];
}


+ (NSString *)encryptSHA256:(NSData *)keyData {
    if (![keyData isNotNull]) return nil;

    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];

    return hash;
}


- (NSString *)encryptSHA1 {
    if (![self isNotNull]) return nil;

    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:cstr length:self.length];

    return [NSString encryptSHA1:keyData];
}

+ (NSString *)encryptSHA1:(NSData *)keyData {
    if (![keyData isNotNull]) return nil;

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(keyData.bytes, (unsigned int)keyData.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}


- (NSString *)encryptMD5 {
    if (![self isNotNull]) return nil;

    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return  output;
}
@end
