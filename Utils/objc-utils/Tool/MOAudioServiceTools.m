//
//  MOAudioServiceTools.m
//  Practice
//
//  Created by Xian Mo on 2020/7/2.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOAudioServiceTools.h"
#import <AVFoundation/AVFoundation.h>

static NSMutableDictionary *audioCaches;
@implementation MOAudioServiceTools

+ (void)load {
    audioCaches = NSMutableDictionary.dictionary;
}

+ (void)play:(NSString *)audioName {
    
    if (audioCaches[audioName]) {
        SystemSoundID soundID = [audioCaches[audioName] intValue];
        AudioServicesPlaySystemSound(soundID);
        return;
    }
    
    NSURL *url = [NSBundle.mainBundle URLForResource:audioName withExtension:nil];
    CFURLRef cfurl = (__bridge CFURLRef)url;
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID(cfurl, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    audioCaches[audioName] = @(soundID);
}


+ (void)clearAudio {
    [audioCaches enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        SystemSoundID soundID = [obj intValue];
        AudioServicesDisposeSystemSoundID(soundID);
        [audioCaches removeObjectForKey:key];
    }];
}



@end
