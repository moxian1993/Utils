//
//  NSArray+ArrayUtils.m
//  Copyright © 2018年 mo. All rights reserved.
//

#import "NSArray+ArrayUtils.h"

@implementation NSArray (ArrayUtils)

- (BOOL)utils_equalWithArray:(NSArray *)anotherArray {
    if (self.count != anotherArray.count) {
        return NO;
    }
    NSSet *set1 = [NSSet setWithArray:self];
    NSSet *set2 = [NSSet setWithArray:anotherArray];
    NSSet *set3 = [set1 setByAddingObjectsFromSet:set2];
    
    return (set3.count == set1.count);
}

@end
