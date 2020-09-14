//
//  NSArray+LocalizedIndex.m
//  Utils
//
//  Created by Xian Mo on 2020/9/14.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "NSArray+LocalizedIndex.h"

@implementation NSArray (LocalizedIndex)

- (NSArray *)contactSort:(NSArray *)customers stringSelector:(SEL)selector {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];

    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如:
    //@[@[以A开头的数据数组],@[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]

    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];

    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }

    //将每个人按name分到某个section下

    for (id model in customers) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:model collationStringSelector:selector];
        //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:model];
    }
    //对每个section中的数组按照name属性排序
    for (int index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection =
            [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    return newSectionsArray;
}


@end
