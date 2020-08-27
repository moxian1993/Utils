//
//  MORollingView.m
//  Utils
//
//  Created by Xian Mo on 2020/8/27.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MORollingView.h"
#import <NerdyUI/NerdyUI.h>

@interface MORollingView ()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) CGFloat startLocation;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat speed;

@property (nonatomic, weak) UILabel *label1;
@property (nonatomic, weak) UILabel *label2;

@property (nonatomic, assign) CGFloat labelWidth;

@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat delta;

@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation MORollingView

- (instancetype)initWithText:(NSString *)text
                        font:(UIFont *)font
                   textColor:(UIColor *)color
               startLocation:(CGFloat)location
                     spacing:(CGFloat)spacing
                       speed:(CGFloat)speed {
    if (self = [super init]) {
        self.text = text;
        self.font = font;
        self.textColor = color;
        self.startLocation = location;
        self.spacing = spacing;
        self.speed = speed;
        [self setup];
    }
    return self;
}

- (void)setup {
    Style(@"lab").str(self.text).leftAlignment.fnt(self.font).color(self.textColor);
    
    UILabel *label1 = Label.styles(@"lab").addTo(self).remakeCons(^{
        make.centerY.equal.superview.constants(0);
        make.left.equal.superview.constants(self.startLocation);
    });
    self.label1 = label1;
    [self layoutIfNeeded];
    self.labelWidth = label1.bounds.size.width;
    
    CGFloat nextStartLocation = self.startLocation + self.labelWidth + self.spacing;
    UILabel *label2 = Label.styles(@"lab").addTo(self).remakeCons(^{
        make.centerY.equal.superview.constants(0);
        make.left.equal.superview.constants(nextStartLocation);
    });
    self.label2 = label2;
}

- (void)start {
    if (self.link && [self.link isPaused]) {
        [self.link setPaused:NO];
        return;
    }
    
    self.delta = 0.0;
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rolling:)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}

- (void)rolling:(CADisplayLink *)sender {
    
    self.delta = self.delta + self.speed;
    
    CGFloat max = self.labelWidth + self.spacing;
    
    if (self.delta >= max) {
        self.delta -= max;
    }
    
    CGFloat location = self.startLocation - self.delta;
    CGFloat nextLocation = self.startLocation + self.labelWidth + self.spacing - self.delta;
    
    self.label1.updateCons(^{
        make.left.equal.superview.constants(location);
    });
    
    self.label2.updateCons(^{
        make.left.equal.superview.constants(nextLocation);
    });
}

- (void)pause {
    [self.link setPaused:YES];
}

- (void)stop {
    [self invalidate];
}

- (void)invalidate {
    [self.link invalidate];
    self.link = nil;
}

- (void)dealloc {
    [self invalidate];
}

@end
