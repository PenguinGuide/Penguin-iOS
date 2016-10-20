//
//  PGStoreCategoryViewController.m
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGStoreCategoryViewController.h"
#import "PGGoodsCollectionView.h"
#import "PGPopover.h"

#import "PGStoreCategoryViewModel.h"

@interface PGStoreCategoryViewController () <PGGoodsCollectionViewDelegate>

@property (nonatomic, strong) PGStoreCategoryViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *filterBarButton;
@property (nonatomic, strong) PGGoodsCollectionView *goodsCollectionView;

@end

@implementation PGStoreCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"葡萄酒"];
    
    UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 18)];
    [filterButton setImage:[UIImage imageNamed:@"pg_store_filter"] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    
    [self.navigationController.navigationBar setTintColor:Theme.colorText];
    self.navigationItem.rightBarButtonItem = self.filterBarButton;
    
    [self.view addSubview:self.goodsCollectionView];
    
    self.viewModel = [[PGStoreCategoryViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"goodsArray" block:^(id changedObject) {
        NSArray *goodsArray = changedObject;
        if (goodsArray && [goodsArray isKindOfClass:[NSArray class]]) {
            [weakself.goodsCollectionView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)dealloc
{
    [self unobserve];
}

#pragma mark - <PGGoodsCollectionViewDelegate>

- (NSArray *)goodsArray
{
    return self.viewModel.goodsArray;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)filterButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    PGPopoverItem *defaultItem = [[PGPopoverItem alloc] init];
    defaultItem.title = @"综合排序";
    defaultItem.icon = @"pg_store_filter_default";
    defaultItem.highlightIcon = @"pg_store_filter_default_highlight";
    defaultItem.selected = YES;
    
    PGPopoverItem *lowestItem = [[PGPopoverItem alloc] init];
    lowestItem.title = @"价格由低到高";
    lowestItem.icon = @"pg_store_filter_lowest";
    lowestItem.highlightIcon = @"pg_store_filter_lowest_highlight";
    
    PGPopoverItem *highestItem = [[PGPopoverItem alloc] init];
    highestItem.title = @"价格由高到低";
    highestItem.icon = @"pg_store_filter_highest";
    highestItem.highlightIcon = @"pg_store_filter_highest_highlight";
    
    PGPopover *popover = [PGPopover popoverWithItems:@[defaultItem, lowestItem, highestItem] itemHeight:50];
    [popover showPopoverFromView:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PGGoodsCollectionView *)goodsCollectionView {
	if(_goodsCollectionView == nil) {
		_goodsCollectionView = [[PGGoodsCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _goodsCollectionView.goodsDelegate = self;
	}
	return _goodsCollectionView;
}

@end
