//
//  PGArticleRelatedArticleView.m
//  Penguin
//
//  Created by Kobe Dai on 14/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleRelatedArticleView.h"

@interface PGArticleRelatedArticleView ()

@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PGArticleRelatedArticleView

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
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.bannerImageView];
    [self addSubview:self.titleLabel];
}

- (void)setViewWithImage:(NSString *)image title:(NSString *)title
{
    [self.bannerImageView setWithImageURL:image placeholder:nil completion:nil];
    [self.titleLabel setText:title];
}

- (UIImageView *)bannerImageView
{
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_width*9/16)];
        _bannerImageView.clipsToBounds = YES;
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerImageView.backgroundColor = Theme.colorBackground;
    }
    return _bannerImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.pg_width*9/16+20, self.pg_width, 18)];
        _titleLabel.font = Theme.fontLargeBold;
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
