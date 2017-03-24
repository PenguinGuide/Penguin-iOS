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

@property (nonatomic, strong) UILabel *topDescLabel;
@property (nonatomic, strong) UILabel *bottomDescLabel;
@property (nonatomic, strong) UIView *verticalLine;

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
    self.topDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 38, 22)];
    self.topDescLabel.textColor = Theme.colorText;
    self.topDescLabel.font = Theme.fontLargeBold;
    
    self.bottomDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10+22, 38, 22)];
    self.bottomDescLabel.textColor = Theme.colorText;
    self.bottomDescLabel.font = Theme.fontLargeBold;
    
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.topDescLabel.pg_right+12, 10, 2, self.pg_height-20)];
    self.verticalLine.backgroundColor = Theme.colorText;
    
    [self.contentView addSubview:self.topDescLabel];
    [self.contentView addSubview:self.bottomDescLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
}

- (void)setCellWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)model;
        self.titleLabel.text = articleBanner.title;
        self.subtitleLabel.text = articleBanner.subTitle;
        self.topDescLabel.text = @"今 日";
        self.bottomDescLabel.text = @"推 文";
        if (!self.verticalLine.superview) {
            [self.contentView addSubview:self.verticalLine];
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

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 12, self.pg_width-95-10, 16)];
        _titleLabel.font = Theme.fontMediumBold;
        _titleLabel.textColor = Theme.colorText;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 36, self.pg_width-95-10, 12)];
        _subtitleLabel.font = Theme.fontExtraSmallBold;
        _subtitleLabel.textColor = Theme.colorLightText;
    }
    return _subtitleLabel;
}

@end
