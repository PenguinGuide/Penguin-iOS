//
//  PGFlashbuyGoodView.m
//  Penguin
//
//  Created by Jing Dai on 8/25/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGFlashbuyGoodView.h"

@interface PGFlashbuyGoodView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *secLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *hourLabel;
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
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.descLabel];
    
    [self addSubview:self.hourLabel];
    UILabel *hourDotLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.hourLabel.pg_right, self.hourLabel.pg_top, 16, 20)];
    hourDotLabel.text = @":";
    hourDotLabel.font = Theme.fontExtraLarge;
    hourDotLabel.textColor = [UIColor blackColor];
    hourDotLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:hourDotLabel];
    
    [self addSubview:self.minLabel];
    UILabel *minDotLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.minLabel.pg_right, self.minLabel.pg_top, 16, 20)];
    minDotLabel.text = @":";
    minDotLabel.font = Theme.fontExtraLarge;
    minDotLabel.textColor = [UIColor blackColor];
    minDotLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:minDotLabel];
    
    [self addSubview:self.secLabel];

    [self addSubview:self.goodImageView];
}

- (void)setViewWithGood:(PGGood *)good
{
    self.titleLabel.text = good.name;
    
    [self.goodImageView setWithImageURL:good.image placeholder:nil completion:nil];
    
    NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ %@", good.discountPrice, good.originalPrice]];
    [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorExtraHighlight range:NSMakeRange(0, good.discountPrice.length+1)];
    [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, good.discountPrice.length+1)];
    [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, good.discountPrice.length+1)];
    [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
    [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
    [attrS addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(good.discountPrice.length+2, good.originalPrice.length)];
    self.priceLabel.attributedText = attrS;
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
            self.hourLabel.text = hoursStr;
            self.minLabel.text = minsStr;
            self.secLabel.text = secsStr;
        } else {
            self.hourLabel.text = @"99";
            self.minLabel.text = @"59";
            self.secLabel.text = @"59";
        }
    } else {
        self.hourLabel.text = @"00";
        self.minLabel.text = @"00";
        self.secLabel.text = @"00";
    }
}

#pragma mark - <Lazy Init>

- (UILabel *)titleLabel {
	if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 19, self.pg_width/2-14-25, 34)];
        _titleLabel.font = Theme.fontMediumBold;
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.numberOfLines = 2;
	}
	return _titleLabel;
}

- (UILabel *)priceLabel {
    if(_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, self.titleLabel.pg_bottom+15, self.pg_width/2-40, 14)];
        _priceLabel.textColor = Theme.colorLightText;
        _priceLabel.font = Theme.fontSmallBold;
    }
    return _priceLabel;
}

- (UILabel *)descLabel {
	if(_descLabel == nil) {
		_descLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, self.pg_height-50-18, self.pg_width/2-40, 18)];
        _descLabel.font = Theme.fontMedium;
        _descLabel.textColor = Theme.colorLightText;
	}
	return _descLabel;
}

- (UILabel *)hourLabel
{
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.descLabel.pg_bottom+15, 24, 24)];
        _hourLabel.font = Theme.fontMedium;
        _hourLabel.textColor = [UIColor whiteColor];
        _hourLabel.backgroundColor = [UIColor blackColor];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        [_hourLabel cropCornerRadius:4.f];
    }
    return _hourLabel;
}

- (UILabel *)minLabel
{
    if (!_minLabel) {
        _minLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.hourLabel.pg_right+16, self.descLabel.pg_bottom+15, 24, 24)];
        _minLabel.font = Theme.fontMedium;
        _minLabel.textColor = [UIColor whiteColor];
        _minLabel.backgroundColor = [UIColor blackColor];
        _minLabel.textAlignment = NSTextAlignmentCenter;
        [_minLabel cropCornerRadius:4.f];
    }
    return _minLabel;
}

- (UILabel *)secLabel
{
    if (!_secLabel) {
        _secLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.minLabel.pg_right+16, self.descLabel.pg_bottom+15, 24, 24)];
        _secLabel.font = Theme.fontMedium;
        _secLabel.textColor = [UIColor whiteColor];
        _secLabel.backgroundColor = [UIColor blackColor];
        _secLabel.textAlignment = NSTextAlignmentCenter;
        [_secLabel cropCornerRadius:4.f];
    }
    return _secLabel;
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
