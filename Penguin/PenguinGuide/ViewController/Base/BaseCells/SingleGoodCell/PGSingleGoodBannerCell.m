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
    self.clipsToBounds = YES;
    
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.goodImageView];
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    maskImageView.image = [[UIImage imageNamed:@"pg_white_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
    [self.contentView addSubview:maskImageView];
}

- (void)setCellWithSingleGood:(PGSingleGoodBanner *)singleGood
{
    NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ %@", singleGood.discountPrice, singleGood.originalPrice]];
    [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, singleGood.discountPrice.length+1)];
    [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, singleGood.discountPrice.length+1)];
    [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, singleGood.discountPrice.length+1)];
    [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"AFAFAF"] range:NSMakeRange(singleGood.discountPrice.length+2, singleGood.originalPrice.length)];
    [attrS addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(singleGood.discountPrice.length+2, singleGood.originalPrice.length)];
    [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(singleGood.discountPrice.length+2, singleGood.originalPrice.length)];
    self.priceLabel.attributedText = attrS;
    
    self.titleLabel.text = singleGood.name;
    self.descLabel.text = singleGood.desc;
    
    [self.goodImageView setWithImageURL:singleGood.image placeholder:nil completion:nil];
}

+ (CGSize)cellSize
{
    CGFloat width = UISCREEN_WIDTH-20;
    return CGSizeMake(width, (width/2)*9/16);
}

#pragma mark - <Setters && Getters>

- (UIImageView *)goodImageView {
	if(_goodImageView == nil) {
        CGFloat width = (UISCREEN_WIDTH-20)/2;
		_goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, width*9/16)];
        _goodImageView.clipsToBounds = YES;
        _goodImageView.backgroundColor = Theme.colorText;
	}
	return _goodImageView;
}

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
        CGFloat width = UISCREEN_WIDTH-20;
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.priceLabel.bottom+3, width/2-30, 35)];
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.font = Theme.fontMediumBold;
        _titleLabel.numberOfLines = 2;
	}
	return _titleLabel;
}

- (UILabel *)priceLabel {
	if(_priceLabel == nil) {
        CGFloat width = UISCREEN_WIDTH-20;
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, width/2-30, 16)];
	}
	return _priceLabel;
}

- (UILabel *)descLabel {
	if(_descLabel == nil) {
        CGFloat width = UISCREEN_WIDTH-20;
		_descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (width/2)*9/16-15-12, width/2-30, 12)];
        _descLabel.font = Theme.fontExtraSmallBold;
        _descLabel.textColor = Theme.colorGray;
	}
	return _descLabel;
}

@end
