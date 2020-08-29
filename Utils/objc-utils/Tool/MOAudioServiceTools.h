//
//  MOAudioServiceTools.h
//  Practice
//
//  Created by Xian Mo on 2020/7/2.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOAudioServiceTools : NSObject


+ (void)play:(NSString *)audioName;

+ (void)clearAudio;
@end

NS_ASSUME_NONNULL_END
