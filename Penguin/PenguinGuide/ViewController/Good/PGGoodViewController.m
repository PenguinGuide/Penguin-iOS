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

#import "PGGoodViewController.h"

#import "PGGoodViewModel.h"

#import "PGGoodBannersCell.h"
#import "PGGoodInfoCell.h"
#import "PGGoodDescCell.h"

@interface PGGoodViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *goodCollectionView;

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
    
    self.viewModel = [[PGGoodViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"good" block:^(id changedObject) {
        PGGood *good = changedObject;
        if (good && [good isKindOfClass:[PGGood class]]) {
            [weakself.goodCollectionView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar pg_reset];
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        return [PGGoodBannersCell cellSize];
    } else if (indexPath.item == 1) {
        return [PGGoodInfoCell cellSize:self.viewModel.good];
    } else if (indexPath.item == 2) {
        return [PGGoodDescCell cellSize:self.viewModel.good.desc];
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

- (PGBaseCollectionView *)goodCollectionView
{
    if (!_goodCollectionView) {
        _goodCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _goodCollectionView.dataSource = self;
        _goodCollectionView.delegate = self;
        
        [_goodCollectionView registerClass:[PGGoodBannersCell class] forCellWithReuseIdentifier:GoodBannersCell];
        [_goodCollectionView registerClass:[PGGoodInfoCell class] forCellWithReuseIdentifier:GoodInfoCell];
        [_goodCollectionView registerClass:[PGGoodDescCell class] forCellWithReuseIdentifier:GoodDescCell];
    }
    return _goodCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
