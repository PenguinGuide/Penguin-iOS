//
//  PGArticleBannerCell.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CollectButtonWidth 90.f

#import "PGArticleBannerCell.h"

@interface PGArticleBannerCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bannerImageScrollView;
@property (nonatomic, strong, readwrite) FLAnimatedImageView *bannerImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIImageView *collectImageView;
@property (nonatomic, strong) UILabel *collectLabel;

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
    [self.bannerImageScrollView addSubview:self.bannerImageView];
    
    // http://stackoverflow.com/questions/14298650/uicollectionviewcell-with-uiscrollview-cancels-didselectitematindexpath
    [self.contentView addGestureRecognizer:self.bannerImageScrollView.panGestureRecognizer];
}

- (void)setCellWithImageBanner:(PGImageBanner *)banner
{
    if ([banner.type isEqualToString:@"video"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:banner.image ofType:@"gif"];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:path]];
        self.bannerImageView.animatedImage = image;
    } else {
        self.bannerImageView.image = [UIImage imageNamed:banner.image];
    }
    self.backgroundColor = [UIColor colorWithHexString:@"f19572"];
    self.collectImageView.image = [UIImage imageNamed:@"pg_home_article_collect"];
    self.collectLabel.text = @"收藏";
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*180/320);
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

@end
