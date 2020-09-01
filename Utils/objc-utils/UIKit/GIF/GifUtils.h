//
//  GifUtils.h
//  Utils
//
//  Created by Mo on 2017/8/3.
//  Copyright © 2017年 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYImage+LoopCount.h"

@interface GifUtils : NSObject

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
                                                  repeatCount:(NSUInteger)repeatCount;


/**
 读取本地GIF生成View(webView的方法)
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
                                        Duration:(double)duration;



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
// #import <FLAnimatedImage.h>
// */
//+ (FLAnimatedImageView *)GIFImageViewWithLocalResource:(NSString *)GIFName
//                                            bunldeName:(NSString *)bunldeName
//                                                bounds:(CGRect)bounds
//                                        isInfiniteLoop:(BOOL)isInfiniteLoop
//                                           repeatCount:(NSInteger)repeatCount
//                                  perLoopFinishedBlock:(void(^)(NSUInteger loopTimes))perLoopFinishedBlock
//                                            completion:(void(^)())completion;

@end
