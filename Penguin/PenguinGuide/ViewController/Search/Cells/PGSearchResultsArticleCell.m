//
//  PGSearchResultsArticleCell.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchResultsArticleCell.h"

@interface PGSearchResultsArticleCell ()

@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UIButton *readsCountButton;
@property (nonatomic, strong) UIButton *commentsCountButton;

@end

@implementation PGSearchResultsArticleCell

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
    
    [self.contentView addSubview:self.bannerImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.readsCountButton];
    [self.contentView addSubview:self.commentsCountButton];
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    maskImageView.image = [[UIImage imageNamed:@"pg_white_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
    [self.contentView addSubview:maskImageView];
}

- (void)setCellWithArticle:(PGArticleBanner *)article
{
    [self.bannerImageView setWithImageURL:article.image placeholder:nil completion:nil];
    [self.titleLabel setText:[NSString stringWithFormat:@"- %@ -", article.title]];
    
    self.readsCountButton.frame = CGRectMake(self.width/2-60, self.titleLabel.bottom+10, 12+16+[self labelWidth:article.readsCount], 26);
    [self.readsCountButton setTitle:article.readsCount forState:UIControlStateNormal];
    
    self.commentsCountButton.frame = CGRectMake(self.width/2, self.titleLabel.bottom+10, 12+16+[self labelWidth:article.commentsCount], 26);
    [self.commentsCountButton setTitle:article.commentsCount forState:UIControlStateNormal];
}

+ (CGSize)cellSize
{
    CGFloat width = UISCREEN_WIDTH-20;
    return CGSizeMake(width, width*90/300+10+14+10+26+10);
}

- (UIImageView *)bannerImageView {
	if(_bannerImageView == nil) {
        CGFloat width = UISCREEN_WIDTH-20;
		_bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width*90/300)];
        _bannerImageView.clipsToBounds = YES;
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerImageView.backgroundColor = Theme.colorText;
	}
	return _bannerImageView;
}

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bannerImageView.bottom+10, UISCREEN_WIDTH-20, 14)];
        _titleLabel.font = Theme.fontMediumBold;
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleLabel;
}

- (UIImageView *)categoryImageView {
    if(_categoryImageView == nil) {
        _categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 28, 28)];
        _categoryImageView.image = [UIImage imageNamed:@"pg_home_article_category_city_guide"];
    }
    return _categoryImageView;
}

- (UIView *)readsCountButton {
    if(_readsCountButton == nil) {
        _readsCountButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2-60, self.titleLabel.bottom+10, 12+16+[self labelWidth:@"0"], 26)];
        _readsCountButton.backgroundColor = [UIColor whiteColor];
        [_readsCountButton.titleLabel setFont:Theme.fontExtraSmallBold];
        [_readsCountButton setTitleColor:Theme.colorHighlight forState:UIControlStateNormal];
        [_readsCountButton setTitle:@"0" forState:UIControlStateNormal];
        [_readsCountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        
        UIImageView *readsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 12, 10)];
        readsIcon.image = [UIImage imageNamed:@"pg_home_article_likes"];
        [_readsCountButton addSubview:readsIcon];
    }
    return _readsCountButton;
}

- (UIView *)commentsCountButton {
    if(_commentsCountButton == nil) {
        _commentsCountButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2, self.titleLabel.bottom+10, 12+16+[self labelWidth:@"0"], 26)];
        _commentsCountButton.backgroundColor = [UIColor whiteColor];
        [_commentsCountButton.titleLabel setFont:Theme.fontExtraSmallBold];
        [_commentsCountButton setTitleColor:Theme.colorHighlight forState:UIControlStateNormal];
        [_commentsCountButton setTitle:@"0" forState:UIControlStateNormal];
        [_commentsCountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        
        UIImageView *commentsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 6.5, 12, 12)];
        commentsIcon.image = [UIImage imageNamed:@"pg_home_article_comments"];
        [_commentsCountButton addSubview:commentsIcon];
    }
    return _commentsCountButton;
}

- (CGFloat)labelWidth:(NSString *)str
{
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:Theme.fontExtraSmallBold}];
    
    return size.width+5;
}

@end
