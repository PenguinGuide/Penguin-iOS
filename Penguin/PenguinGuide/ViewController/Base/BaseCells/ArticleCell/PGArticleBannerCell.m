//
//  PGArticleBannerCell.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CollectButtonWidth 90.f

#import "PGArticleBannerCell.h"
#import "PGBannerImageScrollView.h"
#import "FLAnimatedImageView+PGAnimatedImageView.h"
#import "PGCoverTagView.h"

@interface PGArticleBannerCell () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) PGArticleBanner *article;

@property (nonatomic, strong, readwrite) PGBannerImageScrollView *bannerImageScrollView;
@property (nonatomic, strong, readwrite) FLAnimatedImageView *bannerImageView;
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong, readwrite) UIImageView *collectImageView;
@property (nonatomic, strong, readwrite) UILabel *collectLabel;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *subtitleLabel;
@property (nonatomic, strong, readwrite) UIImageView *articleNewImageView;
@property (nonatomic, strong, readwrite) UIImageView *tagImageView;
@property (nonatomic, strong, readwrite) PGCoverTagView *statusTagView;
@property (nonatomic, strong, readwrite) PGCoverTagView *descTagView;

@property (nonatomic, assign) BOOL isScrollling;

@end

@implementation PGArticleBannerCell

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
    self.backgroundColor = Theme.colorHighlight;
    
    [self.contentView addSubview:self.collectImageView];
    [self.contentView addSubview:self.collectLabel];
    [self.contentView addSubview:self.bannerImageScrollView];
    [self.contentView addSubview:self.articleNewImageView];
    [self.contentView addSubview:self.tagImageView];
    [self.bannerImageScrollView addSubview:self.bannerImageView];
    
    UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bannerImageView.pg_width, self.bannerImageView.pg_height)];
    dimView.backgroundColor = [UIColor blackColorWithAlpha:0.3];
    [self.bannerImageView addSubview:dimView];
    [dimView addSubview:self.titleLabel];
    [dimView addSubview:self.subtitleLabel];
    
    [self.bannerImageView addSubview:self.statusTagView];
    [self.bannerImageView addSubview:self.descTagView];
    
    // http://stackoverflow.com/questions/14298650/uicollectionviewcell-with-uiscrollview-cancels-didselectitematindexpath
    [self.contentView addGestureRecognizer:self.bannerImageScrollView.panGestureRecognizer];
}

- (void)setCellWithArticle:(PGArticleBanner *)article allowGesture:(BOOL)allowGesture
{
    self.article = article;
    
    if (!allowGesture) {
        [self.contentView removeGestureRecognizer:self.bannerImageScrollView.panGestureRecognizer];
    }
    if ([article.type isEqualToString:@"video"]) {
        [self.bannerImageView setWithImageURL:article.image placeholder:nil completion:nil];
    } else {
        [self.bannerImageView setStaticImageURL:article.image placeholder:nil completion:nil];
    }
    self.bannerImageView.backgroundColor = Theme.colorBackground;
    
    self.titleLabel.text = article.title;
    self.subtitleLabel.text = article.coverTitle;
    
    if (self.article.isCollected) {
        self.backgroundColor = Theme.colorExtraHighlight;
        self.collectLabel.text = @"已收藏";
        self.collectImageView.image = [UIImage imageNamed:@"pg_home_article_collected"];
    } else {
        self.backgroundColor = Theme.colorHighlight;
        self.collectLabel.text = @"收藏";
        self.collectImageView.image = [UIImage imageNamed:@"pg_home_article_collect"];
    }
    
    if (self.article.isNew) {
        self.articleNewImageView.hidden = NO;
    } else {
        self.articleNewImageView.hidden = YES;
    }
    
    if (self.article.isRecommendGood) {
        self.tagImageView.hidden = NO;
        self.tagImageView.image = [UIImage imageNamed:@"pg_article_banner_good_tag"];
    } else if (self.article.isRecommendResturant) {
        self.tagImageView.hidden = NO;
        self.tagImageView.image = [UIImage imageNamed:@"pg_article_banner_resturant_tag"];
    } else {
        self.tagImageView.hidden = YES;
    }

    if ([self.article.status isEqualToString:@"1"]) {
        self.statusTagView.hidden = YES;
    } else {
        self.statusTagView.hidden = NO;
        if ([self.article.status isEqualToString:@"2"]) {
            // NEW
            [self.statusTagView setTagViewWithTitle:@"NEW!" style:PGCoverTagViewStyleNew];
        } else if ([self.article.status isEqualToString:@"3"]) {
            // HOT
            [self.statusTagView setTagViewWithTitle:@"HOT!" style:PGCoverTagViewStyleHot];
        }
    }
    
    if (self.article.desc.length > 0) {
        self.descTagView.hidden = NO;
        [self.descTagView setTagViewWithTitle:self.article.desc style:PGCoverTagViewStyleNormal];
    } else {
        self.descTagView.hidden = YES;
    }
}

- (void)cellDidSelectWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)model;
        [PGRouterManager routeToArticlePage:articleBanner.articleId link:articleBanner.link];
    }
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*9/16);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointZero;
    } else {
        if (self.isScrollling) {
            return;
        }
        if (scrollView.contentOffset.x >= CollectButtonWidth) {
            if (PGGlobal.userId && PGGlobal.userId.length > 0) {
                if (self.article.isCollected) {
                    self.backgroundColor = Theme.colorHighlight;
                    self.collectImageView.image = [UIImage imageNamed:@"pg_home_article_collect"];
                    self.collectLabel.text = @"收藏";
                    if (self.delegate && [self.delegate respondsToSelector:@selector(disCollectArticle:)]) {
                        [self.delegate disCollectArticle:self.article];
                    }
                } else {
                    self.backgroundColor = Theme.colorExtraHighlight;
                    self.collectImageView.image = [UIImage imageNamed:@"pg_home_article_collected"];
                    self.collectLabel.text = @"已收藏";
                    if (self.delegate && [self.delegate respondsToSelector:@selector(collectArticle:)]) {
                        [PGAnalytics trackEvent:article_collect_slider_clicked params:@{event_id:self.eventId}];
                        [self.delegate collectArticle:self.article];
                    }
                }
                self.isScrollling = YES;
            } else {
                [PGRouterManager routeToLoginPage];
                return;
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScrollling = NO;
}

- (PGBannerImageScrollView *)bannerImageScrollView
{
    if (!_bannerImageScrollView) {
        _bannerImageScrollView = [[PGBannerImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
        _bannerImageScrollView.delegate = self;
        _bannerImageScrollView.showsHorizontalScrollIndicator = NO;
        _bannerImageScrollView.showsVerticalScrollIndicator = NO;
        _bannerImageScrollView.alwaysBounceHorizontal = YES;
        _bannerImageScrollView.backgroundColor = [UIColor clearColor];
        _bannerImageScrollView.contentSize = CGSizeMake(self.pg_width, self.pg_height);
        _bannerImageScrollView.userInteractionEnabled = NO;
    }
    return _bannerImageScrollView;
}

- (FLAnimatedImageView *)bannerImageView
{
    if (!_bannerImageView) {
        _bannerImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
        _bannerImageView.clipsToBounds = YES;
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bannerImageView;
}

- (UIImageView *)collectImageView
{
    if (!_collectImageView) {
        _collectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.pg_width-32-26, self.pg_height/2-14-18, 26, 24)];
    }
    return _collectImageView;
}

- (UILabel *)collectLabel
{
    if (!_collectLabel) {
        _collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.pg_width-88, self.collectImageView.pg_bottom+6, 85, 14)];
        _collectLabel.font = Theme.fontSmall;
        _collectLabel.textColor = [UIColor whiteColor];
        _collectLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _collectLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.pg_height-16)/2-10, UISCREEN_WIDTH, 16)];
        _titleLabel.font = Theme.fontLargeBold;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.pg_bottom+10, UISCREEN_WIDTH, 14)];
        _subtitleLabel.font = Theme.fontSmall;
        _subtitleLabel.textColor = [UIColor whiteColor];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subtitleLabel;
}

- (UIImageView *)articleNewImageView
{
    if (!_articleNewImageView) {
        _articleNewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, 28, 59)];
        _articleNewImageView.image = [UIImage imageNamed:@"pg_article_banner_new_tag"];
        _articleNewImageView.hidden = YES;
    }
    return _articleNewImageView;
}

- (UIImageView *)tagImageView
{
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.pg_width-14-82, 14, 82, 20)];
        _tagImageView.hidden = YES;
    }
    return _tagImageView;
}

- (PGCoverTagView *)statusTagView
{
    if (!_statusTagView) {
        _statusTagView = [PGCoverTagView tagViewWithMargin:CGPointMake(20, 20) alignment:PGCoverTagViewAlignmentLeft];
    }
    return _statusTagView;
}

- (PGCoverTagView *)descTagView
{
    if (!_descTagView) {
        _descTagView = [PGCoverTagView tagViewWithMargin:CGPointMake(20, 20) alignment:PGCoverTagViewAlignmentRight];
    }
    return _descTagView;
}

- (CGFloat)labelWidth:(NSString *)str
{
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:Theme.fontExtraSmallBold}];
    
    return size.width+5;
}

@end
