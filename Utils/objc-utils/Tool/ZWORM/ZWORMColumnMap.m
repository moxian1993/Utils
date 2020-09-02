//
//  ZWORMColumnMap.m
//  CommonFramework
//
//  Created by zhuwei on 15/1/15.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "ZWORMColumnMap.h"
#import "ZWORMHelpers.h"

@implementation ZWORMColumnMap

- (id)initWithName:(NSString *)name type:(ZWORMColumnMapType)type
{
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
        self.increments = NO;
    }
    return self;
}

/**
 属性名称
 
 */
- (NSString *)propertyName {
    return ZWORMLowerCamelCaseFromSnakeCase(self.name);
}


@end
