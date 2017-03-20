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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.dateLabel];
}

+ (CGSize)cellSize
{
    return CGSizeMake(150, 2*150/3.f+10+40+15+12+20);
}

#pragma mark - <PGBaseCollectionViewCell>

- (void)setCellWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)model;
        [self.articleImageView setWithImageURL:articleBanner.image placeholder:nil completion:nil];
        [self.titleLabel setText:articleBanner.title];
        [self.dateLabel setText:[self dateFromDate:articleBanner.date]];
    }
}

- (void)cellDidSelectWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)model;
        [PGRouterManager routeToArticlePage:articleBanner.articleId link:articleBanner.link animated:NO];
    }
}

- (NSString *)dateFromDate:(NSString *)date
{
    NSString *newDate = @"";
    
    NSArray *components = [date componentsSeparatedByString:@"/"];
    if (components.count == 3) {
        NSString *year = components[0];
        NSString *month = components[1];
        NSString *day = components[2];
        
        if ([month isEqualToString:@"1"]) {
            newDate = @"JAN";
        } else if ([month isEqualToString:@"2"]) {
            newDate = @"FEB";
        } else if ([month isEqualToString:@"3"]) {
            newDate = @"MAR";
        } else if ([month isEqualToString:@"4"]) {
            newDate = @"APR";
        } else if ([month isEqualToString:@"5"]) {
            newDate = @"MAY";
        } else if ([month isEqualToString:@"6"]) {
            newDate = @"JUN";
        } else if ([month isEqualToString:@"7"]) {
            newDate = @"JUL";
        } else if ([month isEqualToString:@"8"]) {
            newDate = @"AUG";
        } else if ([month isEqualToString:@"9"]) {
            newDate = @"SEP";
        } else if ([month isEqualToString:@"10"]) {
            newDate = @"OCT";
        } else if ([month isEqualToString:@"11"]) {
            newDate = @"NOV";
        } else if ([month isEqualToString:@"12"]) {
            newDate = @"DEC";
        }
        newDate = [newDate stringByAppendingString:[NSString stringWithFormat:@" %@.%@", day, year]];
    }
    return newDate;
}

#pragma mark - <Lazy Init>

- (UIImageView *)articleImageView
{
    if (!_articleImageView) {
        _articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, 2*self.pg_width/3)];
        _articleImageView.backgroundColor = Theme.colorBackground;
        _articleImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _articleImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, self.articleImageView.pg_bottom+10, self.pg_width-28, 40)];
        _titleLabel.font = Theme.fontMediumBold;
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, self.titleLabel.pg_bottom+15, self.pg_width-28, 12)];
        _dateLabel.font = Theme.fontExtraSmallBold;
        _dateLabel.textColor = Theme.colorText;
    }
    return _dateLabel;
}

@end
