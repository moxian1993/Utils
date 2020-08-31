//
//  UIFont+FontName.m
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "UIFont+FontName.h"
#import <CoreText/CoreText.h>

@implementation UIFont (FontName)

/** 获取系统拥有的所有字体的名称数组 */
+ (NSArray *)allFontNames {
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSMutableArray *allFontNames = [NSMutableArray array];
    NSArray *fontNames;
    NSInteger indFamily, indFont;

    //NSLog(@"familyNames.count=%ld", familyNames.count);
    for(indFamily = 0; indFamily < familyNames.count; indFamily++) {
        [allFontNames addObject:[NSString stringWithFormat:@"Family name: %@", [familyNames objectAtIndex:indFamily]]];
        fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for(indFont=0; indFont < fontNames.count; indFont++) {
            [allFontNames addObject:[NSString stringWithFormat:@"  Font name: %@", [fontNames objectAtIndex:indFont]]];
        }
    }
    return [allFontNames copy];
}


/**
 获取导入的自定义字体的名称
 并注册自定义字体到系统字体库，在程序启动后调用一次即可
 适用字体类型：ttf，otf

 @param path 字体文件存放路径，
 @return 自定义字体的名称
 */
+ (NSString *)customFontNameWithPath:(NSString *)path {
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    CGFontRelease(fontRef);
    return fontName;
}


/**
 获取导入的自定义字体的名称数组
 并注册自定义字体到系统字体库，在程序启动后调用一次即可
 适用字体类型：ttc

 @param path 字体文件存放路径
 @return 自定义字体的名称数组
 */
+ (NSArray *)customFontNameArrayWithPath:(NSString *)path {
    CFStringRef fontPath = CFStringCreateWithCString(NULL, [path UTF8String], kCFStringEncodingUTF8);
    CFURLRef fontUrl = CFURLCreateWithFileSystemPath(NULL, fontPath, kCFURLPOSIXPathStyle, 0);
    CFArrayRef fontArray =CTFontManagerCreateFontDescriptorsFromURL(fontUrl);
    CTFontManagerRegisterFontsForURL(fontUrl, kCTFontManagerScopeNone, NULL);
    NSMutableArray *customFontArray = [NSMutableArray array];
    for (CFIndex i = 0 ; i < CFArrayGetCount(fontArray); i++){
        CTFontDescriptorRef  descriptor = CFArrayGetValueAtIndex(fontArray, i);
        CTFontRef fontRef = CTFontCreateWithFontDescriptor(descriptor, 15, NULL);
        NSString *fontName = CFBridgingRelease(CTFontCopyName(fontRef, kCTFontPostScriptNameKey));
        [customFontArray addObject:fontName];
    }
    return customFontArray;
}


@end
