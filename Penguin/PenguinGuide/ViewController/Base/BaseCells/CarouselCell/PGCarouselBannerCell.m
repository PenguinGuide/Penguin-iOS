//
//  PGPagedBannersCell.m
//  Penguin
//
//  Created by Jing Dai on 7/10/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCarouselBannerCell.h"
#import "PGImageBanner.h"

@interface PGCarouselBannerCell () <PGPagedScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong, readwrite) PGPagedScrollView *bannersView;

@end

@implementation PGCarouselBannerCell

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
    [self.contentView addSubview:self.bannersView];
}

- (void)reloadBannersWithData:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    [self.bannersView reloadData];
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*9/16);
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

#pragma mark - <Setters && Getters>

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
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
