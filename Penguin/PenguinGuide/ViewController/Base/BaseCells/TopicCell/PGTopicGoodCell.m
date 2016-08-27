//
//  PGTopicGoodCell.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTopicGoodCell.h"

@interface PGTopicGoodCell ()

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *stockImageView;

@end

@implementation PGTopicGoodCell

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
    
    [self.contentView addSubview:self.goodImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.stockImageView];
}

- (void)setCellWithGood:(PGGood *)good
{
    [self.goodImageView setWithImageURL:good.image placeholder:nil completion:nil];
    [self.titleLabel setText:good.name];
    
    NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ %@", good.discountPrice, good.originalPrice]];
    [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
    [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, good.discountPrice.length+1)];
        [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, good.discountPrice.length+1)];
    [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
    [attrS addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
    [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
    self.priceLabel.attributedText = attrS;
    
    if (good.isNew) {
        self.stockImageView.hidden = NO;
    } else {
        self.stockImageView.hidden = YES;
    }
}

#pragma mark - <Setters && Getters>

- (UIImageView *)goodImageView {
    if(_goodImageView == nil) {
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 95)];
        _goodImageView.clipsToBounds = YES;
        _goodImageView.backgroundColor = Theme.colorBackground;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _goodImageView.width, _goodImageView.height)];
        maskImageView.image = [[UIImage imageNamed:@"pg_bg_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
        [_goodImageView addSubview:maskImageView];
    }
    return _goodImageView;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, self.goodImageView.bottom+5, 160-6, 14)];
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.font = Theme.fontSmallBold;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if(_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, self.titleLabel.bottom+3, 160-6, 16)];
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
