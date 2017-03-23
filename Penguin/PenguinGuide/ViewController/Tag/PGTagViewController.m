//
//  PGTagViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/25/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define HotArticlesCell @"HotArticlesCell"
#define ArticleCell @"ArticleCell"
#define ArticlesHeaderView @"ArticlesHeaderView"

#import "PGTagViewController.h"

#import "PGTagViewModel.h"

#import "PGCollectionsCell.h"
#import "PGArticleCardCell.h"
#import "PGArticleBannerCell.h"

#import "PGNavigationView.h"
#import "PGTagHeaderView.h"
#import "UIScrollView+PGScrollView.h"

@interface PGTagViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGNavigationViewDelegate>

@property (nonatomic, strong) NSString *tagId;

@property (nonatomic, strong) PGBaseCollectionView *tagCollectionView;

@property (nonatomic, strong) PGTagViewModel *viewModel;

@property (nonatomic, strong) PGNavigationView *naviView;
@property (nonatomic, strong) UIButton *lightBackButton;
@property (nonatomic, strong) PGTagHeaderView *tagHeaderView;
@property (nonatomic, strong) NSAttributedString *hotArticlesLabelText;

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = Theme.colorBackground;
    
    self.viewModel = [[PGTagViewModel alloc] initWithAPIClient:self.apiClient];
    [self.view addSubview:self.tagCollectionView];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"allArticlesArray" block:^(id changedObject) {
        NSArray *allArticlesArray = changedObject;
        if (allArticlesArray && [allArticlesArray isKindOfClass:[NSArray class]]) {
            if (!weakself.tagHeaderView && weakself.viewModel.tagName) {
                UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*9/16)];
                headerImageView.contentMode = UIViewContentModeScaleAspectFill;
                headerImageView.backgroundColor = Theme.colorBackground;
                [headerImageView setWithImageURL:weakself.viewModel.tagImage placeholder:nil completion:nil];
                weakself.tagHeaderView = [PGTagHeaderView headerViewWithImageView:headerImageView
                                                                            title:weakself.viewModel.tagName
                                                                             desc:weakself.viewModel.tagDesc];
                [weakself.tagCollectionView setHeaderView:weakself.tagHeaderView imageView:headerImageView naviTitle:weakself.viewModel.tagName showBackButton:YES];
                [weakself.view addSubview:weakself.naviView];
            }
            [UIView setAnimationsEnabled:NO];
            [weakself.tagCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
        }
        [weakself dismissLoading];
        [weakself.tagCollectionView endTopRefreshing];
        [weakself.tagCollectionView endBottomRefreshing];
    }];
    [self observeCollectionView:self.tagCollectionView endOfFeeds:self.viewModel];
    
    [self.view addSubview:self.lightBackButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadView];
}

- (void)reloadView
{
    if (!self.viewModel.tagName) {
        [self showLoading];
        [self.viewModel requestTagWithId:self.tagId];
    }
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
}

- (void)dealloc
{
    [self unobserve];
}

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.viewModel.allArticlesArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PGCollectionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HotArticlesCell forIndexPath:indexPath];
        [cell setCellWithTitle:self.hotArticlesLabelText
                   collections:self.viewModel.hotArticlesArray
                     cellClass:[PGArticleCardCell class]
                        config:^(PGCollectionsCellConfig *config) {
                            config.titleHeight = 60.f;
                            config.minimumLineSpacing = 15.f;
                            config.insets = UIEdgeInsetsMake(0, 22.f, 0.f, 22.f);
                            config.collectionCellSize = [PGArticleCardCell cellSize];
                            config.showBorder = YES;
                        }];
        return cell;
    }
    if (indexPath.section == 1) {
        if (self.viewModel.allArticlesArray.count-indexPath.item == 3) {
            PGWeakSelf(self);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakself.viewModel loadNextPage];
            });
        }
        
        PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCell forIndexPath:indexPath];
        
        PGArticleBanner *articleBanner = self.viewModel.allArticlesArray[indexPath.item];
        [cell setCellWithArticle:articleBanner allowGesture:YES];
        
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 1) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ArticlesHeaderView forIndexPath:indexPath];
            
            [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 40)];
            label.attributedText = [[NSAttributedString alloc] initWithString:@"· 所有推文 ·" attributes:@{NSFontAttributeName:Theme.fontMediumBold,
                                                                                                       NSForegroundColorAttributeName:Theme.colorText}];
            
            label.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:label];
            
            return headerView;
        }
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 1) {
            PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
            
            return footerView;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(UISCREEN_WIDTH, 60+[PGArticleCardCell cellSize].height);
    }
    if (indexPath.section == 1) {
        id banner = self.viewModel.allArticlesArray[indexPath.item];
        if ([banner isKindOfClass:[PGArticleBanner class]]) {
            return [PGArticleBannerCell cellSize];
        } else {
            return CGSizeZero;
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.viewModel.allArticlesArray.count > 0) {
            return CGSizeMake(UISCREEN_WIDTH, 40);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (!self.viewModel) {
            return CGSizeZero;
        }
        if (self.viewModel.endFlag) {
            return [PGBaseCollectionViewFooterView footerViewSize];
        }
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(UISCREEN_WIDTH*9/16+93+10-14, 0, 15, 0);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<PGBaseCollectionViewCell> selectedCell = (id<PGBaseCollectionViewCell>)[collectionView cellForItemAtIndexPath:indexPath];
    if ([selectedCell respondsToSelector:@selector(cellDidSelectWithModel:)]) {
        if (indexPath.section == 1) {
            [selectedCell cellDidSelectWithModel:self.viewModel.allArticlesArray[indexPath.item]];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView scrollViewShouldUpdateHeaderView];
    
    CGFloat changeValue = UISCREEN_WIDTH*9/16-64;
    
    if (scrollView.contentOffset.y <= 0) {
        self.naviView.alpha = 0.f;
        self.lightBackButton.alpha = 1.f;
    } else if (scrollView.contentOffset.y < changeValue) {
        self.naviView.alpha = scrollView.contentOffset.y/changeValue;
        self.lightBackButton.alpha = 0.f;
    } else {
        self.naviView.alpha = 1.f;
        self.lightBackButton.alpha = 0.f;
    }
}

#pragma mark - <PGNavigationViewDelegate>

- (void)naviBackButtonClicked
{
    [super backButtonClicked];
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)tagCollectionView
{
    if (!_tagCollectionView) {
        _tagCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _tagCollectionView.dataSource = self;
        _tagCollectionView.delegate = self;
        
        [_tagCollectionView registerClass:[PGCollectionsCell class] forCellWithReuseIdentifier:HotArticlesCell];
        [_tagCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleCell];
        [_tagCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ArticlesHeaderView];
        
        PGWeakSelf(self);
        [_tagCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel loadNextPage];
        }];
    }
    return _tagCollectionView;
}

- (PGNavigationView *)naviView
{
    if (!_naviView) {
        _naviView = [PGNavigationView naviViewWithBackButton:self.viewModel.tagName];
        _naviView.delegate = self;
        _naviView.alpha = 0.f;
    }
    return _naviView;
}

- (UIButton *)lightBackButton
{
    if (!_lightBackButton) {
        _lightBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 40, 30)];
        [_lightBackButton setImage:[UIImage imageNamed:@"pg_navigation_back_button_light"] forState:UIControlStateNormal];
        [_lightBackButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightBackButton;
}

- (NSAttributedString *)hotArticlesLabelText
{
    if (!_hotArticlesLabelText) {
        _hotArticlesLabelText = [[NSAttributedString alloc] initWithString:@"· 热门推文 ·" attributes:@{NSFontAttributeName:Theme.fontMediumBold,
                                                                                                    NSForegroundColorAttributeName:Theme.colorText}];
    }
    return _hotArticlesLabelText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
