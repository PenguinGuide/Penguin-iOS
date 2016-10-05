//
//  PGGoodDescCell.m
//  Penguin
//
//  Created by Jing Dai on 28/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGoodDescCell.h"

@interface PGGoodDescCell ()

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation PGGoodDescCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self.contentView addSubview:self.descLabel];
}

- (void)setCellWithDesc:(NSString *)desc
{
    if (desc) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 5.f;
        NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:desc
                                                                    attributes:@{NSFontAttributeName:Theme.fontMedium, NSParagraphStyleAttributeName:paragraphStyle}];
        self.descLabel.attributedText = attrS;
        
        CGSize textSize = [attrS boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-80, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.descLabel.height = textSize.height;
    }
}

+ (CGSize)cellSize:(NSString *)desc
{
    if (desc && desc.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 5.f;
        NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:desc
                                                                    attributes:@{NSFontAttributeName:Theme.fontMedium, NSParagraphStyleAttributeName:paragraphStyle}];
        CGSize textSize = [attrS boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-80, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        return CGSizeMake(UISCREEN_WIDTH, textSize.height+20);
    }
    return CGSizeZero;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.width-80, 30)];
        _descLabel.font = Theme.fontMedium;
        _descLabel.textColor = Theme.colorText;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

@end
