//
//  PGMessageViewController.m
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define MessageCell @"MessageCell"

#import "PGMessageViewController.h"
#import "PGMessageContentViewController.h"
#import "PGMessageViewModel.h"
#import "PGMessageCell.h"

@interface PGMessageViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *messagesCollectionView;
@property (nonatomic, strong) PGMessageViewModel *viewModel;

@end

@implementation PGMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"我的消息"];
    
    [self.view addSubview:self.messagesCollectionView];
    
    self.viewModel = [[PGMessageViewModel alloc] initWithAPIClient:self.apiClient];
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"countsDict" block:^(id changedObject) {
        NSDictionary *countsDict = changedObject;
        if (countsDict && [countsDict isKindOfClass:[NSDictionary class]]) {
            [weakself.messagesCollectionView reloadData];
        }
        [weakself dismissLoading];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadView];
}

- (void)dealloc
{
    [self unobserve];
}

- (void)reloadView
{
    if (!self.viewModel.countsDict) {
        [self showLoading];
        [self.viewModel requestData];
    }
}

#pragma mark - <UICollectionView>

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
    PGMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MessageCell forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        if (self.viewModel.countsDict[@"1"]) {
            [cell setCellWithDesc:@"系 统 消 息" count:[NSString stringWithFormat:@"%ld", [self.viewModel.countsDict[@"1"] integerValue]]];
        } else {
            [cell setCellWithDesc:@"系 统 消 息" count:nil];
        }
    } else if (indexPath.item == 1) {
        if (self.viewModel.countsDict[@"2"]) {
            [cell setCellWithDesc:@"收 到 的 回 复" count:[NSString stringWithFormat:@"%ld", [self.viewModel.countsDict[@"2"] integerValue]]];
        } else {
            [cell setCellWithDesc:@"收 到 的 回 复" count:nil];
        }
    } else if (indexPath.item == 2) {
        if (self.viewModel.countsDict[@"3"]) {
            [cell setCellWithDesc:@"收 到 的 赞" count:[NSString stringWithFormat:@"%ld", [self.viewModel.countsDict[@"3"] integerValue]]];
        } else {
            [cell setCellWithDesc:@"收 到 的 赞" count:nil];
        }
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        PGMessageContentViewController *replyMessagesVC = [[PGMessageContentViewController alloc] initWithType:PGMessageContentTypeSystem];
        [self.navigationController pushViewController:replyMessagesVC animated:YES];
    } else if (indexPath.item == 1) {
        PGMessageContentViewController *replyMessagesVC = [[PGMessageContentViewController alloc] initWithType:PGMessageContentTypeReply];
        [self.navigationController pushViewController:replyMessagesVC animated:YES];
    } else if (indexPath.item == 2) {
        PGMessageContentViewController *likesMessageVC = [[PGMessageContentViewController alloc] initWithType:PGMessageContentTypeLikes];
        [self.navigationController pushViewController:likesMessageVC animated:YES];
    }
}

- (PGBaseCollectionView *)messagesCollectionView
{
    if (!_messagesCollectionView) {
        _messagesCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _messagesCollectionView.backgroundColor = [UIColor whiteColor];
        _messagesCollectionView.dataSource = self;
        _messagesCollectionView.delegate = self;
        
        [_messagesCollectionView registerClass:[PGMessageCell class] forCellWithReuseIdentifier:MessageCell];
    }
    return _messagesCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
