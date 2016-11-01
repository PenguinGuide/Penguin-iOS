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
            [weakself.historyCollectionView reloadData];
        }
        [weakself dismissLoading];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (self.viewModel.histories.count == 0) {
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

- (PGBaseCollectionView *)historyCollectionView
{
    if (!_historyCollectionView) {
        _historyCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _historyCollectionView.dataSource = self;
        _historyCollectionView.delegate = self;
        
        [_historyCollectionView registerClass:[PGHistoryCell class] forCellWithReuseIdentifier:HistoryCell];
    }
    return _historyCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
