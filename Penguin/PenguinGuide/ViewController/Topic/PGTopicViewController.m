//
//  PGTopicViewController.m
//  Penguin
//
//  Created by Jing Dai on 9/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define InfoHeaderView @"InfoHeaderView"
#define ArticleHeaderView @"ArticleHeaderView"
#define GoodHeaderView @"GoodHeaderView"
#define ArticleCell @"ArticleCell"
#define GoodCell @"GoodCell"

#import "PGTopicViewController.h"
#import "UIScrollView+PGScrollView.h"

#import "PGTopicViewModel.h"

#import "PGArticleBannerCell.h"
#import "PGGoodCell.h"
#import "PGTopicInfoHeaderView.h"
#import "PGTopicHeaderView.h"

@interface PGTopicViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGTopicViewModel *viewModel;
@property (nonatomic, strong) NSString *topicId;

@property (nonatomic, strong) PGBaseCollectionView *topicCollectionView;

@end

@implementation PGTopicViewController

- (id)initWithTopicId:(NSString *)topicId
{
    if (self = [super init]) {
        self.topicId = topicId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.topicCollectionView];
    
    self.viewModel = [[PGTopicViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"topic" block:^(id changedObject) {
        PGTopic *topic = changedObject;
        if (topic && [topic isKindOfClass:[PGTopic class]]) {
            [weakself.topicCollectionView reloadData];
            [weakself setNavigationTitle:weakself.viewModel.topic.title];
        }
        [weakself dismissLoading];
    }];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (self.viewModel.topic == nil) {
        [self showLoading];
        [self.viewModel requestTopic:self.topicId];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [self unobserve];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (!self.viewModel.topic) {
        return 0;
    }
    if (self.viewModel.topic.articlesArray.count > 0 && self.viewModel.topic.goodsArray.count > 0) {
        return 3;
    } else if (self.viewModel.topic.articlesArray.count == 0 && self.viewModel.topic.goodsArray.count == 0) {
        return 1;
    } else if (self.viewModel.topic.articlesArray.count == 0 && self.viewModel.topic.goodsArray.count > 0) {
        return 2;
    } else if (self.viewModel.topic.articlesArray.count > 0 && self.viewModel.topic.goodsArray.count == 0) {
        return 2;
    } else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        if (self.viewModel.topic.articlesArray.count > 0) {
            return self.viewModel.topic.articlesArray.count;
        } else if (self.viewModel.topic.goodsArray.count > 0) {
            return self.viewModel.topic.goodsArray.count;
        } else {
            return 0;
        }
    } else if (section == 2) {
        return self.viewModel.topic.goodsArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.viewModel.topic.articlesArray.count > 0) {
            PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCell forIndexPath:indexPath];
            [cell setCellWithArticle:self.viewModel.topic.articlesArray[indexPath.item] allowGesture:YES];
            
            return cell;
        } else if (self.viewModel.topic.goodsArray.count > 0) {
            PGGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
            [cell setCellWithGood:self.viewModel.topic.goodsArray[indexPath.item]];
            
            return cell;
        }
    } else if (indexPath.section == 2) {
        PGGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
        [cell setGrayBackgroundCellWithGood:self.viewModel.topic.goodsArray[indexPath.item]];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.viewModel.topic.articlesArray.count > 0) {
            return [PGArticleBannerCell cellSize];
        } else if (self.viewModel.topic.goodsArray.count > 0) {
            return [PGGoodCell cellSize];
        }
    } else if (indexPath.section == 2) {
        return [PGGoodCell cellSize];
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [PGTopicInfoHeaderView headerViewSize:self.viewModel.topic.desc];
    } else if (section == 1) {
        return CGSizeMake(UISCREEN_WIDTH, 45);
    } else if (section == 2) {
        return CGSizeMake(UISCREEN_WIDTH, 45);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        if (self.viewModel.topic.articlesArray.count > 0) {
            return 0.f;
        } else if (self.viewModel.topic.goodsArray.count > 0) {
            return 10.f;
        }
    } else if (section == 2) {
        return 10.f;
    }
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        if (self.viewModel.topic.goodsArray.count > 0) {
            return 0.f;
        }
    } else if (section == 2) {
        return 10.f;
    }
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        if (self.viewModel.topic.goodsArray.count > 0) {
            return UIEdgeInsetsMake(10, 8, 10, 8);
        }
    } else if (section == 2) {
        return UIEdgeInsetsMake(10, 8, 10, 8);;
    }
    return UIEdgeInsetsZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            PGTopicInfoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:InfoHeaderView forIndexPath:indexPath];
            [headerView setHeaderViewWithImage:self.viewModel.topic.image desc:self.viewModel.topic.desc];
            
            return headerView;
        } else if (indexPath.section == 1) {
            if (self.viewModel.topic.articlesArray.count > 0) {
                PGTopicHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ArticleHeaderView forIndexPath:indexPath];
                [headerView setHeaderViewWithTitle:@"推文"];
                
                return headerView;
            } else if (self.viewModel.topic.goodsArray.count > 0) {
                PGTopicHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ArticleHeaderView forIndexPath:indexPath];
                [headerView setHeaderViewWithTitle:@"商品"];
                
                return headerView;
            }
        } else if (indexPath.section == 2) {
            PGTopicHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ArticleHeaderView forIndexPath:indexPath];
            [headerView setHeaderViewWithTitle:@"商品"];
            
            return headerView;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.viewModel.topic.articlesArray.count > 0) {
            PGArticleBanner *articleBanner = self.viewModel.topic.articlesArray[indexPath.item];
            [PGRouterManager routeToArticlePage:articleBanner.articleId link:articleBanner.link];
        } else if (self.viewModel.topic.goodsArray.count > 0) {
            PGGood *good = self.viewModel.topic.goodsArray[indexPath.item];
            [PGRouterManager routeToGoodDetailPage:good.goodId link:good.link];
        }
    } else if (indexPath.section == 2) {
        PGGood *good = self.viewModel.topic.goodsArray[indexPath.item];
        [PGRouterManager routeToGoodDetailPage:good.goodId link:good.link];
    }
}

- (PGBaseCollectionView *)topicCollectionView
{
    if (!_topicCollectionView) {
        _topicCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _topicCollectionView.dataSource = self;
        _topicCollectionView.delegate = self;
        
        [_topicCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleCell];
        [_topicCollectionView registerClass:[PGGoodCell class] forCellWithReuseIdentifier:GoodCell];
        
        [_topicCollectionView registerClass:[PGTopicInfoHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:InfoHeaderView];
        [_topicCollectionView registerClass:[PGTopicHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ArticleHeaderView];
        [_topicCollectionView registerClass:[PGTopicHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GoodHeaderView];
    }
    return _topicCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
