//
//  PGHomeViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define PagedBannersCell @"PagedBannersCell"

// view controllers
#import "PGHomeViewController.h"
// view models
#import "PGHomeViewModel.h"
// views
#import "PGPagedBannersCell.h"

#import "ViewController.h"

@interface PGHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGHomeViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *messageButton;
@property (nonatomic, strong) PGBaseCollectionView *homeCollectionView;

@end

@implementation PGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.parentViewController.navigationItem.leftBarButtonItem = self.searchButton;
    self.parentViewController.navigationItem.rightBarButtonItem = self.messageButton;
    self.parentViewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pg_home_logo"]];
    
    [self.view addSubview:self.homeCollectionView];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGPagedBannersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PagedBannersCell forIndexPath:indexPath];
    
    [cell reloadBannersWithData:@[@"pg_home_paged_banners_cell", @"pg_home_paged_banners_cell", @"pg_home_paged_banners_cell", @"pg_home_paged_banners_cell"]];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*175/320);
}

#pragma mark - <PGTabBarControllerDelegate>

- (NSString *)tabBarTitle
{
    return @"首页";
}

- (NSString *)tabBarImage
{
    return @"pg_tab_home";
}

- (NSString *)tabBarHighlightImage
{
    return @"pg_tab_home_highlight";
}

#pragma mark - <Button Events>

- (void)searchButtonClicked
{
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageButtonClicked
{
    
}

#pragma mark - <Setters && Getters>

- (UIBarButtonItem *)searchButton
{
    if (!_searchButton) {
        _searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pg_home_search_button"]
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(searchButtonClicked)];
    }
    return _searchButton;
}

- (UIBarButtonItem *)messageButton
{
    if (!_messageButton) {
        _messageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pg_home_message_button"]
                                                          style:UIBarButtonItemStyleDone
                                                         target:self
                                                         action:@selector(messageButtonClicked)];
    }
    return _messageButton;
}

- (PGBaseCollectionView *)homeCollectionView
{
    if (!_homeCollectionView) {
        _homeCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _homeCollectionView.dataSource = self;
        _homeCollectionView.delegate = self;
        
        [_homeCollectionView registerClass:[PGPagedBannersCell class] forCellWithReuseIdentifier:PagedBannersCell];
        
        __block PGBaseCollectionView *collectionView = _homeCollectionView;
        [_homeCollectionView enablePullToRefresh:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [collectionView endTopRefreshing];
            });
        }];
    }
    return _homeCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
