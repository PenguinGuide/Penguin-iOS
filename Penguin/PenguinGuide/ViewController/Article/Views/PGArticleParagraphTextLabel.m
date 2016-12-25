//
//  PGArticleParagraphTextLabel.m
//  Penguin
//
//  Created by Kobe Dai on 14/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleParagraphTextLabel.h"

@implementation PGArticleParagraphTextLabel

+ (CGSize)sizeWithWidth:(CGFloat)width attriStr:(NSAttributedString *)attrStr
{
    // NOTE: calculate UILabel height with attributed string, width should be UISCREEN_WIDTH, not UISCREEN_WIDTH-40
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, FLT_MAX)];
    label.numberOfLines = 0;
    
    label.attributedText = attrStr;
    
    CGSize size = [label sizeThatFits:label.bounds.size];
    
    return size;
}

@end
