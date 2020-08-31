//
//  NSAttributedString+Utils.m
//

#import "NSAttributedString+Utils.h"

@implementation NSAttributedString (Utils)

+ (NSAttributedString *)attrStringWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace {
    if (!text) {
        return nil;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName :font, NSForegroundColorAttributeName: textColor}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    return attrString.copy;
}

+ (NSAttributedString *)attrStringWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace lineBreakMode:(NSLineBreakMode)breakModel {
    if (!text) {
        return nil;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName :font, NSForegroundColorAttributeName: textColor}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setLineBreakMode:breakModel];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    return attrString.copy;
    
}


+ (NSAttributedString *)fullText:(NSString *)fullText matchText:(NSString *)matchText originColor:(UIColor *)color1 changeColor:(UIColor *)color2 font:(UIFont *)font {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString: fullText];
    NSRange all = [fullText rangeOfString:fullText];
    NSRange part = [[fullText lowercaseString] rangeOfString:[matchText lowercaseString]];
    
    [attr addAttribute:NSFontAttributeName value:font range:all];
    [attr addAttribute:NSForegroundColorAttributeName value:color1 range:all];
    [attr addAttribute:NSForegroundColorAttributeName value:color2 range:part];
    return attr;
}


@end
