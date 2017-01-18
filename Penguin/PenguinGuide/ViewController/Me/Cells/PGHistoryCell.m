//
//  PGHistoryCell.m
//  Penguin
//
//  Created by Jing Dai on 31/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHistoryCell.h"

@interface PGHistoryCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *articleImageView;
@property (nonatomic, strong) UILabel *articleTitleLabel;
@property (nonatomic, strong) UIView *horizontalLine;

@end

@implementation PGHistoryCell

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
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.containerView];
    [self.contentView addSubview:self.horizontalLine];
    
    [self.containerView addSubview:self.articleImageView];
    [self.containerView addSubview:self.articleTitleLabel];
}

- (void)setCellWithHistory:(PGHistory *)history
{
    [self.dateLabel setText:history.time];
    [self.contentLabel setText:history.content.content];
    [self.articleTitleLabel setText:history.content.articleTitle];
    [self.articleImageView setWithImageURL:history.content.image placeholder:nil completion:nil];
    
    CGSize size = [history.content.content boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-50-24, 1000)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:Theme.fontSmall}
                                                        context:nil].size;
    self.contentLabel.pg_height = size.height;
    self.containerView.frame = CGRectMake(24, self.contentLabel.pg_bottom+10, UISCREEN_WIDTH-48, 80);
    self.articleImageView.frame = CGRectMake(12, (80-42)/2, 42, 42);
    self.articleTitleLabel.frame = CGRectMake(70, (80-42)/2, self.containerView.pg_width-70-15, 42);
    self.horizontalLine.frame = CGRectMake(24, self.pg_height-1/[UIScreen mainScreen].scale, UISCREEN_WIDTH-48, 1/[UIScreen mainScreen].scale);
}

+ (CGSize)cellSize:(PGHistory *)history
{
    CGSize size = [history.content.content boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-50-24, 1000)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:Theme.fontSmall}
                                                        context:nil].size;
    
    return CGSizeMake(UISCREEN_WIDTH, 20+14+5+size.height+10+80+20);
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 20, 150, 16)];
        _dateLabel.font = Theme.fontMedium;
        _dateLabel.textColor = Theme.colorText;
    }
    return _dateLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, self.dateLabel.pg_bottom+5, UISCREEN_WIDTH-36-24, 0)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = Theme.fontSmall;
        _contentLabel.textColor = Theme.colorText;
    }
    return _contentLabel;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(24, self.contentLabel.pg_bottom+10, UISCREEN_WIDTH-48, 80)];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIImageView *)articleImageView
{
    if (!_articleImageView) {
        _articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, (80-42)/2, 42, 42)];
        _articleImageView.clipsToBounds = YES;
        _articleImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _articleImageView;
}

- (UILabel *)articleTitleLabel
{
    if (!_articleTitleLabel) {
        _articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, (80-42)/2, self.containerView.pg_width-70-15, 42)];
        _articleTitleLabel.font = Theme.fontMedium;
        _articleTitleLabel.textColor = Theme.colorText;
    }
    return _articleTitleLabel;
}

- (UIView *)horizontalLine
{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(24, self.pg_height-1/[UIScreen mainScreen].scale, UISCREEN_WIDTH-48, 1/[UIScreen mainScreen].scale)];
        _horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    }
    return _horizontalLine;
}

@end
