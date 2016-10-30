//
//  PGCollectionsViewController.m
//  Penguin
//
//  Created by Jing Dai on 28/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CollectionCell @"CollectionCell"

#import "PGCollectionsViewController.h"
#import "PGCollectionsContentViewController.h"
#import "PGCollectionViewModel.h"
#import "PGCollectionCell.h"

@interface PGCollectionsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *collectionsCollectionView;

@property (nonatomic, strong) PGCollectionViewModel *viewModel;

@end

@implementation PGCollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"我的收藏"];
    
    [self.view addSubview:self.collectionsCollectionView];
    
    self.viewModel = [[PGCollectionViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"collections" block:^(id changedObject) {
        NSArray *collections = changedObject;
        if (collections && [collections isKindOfClass:[NSArray class]]) {
            [weakself.collectionsCollectionView reloadData];
        }
        [weakself dismissLoading];
    }];
    [self observeError:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (self.viewModel.collections.count == 0) {
        [self showLoading];
        [self.viewModel requestData];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.collections.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCell forIndexPath:indexPath];
    
    PGCollection *collection = self.viewModel.collections[indexPath.item];
    
    [cell setCellWithIcon:collection.icon desc:collection.name count:collection.count];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(UISCREEN_WIDTH, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGCollection *collection = self.viewModel.collections[indexPath.item];
    PGCollectionsContentViewController *collectionsContentVC = [[PGCollectionsContentViewController alloc] initWithCollection:collection];
    [self.navigationController pushViewController:collectionsContentVC animated:YES];
}

- (PGBaseCollectionView *)collectionsCollectionView
{
    if (!_collectionsCollectionView) {
        _collectionsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionsCollectionView.dataSource = self;
        _collectionsCollectionView.delegate = self;
        
        [_collectionsCollectionView registerClass:[PGCollectionCell class] forCellWithReuseIdentifier:CollectionCell];
    }
    return _collectionsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
