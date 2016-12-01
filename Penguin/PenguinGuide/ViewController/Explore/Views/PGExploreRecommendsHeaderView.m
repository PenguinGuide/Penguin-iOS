//
//  PGExploreRecommendsHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static NSString *const ScenarioCell = @"ScenarioCell";

#import "PGExploreRecommendsHeaderView.h"
#import "PGImageBanner.h"

@interface PGExploreRecommendsHeaderView () <PGPagedScrollViewDelegate>

@property (nonatomic, strong) NSArray *recommendsArray;
@property (nonatomic, strong, readwrite) PGPagedScrollView *bannersView;

@end

@implementation PGExploreRecommendsHeaderView

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
    
    [self addSubview:self.bannersView];
}

- (void)reloadBannersWithRecommendsArray:(NSArray *)recommendsArray
{
    self.recommendsArray = recommendsArray;
    [self.bannersView reloadData];
}

+ (CGSize)headerViewSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*9/16);
}

#pragma mark - <PGPagedScrollViewDelegate>

- (NSArray *)imagesForScrollView
{
    NSMutableArray *banners = [NSMutableArray new];
    for (PGImageBanner *banner in self.recommendsArray) {
        if (banner.image) {
            [banners addObject:banner.image];
        }
    }
    return [NSArray arrayWithArray:banners];
}

- (void)imageViewDidSelect:(NSInteger)index
{
    PGImageBanner *banner = self.recommendsArray[index];
    [[PGRouter sharedInstance] openURL:banner.link];
}

#pragma mark - <Setters && Getters>

- (NSArray *)recommendsArray
{
    if (!_recommendsArray) {
        _recommendsArray = [NSArray new];
    }
    return _recommendsArray;
}

- (PGPagedScrollView *)bannersView
{
    if (!_bannersView) {
        _bannersView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeDefault];
        _bannersView.delegate = self;
    }
    return _bannersView;
}

@end
