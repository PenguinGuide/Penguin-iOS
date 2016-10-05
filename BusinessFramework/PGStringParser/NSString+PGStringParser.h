//
//  NSString+PGStringParser.h
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PGStringParser)

- (NSAttributedString *)paragraphAttributedString;
- (NSAttributedString *)centerAlignedParagraphAttributedString;

- (NSAttributedString *)catalogTitleAttributedString;

- (NSAttributedString *)styledParagraphAttributedString:(NSDictionary *)style;

- (NSAttributedString *)attributedStringWithColor:(NSString *)color font:(UIFont *)font;

- (NSDictionary *)CSSStyles;

@end
