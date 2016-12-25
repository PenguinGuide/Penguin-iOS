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
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
    maskImageView.image = [[UIImage imageNamed:@"pg_bg_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
    [self.contentView addSubview:maskImageView];
}

- (void)reloadBannersWithFlashbuy:(PGFlashbuyBanner *)flashbuy
{
    self.flashbuy = flashbuy;
    NSMutableArray *views = [NSMutableArray new];
    for (PGGood *good in flashbuy.goodsArray) {
        PGFlashbuyGoodView *flashbuyGoodView = [[PGFlashbuyGoodView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
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
    return CGSizeMake(UISCREEN_WIDTH-40, (UISCREEN_WIDTH-40)*150/300);
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
        _bannersView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeLight];
        _bannersView.delegate = self;
    }
    return _bannersView;
}

@end
