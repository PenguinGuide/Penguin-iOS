//
//  PGMeViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define MeCell @"MeCell"
#define HeaderView @"HeaderView"

#import "PGMeViewController.h"
#import "PGPersonalSettingsViewController.h"
#import "PGSystemSettingsViewController.h"

#import "PGMeViewModel.h"

#import "PGMeCell.h"

#import "PGMeHeaderView.h"

@interface PGMeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *meCollectionView;

@property (nonatomic, strong) PGMeViewModel *viewModel;

@end

@implementation PGMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.meCollectionView];
    
    self.viewModel = [[PGMeViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"me" block:^(id changedObject) {
        PGMe *me = changedObject;
        if (me && [me isKindOfClass:[PGMe class]]) {
            [weakself.meCollectionView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - <PGTabBarControllerDelegate>

- (NSString *)tabBarTitle
{
    return @"我的";
}

- (NSString *)tabBarImage
{
    return @"pg_tab_me";
}

- (NSString *)tabBarHighlightImage
{
    return @"pg_tab_me_highlight";
}

- (void)tabBarDidClicked
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.parentViewController.navigationItem.leftBarButtonItem = nil;
    self.parentViewController.navigationItem.titleView = nil;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGMeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MeCell forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        [cell setCellWithIcon:@"pg_me_order" name:@"订 单" count:nil highlight:NO];
    } else if (indexPath.item == 1) {
        [cell setCellWithIcon:@"pg_me_collection" name:@"我 的 收 藏" count:self.viewModel.me.collectionCount highlight:YES];
    } else if (indexPath.item == 2) {
        [cell setCellWithIcon:@"pg_me_message" name:@"我 的 消 息" count:self.viewModel.me.messageCount highlight:NO];
    } else if (indexPath.item == 3) {
        [cell setCellWithIcon:@"pg_me_history" name:@"我 的 足 迹" count:@"111" highlight:NO];
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PGMeCell cellSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return [PGMeHeaderView headerViewSize];
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
    if (kind == UICollectionElementKindSectionHeader) {
        PGMeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderView forIndexPath:indexPath];
        [headerView.avatarButton addTarget:self action:@selector(avatarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [headerView.settingButton addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [headerView setViewWithMe:self.viewModel.me];
        
        return headerView;
    }
    return nil;
}

- (void)avatarButtonClicked
{
    PGPersonalSettingsViewController *personalSettingsVC = [[PGPersonalSettingsViewController alloc] init];
    
    [self.navigationController pushViewController:personalSettingsVC animated:YES];
}

- (void)settingButtonClicked
{
    PGSystemSettingsViewController *systemSettingsVC = [[PGSystemSettingsViewController alloc] init];
    
    [self.navigationController pushViewController:systemSettingsVC animated:YES];
}

- (PGBaseCollectionView *)meCollectionView
{
    if (!_meCollectionView) {
        _meCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-50) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _meCollectionView.backgroundColor = [UIColor whiteColor];
        _meCollectionView.dataSource = self;
        _meCollectionView.delegate = self;
        
        [_meCollectionView registerClass:[PGMeCell class] forCellWithReuseIdentifier:MeCell];
        [_meCollectionView registerClass:[PGMeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderView];
    }
    return _meCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
