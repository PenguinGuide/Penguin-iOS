//
//  PGSingleGoodBannerCell.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSingleGoodBannerCell.h"

@interface PGSingleGoodBannerCell ()

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation PGSingleGoodBannerCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.goodImageView];
}

- (void)setCellWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGSingleGoodBanner class]]) {
        PGSingleGoodBanner *singleGood = (PGSingleGoodBanner *)model;
        if (singleGood.originalPrice && ![singleGood.originalPrice isEqualToString:@"0"]) {
            NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ %@", singleGood.discountPrice, singleGood.originalPrice]];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, singleGood.discountPrice.length+1)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontLargeBold range:NSMakeRange(0, singleGood.discountPrice.length+1)];
            [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, singleGood.discountPrice.length+1)];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(singleGood.discountPrice.length+2, singleGood.originalPrice.length)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(singleGood.discountPrice.length+2, singleGood.originalPrice.length)];
            [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(singleGood.discountPrice.length+2, singleGood.originalPrice.length)];
            self.priceLabel.attributedText = attrS;
        } else {
            NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", singleGood.discountPrice]];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, singleGood.discountPrice.length+1)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontLargeBold range:NSMakeRange(0, singleGood.discountPrice.length+1)];
            self.priceLabel.attributedText = attrS;
        }
        
        self.titleLabel.text = singleGood.name;
        self.descLabel.text = singleGood.desc;
        
        [self.goodImageView setWithImageURL:singleGood.image placeholder:nil completion:nil];
    }
}

- (void)cellDidSelectWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGSingleGoodBanner class]]) {
        PGSingleGoodBanner *singleGood = (PGSingleGoodBanner *)model;
        [PGRouterManager routeToGoodDetailPage:singleGood.goodsId link:singleGood.link];
    }
}

- (void)setCellWithGood:(PGGood *)good
{
    if (good.originalPrice && ![good.originalPrice isEqualToString:@"0"]) {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ %@", good.discountPrice, good.originalPrice]];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontLargeBold range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
        self.priceLabel.attributedText = attrS;
    } else {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", good.discountPrice]];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontLargeBold range:NSMakeRange(0, good.discountPrice.length+1)];
        self.priceLabel.attributedText = attrS;
    }
    
    self.titleLabel.text = good.name;
    self.descLabel.text = good.desc;
    
    [self.goodImageView setWithImageURL:good.image placeholder:nil completion:nil];
}

+ (CGSize)cellSize
{
    CGFloat width = UISCREEN_WIDTH-44;
    return CGSizeMake(width, width*1/3);
}

#pragma mark - <Lazy Init>

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
        CGFloat width = UISCREEN_WIDTH-20;
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 13, width/2-14-25, 34)];
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.font = Theme.fontMediumBold;
        _titleLabel.numberOfLines = 2;
	}
	return _titleLabel;
}

- (UILabel *)descLabel {
    if(_descLabel == nil) {
        CGFloat width = UISCREEN_WIDTH-20;
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, self.titleLabel.pg_bottom+7, width/2-40, 18)];
        _descLabel.font = Theme.fontSmall;
        _descLabel.textColor = Theme.colorLightText;
    }
    return _descLabel;
}

- (UILabel *)priceLabel {
	if(_priceLabel == nil) {
        CGFloat width = UISCREEN_WIDTH-20;
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, self.pg_height-10-14, width/2-40, 14)];
	}
	return _priceLabel;
}

- (UIImageView *)goodImageView {
    if(_goodImageView == nil) {
        CGFloat width = self.pg_width/2;
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, self.pg_height)];
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodImageView.backgroundColor = Theme.colorLightBackground;
    }
    return _goodImageView;
}

@end
