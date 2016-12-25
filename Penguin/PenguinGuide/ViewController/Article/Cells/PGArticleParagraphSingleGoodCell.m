//
//  PGArticleParagraphSingleGoodCell.m
//  Penguin
//
//  Created by Jing Dai on 26/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleParagraphSingleGoodCell.h"

@interface PGArticleParagraphSingleGoodCell ()

@property (nonatomic, strong) UIView *goodView;
@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation PGArticleParagraphSingleGoodCell

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
    [self.contentView addSubview:self.goodView];
    [self.goodView addSubview:self.goodImageView];
    [self.goodView addSubview:self.titleLabel];
    [self.goodView addSubview:self.priceLabel];
}

- (void)setCellWithGood:(PGGood *)good
{
    [self.goodImageView setWithImageURL:good.image placeholder:nil completion:nil];
    [self.titleLabel setText:good.name];
    
    if (good.originalPrice && ![good.originalPrice isEqualToString:@"0"]) {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ %@", good.discountPrice, good.originalPrice]];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        self.priceLabel.attributedText = attrS;
    } else {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", good.discountPrice]];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, good.discountPrice.length+1)];
        self.priceLabel.attributedText = attrS;
    }
}

- (UIView *)goodView
{
    if (!_goodView) {
        _goodView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.pg_width, self.pg_height-30)];
        _goodView.backgroundColor = [UIColor whiteColor];
        _goodView.layer.borderWidth = 2.f;
        _goodView.layer.borderColor = Theme.colorText.CGColor;
    }
    return _goodView;
}

#pragma mark - <Setters && Getters>

- (UIImageView *)goodImageView {
    if(_goodImageView == nil) {
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_width)];
        _goodImageView.backgroundColor = Theme.colorLightBackground;
        _goodImageView.clipsToBounds = YES;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodImageView;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.goodImageView.pg_bottom, self.pg_width-40, 30)];
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.font = Theme.fontSmallBold;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if(_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.titleLabel.pg_bottom+3, self.pg_width-40, 16)];
    }
    return _priceLabel;
}

@end
