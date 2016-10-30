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
#import "PGMessageCell.h"

@interface PGMessageViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *messagesCollectionView;

@end

@implementation PGMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"我的消息"];
    
    [self.view addSubview:self.messagesCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MessageCell forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        [cell setCellWithDesc:@"系 统 消 息" count:@"5"];
    } else if (indexPath.item == 1) {
        [cell setCellWithDesc:@"收 到 的 回 复" count:@"10"];
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
