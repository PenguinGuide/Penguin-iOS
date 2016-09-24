//
//  NSString+PGStringParser.m
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CSS_Style_Text_Color @"color"
#define CSS_Style_Font_Size @"font-size"
#define CSS_Style_Font_Bold @"bold"

#import "NSString+PGStringParser.h"
#import "UIColor+PGColor.h"

@implementation NSString (PGStringParser)

- (NSAttributedString *)paragraphAttributedString
{
    NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f weight:UIFontWeightLight],
                                                                                             NSParagraphStyleAttributeName:[self defaultParagraphStyle]}];
    
    return attrS;
}

- (NSAttributedString *)catalogTitleAttributedString
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.firstLineHeadIndent = 20.f;
    paragraphStyle.headIndent = 20.f;
    paragraphStyle.tailIndent = -20.f;
    paragraphStyle.lineSpacing = 5.f;
    
    NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f weight:UIFontWeightBold],
                                                                                             NSForegroundColorAttributeName:[UIColor colorWithHexString:@"EF6733"],
                                                                                             NSParagraphStyleAttributeName:paragraphStyle}];
    return attrS;
}

- (NSAttributedString *)styledParagraphAttributedString:(NSArray *)styles
{
    NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithAttributedString:[self paragraphAttributedString]];
    for (NSDictionary *style in styles) {
        if (style[@"range"] && style[@"styles"]) {
            NSDictionary *stylesDict = style[@"styles"];
            NSRange range = [style[@"range"] rangeValue];
            for (NSString *key in stylesDict.allKeys) {
                if ([key isEqualToString:CSS_Style_Text_Color]) {
                    NSString *color = stylesDict[CSS_Style_Text_Color];
                    if ([color rangeOfString:@"#"].location != NSNotFound && color.length == 7) {
                        color = [color substringFromIndex:1];
                        [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:color] range:range];
                    }
                } else if ([key isEqualToString:CSS_Style_Font_Size]) {
                    NSString *fontSize = stylesDict[CSS_Style_Font_Size];
                    if ([fontSize rangeOfString:@"px"].location != NSNotFound) {
                        fontSize = [fontSize stringByReplacingOccurrencesOfString:@"px" withString:@""];
                        [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[fontSize floatValue] weight:UIFontWeightLight] range:range];
                    }
                } else if ([key isEqualToString:CSS_Style_Font_Bold]) {
                    [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f weight:UIFontWeightBold] range:range];
                }
            }
        }
    }
    return [[NSAttributedString alloc] initWithAttributedString:attrS];
}

- (NSAttributedString *)attributedStringWithColor:(NSString *)color font:(UIFont *)font
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self
                                                                  attributes:@{NSFontAttributeName:font?font:[UIFont systemFontOfSize:16.f weight:UIFontWeightLight],
                                                                               NSForegroundColorAttributeName:[UIColor colorWithHexString:color],
                                                                               NSParagraphStyleAttributeName:[self defaultParagraphStyle]}];
    return attrStr;
}

- (NSDictionary *)CSSStyles
{
    NSMutableDictionary *stylesDict = [NSMutableDictionary new];
    
    NSArray *stylesArray = [self componentsSeparatedByString:@";"];
    if (stylesArray.count > 0) {
        for (NSString *styleStr in stylesArray) {
            NSArray *styleArray = [styleStr componentsSeparatedByString:@":"];
            if (styleArray.count >= 2) {
                NSString *styleKey = styleArray[0];
                NSString *styleValue = styleArray[1];
                
                stylesDict[styleKey] = styleValue;
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:stylesDict];
}

- (NSMutableParagraphStyle *)defaultParagraphStyle
{
    NSMutableParagraphStyle *defaultParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    defaultParagraphStyle.alignment = NSTextAlignmentJustified;
    defaultParagraphStyle.firstLineHeadIndent = 30.f;
    defaultParagraphStyle.headIndent = 30.f;
    defaultParagraphStyle.tailIndent = -30.f;
    defaultParagraphStyle.lineSpacing = 5.f;
    
    return defaultParagraphStyle;
}

@end
