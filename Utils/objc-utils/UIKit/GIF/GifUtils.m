//
//  GifUtils.m
//  Utils
//
//  Created by Mo on 2017/8/3.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import "GifUtils.h"
#import "FileUtils.h"
#import <WebKit/WebKit.h>

@implementation GifUtils


/**
 读取本地GIF资源生成imageView(YYImage)
 (需要pod入YYImage)
 优点：可以完美释放
 缺点：播放过程中内存增加5M左右
 
 @param GifName GIF名称
 @param bundleName 所在bundle的名字
 @param repeatCount 循环次数(<=0 默认为无限循环)
 @return YYAnimatedImageView的实例对象
 */
+ (YYAnimatedImageView *)GifCreatedByYYImageWithLocalReousrce:(NSString *)GifName
                                                   bundleName:(NSString *)bundleName
                                                  repeatCount:(NSUInteger)repeatCount {
    
    NSString *filePath = [FileUtils pathWithName:GifName type:@"gif" bundleName:bundleName];
    YYImage *image = [YYImage imageWithContentsOfFile:filePath];
    image.loopCount = repeatCount;
    
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    return imageView;
}



/**
 读取本地GIF生成View(webView)
 优点：播放过程中性能消耗极少，在gif很大的情况下可以将头尾图片传入来模拟第一帧和最后一帧情况
 缺点：销毁后有内存泄漏 10M左右
 
 @param GifName GIF名称
 @param bundleName 所在bundle的名字
 @param firstImage 第一帧图片
 @param lastImage 最后一帧图片
 @param bounds bounds
 @param duration Gif时长
 @return uiview
 */
+ (UIView *)GifCrectedByWebViewWithLocalResource:(NSString *)GifName
                                  bundleName:(NSString *)bundleName
                                  firstImage:(UIImage *)firstImage
                                   lastImage:(UIImage *)lastImage
                                      bounds:(CGRect)bounds
                                    Duration:(double)duration {

    UIView *view = [[UIView alloc] initWithFrame:bounds];
    
    UIImageView *borderIv;
    if (firstImage || lastImage) {
        //如果加载速度较慢 需要将头尾图片传入方法 模拟第一帧和最后一帧情况
        borderIv = [[UIImageView alloc] init];
        borderIv.contentMode = UIViewContentModeScaleToFill;
        borderIv.frame = view.frame;
        [view addSubview:borderIv];
        if (firstImage) {
            borderIv.image = firstImage;
        }
    }
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:bounds];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.userInteractionEnabled = NO;
    [view addSubview:webView];
    
    NSData *data = [FileUtils dataWithName:GifName type:@"gif" bundleName:bundleName];
    [webView loadData:data MIMEType:@"image/gif" characterEncodingName:nil baseURL:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        webView.hidden = YES;
        if (lastImage) {
            borderIv.image = lastImage;
            borderIv.hidden = NO;
        }
        [webView removeFromSuperview];
    });
    return view;
}


///**
// 读取本地GIF资源生成imageView
// (需要pod入FLAnimatedImage)
// @param GIFName GIF名称
// @param bunldeName 所在bundle的名字
// @param bounds imageView的bounds
// @param isInfiniteLoop 循环次数是否有限
// @param repeatCount 循环次数(无限循环模式下该参数无效)
// @param perLoopFinishedBlock 每次循环结束的回调
// @param completion 循环结束的回调(无限循环模式下该参数无效)
// @return FLAnimatedImageView的实例对象
//
// 存在问题：用FLAnimatedImage Gif播放时长远超于实际时长
// */
//+ (FLAnimatedImageView *)GIFImageViewWithLocalResource:(NSString *)GIFName
//                                            bunldeName:(NSString *)bunldeName
//                                                bounds:(CGRect)bounds
//                                        isInfiniteLoop:(BOOL)isInfiniteLoop
//                                           repeatCount:(NSInteger)repeatCount
//                                  perLoopFinishedBlock:(void(^)(NSUInteger loopTimes))perLoopFinishedBlock
//                                            completion:(void(^)())completion {
//    
//    NSData *data = [FileUtils dataWithName:GIFName type:@"gif" bundleName:bunldeName];
//    NSAssert(data != nil, @"GIF资源获取失败，请检查传参是否正确");
//    
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
//    
//    FLAnimatedImageView * imageView = [[FLAnimatedImageView alloc] init];
//    imageView.bounds = bounds;
//    imageView.animatedImage = image;
//    
//    __weak typeof(imageView) weakImageView = imageView;
//    
//    if (!isInfiniteLoop) {
//        //有限循环
//        NSAssert(repeatCount >0, @"有限循环模式下，循环次数必须大于0");
//        imageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
//            if (perLoopFinishedBlock != nil) {
//                perLoopFinishedBlock(-loopCountRemaining -1);
//            }
//            if (loopCountRemaining == -repeatCount -1) {
//                [weakImageView stopAnimating];
//                if (completion != nil) {
//                    completion();
//                }
//            }
//        };
//    } else {
//        //无限循环
//        imageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
//            if (perLoopFinishedBlock != nil) {
//                perLoopFinishedBlock(-loopCountRemaining -1);
//            }
//        };
//    }
//    return imageView;
//}

@end
