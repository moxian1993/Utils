//
//  EOCAutoDictionary.m
//  Utils
//
//  Created by Mo on 2017/9/14.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import "EOCAutoDictionary.h"
#import <objc/message.h>

@interface EOCAutoDictionary ()
@property (nonatomic, strong) NSMutableDictionary *mDictionary;
@end 

@implementation EOCAutoDictionary

- (NSMutableDictionary *)mDictionary {
    if (!_mDictionary) {
        _mDictionary = [NSMutableDictionary dictionary];
    }
    return _mDictionary;
}

@dynamic string, number, date, opaqueObject;

void propertySetter(id self, SEL _cmd, id value) {
    EOCAutoDictionary *typeSelf = (EOCAutoDictionary *)self;
    
    NSString *selectorName = NSStringFromSelector(_cmd);
    //setXXXXX:
    NSString *key = [[selectorName substringWithRange:NSMakeRange(3, selectorName.length -4)] lowercaseString];
    if (key && value) {
        [typeSelf.mDictionary setObject:value forKey:key];
        NSLog(@"saved value success, key: %@, value: %@", key, value);
    } else {
        NSLog(@"saved value failure");
    }
}

id propertyGetter(id self, SEL _cmd) {
    EOCAutoDictionary *typeSelf = (EOCAutoDictionary *)self;
    
    NSString *seletorName = NSStringFromSelector(_cmd);
    NSString *key = [seletorName lowercaseString];
    if (key) {
        id value = typeSelf.mDictionary[key];
        NSLog(@"get value success, key :%@, value: %@",key ,value);
        return value;
    }
    NSLog(@"get value failure");
    return nil;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selString = NSStringFromSelector(sel);
    if ([selString hasPrefix:@"set"]) {
        //set         //向类中动态添加方法   //函数指针，指向待添加的方法
        class_addMethod([self class], sel, (IMP)propertySetter, "v@:@");
                               //处理给定的选择器                 //类型编码
    } else { //get
        class_addMethod([self class], sel, (IMP)propertyGetter, "@@:");
    }
    return YES;
}

@end
