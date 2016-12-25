//
//  NSString+PGStringParser.m
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CSS_Style_Text_Color @"color"
#define CSS_Style_Font_Size @"font-size"
#define CSS_Style_Font_Strong @"strong"

#define HTML_Attribute_Text_Align @"text-align"

#import "NSString+PGStringParser.h"
#import "UIColor+PGColor.h"

@implementation NSString (PGStringParser)

- (NSAttributedString *)paragraphAttributedString
{
    NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f weight:UIFontWeightRegular],
                                                                                             NSParagraphStyleAttributeName:[self defaultParagraphStyle]}];
    
    return attrS;
}

- (NSAttributedString *)centerAlignedParagraphAttributedString
{
    NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f weight:UIFontWeightRegular],
                                                                                             NSParagraphStyleAttributeName:[self centerAlignedParagraphStyle]}];
    
    return attrS;
}

- (NSAttributedString *)styledParagraphAttributedString:(NSDictionary *)style
{
    NSMutableAttributedString *attrS = nil;
    if ([style objectForKey:HTML_Attribute_Text_Align]) {
        NSString *textAlign = [style objectForKey:HTML_Attribute_Text_Align];
        if ([textAlign isEqualToString:@"center"]) {
            attrS = [[NSMutableAttributedString alloc] initWithAttributedString:[self centerAlignedParagraphAttributedString]];
        } else {
            attrS = [[NSMutableAttributedString alloc] initWithAttributedString:[self paragraphAttributedString]];
        }
    } else {
        attrS = [[NSMutableAttributedString alloc] initWithAttributedString:[self paragraphAttributedString]];
    }
    for (NSString *key in style.allKeys) {
        if ([key isEqualToString:CSS_Style_Text_Color]) {
            NSString *color = style[CSS_Style_Text_Color];
            color = [color stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([color rangeOfString:@"#"].location != NSNotFound && color.length == 7) {
                // #FFFFFF
                color = [color substringFromIndex:1];
                [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:color] range:NSMakeRange(0, attrS.length)];
            } else if ([color rangeOfString:@"rgb"].location != NSNotFound) {
                // rgb(134, 137, 141)
                NSString *colorComponentsStr = [color stringByReplacingOccurrencesOfString:@"rgb" withString:@""];
                colorComponentsStr = [colorComponentsStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
                colorComponentsStr = [colorComponentsStr stringByReplacingOccurrencesOfString:@")" withString:@""];
                NSArray *colorComponents = [colorComponentsStr componentsSeparatedByString:@","];
                if (colorComponents.count == 3) {
                    [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:[colorComponents[0] floatValue]/255.f green:[colorComponents[1] floatValue]/255.f blue:[colorComponents[2] floatValue]/255.f alpha:1.f] range:NSMakeRange(0, attrS.length)];
                }
            }
        } else if ([key isEqualToString:CSS_Style_Font_Size]) {
            NSString *fontSize = style[CSS_Style_Font_Size];
            if ([fontSize rangeOfString:@"px"].location != NSNotFound) {
                fontSize = [fontSize stringByReplacingOccurrencesOfString:@"px" withString:@""];
                [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[fontSize floatValue] weight:UIFontWeightRegular] range:NSMakeRange(0, attrS.length)];
            }
        } else if ([key isEqualToString:CSS_Style_Font_Strong]) {
            [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f weight:UIFontWeightBold] range:NSMakeRange(0, attrS.length)];
        }
    }
    return [[NSAttributedString alloc] initWithAttributedString:attrS];
}

- (NSAttributedString *)attributedStringWithColor:(NSString *)color font:(UIFont *)font
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self
                                                                  attributes:@{NSFontAttributeName:font?font:[UIFont systemFontOfSize:16.f weight:UIFontWeightRegular],
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
                NSString *styleValue = [styleArray[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                stylesDict[styleKey] = styleValue;
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:stylesDict];
}

- (NSMutableParagraphStyle *)defaultParagraphStyle
{
    NSMutableParagraphStyle *defaultParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    defaultParagraphStyle.alignment = NSTextAlignmentLeft;
    defaultParagraphStyle.firstLineHeadIndent = 20.f;
    defaultParagraphStyle.headIndent = 20.f;
    defaultParagraphStyle.tailIndent = -20.f;
    defaultParagraphStyle.lineSpacing = 5.f;
    defaultParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    return defaultParagraphStyle;
}

- (NSMutableParagraphStyle *)centerAlignedParagraphStyle
{
    NSMutableParagraphStyle *centerAlignedParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    centerAlignedParagraphStyle.alignment = NSTextAlignmentCenter;
    centerAlignedParagraphStyle.firstLineHeadIndent = 20.f;
    centerAlignedParagraphStyle.headIndent = 20.f;
    centerAlignedParagraphStyle.tailIndent = -20.f;
    centerAlignedParagraphStyle.lineSpacing = 5.f;
    centerAlignedParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    return centerAlignedParagraphStyle;
}

@end
