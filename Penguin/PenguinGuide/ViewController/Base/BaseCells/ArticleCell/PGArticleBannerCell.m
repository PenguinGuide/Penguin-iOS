//
//  PGArticleBannerCell.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CollectButtonWidth 90.f

#import "PGArticleBannerCell.h"
#import "FLAnimatedImageView+PGAnimatedImageView.h"

@interface PGArticleBannerCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bannerImageScrollView;
@property (nonatomic, strong, readwrite) FLAnimatedImageView *bannerImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIImageView *collectImageView;
@property (nonatomic, strong) UILabel *collectLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

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
    [self.bannerImageScrollView addSubview:self.bannerImageView];
    
    UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bannerImageView.pg_width, self.bannerImageView.pg_height)];
    dimView.backgroundColor = [UIColor blackColorWithAlpha:0.3];
    [self.bannerImageView addSubview:dimView];
    [dimView addSubview:self.titleLabel];
    [dimView addSubview:self.subtitleLabel];
    
    // http://stackoverflow.com/questions/14298650/uicollectionviewcell-with-uiscrollview-cancels-didselectitematindexpath
    [self.contentView addGestureRecognizer:self.bannerImageScrollView.panGestureRecognizer];
}

- (void)setCellWithArticle:(PGArticleBanner *)article
{
    if ([article.type isEqualToString:@"video"]) {
        [self.bannerImageView setWithImageURL:article.image placeholder:nil completion:nil];
    } else {
        [self.bannerImageView setStaticImageURL:article.image placeholder:nil completion:nil];
    }
    self.bannerImageView.backgroundColor = Theme.colorText;
    
    self.backgroundColor = Theme.colorHighlight;
    
    self.titleLabel.text = article.title;
    self.subtitleLabel.text = @"日 料 | 夜 宵 | 放 毒";
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
        if (scrollView.contentOffset.x >= CollectButtonWidth) {
            self.backgroundColor = Theme.colorExtraHighlight;
            self.collectImageView.image = [UIImage imageNamed:@"pg_home_article_collected"];
            self.collectLabel.text = @"已收藏";
        }
    }
}

- (UIScrollView *)bannerImageScrollView
{
    if (!_bannerImageScrollView) {
        _bannerImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
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
        _collectImageView.image = [UIImage imageNamed:@"pg_home_article_collect"];
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
        _collectLabel.text = @"收藏";
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

- (CGFloat)labelWidth:(NSString *)str
{
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:Theme.fontExtraSmallBold}];
    
    return size.width+5;
}

@end
