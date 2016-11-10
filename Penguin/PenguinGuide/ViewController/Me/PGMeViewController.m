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
#import "PGCollectionsViewController.h"
#import "PGMessageViewController.h"
#import "PGHistoryViewController.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meShouldReload) name:PG_NOTIFICATION_UPDATE_ME object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.meCollectionView];
    
    self.viewModel = [[PGMeViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"me" block:^(id changedObject) {
        PGMe *me = changedObject;
        if (me && [me isKindOfClass:[PGMe class]]) {
            [weakself.meCollectionView reloadData];
        }
        [weakself dismissLoading];
    }];
    [self observe:self.viewModel keyPath:@"readSuccess" block:^(id changedObject) {
        BOOL readSuccess = changedObject;
        if (readSuccess) {
            PGGlobal.hasNewMessage = NO;
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.tabBarController hideTabDot:3];
        }
    }];
    [self observeError:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!PGGlobal.userId) {
        [PGRouterManager routeToLoginPage];
    } else {
        if (!self.viewModel.me) {
            [self showLoading];
            [self.viewModel requestData];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unobserve];
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

- (BOOL)tabBarShouldShowDot
{
    return PGGlobal.hasNewMessage;
}

- (BOOL)tabBarShouldClicked
{
    if (!PGGlobal.userId) {
        [PGRouterManager routeToLoginPage];
        return NO;
    }
    return YES;
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
    if (self.viewModel.me) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGMeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MeCell forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        [cell setCellWithIcon:@"pg_me_order" name:@"订 单" count:nil];
    } else if (indexPath.item == 1) {
        [cell setCellWithIcon:@"pg_me_collection" name:@"我 的 收 藏" count:self.viewModel.me.collectionCount];
    } else if (indexPath.item == 2) {
        [cell setCellWithIcon:@"pg_me_message" name:@"我 的 消 息" highlight:self.viewModel.me.hasNewMessage];
    } else if (indexPath.item == 3) {
        [cell setCellWithIcon:@"pg_me_history" name:@"我 的 足 迹" count:nil];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        [PGAlibcTraderManager openMyOrdersPageWithNative:NO];
    } else if (indexPath.item == 1) {
        PGCollectionsViewController *collectionsVC = [[PGCollectionsViewController alloc] init];
        [self.navigationController pushViewController:collectionsVC animated:YES];
    } else if (indexPath.item == 2) {
        PGMessageViewController *messageVC = [[PGMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
        [self.viewModel readMessages];
    } else if (indexPath.item == 3) {
        PGHistoryViewController *historyVC = [[PGHistoryViewController alloc] init];
        [self.navigationController pushViewController:historyVC animated:YES];
    }
}

#pragma mark - <Button Events>

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

#pragma mark - <Notifications>

- (void)meShouldReload
{
    [self.viewModel requestData];
}

#pragma mark - <Setters && Getters>

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
