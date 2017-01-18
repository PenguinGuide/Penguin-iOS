//
//  PGGoodBannersCell.m
//  Penguin
//
//  Created by Jing Dai on 29/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGoodBannersCell.h"
#import "PGImageBanner.h"

@interface PGGoodBannersCell () <PGPagedScrollViewDelegate>

@property (nonatomic, strong, readwrite) PGPagedScrollView *pagedScrollView;
@property (nonatomic, strong) NSArray *bannersArray;

@end

@implementation PGGoodBannersCell

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
    [self.contentView addSubview:self.pagedScrollView];
}

- (void)reloadCellWithBanners:(NSArray *)banners
{
    self.bannersArray = banners;
    
    [self.pagedScrollView reloadData];
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*2/3);
}

#pragma mark - <PGPagedScrollViewDelegate>

- (NSArray *)imagesForScrollView
{
    NSMutableArray *banners = [NSMutableArray new];
    for (NSString *banner in self.bannersArray) {
        [banners addObject:banner];
    }
    return [NSArray arrayWithArray:banners];
}

- (PGPagedScrollView *)pagedScrollView
{
    if (!_pagedScrollView) {
        _pagedScrollView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*2/3) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeLight];
        _pagedScrollView.delegate = self;
    }
    return _pagedScrollView;
}

@end
