//
//  PGArticleCardCell.m
//  Penguin
//
//  Created by Kobe Dai on 16/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGArticleCardCell.h"
#import "PGArticleBanner.h"

@interface PGArticleCardCell ()

@property (nonatomic, strong) UIImageView *articleImageView;

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UIView *dateVerticalLine;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PGArticleCardCell

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
    [self.contentView addSubview:self.articleImageView];
    
    UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
    dimView.backgroundColor = [UIColor blackColorWithAlpha:0.3];
    [self.contentView addSubview:dimView];
    
    [dimView addSubview:self.titleLabel];
    [dimView addSubview:self.dayLabel];
    [dimView addSubview:self.dateVerticalLine];
    [dimView addSubview:self.yearLabel];
    [dimView addSubview:self.monthLabel];
}

+ (CGSize)cellSize
{
    return CGSizeMake(180, 4*180/3.f);
}

#pragma mark - <PGBaseCollectionViewCell>

- (void)setCellWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)model;
        [self.articleImageView setWithImageURL:articleBanner.image placeholder:nil completion:nil];
        [self.titleLabel setText:articleBanner.title];
        
        if (articleBanner.date && articleBanner.date.length > 0) {
            NSArray *datesArray = [articleBanner.date componentsSeparatedByString:@"/"];
            if (datesArray.count == 3) {
                NSArray *dates = [articleBanner.date componentsSeparatedByString:@"/"];
                if (dates.count == 3) {
                    self.yearLabel.text = dates[0];
                    self.dayLabel.text = dates[2];
                    
                    NSString *month = dates[1];
                    if ([month isEqualToString:@"1"]) {
                        self.monthLabel.text = @"JAN.";
                    } else if ([month isEqualToString:@"2"]) {
                        self.monthLabel.text = @"FEB.";
                    } else if ([month isEqualToString:@"3"]) {
                        self.monthLabel.text = @"MAR.";
                    } else if ([month isEqualToString:@"4"]) {
                        self.monthLabel.text = @"APR.";
                    } else if ([month isEqualToString:@"5"]) {
                        self.monthLabel.text = @"MAY.";
                    } else if ([month isEqualToString:@"6"]) {
                        self.monthLabel.text = @"JUN.";
                    } else if ([month isEqualToString:@"7"]) {
                        self.monthLabel.text = @"JUL.";
                    } else if ([month isEqualToString:@"8"]) {
                        self.monthLabel.text = @"AUG.";
                    } else if ([month isEqualToString:@"9"]) {
                        self.monthLabel.text = @"SEP.";
                    } else if ([month isEqualToString:@"10"]) {
                        self.monthLabel.text = @"OCT.";
                    } else if ([month isEqualToString:@"11"]) {
                        self.monthLabel.text = @"NOV.";
                    } else if ([month isEqualToString:@"12"]) {
                        self.monthLabel.text = @"DEC.";
                    }
                }
            }
        }
    }
}

- (void)cellDidSelectWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)model;
        [PGRouterManager routeToArticlePage:articleBanner.articleId link:articleBanner.link animated:NO];
    }
}

#pragma mark - <Lazy Init>

- (UIImageView *)articleImageView
{
    if (!_articleImageView) {
        _articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, 4*self.pg_width/3)];
        _articleImageView.backgroundColor = Theme.colorBackground;
        _articleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _articleImageView.clipsToBounds = YES;
    }
    return _articleImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, self.pg_height-20-40, self.pg_width-22-40, 40)];
        _titleLabel.font = Theme.fontLargeBold;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, self.titleLabel.pg_top-10-26, 38, 26)];
        _dayLabel.font = [UIFont systemFontOfSize:26.f weight:UIFontWeightBold];
        _dayLabel.textColor = [UIColor whiteColor];
    }
    return _dayLabel;
}

- (UIView *)dateVerticalLine
{
    if (!_dateVerticalLine) {
        _dateVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.dayLabel.pg_right+3, self.titleLabel.pg_top-10-24+2, 2, 20)];
        _dateVerticalLine.backgroundColor = [UIColor whiteColor];
    }
    return _dateVerticalLine;
}

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dateVerticalLine.pg_right+8, self.titleLabel.pg_top-10-23, 50, 10)];
        _monthLabel.font = [UIFont systemFontOfSize:10.f weight:UIFontWeightBold];
        _monthLabel.textColor = [UIColor whiteColor];
    }
    return _monthLabel;
}

- (UILabel *)yearLabel
{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dateVerticalLine.pg_right+8, self.monthLabel.pg_bottom+2, 50, 10)];
        _yearLabel.font = [UIFont systemFontOfSize:10.f weight:UIFontWeightBold];
        _yearLabel.textColor = [UIColor whiteColor];
    }
    return _yearLabel;
}

@end
