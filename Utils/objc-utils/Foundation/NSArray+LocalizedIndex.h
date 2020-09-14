//
//  NSArray+LocalizedIndex.h
//  Utils
//
//  Created by Xian Mo on 2020/9/14.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (LocalizedIndex)

//分组排序 a-z #
- (NSArray *)contactSort:(NSArray *)customers stringSelector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
