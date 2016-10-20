//
//  PGChannelAllCategoriesHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGChannelAllCategoriesHeaderView.h"

@interface PGChannelAllCategoriesHeaderView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) PGChannel *channel;

@end

@implementation PGChannelAllCategoriesHeaderView

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
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.descLabel];
}

- (void)setViewWithChannel:(PGChannel *)channel
{
    self.channel = channel;
    
    self.countLabel.text = [NSString stringWithFormat:@"-共%@篇-", self.channel.totalArticles];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 10.f;
    NSAttributedString *descStr = [[NSAttributedString alloc] initWithString:channel.desc
                                                                  attributes:@{NSFontAttributeName:Theme.fontExtraSmall,
                                                                               NSForegroundColorAttributeName:Theme.colorText,
                                                                               NSParagraphStyleAttributeName:paragraphStyle}];
    CGSize textSize = [descStr boundingRectWithSize:CGSizeMake(self.pg_width-26*2, UISCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.descLabel.frame = CGRectMake(32, self.countLabel.pg_bottom+12, self.pg_width-32*2, textSize.height+10);
    self.descLabel.attributedText = descStr;
}

+ (CGSize)viewSize:(PGChannel *)channel
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 10.f;
    NSAttributedString *descStr = [[NSAttributedString alloc] initWithString:channel.desc
                                                                  attributes:@{NSFontAttributeName:Theme.fontExtraSmall,
                                                                               NSForegroundColorAttributeName:Theme.colorText,
                                                                               NSParagraphStyleAttributeName:paragraphStyle}];
    CGSize textSize = [descStr boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-26*2, UISCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat height = 115+textSize.height+10;
    
    return CGSizeMake(UISCREEN_WIDTH, height);
}

- (UIImageView *)iconImageView {
	if(_iconImageView == nil) {
		_iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.pg_width/2-17/2.f, 30, 17, 20)];
        _iconImageView.image = [UIImage imageNamed:@"pg_channel_info_city_guide"];
	}
	return _iconImageView;
}

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImageView.pg_bottom+8, self.pg_width, 16)];
        _titleLabel.text = @"城市指南";
        _titleLabel.font = Theme.fontMediumBold;
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleLabel;
}

- (UILabel *)countLabel {
	if(_countLabel == nil) {
		_countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.pg_bottom+12, self.pg_width, 12)];
        _countLabel.font = Theme.fontExtraSmall;
        _countLabel.textColor = Theme.colorLightText;
        _countLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _countLabel;
}

- (UILabel *)descLabel {
	if(_descLabel == nil) {
		_descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.countLabel.pg_bottom+12, self.pg_width, 12)];
        _descLabel.numberOfLines = 0;
	}
	return _descLabel;
}

@end
