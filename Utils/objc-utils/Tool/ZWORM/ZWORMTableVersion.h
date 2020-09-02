//
//  ZWORMTableVersion.h
//  Pods
//
//  Created by zhuwei on 15/7/21.
//
//

#import <Foundation/Foundation.h>
#import "ZWORMModel.h"

/**
 *  表版本对象
 */
@interface ZWORMTableVersion : ZWORMModel

@property (strong, nonatomic)   NSString*   tableName;

@property (strong, nonatomic)   NSNumber*   version;

@end
