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
@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UIButton *readsCountButton;
@property (nonatomic, strong) UIButton *commentsCountButton;

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
    self.backgroundColor = [UIColor colorWithHexString:@"f19572"];
    
    [self.contentView addSubview:self.collectImageView];
    [self.contentView addSubview:self.collectLabel];
    [self.contentView addSubview:self.bannerImageScrollView];
    [self.contentView addSubview:self.categoryImageView];
    [self.bannerImageScrollView addSubview:self.bannerImageView];
    
    [self.bannerImageView addSubview:self.commentsCountButton];
    [self.bannerImageView addSubview:self.readsCountButton];
    
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
    
    self.commentsCountButton.frame = CGRectMake(UISCREEN_WIDTH-18-(12+16+[self labelWidth:article.commentsCount]), self.height-15-26, 12+16+[self labelWidth:article.commentsCount], 26);
    [self.commentsCountButton setTitle:article.commentsCount forState:UIControlStateNormal];
    
    self.readsCountButton.frame = CGRectMake(self.commentsCountButton.left-18-(12+16+[self labelWidth:article.likesCount]), self.height-15-26, 12+16+[self labelWidth:article.likesCount], 26);
    [self.readsCountButton setTitle:article.likesCount forState:UIControlStateNormal];
    
    self.backgroundColor = [UIColor colorWithHexString:@"f19572"];
    self.collectLabel.text = @"收藏";
    
    if ([article.channel isEqualToString:@"city_guide"]) {
        self.categoryImageView.hidden = NO;
        [self.categoryImageView setImage:[UIImage imageNamed:@"pg_home_article_category_city_guide"]];
    } else if ([article.channel isEqualToString:@"shop"]) {
        self.categoryImageView.hidden = NO;
        [self.categoryImageView setImage:[UIImage imageNamed:@"pg_home_article_category_shop"]];
    } else if ([article.channel isEqualToString:@"test"]) {
        self.categoryImageView.hidden = NO;
        [self.categoryImageView setImage:[UIImage imageNamed:@"pg_home_article_category_test"]];
    } else {
        self.categoryImageView.hidden = YES;
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
        if (scrollView.contentOffset.x >= CollectButtonWidth) {
            self.backgroundColor = Theme.colorHighlight;
            self.collectImageView.image = [UIImage imageNamed:@"pg_home_article_collected"];
            self.collectLabel.text = @"已收藏";
        }
    }
}

- (UIScrollView *)bannerImageScrollView
{
    if (!_bannerImageScrollView) {
        _bannerImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _bannerImageScrollView.delegate = self;
        _bannerImageScrollView.showsHorizontalScrollIndicator = NO;
        _bannerImageScrollView.showsVerticalScrollIndicator = NO;
        _bannerImageScrollView.alwaysBounceHorizontal = YES;
        _bannerImageScrollView.backgroundColor = [UIColor clearColor];
        _bannerImageScrollView.contentSize = CGSizeMake(self.width, self.height);
        _bannerImageScrollView.userInteractionEnabled = NO;
    }
    return _bannerImageScrollView;
}

- (FLAnimatedImageView *)bannerImageView
{
    if (!_bannerImageView) {
        _bannerImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _bannerImageView.clipsToBounds = YES;
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bannerImageView;
}

- (UIImageView *)collectImageView
{
    if (!_collectImageView) {
        _collectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-32-24, self.height/2-14-18, 24, 28)];
        _collectImageView.image = [UIImage imageNamed:@"pg_home_article_collect"];
    }
    return _collectImageView;
}

- (UILabel *)collectLabel
{
    if (!_collectLabel) {
        _collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-90, self.collectImageView.bottom+6, 85, 14)];
        _collectLabel.font = Theme.fontSmall;
        _collectLabel.textColor = [UIColor whiteColor];
        _collectLabel.textAlignment = NSTextAlignmentCenter;
        _collectLabel.text = @"收藏";
    }
    return _collectLabel;
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
		_readsCountButton = [[UIButton alloc] initWithFrame:CGRectMake(self.commentsCountButton.left-18-(12+16+[self labelWidth:@"0"]), self.height-15-26, 12+16+[self labelWidth:@"0"], 26)];
        _readsCountButton.backgroundColor = [UIColor colorWithRed:241.f/256.f green:241.f/256.f blue:241.f/256.f alpha:0.9f];
        _readsCountButton.clipsToBounds = YES;
        _readsCountButton.layer.cornerRadius = 13;
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
		_commentsCountButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-18-(12+16+[self labelWidth:@"0"]), self.height-15-26, 12+16+[self labelWidth:@"0"], 26)];
        _commentsCountButton.backgroundColor = [UIColor colorWithRed:241.f/256.f green:241.f/256.f blue:241.f/256.f alpha:0.9f];
        _commentsCountButton.clipsToBounds = YES;
        _commentsCountButton.layer.cornerRadius = 13;
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
