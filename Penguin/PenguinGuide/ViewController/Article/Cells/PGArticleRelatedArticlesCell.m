//
//  PGArticleRelatedArticlesCell.m
//  Penguin
//
//  Created by Jing Dai on 9/20/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleRelatedArticlesCell.h"
#import "PGArticleBanner.h"
#import "PGDashedLineView.h"
#import "PGArticleRelatedArticleView.h"

@interface PGArticleRelatedArticlesCell () <PGPagedScrollViewDelegate>

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) PGPagedScrollView *pagedScrollView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *viewsArray;

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
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.pagedScrollView];
    
    PGDashedLineView *dashedLine = [[PGDashedLineView alloc] initWithFrame:CGRectMake(0, self.pg_height-5-2, self.pg_width, 2)];
    dashedLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:dashedLine];
}

- (void)setCellWithDataArray:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    
    NSMutableArray *views = [NSMutableArray new];
    for (PGArticleBanner *banner in dataArray) {
        CGFloat width = self.pg_width;
        CGFloat height = width*9/16+38;
        
        PGArticleRelatedArticleView *articleView = [[PGArticleRelatedArticleView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [articleView setViewWithImage:banner.image title:banner.title];
        [views addObject:articleView];
    }
    self.viewsArray = [NSArray arrayWithArray:views];
    
    [self.pagedScrollView reloadData];
}

+ (CGSize)cellSize
{
    CGFloat width = UISCREEN_WIDTH-33*2;
    CGFloat height = 30+15+width*9/16+30+38;
    
    return CGSizeMake(width, height);
}

#pragma mark - <PGPagedScrollViewDelegate>

- (NSArray *)viewsForScrollView
{
    return self.viewsArray;
}

- (void)imageViewDidSelect:(NSInteger)index
{
    PGArticleBanner *articleBanner = self.dataArray[index];
    if (articleBanner.articleId) {
        [PGAnalytics trackEvent:related_article_banner_clicked params:@{event_id:articleBanner.articleId}];
    }
    [[PGRouter sharedInstance] openURL:articleBanner.link];
}

#pragma mark - <Lazy Init>

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, 30)];
        _title.text = @"·  猜你喜欢  ·";
        _title.font = Theme.fontExtraLargeBold;
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (PGPagedScrollView *)pagedScrollView
{
    if (!_pagedScrollView) {
        CGFloat width = self.pg_width;
        CGFloat height = width*9/16+38;
        _pagedScrollView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, self.title.pg_bottom+15, width, height) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeLabel];
        [_pagedScrollView updateLabelFrame:CGRectMake(_pagedScrollView.frame.size.width-10-40, _pagedScrollView.frame.size.height-10-38-30, 40, 30)];
        _pagedScrollView.delegate = self;
    }
    return _pagedScrollView;
}

@end
