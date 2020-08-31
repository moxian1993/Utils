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
+ (NSArray <NSString *>*)getPropertyNameList {

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
    
    objc_property_t * propertyList = class_copyPropertyList([self class], &count);
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0 ; i < count ; i++) {
        //拿到数组中的每个属性objc_property_t
        
        //property_getName获取属性的名字
        const char *name = property_getName(propertyList[i]);
        
        //char _>nsstring
        NSString *nameStr = [NSString stringWithUTF8String:name];
        [mArray addObject:nameStr];
    }
    return mArray.copy;
}



+ (NSArray <NSString *>*)getProtocalNameList {
//类中有多少代理
    unsigned int count;
    
    Protocol * __unsafe_unretained * protocolList = objc_copyProtocolList(&count);
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0 ; i < count ; i++) {
        const char *name = protocol_getName(protocolList[i]);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        [mArray addObject:nameStr];
    }
    return mArray.copy;
}


+ (NSArray <NSString *>*)getMethodNameList {

    unsigned int count;
    
    Method *methodList = class_copyMethodList([self class], &count);
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0 ; i < count ; i++) {
        
        SEL sel = method_getName(methodList[i]);
        NSString *nameStr = NSStringFromSelector(sel);
        [mArray addObject:nameStr];
    }
    return mArray.copy;
}

@end
