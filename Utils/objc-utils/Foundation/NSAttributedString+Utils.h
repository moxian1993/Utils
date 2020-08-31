//
//  NSAttributedString+Utils.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (Utils)

/** line space */
+ (NSAttributedString *)attrStringWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace;
+ (NSAttributedString *)attrStringWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace lineBreakMode:(NSLineBreakMode)breakModel;

/** match substring */
+ (NSAttributedString *)fullText:(NSString *)fullText matchText:(NSString *)matchText originColor:(UIColor *)color1 changeColor:(UIColor *)color2 font:(UIFont *)font;

@end
