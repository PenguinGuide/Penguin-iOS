//
//  PGGoodCell.m
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGoodCell.h"

@interface PGGoodCell ()

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation PGGoodCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    [self.contentView addSubview:self.goodImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
}

- (void)setCellWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGGood class]]) {
        PGGood *good = (PGGood *)model;
        [self.goodImageView setWithImageURL:good.image placeholder:nil completion:nil];
        [self.titleLabel setText:good.name];
        
        if (good.originalPrice && ![good.originalPrice isEqualToString:@"0"]) {
            NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ %@", good.discountPrice, good.originalPrice]];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, good.discountPrice.length+1)];
            [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, good.discountPrice.length+1)];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
            [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
            self.priceLabel.attributedText = attrS;
        } else {
            NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", good.discountPrice]];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, good.discountPrice.length+1)];
            self.priceLabel.attributedText = attrS;
        }
    }
}

- (void)cellDidSelectWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGGood class]]) {
        PGGood *good = (PGGood *)model;
        [PGRouterManager routeToGoodDetailPage:good.goodId link:good.link];
    }
}

- (void)setCellWithGood:(PGGood *)good
{
    [self.goodImageView setWithImageURL:good.image placeholder:nil completion:nil];
    [self.titleLabel setText:good.name];
    
    if (good.originalPrice && ![good.originalPrice isEqualToString:@"0"]) {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ %@", good.discountPrice, good.originalPrice]];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        self.priceLabel.attributedText = attrS;
    } else {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", good.discountPrice]];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, good.discountPrice.length+1)];
        self.priceLabel.attributedText = attrS;
    }
}

- (void)setGrayBackgroundCellWithGood:(PGGood *)good
{
    if (!self.maskImageView) {
        self.maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
        self.maskImageView.image = [[UIImage imageNamed:@"pg_bg_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
        [self.contentView addSubview:self.maskImageView];
    }
    [self.goodImageView setWithImageURL:good.image placeholder:nil completion:nil];
    [self.titleLabel setText:good.name];
    
    if (good.originalPrice && ![good.originalPrice isEqualToString:@"0"]) {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ %@", good.discountPrice, good.originalPrice]];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        self.priceLabel.attributedText = attrS;
    } else {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", good.discountPrice]];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, good.discountPrice.length+1)];
        self.priceLabel.attributedText = attrS;
    }
}

+ (CGSize)cellSize
{
    CGFloat width = (UISCREEN_WIDTH-22-20-22)/2;
    return CGSizeMake(width, width+60);
}

#pragma mark - <Lazy Init>

- (UIImageView *)goodImageView {
    if(_goodImageView == nil) {
        CGFloat width = (UISCREEN_WIDTH-22-20-22)/2;
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _goodImageView.backgroundColor = Theme.colorLightBackground;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_goodImageView cropCornerRadius:8.f];
    }
    return _goodImageView;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        CGFloat width = (UISCREEN_WIDTH-22-20-22)/2;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.goodImageView.pg_bottom+14, width, 16)];
        _titleLabel.font = Theme.fontMedium;
        _titleLabel.textColor = Theme.colorText;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if(_priceLabel == nil) {
        CGFloat width = (UISCREEN_WIDTH-22-20-22)/2;
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.pg_bottom+3, width-40, 16)];
    }
    return _priceLabel;
}

@end
