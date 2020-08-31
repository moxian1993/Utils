//
//  NSObject+XFCategory.m
//  XiaoFuTechBasic
//
//  Created by xiaofutech on 2017/9/25.
//  Copyright © 2017年 XiaoFu. All rights reserved.
//

#import "NSObject+XFCategory.h"
#import <objc/runtime.h>

#pragma mark - 借助运行时给分类增加属性
#define Runtime_Setter(propertyName, property) objc_setAssociatedObject(self, propertyName, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define Runtime_Getter(propertyName) objc_getAssociatedObject(self, propertyName)

char* const xf_objectName = "xf_object";
char* const xf_keyboardWillShowName = "xf_keyboardWillShow";
char* const xf_keyboardWillHideName = "xf_keyboardWillHide";

@implementation NSObject (XFCategory)

#pragma mark >> 对象的 复制拷贝 <<
- (NSArray *)xf_ignoredNames {
    return nil;
}

- (void)xf_encode:(NSCoder *)aCoder {
    Class c = self.class;
    while (c && c!= [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];

            if ([self respondsToSelector:@selector(xf_ignoredNames)]) {
                if ([[self xf_ignoredNames] containsObject:key]) {
                    continue;
                }
            }

            id value = [self valueForKeyPath:key];
            if (value!=nil && ![value isKindOfClass:[NSNull class]]) {
                [aCoder encodeObject:value forKey:key];
            }
        }
        free(ivars);
        c = [c superclass];
    }
}

- (void)xf_decode:(NSCoder *)aDecoder {
    Class c = self.class;
    while (c && c != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];

            if ([self respondsToSelector:@selector(xf_ignoredNames)]) {
                if ([[self xf_ignoredNames] containsObject:key]) {
                    continue;
                }
            }

            id value = [aDecoder decodeObjectForKey:key];
            if (value!=nil && ![value isKindOfClass:[NSNull class]]) {
                [self setValue:value forKey:key];
            }
        }
        free(ivars);
        c = [c superclass];
    }
}

- (id)xf_copyWithZone:(NSZone *)zone {
    id copySelf = [[self class] new];

    Class c = self.class;
    while (c && c != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];

            if ([self respondsToSelector:@selector(xf_ignoredNames)]) {
                if ([[self xf_ignoredNames] containsObject:key]) {
                    continue;
                }
            }

            id value = [self valueForKey:key];
            if (value != nil && ![value isKindOfClass:[NSNull class]]) {
                [copySelf setValue:value forKey:key];
            }
        }
        free(ivars);
        c = [c superclass];
    }
    return copySelf;
}

#pragma mark >> 带参，键盘监听 <<
- (id)xf_object {
    return Runtime_Getter(xf_objectName);
}
- (void)setXf_object:(id)xf_object {
    Runtime_Setter(xf_objectName, xf_object);
}

- (void (^)(NSTimeInterval, CGFloat))xf_keyboardWillShow {
    return Runtime_Getter(xf_keyboardWillShowName);
}
- (void)setXf_keyboardWillShow:(void (^)(NSTimeInterval, CGFloat))xf_keyboardWillShow {
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notiCenter addObserver:self
                   selector:@selector(keyboardWillShowForXF:)
                       name:UIKeyboardWillShowNotification object:nil];

    Runtime_Setter(xf_keyboardWillShowName, xf_keyboardWillShow);
}

- (void (^)(NSTimeInterval, CGFloat))xf_keyboardWillHide {
    return Runtime_Getter(xf_keyboardWillHideName);
}
- (void)setXf_keyboardWillHide:(void (^)(NSTimeInterval, CGFloat))xf_keyboardWillHide {
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [notiCenter addObserver:self
                   selector:@selector(keyboardWillHideForXF:)
                       name:UIKeyboardWillHideNotification object:nil];

    Runtime_Setter(xf_keyboardWillHideName, xf_keyboardWillHide);
}

- (void)keyboardWillShowForXF:(NSNotification *)noti {
    NSDictionary* info = [noti userInfo];
    CGFloat height = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.xf_keyboardWillShow) {
        self.xf_keyboardWillShow(duration, height);
    }
}
- (void)keyboardWillHideForXF:(NSNotification *)noti {
    NSDictionary* info = [noti userInfo];
    //CGFloat height = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.xf_keyboardWillHide) {
        self.xf_keyboardWillHide(duration, 0);
    }
}

#pragma mark >> 安全性检查 <<
- (long)xf_GetRetainCount {
    return CFGetRetainCount((__bridge CFTypeRef)(self));
}

- (BOOL)xf_NotNull {
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

- (id)xf_checkNull {
    if ([self isKindOfClass:[NSDictionary class]]
        || [self isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)self];
        for (int i = 0; i < dict.allKeys.count; i++) {
            NSString *key = [dict.allKeys objectAtIndex:i];
            id obj = [dict objectForKey:key];
            if ([obj isKindOfClass:[NSArray class]]
                || [obj isKindOfClass:[NSMutableArray class]]
                || [obj isKindOfClass:[NSDictionary class]]
                || [obj isKindOfClass:[NSMutableDictionary class]]) {
                obj = [obj xf_checkNull];
                [dict setObject:obj forKey:key];
            } else if (![obj xf_NotNull]) {
                obj = @"";
                [dict setObject:obj forKey:key];
            }
        }

        if ([self isKindOfClass:[NSDictionary class]]) {
            return [dict copy];
        } else {
            return dict;
        }

    } else if ([self isKindOfClass:[NSArray class]]
               || [self isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:(NSArray *)self];
        for (NSInteger i = 0; i < array.count; i++) {
            id obj = array[i];
            if ([obj isKindOfClass:[NSArray class]]
                || [obj isKindOfClass:[NSMutableArray class]]
                || [obj isKindOfClass:[NSDictionary class]]
                || [obj isKindOfClass:[NSMutableDictionary class]]) {
                obj = [obj xf_checkNull];
                [array replaceObjectAtIndex:i withObject:obj];
            } else if (![obj xf_NotNull]) {
                obj = @"";
                [array replaceObjectAtIndex:i withObject:obj];
            }
        }

        if ([self isKindOfClass:[NSArray class]]) {
            return [array copy];
        } else {
            return array;
        }
    }

    return self;
}

#pragma mark >> json解析、转换 <<
- (NSData *)xf_convertToJsonData {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData || error) {
        NSLog(@"ConvertToJsonData Failed:%@", error);
    }

    return jsonData;
}

- (NSString *)xf_convertToJsonString {
    NSData *jsonData = [self xf_convertToJsonData];
    if (![jsonData xf_NotNull]) {
        return nil;
    }

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    /* 过滤不想要的(非法)字符，filterString自定义 */
    NSString *filterString = @"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ ";
    filterString = @" \n";/* 当前仅处理空格和换行 */
    NSCharacterSet *filterSet = [NSCharacterSet characterSetWithCharactersInString:filterString];
    jsonString = [[jsonString componentsSeparatedByCharactersInSet:filterSet]
                  componentsJoinedByString:@""];

    return jsonString;
}

+ (id)XF_ConvertToObject:(NSString *)jsonString {
    if (![jsonString xf_NotNull]) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if (!object || error) {
        NSLog(@"ConvertToObject Failed:%@", error);
    }

    return object;
}

#pragma mark >> 字典对象互转 <<
- (NSDictionary *)xf_ObjectToDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    Class objClass = [self class];
    while (YES) {
        unsigned int propsCount;
        objc_property_t* props = class_copyPropertyList(objClass, &propsCount);
        for(int i = 0;i < propsCount; i++) {
            objc_property_t prop = props[i];
            NSString* propName = [NSString stringWithUTF8String:property_getName(prop)];
            id value = [self valueForKey:propName];

            if(value == nil || [value isKindOfClass:[NSNull class]]) {
                [dict setValue:[NSNull null] forKey:propName];///设定拥有内存地址的空类型
            }
            else if ([value isKindOfClass:[NSArray class]]) {
                NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:[value count]];
                for (id v in value) {
                    if ([v isKindOfClass:[self class]]) {
                        [valueArray addObject:[v xf_ObjectToDictionary]];
                    }
                }
                [dict setValue:valueArray forKey:propName];
            }
            else if ([value isKindOfClass:[NSNumber class]] ||
                     [value isKindOfClass:[NSString class]] ||
                     [value isKindOfClass:[NSDictionary class]]) {
                [dict setValue:value forKey:propName];
            }
            else {
                [dict setValue:[value xf_ObjectToDictionary] forKey:propName];
            }
        }
        free(props);
        objClass = class_getSuperclass(objClass); {
            break;
        }
    }
    return [dict copy];
}

+ (id)XF_DictionaryToObject:(NSDictionary*)dict ClassName:(id)className {
    if (!([dict isKindOfClass:[NSDictionary class]] ||
          [dict isKindOfClass:[NSMutableDictionary class]])) {
        return nil;
    }
    NSDictionary *lowcaseKeyDic = [NSObject XF_GetLowcaseKeyDictionary:dict];

    id obj;
    if([className isKindOfClass:[NSString class]]) {
        Class cls = NSClassFromString(className);
        obj = [cls new];
    } else {
        obj = className;
    }
    Class objClass = [obj class];

    while (YES) {
        unsigned int propsCount;
        objc_property_t* props = class_copyPropertyList(objClass, &propsCount);
        for(int i = 0;i < propsCount; i++) {
            objc_property_t prop = props[i];
            NSString* propName = [NSString stringWithUTF8String:property_getName(prop)];
            id value = lowcaseKeyDic[[propName lowercaseString]];
            if (value == nil || [value isKindOfClass:[NSNull class]]) {
                continue;
            } else if ([value isKindOfClass:[NSArray class]]) {
                NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:[value count]];
                for (id v in value) {
                    if ([v isKindOfClass:[NSDictionary class]]) {
                        [valueArray addObject:[NSObject XF_DictionaryToObject:v ClassName:className]];
                    } else {
                        if (v && ![v isKindOfClass:[NSNull class]]) {
                            [valueArray addObject:v];
                        }
                    }
                }
                [obj setValue:valueArray forKey:propName];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                NSString *propType = [NSString stringWithUTF8String:property_getAttributes(prop)];
                NSRange start = [propType rangeOfString:@"@\""];
                NSRange end = [propType rangeOfString:@"\","];
                NSString *type = [propType substringWithRange:NSMakeRange(start.location +start.length, end.location - start.location - start.length)];
                if ([type isEqualToString:@"NSDictionary"]) {
                    [obj setValue:[NSDictionary dictionaryWithDictionary:value] forKey:propName];
                } else if ([type isEqualToString:@"NSMutableDictionary"]) {
                    [obj setValue:[NSMutableDictionary dictionaryWithDictionary:value] forKey:propName];
                } else {
                    [obj setValue:[NSObject XF_DictionaryToObject:value ClassName:type] forKey:propName];
                }

            } else {
                [obj setValue:value forKey:propName];
            }
        }
        free(props);
        objClass=class_getSuperclass(objClass);
        if(!objClass || objClass==[NSObject class]) {
            break;
        }
    }
    return obj;
}

#pragma mark >> 其它 <<
+ (NSDictionary *)XF_GetLowcaseKeyDictionary:(NSDictionary *)dictionary {
    if (!([dictionary isKindOfClass:[NSDictionary class]] ||
          [dictionary isKindOfClass:[NSMutableDictionary class]])) {
        return nil;
    }

    NSMutableDictionary *lowcaseKeyDic = [NSMutableDictionary new];
    NSArray* allkeys = dictionary.allKeys;
    for (int i = 0; i<allkeys.count; i++) {
        NSString* key = allkeys[i];
        NSString* value = dictionary[key];
        NSString* lowcaseKey = [key lowercaseString];
        [lowcaseKeyDic setValue:value forKey:lowcaseKey];
    }
    return lowcaseKeyDic;
}


@end
