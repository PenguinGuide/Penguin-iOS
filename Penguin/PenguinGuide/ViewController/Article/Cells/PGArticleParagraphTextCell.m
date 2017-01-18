//
//  PGArticleParagraphTextCell.m
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleParagraphTextCell.h"
#import "PGArticleParagraphTextLabel.h"

@interface PGArticleParagraphTextCell ()

@property (nonatomic, strong) PGArticleParagraphTextLabel *textLabel;

@end

@implementation PGArticleParagraphTextCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    [self.contentView addSubview:self.textLabel];
}

- (void)setCellWithStr:(NSAttributedString *)attrStr
{
    self.textLabel.frame = CGRectMake(0, 0, self.pg_width, self.pg_height);
    self.textLabel.attributedText = attrStr;
}

+ (CGSize)cellSize:(PGParserTextStorage *)textStorage
{
    if (CGSizeEqualToSize(textStorage.textSize, CGSizeZero)) {
        @autoreleasepool {
            // NOTE: calculate NSAttributedString size http://stackoverflow.com/questions/13621084/boundingrectwithsize-for-nsattributedstring-returning-wrong-size, https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/TextLayout/Tasks/StringHeight.html
            // NOTE: counting NSAttributedString number of lines https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/TextLayout/Tasks/CountLines.html
            if (textStorage.text) {
                CGSize textSize = [PGArticleParagraphTextLabel sizeWithWidth:UISCREEN_WIDTH attriStr:textStorage.text];
                
                textStorage.textSize = CGSizeMake(UISCREEN_WIDTH, ceil(textSize.height+15));
                
                return textStorage.textSize;
            }
            return CGSizeZero;
        }
    } else {
        return textStorage.textSize;
    }
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[PGArticleParagraphTextLabel alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

@end
