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
    [dimView addSubview:self.yearLabel];
    [dimView addSubview:self.monthLabel];
    [dimView addSubview:self.dayLabel];
    
    self.dateVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(72, self.titleLabel.pg_top-15-30+2, 2, 26)];
    self.dateVerticalLine.backgroundColor = [UIColor whiteColor];
    [dimView addSubview:self.dateVerticalLine];
}

+ (CGSize)cellSize
{
    return CGSizeMake(240, 4*240/3.f);
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
//            if (!self.dateVerticalLine.superview) {
//                [self.contentView addSubview:self.dateVerticalLine];
//            }
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, self.pg_height-30-50, self.pg_width-22-50, 50)];
        _titleLabel.font = [UIFont systemFontOfSize:20.f weight:UIFontWeightBold];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, self.titleLabel.pg_top-15-30, 48, 30)];
        _dayLabel.font = [UIFont systemFontOfSize:36.f weight:UIFontWeightBold];
        _dayLabel.textColor = [UIColor whiteColor];
    }
    return _dayLabel;
}

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, self.titleLabel.pg_top-15-30, 50, 15-1)];
        _monthLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightBold];
        _monthLabel.textColor = [UIColor whiteColor];
    }
    return _monthLabel;
}

- (UILabel *)yearLabel
{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, self.monthLabel.pg_bottom+2, 50, 15-1)];
        _yearLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightBold];
        _yearLabel.textColor = [UIColor whiteColor];
    }
    return _yearLabel;
}

@end
