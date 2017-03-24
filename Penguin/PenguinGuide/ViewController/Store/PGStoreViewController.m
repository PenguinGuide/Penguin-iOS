//
//  PGStoreViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define StoreScenariosCell @"StoreScenariosCell"
#define StoreFlashbuyCell @"StoreFlashbuyCell"
#define StoreSingleGoodCell @"StoreSingleGoodCell"
#define StoreGoodsCollectionCell @"StoreGoodsCollectionCell"
#define StoreGoodCell @"StoreGoodCell"
#define StoreSalesHeaderView @"StoreSalesHeaderView"
#define StoreCollectionsHeaderView @"StoreCollectionsHeaderView"
#define StoreGoodsHeaderView @"StoreGoodsHeaderView"

#import "PGStoreViewController.h"
#import "PGSearchRecommendsViewController.h"

#import "PGStoreViewModel.h"

#import "PGCollectionsCell.h"
#import "PGStoreScenarioCell.h"
#import "PGFlashbuyBannerCell.h"
#import "PGSingleGoodBannerCell.h"
#import "PGGoodsCollectionBannerCell.h"
#import "PGGoodCell.h"

#import "MSWeakTimer.h"

@interface PGStoreViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGNavigationViewDelegate>

@property (nonatomic, strong) PGNavigationView *navigationView;
@property (nonatomic, strong) PGStoreViewModel *viewModel;
@property (nonatomic, strong) PGBaseCollectionView *storeCollectionView;

@property (nonatomic, strong) NSAttributedString *scenariosLabelText;
@property (nonatomic, strong) NSAttributedString *salesLabelText;
@property (nonatomic, strong) NSAttributedString *collectionsLabelText;
@property (nonatomic, strong) NSAttributedString *goodsLabelText;

@property (nonatomic, strong) MSWeakTimer *flashbuyWeakTimer;

@end

@implementation PGStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationView = [PGNavigationView naviViewWithSearchButton];
    self.navigationView.delegate = self;
    [self.view addSubview:self.navigationView];
    
    [self.view addSubview:self.storeCollectionView];
    
    self.viewModel = [[PGStoreViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"goodsArray" block:^(id changedObject) {
        NSArray *goodsArray = changedObject;
        if (goodsArray && [goodsArray isKindOfClass:[NSArray class]]) {
            [UIView setAnimationsEnabled:NO];
            [weakself.storeCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
        }
        [weakself dismissLoading];
        [weakself.storeCollectionView endTopRefreshing];
        [weakself.storeCollectionView endBottomRefreshing];
    }];
    [self observe:self.viewModel keyPath:@"error" block:^(id changedObject) {
        NSError *error = changedObject;
        if (error && [error isKindOfClass:[NSError class]]) {
            [weakself showErrorMessage:error];
            [weakself dismissLoading];
            [weakself.storeCollectionView endTopRefreshing];
            [weakself.storeCollectionView endBottomRefreshing];
        }
    }];
    [self observeCollectionView:self.storeCollectionView endOfFeeds:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.flashbuyWeakTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1.f
                                                                  target:self
                                                                selector:@selector(flashbuyCountDown)
                                                                userInfo:nil
                                                                 repeats:YES
                                                           dispatchQueue:dispatch_get_main_queue()];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadView];
}

- (void)dealloc
{
    [self unobserve];
    
    [self.flashbuyWeakTimer invalidate];
    self.flashbuyWeakTimer = nil;
}

- (void)reloadView
{
    if (self.viewModel.scenariosArray.count == 0) {
        [self showLoading];
        [self.viewModel requestData];
    }
}

- (void)initAnalyticsKeys
{
    self.pageName = store_tab_view;
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
}

#pragma mark - <PGTabBarControllerDelegate>

- (NSString *)tabBarTitle
{
    return @"购买";
}

- (NSString *)tabBarImage
{
    return @"pg_tab_store";
}

- (NSString *)tabBarHighlightImage
{
    return @"pg_tab_store_highlight";
}

- (void)tabBarDidClicked
{
    // NOTE: these codes in viewDidLoad && viewWillLoad will not work since self.navigationController is nil for the first time
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.parentViewController.navigationItem.leftBarButtonItem = nil;
    self.parentViewController.navigationItem.titleView = nil;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.viewModel.salesArray.count;
    }
    if (section == 2) {
        return self.viewModel.collectionsArray.count;
    }
    if (section == 3) {
        return self.viewModel.goodsArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PGCollectionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StoreScenariosCell forIndexPath:indexPath];
        [cell setCellWithTitle:self.scenariosLabelText
                   collections:self.viewModel.scenariosArray
                     cellClass:[PGStoreScenarioCell class]
                        config:^(PGCollectionsCellConfig *config) {
                            config.titleHeight = 60.f;
                            config.minimumLineSpacing = 20.f;
                            config.insets = UIEdgeInsetsMake(0, 22.f, 0.f, 22.f);
                            config.collectionCellSize = [PGStoreScenarioCell cellSize];
                            config.showBorder = NO;
                        }];
        return cell;
    }
    if (indexPath.section == 1) {
        id banner = self.viewModel.salesArray[indexPath.item];
        if ([banner isKindOfClass:[PGFlashbuyBanner class]]) {
            PGFlashbuyBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StoreFlashbuyCell forIndexPath:indexPath];
            if ([cell respondsToSelector:@selector(setCellWithModel:)]) {
                [cell setCellWithModel:banner];
            }
            [cell countdown:(PGFlashbuyBanner *)banner];
            return cell;
        } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
            PGSingleGoodBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StoreSingleGoodCell forIndexPath:indexPath];
            if ([cell respondsToSelector:@selector(setCellWithModel:)]) {
                [cell setCellWithModel:banner];
            }
            return cell;
        }
    }
    if (indexPath.section == 2) {
        PGGoodsCollectionBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StoreGoodsCollectionCell forIndexPath:indexPath];
        if ([cell respondsToSelector:@selector(setCellWithModel:)]) {
            [cell setCellWithModel:self.viewModel.collectionsArray[indexPath.item]];
        }
        return cell;
    }
    if (indexPath.section == 3) {
        if (self.viewModel.goodsArray.count-indexPath.item == 2) {
            PGWeakSelf(self);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakself.viewModel requestGoods];
            });
        }
        PGGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StoreGoodCell forIndexPath:indexPath];
        if ([cell respondsToSelector:@selector(setCellWithModel:)]) {
            [cell setCellWithModel:self.viewModel.goodsArray[indexPath.item]];
        }
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 1) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:StoreSalesHeaderView forIndexPath:indexPath];
            
            [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 60)];
            label.attributedText = self.salesLabelText;
            label.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:label];
            
            return headerView;
        }
        if (indexPath.section == 2) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:StoreCollectionsHeaderView forIndexPath:indexPath];
            
            [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 60)];
            label.attributedText = self.collectionsLabelText;
            label.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:label];
            
            return headerView;
        }
        if (indexPath.section == 3) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:StoreGoodsHeaderView forIndexPath:indexPath];
            
            [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 60)];
            label.attributedText = self.goodsLabelText;
            label.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:label];
            
            return headerView;
        }
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 3) {
            PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
            
            return footerView;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(UISCREEN_WIDTH, 60+[PGStoreScenarioCell cellSize].height);
    }
    if (indexPath.section == 1) {
        id banner = self.viewModel.salesArray[indexPath.item];
        if ([banner isKindOfClass:[PGFlashbuyBanner class]]) {
            return [PGFlashbuyBannerCell cellSize];
        } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
            return [PGSingleGoodBannerCell cellSize];
        }
    }
    if (indexPath.section == 2) {
        id banner = self.viewModel.collectionsArray[indexPath.item];
        if ([banner isKindOfClass:[PGGoodsCollectionBanner class]]) {
            return [PGGoodsCollectionBannerCell cellSize];
        }
    }
    if (indexPath.section == 3) {
        id banner = self.viewModel.goodsArray[indexPath.item];
        if ([banner isKindOfClass:[PGGood class]]) {
            return [PGGoodCell cellSize];
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.viewModel.salesArray.count > 0) {
            return CGSizeMake(UISCREEN_WIDTH, 60.f);
        }
    }
    if (section == 2) {
        if (self.viewModel.collectionsArray.count > 0) {
            return CGSizeMake(UISCREEN_WIDTH, 60.f);
        }
    }
    if (section == 3) {
        if (self.viewModel.goodsArray.count > 0) {
            return CGSizeMake(UISCREEN_WIDTH, 60.f);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        if (!self.viewModel) {
            return CGSizeZero;
        }
        if (self.viewModel.endFlag) {
            return [PGBaseCollectionViewFooterView footerViewSize];
        }
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 15, 0);
    }
    if (section == 1) {
        return UIEdgeInsetsMake(0, 0, 15, 0);
    }
    if (section == 2) {
        return UIEdgeInsetsMake(0, 0, 15, 0);
    }
    if (section == 3) {
        return UIEdgeInsetsMake(0, 22.f, 0, 22.f);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 3) {
        return 20.f;
    }
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return 22.f;
    }
    if (section == 2) {
        return 22.f;
    }
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if ([cell isKindOfClass:[PGBaseCollectionViewCell class]]) {
            [(PGBaseCollectionViewCell *)cell insertCellBorderLayer:8.f];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<PGBaseCollectionViewCell> selectedCell = (id<PGBaseCollectionViewCell>)[collectionView cellForItemAtIndexPath:indexPath];
    if ([selectedCell respondsToSelector:@selector(cellDidSelectWithModel:)]) {
        if (indexPath.section == 1) {
            [selectedCell cellDidSelectWithModel:self.viewModel.salesArray[indexPath.item]];
        }
        if (indexPath.section == 3) {
            [selectedCell cellDidSelectWithModel:self.viewModel.goodsArray[indexPath.item]];
        }
    }
}

#pragma mark - <PGNavigationViewDelegate>

- (void)searchButtonClicked
{
    PGSearchRecommendsViewController *searchRecommendsVC = [[PGSearchRecommendsViewController alloc] init];
    PGBaseNavigationController *naviController = [[PGBaseNavigationController alloc] initWithRootViewController:searchRecommendsVC];
    PGGlobal.tempNavigationController = naviController;
    [self presentViewController:naviController animated:NO completion:nil];
}

#pragma mark - <Timer>

- (void)flashbuyCountDown
{
    for (UICollectionViewCell *visibleCell in self.storeCollectionView.visibleCells) {
        if ([visibleCell isKindOfClass:[PGFlashbuyBannerCell class]]) {
            PGFlashbuyBannerCell *cell = (PGFlashbuyBannerCell *)visibleCell;
            NSInteger index = [[self.storeCollectionView indexPathForCell:cell] item];
            if (index < self.viewModel.salesArray.count) {
                PGFlashbuyBanner *flashbuyBanner = self.viewModel.salesArray[index];
                if (flashbuyBanner && [flashbuyBanner isKindOfClass:[PGFlashbuyBanner class]] && cell) {
                    [cell countdown:flashbuyBanner];
                }
            }
        }
    }
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)storeCollectionView
{
    if (!_storeCollectionView) {
        _storeCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 64, UISCREEN_WIDTH, UISCREEN_HEIGHT-64-50) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _storeCollectionView.dataSource = self;
        _storeCollectionView.delegate = self;
        
        [_storeCollectionView registerClass:[PGCollectionsCell class] forCellWithReuseIdentifier:StoreScenariosCell];
        [_storeCollectionView registerClass:[PGFlashbuyBannerCell class] forCellWithReuseIdentifier:StoreFlashbuyCell];
        [_storeCollectionView registerClass:[PGSingleGoodBannerCell class] forCellWithReuseIdentifier:StoreSingleGoodCell];
        [_storeCollectionView registerClass:[PGGoodsCollectionBannerCell class] forCellWithReuseIdentifier:StoreGoodsCollectionCell];
        [_storeCollectionView registerClass:[PGGoodCell class] forCellWithReuseIdentifier:StoreGoodCell];
        [_storeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:StoreSalesHeaderView];
        [_storeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:StoreCollectionsHeaderView];
        [_storeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:StoreGoodsHeaderView];
        
        PGWeakSelf(self);
        [_storeCollectionView enablePullToRefreshWithTopInset:0.f completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.viewModel clearPagination];
                [weakself.viewModel requestData];
            });
        }];
        [_storeCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestGoods];
        }];
    }
    return _storeCollectionView;
}

- (NSAttributedString *)scenariosLabelText
{
    if (!_scenariosLabelText) {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:@"品类 · PENGUIN SCENARIOS"];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, 5)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, 5)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeLight range:NSMakeRange(5, 17)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(5, 17)];
        
        _scenariosLabelText = [[NSAttributedString alloc] initWithAttributedString:attrS];
    }
    return _scenariosLabelText;
}

- (NSAttributedString *)salesLabelText
{
    if (!_salesLabelText) {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:@"本周热卖 · PENGUIN SALES"];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, 7)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, 7)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeLight range:NSMakeRange(7, 13)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(7, 13)];
        
        _salesLabelText = [[NSAttributedString alloc] initWithAttributedString:attrS];
    }
    return _salesLabelText;
}

- (NSAttributedString *)collectionsLabelText
{
    if (!_collectionsLabelText) {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:@"精选集合 · PENGUIN COLLECTIONS"];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, 7)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, 7)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeLight range:NSMakeRange(7, 19)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(7, 19)];
        
        _collectionsLabelText = [[NSAttributedString alloc] initWithAttributedString:attrS];
    }
    return _collectionsLabelText;
}

- (NSAttributedString *)goodsLabelText
{
    if (!_goodsLabelText) {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:@"商品 · PENGUIN GOODS"];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, 5)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, 5)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeLight range:NSMakeRange(5, 13)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(5, 13)];
        
        _goodsLabelText = [[NSAttributedString alloc] initWithAttributedString:attrS];
    }
    return _goodsLabelText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
