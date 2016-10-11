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

@interface PGGoodViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *goodCollectionView;
@property (nonatomic, strong) UIView *bottomToolBar;

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
    [self.view addSubview:self.bottomToolBar];
    
    self.viewModel = [[PGGoodViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"good" block:^(id changedObject) {
        PGGood *good = changedObject;
        if (good && [good isKindOfClass:[PGGood class]]) {
            [weakself.goodCollectionView reloadData];
        }
    }];
    
    [self observe:self.viewModel keyPath:@"relatedGoods" block:^(id changedObject) {
        NSArray *relatedGoods = changedObject;
        if (relatedGoods && [relatedGoods isKindOfClass:[NSArray class]]) {
            [weakself.goodCollectionView reloadData];
            [weakself.goodCollectionView endBottomRefreshing];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    [self unobserve];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModel.relatedGoods.count > 0 ? 2 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        return self.viewModel.relatedGoods.count;
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
        } else if (indexPath.item == 4) {
            PGArticleRelatedArticlesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodRelatedArticlesCell forIndexPath:indexPath];
            
            [cell setCellWithDataArray:self.viewModel.good.relatedArticlesArray];
            
            return cell;
        }
    } else if (indexPath.section == 1) {
        PGGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodRelatedGoodCell forIndexPath:indexPath];
        
        [cell setCellWithGood:self.viewModel.relatedGoods[indexPath.item]];
        
        return cell;
    }
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && kind == UICollectionElementKindSectionHeader) {
        PGGoodRelatedGoodsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:GoodRelatedGoodHeaderView forIndexPath:indexPath];
        
        return headerView;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsZero;
    } else if (section == 1) {
        return UIEdgeInsetsMake(10, 8, 10, 8);
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
        } else if (indexPath.item == 4) {
            return self.viewModel.good.relatedArticlesArray.count > 0 ? [PGArticleRelatedArticlesCell cellSize] : CGSizeZero;
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return 10.f;
    }
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return 11.f;
    }
    return 0.f;
}

#pragma mark - <Button Events>

- (void)buyButtonClicked
{
    [PGAlibcTraderManager openGoodDetailPage:@"536212841769" native:NO];
}

#pragma mark - <Setters && Getters>

- (PGBaseCollectionView *)goodCollectionView
{
    if (!_goodCollectionView) {
        _goodCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _goodCollectionView.dataSource = self;
        _goodCollectionView.delegate = self;
        
        [_goodCollectionView registerClass:[PGGoodBannersCell class] forCellWithReuseIdentifier:GoodBannersCell];
        [_goodCollectionView registerClass:[PGGoodInfoCell class] forCellWithReuseIdentifier:GoodInfoCell];
        [_goodCollectionView registerClass:[PGGoodDescCell class] forCellWithReuseIdentifier:GoodDescCell];
        [_goodCollectionView registerClass:[PGGoodTagsCell class] forCellWithReuseIdentifier:GoodTagsCell];
        [_goodCollectionView registerClass:[PGArticleRelatedArticlesCell class] forCellWithReuseIdentifier:GoodRelatedArticlesCell];
        [_goodCollectionView registerClass:[PGGoodCell class] forCellWithReuseIdentifier:GoodRelatedGoodCell];
        
        [_goodCollectionView registerClass:[PGGoodRelatedGoodsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GoodRelatedGoodHeaderView];
        
        PGWeakSelf(self);
        [_goodCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestRelatedGoods];
        }];
    }
    return _goodCollectionView;
}

- (UIView *)bottomToolBar
{
    if (!_bottomToolBar) {
        _bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT-44, UISCREEN_WIDTH, 44)];
        _bottomToolBar.backgroundColor = [UIColor whiteColor];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
        horizontalLine.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
        [_bottomToolBar addSubview:horizontalLine];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [backButton setImage:[UIImage imageNamed:@"pg_login_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolBar addSubview:backButton];
        
        UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-100, 0, 100, 44)];
        [buyButton addTarget:self action:@selector(buyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buyButton setBackgroundColor:[UIColor colorWithHexString:@"EF6733"]];
        [buyButton setTitle:@"前往购买" forState:UIControlStateNormal];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyButton.titleLabel setFont:Theme.fontMediumBold];
        [_bottomToolBar addSubview:buyButton];
        
        UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(buyButton.pg_left-60, 0, 44, 44)];
        [collectButton setImage:[UIImage imageNamed:@"pg_article_collect"] forState:UIControlStateNormal];
        [_bottomToolBar addSubview:collectButton];
        
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(collectButton.pg_left-44, 0, 44, 44)];
        [shareButton setImage:[UIImage imageNamed:@"pg_article_share"] forState:UIControlStateNormal];
        [_bottomToolBar addSubview:shareButton];
    }
    return _bottomToolBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end