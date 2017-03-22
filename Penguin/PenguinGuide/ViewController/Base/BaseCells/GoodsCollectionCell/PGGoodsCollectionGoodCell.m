//
//  PGGoodsCollectionGoodCell.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGoodsCollectionGoodCell.h"

@interface PGGoodsCollectionGoodCell ()

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *stockImageView;

@end

@implementation PGGoodsCollectionGoodCell

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
    [self.contentView addSubview:self.stockImageView];
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
    
    if (good.isNew) {
        self.stockImageView.hidden = NO;
    } else {
        self.stockImageView.hidden = YES;
    }
}

#pragma mark - <Lazy Init>

- (UIImageView *)goodImageView {
	if(_goodImageView == nil) {
		_goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _goodImageView.backgroundColor = Theme.colorLightBackground;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_goodImageView cropCornerRadius:8.f];
	}
	return _goodImageView;
}

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.goodImageView.pg_bottom+14, self.pg_width, 16)];
        _titleLabel.font = Theme.fontMedium;
        _titleLabel.textColor = Theme.colorText;
	}
	return _titleLabel;
}

- (UILabel *)priceLabel {
	if(_priceLabel == nil) {
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.pg_bottom+3, 160-40, 16)];
	}
	return _priceLabel;
}

- (UIImageView *)stockImageView {
	if(_stockImageView == nil) {
		_stockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 34, 18)];
        _stockImageView.clipsToBounds = YES;
        _stockImageView.hidden = YES;
        _stockImageView.image = [UIImage imageNamed:@"pg_good_new"];
	}
	return _stockImageView;
}

@end
