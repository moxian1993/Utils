//  Created by Mo on 2018/3/17.
//  Copyright © 2018年 Mo. All rights reserved.
//

#import "UIImageView+FitSize.h"
#import <objc/runtime.h>

@implementation UIImageView (FitSize)

//在类被加载到运行时的时候就会执行
+ (void)load {
    Method originalSetImageMethod = class_getInstanceMethod([self class], @selector(setImage:));
    Method targetMethod = class_getInstanceMethod([self class], @selector(fitSizeWithImage:));
    
    //交换方法后 名字就互换了！
    method_exchangeImplementations(originalSetImageMethod, targetMethod);
}

//系统调用setImage:方法，现在会变成调用fitSizeWithImage:方法
- (UIImage *)fitSizeWithImage:(UIImage *)image {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [image drawInRect:self.bounds];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //此处的fitSizeWithImage: 其实是原生的setImage:方法，交换方法后，名字也随之互换
    return [self fitSizeWithImage:result];
}


@end
