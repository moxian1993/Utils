//
//  ThemeManager.m
//  Utils
//
//  Created by Xian Mo on 2020/8/29.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "ThemeManager.h"
#import "UIImage+Color.h"

@implementation ThemeManager

IMPLEMENTATION_SINGLETON(ThemeManager)

- (NSString *)localizedStringWithKey:(NSString *)key {
    return NSLocalizedStringFromTable(key, @"LocalizedFile", @"");
}

- (UIImage *)imageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    if (_ThemeManager.themeColor) {
        image = [image utils_imageWithTintColor:_ThemeManager.themeColor];
    }
    return image;
}


/** 检测多语言文件是否缺少LanguageKey(DEBUG环境) */
+ (void)checkMissingLanguageKeyWithCurrentTablePath:(NSString *)tablePath {
#ifdef RELEASE
    return ;
#else
    NSString *current = tablePath;
    NSString *base = @"";//@"zh-Hans.lproj/MKLanguage_MockupCN";
    
    NSDictionary *currentMap = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: current ofType: @"strings"]];
    NSDictionary *baseMap = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: base ofType: @"strings"]];
    
    NSMutableArray *missingList = NSMutableArray.array;
    [baseMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!currentMap[key]) {
            [missingList addObject: key];
        }
    }];
    
    if ([missingList count] > 0) {
        NSMutableArray *list = @[@"\n"].mutableCopy;
        for (NSString *key in missingList) {
            [list addObject: [NSString stringWithFormat: @"\"%@\" = \"%@\";", key, key]];
        }
        [list sortUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
            return [a compare: b];
        }];
        
        NSLog(@"%@", [list componentsJoinedByString: @"\n"]);
        exit(0);
    }
#endif
}


@end
