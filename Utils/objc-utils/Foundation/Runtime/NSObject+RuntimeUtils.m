//
//  NSObject+RuntimeUtils.m
//  Utils
//
//  Created by Xian Mo on 2020/8/31.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "NSObject+RuntimeUtils.h"
#import <objc/runtime.h>

//套路:查看头文件 只要是获得列表的函数 CopyXXXX
//获取名字 method_getName protocal_getName

@implementation NSObject (RuntimeUtils)

//获取到属性名字的列表
+ (NSArray <NSString *>*)propertyList {
    
    // 提升性能，重复调用时从内存中寻找
    NSArray *result = objc_getAssociatedObject(self, _cmd);
    if (result != nil) {
        return result;
    }

    unsigned int count;
    //拷贝属性列表 class
    /*
     1.哪个类
     2.count 数量 输出参数
     */
    
    /*
     An array of pointers of type \c objc_property_t describing the properties
     *  declared by the class.
     返回一个数组的指针 数组中的类型为objc_property_t
     */
    objc_property_t * list = class_copyPropertyList([self class], &count);
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0 ; i < count ; i++) {
        //拿到数组中的每个属性objc_property_t
        //property_getName获取属性的名字
        const char *name = property_getName(list[i]);
        //char _>nsstring
        NSString *nameStr = [NSString stringWithUTF8String:name];
        [mArray addObject:nameStr];
    }
    free(list);
    // 设置关联对象
    objc_setAssociatedObject(self, _cmd, mArray.copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return objc_getAssociatedObject(self, _cmd);
}



+ (NSArray <NSString *>*)protocalList {
    //类中有多少代理
    // 获取关联对象
    NSArray *result = objc_getAssociatedObject(self, _cmd);
    
    if (result != nil) {
        return result;
    }
    unsigned int count;
    
    Protocol * __unsafe_unretained * list = objc_copyProtocolList(&count);
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0 ; i < count ; i++) {
        const char *name = protocol_getName(list[i]);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        [mArray addObject:nameStr];
    }
    free(list);
    // 设置关联对象
    objc_setAssociatedObject(self, _cmd, mArray.copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return objc_getAssociatedObject(self, _cmd);
}


+ (NSArray <NSString *>*)methodList {
    // 获取关联对象
    NSArray *result = objc_getAssociatedObject(self, _cmd);
    
    if (result != nil) {
        return result;
    }
    
    unsigned int count;
    
    Method *list = class_copyMethodList([self class], &count);
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0 ; i < count ; i++) {
        
        SEL sel = method_getName(list[i]);
        NSString *nameStr = NSStringFromSelector(sel);
        [mArray addObject:nameStr];
    }
    
    free(list);
    // 设置关联对象
    objc_setAssociatedObject(self, _cmd, mArray.copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return objc_getAssociatedObject(self, _cmd);
}


+ (NSArray *)ivarsList {
    // 获取关联对象
    NSArray *result = objc_getAssociatedObject(self, _cmd);
    
    if (result != nil) {
        return result;
    }
    
    unsigned int count = 0;
    Ivar *list = class_copyIvarList([self class], &count);
    
    // 遍历所有的属性
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = list[i];
        // 获取 ivar 名称
        const char *cName = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:cName];
        [arrayM addObject:name];
    }
    free(list);
    // 设置关联对象
    objc_setAssociatedObject(self, _cmd, arrayM.copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return objc_getAssociatedObject(self, _cmd);
}


@end
