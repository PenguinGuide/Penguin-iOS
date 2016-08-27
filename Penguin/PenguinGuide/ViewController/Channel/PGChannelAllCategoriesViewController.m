//
//  PGChannelAllCategoriesViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define HeaderView @"HeaderView"
#define CategoryCell @"CategoryCell"

#import "PGChannelAllCategoriesViewController.h"
#import "UINavigationBar+PGTransparentNaviBar.h"

#import "PGChannelAllCategoryCell.h"
#import "PGChannelAllCategoriesHeaderView.h"

@interface PGChannelAllCategoriesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *categoriesCollectionView;

@property (nonatomic, strong) PGChannel *channel;
@property (nonatomic, strong) UIImage *bgImage;

@end

@implementation PGChannelAllCategoriesViewController

- (id)initWithBackgroundImage:(UIImage *)bgImage channel:(PGChannel *)channel
{
    if (self = [super init]) {
        self.channel = channel;
        self.bgImage = bgImage;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = self.bgImage;
    [self.view addSubview:bgImageView];
    
    [self.view addSubview:self.categoriesCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // http://www.cocoachina.com/bbs/read.php?tid=316263
    // http://blog.csdn.net/cx_wzp/article/details/47166601
    
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar pg_reset];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.channel.categoriesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGChannelAllCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCell forIndexPath:indexPath];
    
    [cell setCellWithCategory:self.channel.categoriesArray[indexPath.item]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        PGChannelAllCategoriesHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderView forIndexPath:indexPath];
        
        [headerView setViewWithChannel:self.channel];
        
        return headerView;
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PGChannelAllCategoryCell cellSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return [PGChannelAllCategoriesHeaderView viewSize:self.channel];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5, 0, 5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionView *)categoriesCollectionView {
	if(_categoriesCollectionView == nil) {
        _categoriesCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _categoriesCollectionView.dataSource = self;
        _categoriesCollectionView.delegate = self;
        _categoriesCollectionView.showsHorizontalScrollIndicator = NO;
        _categoriesCollectionView.showsVerticalScrollIndicator = NO;
        _categoriesCollectionView.backgroundColor = [UIColor clearColor];
        
        [_categoriesCollectionView registerClass:[PGChannelAllCategoryCell class] forCellWithReuseIdentifier:CategoryCell];
        [_categoriesCollectionView registerClass:[PGChannelAllCategoriesHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderView];
	}
	return _categoriesCollectionView;
}

@end
