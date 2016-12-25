//
//  PGAllScenariosViewController.m
//  Penguin
//
//  Created by Jing Dai on 30/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ScenarioCell @"ScenarioCell"

#import "PGAllScenariosViewController.h"
#import "PGAllScenariosViewModel.h"
#import "PGCategoryCell.h"
#import "PGScenarioBanner.h"

@interface PGAllScenariosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *scenariosCollectionView;
@property (nonatomic, strong) PGAllScenariosViewModel *viewModel;

@property (nonatomic, strong) NSString *scenarioType;

@end

@implementation PGAllScenariosViewController

- (id)initWithScenarioType:(NSString *)scenarioType
{
    if (self = [super init]) {
        self.scenarioType = scenarioType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.scenarioType isEqualToString:@"4"]) {
        [self setNavigationTitle:@"品类"];
    } else if ([self.scenarioType isEqualToString:@"3"]) {
        [self setNavigationTitle:@"难易"];
    } else if ([self.scenarioType isEqualToString:@"2"]) {
        [self setNavigationTitle:@"人群"];
    }
    
    [self.view addSubview:self.scenariosCollectionView];
    
    self.viewModel = [[PGAllScenariosViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"scenariosArray" block:^(id changedObject) {
        NSArray *scenariosArray = changedObject;
        if (scenariosArray && [scenariosArray isKindOfClass:[NSArray class]]) {
            [UIView setAnimationsEnabled:NO];
            [weakself.scenariosCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
        }
        [weakself dismissLoading];
        [weakself.scenariosCollectionView endBottomRefreshing];
    }];
    [self observe:self.viewModel keyPath:@"error" block:^(id changedObject) {
        NSError *error = changedObject;
        if (error && [error isKindOfClass:[NSError class]]) {
            [weakself showErrorMessage:error];
            [weakself dismissLoading];
            [weakself.scenariosCollectionView endBottomRefreshing];
        }
    }];
    [self observeCollectionView:self.scenariosCollectionView endOfFeeds:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.viewModel.scenariosArray.count == 0) {
        [self showLoading];
        [self.viewModel requestScenarios:self.scenarioType];
    }
}

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.scenariosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScenarioCell forIndexPath:indexPath];
    
    [cell setCellWithCategoryIcon:self.viewModel.scenariosArray[indexPath.item]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (UISCREEN_WIDTH-15-15-15)/2;
    float height = width*2/3+35;
    
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (!self.viewModel) {
        return CGSizeZero;
    }
    if (self.viewModel.endFlag) {
        return [PGBaseCollectionViewFooterView footerViewSize];
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15.f, 15.f, 0, 15.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
            
            return footerView;
        }
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGScenarioBanner *scenario = self.viewModel.scenariosArray[indexPath.item];
    [PGRouterManager routeToScenarioPage:scenario.scenarioId link:scenario.link fromStorePage:NO];
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)scenariosCollectionView
{
    if (!_scenariosCollectionView) {
        _scenariosCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _scenariosCollectionView.dataSource = self;
        _scenariosCollectionView.delegate = self;
        
        [_scenariosCollectionView registerClass:[PGCategoryCell class] forCellWithReuseIdentifier:ScenarioCell];
        [_scenariosCollectionView registerClass:[PGBaseCollectionViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BaseCollectionViewFooterView];
        
        PGWeakSelf(self);
        [_scenariosCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestScenarios:weakself.scenarioType];
        }];
    }
    return _scenariosCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
