//
//  PGArticleRelatedArticlesCell.m
//  Penguin
//
//  Created by Jing Dai on 9/20/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleRelatedArticlesCell.h"
#import "PGImageBanner.h"
#import "PGDashedLineView.h"

@interface PGArticleRelatedArticlesCell () <PGPagedScrollViewDelegate>

@property (nonatomic, strong) UIImageView *bannerFrameView;
@property (nonatomic, strong) PGPagedScrollView *pagedScrollView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation PGArticleRelatedArticlesCell

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
    [self.contentView addSubview:self.bannerFrameView];
    [self.contentView addSubview:self.pagedScrollView];
    
    PGDashedLineView *dashedLine = [[PGDashedLineView alloc] initWithFrame:CGRectMake(0, self.pg_height-5-2, self.pg_width, 2)];
    dashedLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:dashedLine];
}

- (void)setCellWithDataArray:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    [self.pagedScrollView reloadData];
}

+ (CGSize)cellSize
{
    CGFloat width = UISCREEN_WIDTH-60;
    CGFloat height = width*279/290+60;
    
    return CGSizeMake(width, height);
}

#pragma mark - <PGPagedScrollViewDelegate>

- (NSArray *)imagesForScrollView
{
    NSMutableArray *banners = [NSMutableArray new];
    for (PGImageBanner *banner in self.dataArray) {
        if (banner.image) {
            [banners addObject:banner.image];
        }
    }
    return [NSArray arrayWithArray:banners];
}

- (UIImageView *)bannerFrameView
{
    if (!_bannerFrameView) {
        _bannerFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height-60)];
        _bannerFrameView.clipsToBounds = YES;
        _bannerFrameView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerFrameView.image = [UIImage imageNamed:@"pg_article_banner_frame"];
    }
    return _bannerFrameView;
}

- (void)imageViewDidSelect:(NSInteger)index
{
    PGImageBanner *banner = self.dataArray[index];
    [[PGRouter sharedInstance] openURL:banner.link];
}

- (PGPagedScrollView *)pagedScrollView
{
    if (!_pagedScrollView) {
        CGFloat width = self.pg_width-15-15;
        CGFloat height = width*9/16;
        _pagedScrollView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(15, self.pg_height-13-height-60, width, height) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeLight];
        _pagedScrollView.delegate = self;
    }
    return _pagedScrollView;
}

@end
