//
//  NSArray+HighOrderFunc.m
//  Utils
//
//  Created by Xian Mo on 2020/9/22.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "NSArray+HighOrderFunc.h"

@implementation NSArray (HighOrderFunc)

- (NSArray *)_map:(id(^)(id))hanlde {
    if (!hanlde || !self) return self;
    
    NSMutableArray *arr = NSMutableArray.array;
    for (id obj in self) {
        id new = hanlde(obj);
        [arr addObject:new];
    }
    return arr.copy;
}

- (NSArray *)_filter:(BOOL(^)(id))handle {
    if (!handle || !self) return self;
    
    NSMutableArray *arr = NSMutableArray.array;
    for (id obj in self) {
        if (handle(obj)) {
            [arr addObject:obj];
        }
    }
    return arr.copy;
}

- (void)_forEach:(void(^)(id))handle {
    if (!handle || !self) return;
    
    for (id obj in self) {
        handle(obj);
    }
}

- (id)_reduce:(id(^)(id, id))handle initial:(id)initial {
    if (!handle || !self || !initial) return self;
    if (self.count <1) return initial;
    
    id value = initial;
    for (id obj in self) {
        value = handle(value, obj);
    }
    return value;
}


@end
