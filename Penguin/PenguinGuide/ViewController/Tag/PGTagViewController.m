//
//  PGTagViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/25/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTagViewController.h"
#import "PGFeedsCollectionView.h"

#import "PGTagViewModel.h"

@interface PGTagViewController () <PGFeedsCollectionViewDelegate>

@property (nonatomic, strong) NSString *tagId;

@property (nonatomic, strong) PGFeedsCollectionView *feedsCollectionView;

@property (nonatomic, strong) PGTagViewModel *viewModel;

@end

@implementation PGTagViewController

- (id)initWithTagId:(NSString *)tagId
{
    if (self = [super init]) {
        self.tagId = tagId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = Theme.colorBackground;
    
    [self.view addSubview:self.feedsCollectionView];
    
    self.viewModel = [[PGTagViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"feedsArray" block:^(id changedObject) {
        NSArray *feedsArray = changedObject;
        if (feedsArray && [feedsArray isKindOfClass:[NSArray class]]) {
            [weakself setNavigationTitle:weakself.viewModel.tagName];
            [weakself.feedsCollectionView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [self unobserve];
}

#pragma mark - <PGFeedsCollectionViewDelegate>

- (NSArray *)recommendsArray
{
    return nil;
}

- (NSArray *)feedsArray
{
    return self.viewModel.feedsArray;
}

- (CGSize)feedsHeaderSize
{
    return CGSizeZero;
}

- (NSString *)tabType
{
    return nil;
}

- (PGFeedsCollectionView *)feedsCollectionView
{
    if (!_feedsCollectionView) {
        _feedsCollectionView = [[PGFeedsCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _feedsCollectionView.feedsDelegate = self;
    }
    return _feedsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
