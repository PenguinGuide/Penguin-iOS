//
//  PGTopicViewController.m
//  Penguin
//
//  Created by Jing Dai on 9/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTopicViewController.h"
#import "UIScrollView+PGScrollView.h"

#import "PGTopicViewModel.h"

#import "PGGoodsCollectionView.h"

@interface PGTopicViewController () <PGGoodsCollectionViewDelegate>

@property (nonatomic, strong) PGTopicViewModel *viewModel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) PGGoodsCollectionView *topicCollectionView;

@end

@implementation PGTopicViewController

- (id)initWithTopicId:(NSString *)topicId
{
    if (self = [super init]) {
        self.topicId = topicId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.topicCollectionView];
    [self.view addSubview:self.backButton];
    
    self.viewModel = [[PGTopicViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"topic" block:^(id changedObject) {
        PGTopic *topic = changedObject;
        if (topic && [topic isKindOfClass:[PGTopic class]]) {
            [weakself.topicCollectionView reloadData];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*9/16)];
            [imageView setWithImageURL:weakself.viewModel.topic.image placeholder:nil completion:nil];
            [weakself.topicCollectionView setHeaderView:imageView naviTitle:weakself.viewModel.topic.title rightNaviButton:nil];
        }
    }];
    
    [self setNeedsStatusBarAppearanceUpdate];
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

- (void)dealloc
{
    [self unobserve];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <PGGoodsCollectionViewDelegate>

- (NSArray *)goodsArray
{
    return self.viewModel.topic.goodsArray;
}

- (UIEdgeInsets)topEdgeInsets
{
    return UIEdgeInsetsMake(UISCREEN_WIDTH*9/16+15, 8, 10, 8);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView scrollViewShouldUpdate];
}

- (PGGoodsCollectionView *)topicCollectionView {
	if(_topicCollectionView == nil) {
		_topicCollectionView = [[PGGoodsCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _topicCollectionView.goodsDelegate = self;
	}
	return _topicCollectionView;
}

- (UIButton *)backButton {
    if(_backButton == nil) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 35, 50, 50)];
        [_backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button_light"] forState:UIControlStateNormal];
        [_backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

@end
