//
//  PGGoodNameCell.m
//  Penguin
//
//  Created by Jing Dai on 28/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGoodInfoCell.h"

@interface PGGoodInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation PGGoodInfoCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
}

- (void)setCellWithGood:(PGGood *)good
{
    if (good) {
        [self.titleLabel setText:good.name];
        
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ %@", good.discountPrice, good.originalPrice]];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        self.priceLabel.attributedText = attrS;
        
        CGSize textSize = [good.name boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-80, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.f weight:UIFontWeightRegular]} context:nil].size;
        self.titleLabel.pg_height = textSize.height;
        self.priceLabel.frame = CGRectMake(self.priceLabel.pg_x, self.titleLabel.pg_bottom+10, self.priceLabel.pg_width, self.priceLabel.pg_height);
    }
}

+ (CGSize)cellSize:(PGGood *)good
{
    CGSize textSize = [good.name boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-80, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.f weight:UIFontWeightRegular]} context:nil].size;
    
    return CGSizeMake(UISCREEN_WIDTH, 20+textSize.height+10+16+20);
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.pg_width-80, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:20.f weight:UIFontWeightRegular];
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if(_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.titleLabel.pg_bottom+10, 100, 16)];
    }
    return _priceLabel;
}

@end
