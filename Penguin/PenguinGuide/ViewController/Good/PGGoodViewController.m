//
//  PGGoodViewController.m
//  Penguin
//
//  Created by Jing Dai on 27/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define GoodBannersCell @"GoodBannersCell"
#define GoodInfoCell @"GoodInfoCell"
#define GoodDescCell @"GoodDescCell"
#define GoodTagsCell @"GoodTagsCell"
#define GoodRelatedArticlesCell @"GoodRelatedArticlesCell"
#define GoodRelatedGoodCell @"GoodRelatedGoodCell"
#define GoodRelatedGoodHeaderView @"GoodRelatedGoodHeaderView"

#import "PGGoodViewController.h"

#import "PGGoodViewModel.h"

#import "PGGoodBannersCell.h"
#import "PGGoodInfoCell.h"
#import "PGGoodDescCell.h"
#import "PGGoodTagsCell.h"
#import "PGArticleRelatedArticlesCell.h"
#import "PGGoodCell.h"
#import "PGGoodRelatedGoodsHeaderView.h"
#import "PGNavigationView.h"

#import "PGSegmentedButtonsControl.h"

@interface PGGoodViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGNavigationViewDelegate>

@property (nonatomic, strong) PGNavigationView *naviView;
@property (nonatomic, strong) PGBaseCollectionView *goodCollectionView;
@property (nonatomic, strong) PGSegmentedButtonsControl *segmentedButtonsControl;

@property (nonatomic, strong) NSString *goodId;
@property (nonatomic, strong) PGGoodViewModel *viewModel;

@end

@implementation PGGoodViewController

- (id)initWithGoodId:(NSString *)goodId
{
    if (self = [super init]) {
        self.goodId = goodId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.goodCollectionView];
    [self.view addSubview:self.segmentedButtonsControl];
    
    self.viewModel = [[PGGoodViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"good" block:^(id changedObject) {
        PGGood *good = changedObject;
        if (good && [good isKindOfClass:[PGGood class]]) {
            if (!weakself.naviView.superview) {
                weakself.naviView = [PGNavigationView naviViewWithBackButton:good.name];
                weakself.naviView.delegate = weakself;
                [weakself.view addSubview:weakself.naviView];
            }
            [weakself.goodCollectionView reloadData];
        }
        [weakself dismissLoading];
    }];
    
    [self observeError:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self reloadView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [self unobserve];
}

- (void)reloadView
{
    if (!self.viewModel.good) {
        [self showLoading];
        [self.viewModel requestGood:self.goodId];
    }
}

- (void)initAnalyticsKeys
{
    self.pageName = good_view;
    self.pageId = self.goodId;
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModel.good.relatedGoods.count > 0 ? 2 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return self.viewModel.good.relatedGoods.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            PGGoodBannersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodBannersCell forIndexPath:indexPath];
            
            [cell reloadCellWithBanners:self.viewModel.good.bannersArray];
            
            return cell;
        } else if (indexPath.item == 1) {
            PGGoodInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodInfoCell forIndexPath:indexPath];
            
            [cell setCellWithGood:self.viewModel.good];
            
            return cell;
        } else if (indexPath.item == 2) {
            PGGoodDescCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodDescCell forIndexPath:indexPath];
            
            [cell setCellWithDesc:self.viewModel.good.desc];
            
            return cell;
        } else if (indexPath.item == 3) {
            PGGoodTagsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodTagsCell forIndexPath:indexPath];
            
            [cell reloadWithTagsArray:self.viewModel.good.tagsArray];
            
            return cell;
        }
    } else if (indexPath.section == 1) {
        PGGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodRelatedGoodCell forIndexPath:indexPath];
        
        PGGood *good = self.viewModel.good.relatedGoods[indexPath.item];
        cell.eventName = good_banner_clicked;
        cell.eventId = good.goodId;
        cell.pageName = good_view;
        
        [cell setGrayBackgroundCellWithGood:good];
        
        return cell;
    }
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (kind == UICollectionElementKindSectionHeader) {
            PGGoodRelatedGoodsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:GoodRelatedGoodHeaderView forIndexPath:indexPath];
            
            return headerView;
        } else if (kind == UICollectionElementKindSectionFooter) {
            PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
            
            return footerView;
        }
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsZero;
    } else if (section == 1) {
        return UIEdgeInsetsMake(15.f, 22.f, 0, 22.f);
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            return [PGGoodBannersCell cellSize];
        } else if (indexPath.item == 1) {
            return [PGGoodInfoCell cellSize:self.viewModel.good];
        } else if (indexPath.item == 2) {
            return [PGGoodDescCell cellSize:self.viewModel.good.desc];
        } else if (indexPath.item == 3) {
            return self.viewModel.good.tagsArray.count > 0 ? CGSizeMake(UISCREEN_WIDTH, 45) : CGSizeZero;
        }
    } else if (indexPath.section == 1) {
        return [PGGoodCell cellSize];
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(UISCREEN_WIDTH, 40);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return [PGBaseCollectionViewFooterView footerViewSize];
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return 20.f;
    }
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.good.relatedGoods.count > 0 && indexPath.section == 1) {
        PGGood *good = self.viewModel.good.relatedGoods[indexPath.item];
        [PGRouterManager routeToGoodDetailPage:good.goodId link:good.link];
    }
}

#pragma mark - <PGNavigationViewDelegate>

- (void)naviBackButtonClicked
{
    [super backButtonClicked];
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)goodCollectionView
{
    if (!_goodCollectionView) {
        _goodCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 64, UISCREEN_WIDTH, UISCREEN_HEIGHT-64) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _goodCollectionView.dataSource = self;
        _goodCollectionView.delegate = self;
        
        [_goodCollectionView registerClass:[PGGoodBannersCell class] forCellWithReuseIdentifier:GoodBannersCell];
        [_goodCollectionView registerClass:[PGGoodInfoCell class] forCellWithReuseIdentifier:GoodInfoCell];
        [_goodCollectionView registerClass:[PGGoodDescCell class] forCellWithReuseIdentifier:GoodDescCell];
        [_goodCollectionView registerClass:[PGGoodTagsCell class] forCellWithReuseIdentifier:GoodTagsCell];
        [_goodCollectionView registerClass:[PGArticleRelatedArticlesCell class] forCellWithReuseIdentifier:GoodRelatedArticlesCell];
        [_goodCollectionView registerClass:[PGGoodCell class] forCellWithReuseIdentifier:GoodRelatedGoodCell];
        
        [_goodCollectionView registerClass:[PGGoodRelatedGoodsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GoodRelatedGoodHeaderView];
    }
    return _goodCollectionView;
}

- (PGSegmentedButtonsControl *)segmentedButtonsControl
{
    if (!_segmentedButtonsControl) {
        _segmentedButtonsControl = [PGSegmentedButtonsControl segmentedButtonsControlWithTitles:@[@"立即购买", @"购物车"] images:@[[UIImage imageNamed:@"pg_good_buy"], [UIImage imageNamed:@"pg_good_cart"]] segmentedButtonSize:CGSizeMake(70, 48)];
        PGWeakSelf(self);
        [_segmentedButtonsControl setIndexClickedBlock:^(NSInteger index) {
            if (index == 0) {
                [PGAlibcTraderManager openGoodDetailPage:weakself.viewModel.good.goodTaobaoId native:NO];
            } else if (index == 1) {
                [PGAlibcTraderManager openMyShoppingCartPageWithNative:YES];
            }
        }];
    }
    return _segmentedButtonsControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
