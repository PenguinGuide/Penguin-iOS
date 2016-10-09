//
//  PGArticleParagraphTextCell.m
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleParagraphTextCell.h"

@interface PGArticleParagraphTextCell ()

@property (nonatomic, strong) UILabel *textLabel;

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

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

@end
