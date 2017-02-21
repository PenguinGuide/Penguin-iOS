//
//  PGHistoryViewController.m
//  Penguin
//
//  Created by Jing Dai on 31/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define HistoryCell @"HistoryCell"

#import "PGHistoryViewController.h"
#import "PGHistoryViewModel.h"
#import "PGHistoryCell.h"

@interface PGHistoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *historyCollectionView;
@property (nonatomic, strong) PGHistoryViewModel *viewModel;

@end

@implementation PGHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.historyCollectionView];
    
    [self setNavigationTitle:@"我的足迹"];
    
    self.viewModel = [[PGHistoryViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"histories" block:^(id changedObject) {
        NSArray *histories = changedObject;
        if (histories && [histories isKindOfClass:[NSArray class]]) {
            [UIView setAnimationsEnabled:NO];
            [weakself.historyCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
        }
        if (histories && [histories isKindOfClass:[NSArray class]]) {
            if (histories.count == 0 && !weakself.viewModel.endFlag) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself showPlaceholder:@"pg_history_placeholder" desc:@"还没有给文章评论，赶紧去吧"];
                });
            }
        }
        [weakself dismissLoading];
        [weakself.historyCollectionView endBottomRefreshing];
    }];
    [self observeCollectionView:self.historyCollectionView endOfFeeds:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadView];
}

- (void)dealloc
{
    [self unobserve];
}

- (void)reloadView
{
    if (self.viewModel.histories.count == 0 && !self.viewModel.endFlag) {
        [self showLoading];
        [self.viewModel requestData];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.histories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HistoryCell forIndexPath:indexPath];
    
    PGHistory *history = self.viewModel.histories[indexPath.item];
    [cell setCellWithHistory:history];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGHistory *history = self.viewModel.histories[indexPath.item];
    return [PGHistoryCell cellSize:history];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (!self.viewModel) {
        return CGSizeZero;
    }
    if (self.viewModel.endFlag && self.viewModel.histories.count != 0) {
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
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
        return footerView;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGHistory *history = self.viewModel.histories[indexPath.item];
    
    [PGRouterManager routeToArticlePage:history.content.articleId link:history.content.link];
}

- (PGBaseCollectionView *)historyCollectionView
{
    if (!_historyCollectionView) {
        _historyCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _historyCollectionView.dataSource = self;
        _historyCollectionView.delegate = self;
        
        [_historyCollectionView registerClass:[PGHistoryCell class] forCellWithReuseIdentifier:HistoryCell];
        
        PGWeakSelf(self);
        [_historyCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestData];
        }];
    }
    return _historyCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
