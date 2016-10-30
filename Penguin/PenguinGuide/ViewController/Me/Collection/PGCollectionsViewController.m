//
//  PGCollectionsViewController.m
//  Penguin
//
//  Created by Jing Dai on 28/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CollectionCell @"CollectionCell"

#import "PGCollectionsViewController.h"
#import "PGCollectionCell.h"

@interface PGCollectionsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *collectionsCollectionView;

@end

@implementation PGCollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionsCollectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCell forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        [cell setCellWithIcon:@"pg_collection_city_wiki" desc:@"城市指南" count:@"12"];
    } else if (indexPath.item == 1) {
        [cell setCellWithIcon:@"pg_collection_teach" desc:@"教你做" count:@"12"];
    } else if (indexPath.item == 2) {
        [cell setCellWithIcon:@"pg_collection_store" desc:@"企鹅市集" count:@"12"];
    } else if (indexPath.item == 3) {
        [cell setCellWithIcon:@"pg_collection_test" desc:@"爱测评" count:@"12"];
    } else if (indexPath.item == 4) {
        [cell setCellWithIcon:@"pg_collection_knowledge" desc:@"涨知识" count:@"12"];
    }
    
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
