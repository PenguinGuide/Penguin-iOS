//
//  PGReplyMessagesViewController.m
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define MessageCell @"MessageCell"

#import "PGMessageContentViewController.h"
#import "PGMessageContentCell.h"

#import "PGMessageViewModel.h"

@interface PGMessageContentViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) PGMessageContentType type;
@property (nonatomic, strong) PGBaseCollectionView *messagesCollectionView;
@property (nonatomic, strong) PGMessageViewModel *viewModel;

@end

@implementation PGMessageContentViewController

- (id)initWithType:(PGMessageContentType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.messagesCollectionView];
    
    self.viewModel = [[PGMessageViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"messages" block:^(id changedObject) {
        NSArray *messages = changedObject;
        if (messages && [messages isKindOfClass:[NSArray class]]) {
            [weakself.messagesCollectionView reloadData];
            [weakself dismissLoading];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.viewModel.messages.count == 0) {
        [self showLoading];
        if (self.type == PGMessageContentTypeSystem) {
            [self.viewModel requestSystemMessages];
        } else if (self.type == PGMessageContentTypeReply) {
            [self.viewModel requestReplyMessages];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.messages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGMessageContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MessageCell forIndexPath:indexPath];
    
    PGMessage *message = self.viewModel.messages[indexPath.item];
    [cell setCellWithMessage:message];
    
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

- (PGBaseCollectionView *)messagesCollectionView
{
    if (!_messagesCollectionView) {
        _messagesCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _messagesCollectionView.backgroundColor = [UIColor whiteColor];
        _messagesCollectionView.dataSource = self;
        _messagesCollectionView.delegate = self;
        
        [_messagesCollectionView registerClass:[PGMessageContentCell class] forCellWithReuseIdentifier:MessageCell];
    }
    return _messagesCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
