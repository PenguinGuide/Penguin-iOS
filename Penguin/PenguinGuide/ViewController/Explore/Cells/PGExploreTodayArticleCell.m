//
//  PGExploreTodayArticleCell.m
//  Penguin
//
//  Created by Kobe Dai on 17/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGExploreTodayArticleCell.h"
#import "PGArticleBanner.h"

@interface PGExploreTodayArticleCell ()

@property (nonatomic, strong) UILabel *todayLabel;
@property (nonatomic, strong) UIImageView *articleImageView;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;

@property (nonatomic, strong) UIView *topVerticalLine;
@property (nonatomic, strong) UIView *bottomVerticalLine;
@property (nonatomic, strong) UIView *dateVerticalLine;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation PGExploreTodayArticleCell

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
    [self.contentView addSubview:self.todayLabel];
    [self.contentView addSubview:self.articleImageView];
    
    [self.contentView addSubview:self.yearLabel];
    [self.contentView addSubview:self.monthLabel];
    [self.contentView addSubview:self.dayLabel];
    
    self.topVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, SINGLE_LINE_HEIGHT)];
    self.topVerticalLine.backgroundColor = Theme.colorBackground;
    
    self.bottomVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.pg_height-SINGLE_LINE_HEIGHT, self.pg_width, SINGLE_LINE_HEIGHT)];
    self.bottomVerticalLine.backgroundColor = Theme.colorBackground;
    
    self.dateVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(60, self.articleImageView.pg_bottom+23, 2, 26)];
    self.dateVerticalLine.backgroundColor = Theme.colorText;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
}

+ (CGSize)cellSize
{
    CGFloat width = UISCREEN_WIDTH-44;
    CGFloat height = 60+width*9/16+20+30+20;
    return CGSizeMake(width, height);
}

- (void)setCellWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)model;
        [self.articleImageView setWithImageURL:articleBanner.image placeholder:nil completion:nil];
        self.titleLabel.text = articleBanner.title;
        self.subtitleLabel.text = articleBanner.subTitle;
        if (!self.topVerticalLine.superview) {
            [self.contentView addSubview:self.topVerticalLine];
        }
        if (!self.bottomVerticalLine.superview) {
            [self.contentView addSubview:self.bottomVerticalLine];
        }
        
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
            if (!self.dateVerticalLine.superview) {
                [self.contentView addSubview:self.dateVerticalLine];
            }
        }
    }
}

- (void)cellDidSelectWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)model;
        [PGRouterManager routeToArticlePage:articleBanner.articleId link:articleBanner.link];
    }
}

#pragma mark - <Lazy Init>

- (UILabel *)todayLabel
{
    if (!_todayLabel) {
        _todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, 60)];
        _todayLabel.textAlignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:@"今日推文 · PENGUIN TODAY"];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, 7)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, 7)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeLight range:NSMakeRange(7, 13)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(7, 13)];
        
        _todayLabel.attributedText = attrS;
    }
    return _todayLabel;
}

- (UIImageView *)articleImageView
{
    if (!_articleImageView) {
        _articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, self.pg_width, self.pg_width*9/16)];
        _articleImageView.clipsToBounds = YES;
        _articleImageView.backgroundColor = Theme.colorBackground;
    }
    return _articleImageView;
}

- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.articleImageView.pg_bottom+20, 48, 30)];
        _dayLabel.font = [UIFont systemFontOfSize:36.f weight:UIFontWeightBold];
        _dayLabel.textColor = Theme.colorText;
    }
    return _dayLabel;
}

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, self.articleImageView.pg_bottom+20, 50, 15-1)];
        _monthLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightBold];
        _monthLabel.textColor = Theme.colorText;
    }
    return _monthLabel;
}

- (UILabel *)yearLabel
{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, self.monthLabel.pg_bottom+2, 50, 15-1)];
        _yearLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightBold];
        _yearLabel.textColor = Theme.colorText;
    }
    return _yearLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, self.articleImageView.pg_bottom+18, self.pg_width-125-10, 16)];
        _titleLabel.font = Theme.fontMediumBold;
        _titleLabel.textColor = Theme.colorText;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, self.titleLabel.pg_bottom+5, self.pg_width-125-10, 12)];
        _subtitleLabel.font = Theme.fontExtraSmallBold;
        _subtitleLabel.textColor = Theme.colorLightText;
    }
    return _subtitleLabel;
}

@end
