//
//  PGFlashbuyBannerCell.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGFlashbuyBannerCell.h"
#import "PGFlashbuyGoodView.h"
#import "PGGood.h"

@interface PGFlashbuyBannerCell () <PGPagedScrollViewDelegate>

@property (nonatomic, strong) NSArray *viewsArray;
@property (nonatomic, strong) PGFlashbuyBanner *flashbuy;
@property (nonatomic, strong, readwrite) PGPagedScrollView *bannersView;

@end

@implementation PGFlashbuyBannerCell

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
    
    [self.contentView addSubview:self.bannersView];
}

- (void)setCellWithModel:(PGRKModel *)model
{
    self.flashbuy = (PGFlashbuyBanner *)model;
    NSMutableArray *views = [NSMutableArray new];
    for (PGGood *good in self.flashbuy.goodsArray) {
        PGFlashbuyGoodView *flashbuyGoodView = [[PGFlashbuyGoodView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
        flashbuyGoodView.eventName = flashbuy_banner_good_clicked;
        flashbuyGoodView.eventId = good.goodId;
        flashbuyGoodView.pageName = self.pageName;
        
        [flashbuyGoodView setViewWithGood:good];
        [views addObject:flashbuyGoodView];
    }
    self.viewsArray = [NSArray arrayWithArray:views];
    [self.bannersView reloadData];
}

- (void)reloadBannersWithFlashbuy:(PGFlashbuyBanner *)flashbuy
{
    self.flashbuy = flashbuy;
    NSMutableArray *views = [NSMutableArray new];
    for (PGGood *good in flashbuy.goodsArray) {
        PGFlashbuyGoodView *flashbuyGoodView = [[PGFlashbuyGoodView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
        flashbuyGoodView.eventName = flashbuy_banner_good_clicked;
        flashbuyGoodView.eventId = good.goodId;
        flashbuyGoodView.pageName = self.pageName;
        
        [flashbuyGoodView setViewWithGood:good];
        [views addObject:flashbuyGoodView];
    }
    self.viewsArray = [NSArray arrayWithArray:views];
    [self.bannersView reloadData];
}

- (void)countdown:(PGFlashbuyBanner *)flashbuy
{
    for (int i = 0; i < flashbuy.goodsArray.count; i++) {
        if (i < self.viewsArray.count) {
            PGGood *good = flashbuy.goodsArray[i];
            PGFlashbuyGoodView *view = self.viewsArray[i];
            NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:[good.startTime doubleValue]];
            NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:[good.endTime doubleValue]];
            [view setCountDown:startDate endDate:endDate];
        } else {
            break;
        }
    }
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH-44, (UISCREEN_WIDTH-44)*150/300);
}

#pragma mark - <PGPagedScrollViewDelegate>

- (NSArray *)viewsForScrollView
{
    return self.viewsArray;
}

- (void)imageViewDidSelect:(NSInteger)index
{
    PGGood *good = self.flashbuy.goodsArray[index];
    [[PGRouter sharedInstance] openURL:good.link];
}

#pragma mark - <Setters && Getters>

- (PGPagedScrollView *)bannersView
{
    if (!_bannersView) {
        _bannersView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeLabel];
        _bannersView.delegate = self;
    }
    return _bannersView;
}

@end
