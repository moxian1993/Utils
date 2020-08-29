//
//  MOImageDetectUtils.m
//  Practice
//
//  Created by Xian Mo on 2020/7/7.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOImageDetectUtils.h"
#import <CoreImage/CoreImage.h>

@implementation MOImageDetectUtils

+ (void)detectFaceWithImageView:(UIImageView *)imageView {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}
                            ];
    UIImage *image = imageView.image;
    CGImageRef imageRef = [image CGImage];
    CIImage *ciImage = [CIImage imageWithCGImage:imageRef];
    NSArray *features = [detector featuresInImage:ciImage];
    
    CALayer *coordinate = CALayer.layer;
    coordinate.frame = imageView.bounds;
    coordinate.affineTransform = CGAffineTransformMakeScale(1, -1);
    
    for (CIFaceFeature *feature in features) {
        CALayer *border = CALayer.layer;
        border.borderColor = UIColor.redColor.CGColor;
        border.borderWidth = 2.0;
        
        CGFloat scale = UIScreen.mainScreen.scale;
        CGFloat x, y, width ,height;
        x = feature.bounds.origin.x / scale;
        y = feature.bounds.origin.y / scale;
        width = feature.bounds.size.width / scale;
        height = feature.bounds.size.height / scale;
        border.frame = CGRectMake(x, y, width, height);
        
        [coordinate addSublayer:border];
        [imageView.layer addSublayer:coordinate];
    }
}


@end
