//
//  PGFlashbuyGoodView.m
//  Penguin
//
//  Created by Jing Dai on 8/25/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGFlashbuyGoodView.h"

@interface PGFlashbuyGoodView ()

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *goodImageView;

@end

@implementation PGFlashbuyGoodView

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
    self.backgroundColor = Theme.colorLightBackground;
    
    [self addSubview:self.goodImageView];
    [self addSubview:self.titleButton];
    [self addSubview:self.descLabel];
    [self addSubview:self.countdownLabel];
    [self addSubview:self.priceLabel];
}

- (void)setViewWithGood:(PGGood *)good
{
    NSString *title = [NSString stringWithFormat:@"¥%@  %@", good.discountPrice, good.name];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:Theme.fontMediumBold}];
    self.titleButton.pg_width = titleSize.width+25;
    
    [self.titleButton setTitle:[NSString stringWithFormat:@"¥%@  %@", good.discountPrice, good.name] forState:UIControlStateNormal];
    [self.goodImageView setWithImageURL:good.image placeholder:nil completion:nil];
    [self.priceLabel setText:[NSString stringWithFormat:@"原价 ¥%@", good.originalPrice]];
}

- (void)setCountDown:(NSDate *)startDate endDate:(NSDate *)endDate
{
    int secsLeftFromStart = [startDate timeIntervalSinceNow];
    int secsLeftToEnd = [endDate timeIntervalSinceNow];
    if (secsLeftFromStart > 0) {
        self.descLabel.text = @"距离闪购开始";
        [self setCountDown:secsLeftFromStart];
    } else {
        self.descLabel.text = @"距离闪购结束";
        [self setCountDown:secsLeftToEnd];
    }
}

- (void)setCountDown:(int)secsLeft
{
    if (secsLeft > 0) {
        secsLeft--;
        int hours = secsLeft / 3600;
        int mins = (secsLeft - hours*3600) / 60;
        int secs = secsLeft - hours*3600 - mins*60;
        
        NSString *hoursStr = [NSString stringWithFormat:@"%02d", hours];
        NSString *minsStr = [NSString stringWithFormat:@"%02d", mins];
        NSString *secsStr = [NSString stringWithFormat:@"%02d", secs];
        
        if (hoursStr.length == 2 && minsStr.length == 2 && secsStr.length == 2) {
            NSString *countdownStr = [NSString stringWithFormat:@"%@ h %@ min %@ s", hoursStr, minsStr, secsStr];
            NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:countdownStr];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, 2)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, 2)];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(3, 1)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraSmallBold range:NSMakeRange(3, 1)];
            
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(5, 2)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(5, 2)];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(8, 3)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraSmallBold range:NSMakeRange(8, 3)];
            
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(12, 2)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(12, 2)];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(15, 1)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraSmallBold range:NSMakeRange(15, 1)];
            
            self.countdownLabel.attributedText = attrS;
        } else {
            NSString *countdownStr = @"99 h 59 min 59 s";
            NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:countdownStr];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, 2)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, 2)];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(3, 1)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraSmallBold range:NSMakeRange(3, 1)];
            
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(5, 2)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(5, 2)];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(8, 3)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraSmallBold range:NSMakeRange(8, 3)];
            
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(12, 2)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(12, 2)];
            [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(15, 1)];
            [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraSmallBold range:NSMakeRange(15, 1)];
            
            self.countdownLabel.attributedText = attrS;
        }
    } else {
        NSString *countdownStr = @"00 h 00 min 00 s";
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:countdownStr];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, 2)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, 2)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(3, 1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraSmallBold range:NSMakeRange(3, 1)];
        
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(5, 2)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(5, 2)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(8, 3)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraSmallBold range:NSMakeRange(8, 3)];
        
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(12, 2)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(12, 2)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(15, 1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraSmallBold range:NSMakeRange(15, 1)];
        
        self.countdownLabel.attributedText = attrS;
    }
}

#pragma mark - <Setters && Getters>

- (UIButton *)titleButton {
	if(_titleButton == nil) {
		_titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 0, 26)];
        _titleButton.userInteractionEnabled = NO;
        [_titleButton.titleLabel setFont:Theme.fontMediumBold];
        [_titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_titleButton setBackgroundImage:[UIImage imageNamed:@"pg_flashbuy_arrow"] forState:UIControlStateNormal];
	}
	return _titleButton;
}

- (UILabel *)descLabel {
	if(_descLabel == nil) {
		_descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.titleButton.pg_bottom+20, self.pg_width/2-40, 18)];
        _descLabel.textColor = Theme.colorText;
        _descLabel.font = Theme.fontLargeBold;
	}
	return _descLabel;
}

- (UILabel *)countdownLabel {
	if(_countdownLabel == nil) {
		_countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.descLabel.pg_bottom+5, self.pg_width/2-40, 20)];
	}
	return _countdownLabel;
}

- (UILabel *)priceLabel {
	if(_priceLabel == nil) {
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.countdownLabel.pg_bottom+10, self.pg_width/2-40, 14)];
        _priceLabel.textColor = Theme.colorLightText;
        _priceLabel.font = Theme.fontSmallBold;
	}
	return _priceLabel;
}

- (UIImageView *)goodImageView {
	if(_goodImageView == nil) {
		_goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.pg_width/2, 0, self.pg_width/2, self.pg_height)];
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodImageView.clipsToBounds = YES;
        _goodImageView.backgroundColor = Theme.colorText;
	}
	return _goodImageView;
}

@end
