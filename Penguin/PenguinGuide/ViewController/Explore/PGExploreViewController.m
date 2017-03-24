//
//  PGExploreViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define HotArticlesCell @"HotArticlesCell"
#define TodayArticleCell @"TodayArticleCell"
#define TagsCell @"TagsCell"
#define ArticleCell @"ArticleCell"
#define HistoryArticlesHeaderView @"HistoryArticlesHeaderView"

#import "PGExploreViewController.h"
#import "PGSearchRecommendsViewController.h"

#import "PGExploreViewModel.h"

#import "PGCollectionsCell.h"
#import "PGArticleCardCell.h"
#import "PGExploreTodayArticleCell.h"
#import "PGExploreTagCell.h"
#import "PGArticleBannerCell.h"

@interface PGExploreViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGNavigationViewDelegate>

@property (nonatomic, strong) PGNavigationView *navigationView;

@property (nonatomic, strong, readwrite) PGBaseCollectionView *exploreCollectionView;

@property (nonatomic, strong) PGExploreViewModel *viewModel;

@property (nonatomic, strong) NSAttributedString *hotArticlesLabelText;
@property (nonatomic, strong) NSAttributedString *historyArticlesLabelText;

@end

@implementation PGExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationView = [PGNavigationView naviViewWithSearchButton];
    self.navigationView.delegate = self;
    [self.view addSubview:self.navigationView];
    
    [self.view addSubview:self.exploreCollectionView];
    
    self.viewModel = [[PGExploreViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"articlesArray" block:^(id changedObject) {
        NSArray *articlesArray = changedObject;
        if (articlesArray && [articlesArray isKindOfClass:[NSArray class]]) {
            // NOTE: fix reloadData flash http://www.cnblogs.com/Rinpe/p/5850238.html
            [UIView setAnimationsEnabled:NO];
            [weakself.exploreCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
        }
        [weakself dismissLoading];
        [weakself.exploreCollectionView endTopRefreshing];
        [weakself.exploreCollectionView endBottomRefreshing];
    }];
    [self observe:self.viewModel keyPath:@"error" block:^(id changedObject) {
        NSError *error = changedObject;
        if (error && [error isKindOfClass:[NSError class]]) {
            [weakself showErrorMessage:error];
            [weakself dismissLoading];
            [weakself.exploreCollectionView endTopRefreshing];
            [weakself.exploreCollectionView endBottomRefreshing];
        }
    }];
    [self observeCollectionView:self.exploreCollectionView endOfFeeds:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadView];
    
    self.exploreCollectionView.contentInset = UIEdgeInsetsZero;
    
    [self checkSystemNotification];
}

- (void)dealloc
{
    [self unobserve];
}

- (void)reloadView
{
    if (self.viewModel.hotArticlesArray.count == 0) {
        [self showLoading];
        [self.viewModel requestData];
    }
}

- (void)initAnalyticsKeys
{
    self.pageName = explore_tab_view;
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
}

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        if (self.viewModel.currentArticle) {
            return 1;
        }
        return 0;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 3) {
        return self.viewModel.articlesArray.count;
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
    } else if (indexPath.section == 1) {
        PGExploreTodayArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TodayArticleCell forIndexPath:indexPath];
        if ([cell respondsToSelector:@selector(setCellWithModel:)]) {
            [(id<PGBaseCollectionViewCell>)cell setCellWithModel:self.viewModel.currentArticle];
        }
        return cell;
    } else if (indexPath.section == 2) {
        PGCollectionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagsCell forIndexPath:indexPath];
        [cell setCellWithTitle:nil
                   collections:self.viewModel.tagsArray
                     cellClass:[PGExploreTagCell class]
                        config:^(PGCollectionsCellConfig *config) {
                            config.titleHeight = 0.f;
                            config.minimumLineSpacing = 20.f;
                            config.insets = UIEdgeInsetsMake(0, 22.f, 0.f, 22.f);
                            config.collectionCellSize = [PGExploreTagCell cellSize];
                            config.showBorder = NO;
                        }];
        return cell;
    } else if (indexPath.section == 3) {
        if (self.viewModel.articlesArray.count-indexPath.item == 3) {
            PGWeakSelf(self);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakself.viewModel requestArticles];
            });
        }
        
        PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCell forIndexPath:indexPath];
        
        PGArticleBanner *articleBanner = self.viewModel.articlesArray[indexPath.item];
        cell.eventName = article_banner_clicked;
        cell.eventId = articleBanner.articleId;
        cell.pageName = explore_tab_view;
        if (articleBanner.title) {
            cell.extraParams = @{@"article_title":articleBanner.title};
        }
        
//        [cell setDelegate:self];
        [cell setCellWithArticle:articleBanner allowGesture:YES];
        
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 3) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HistoryArticlesHeaderView forIndexPath:indexPath];
            
            [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 60)];
            label.attributedText = self.historyArticlesLabelText;
            label.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:label];
            
            return headerView;
        }
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 3) {
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
        return CGSizeMake(UISCREEN_WIDTH-22*2, 60);
    }
    if (indexPath.section == 2) {
        return CGSizeMake(UISCREEN_WIDTH, [PGExploreTagCell cellSize].height);
    }
    if (indexPath.section == 3) {
        id banner = self.viewModel.articlesArray[indexPath.item];
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
    if (section == 3) {
        if (self.viewModel.articlesArray.count > 0) {
            return CGSizeMake(UISCREEN_WIDTH, 60);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 3) {
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
        return UIEdgeInsetsZero;
    }
    if (section == 1) {
        return UIEdgeInsetsMake(30, 22, 24, 22);
    }
    if (section == 2) {
        return UIEdgeInsetsMake(10, 0, 15, 0);
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if ([cell isKindOfClass:[PGExploreTodayArticleCell class]]) {
            [(PGExploreTodayArticleCell *)cell insertCellBorderLayer:8.f];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        id<PGBaseCollectionViewCell> selectedCell = (id<PGBaseCollectionViewCell>)[collectionView cellForItemAtIndexPath:indexPath];
        if ([selectedCell respondsToSelector:@selector(cellDidSelectWithModel:)]) {
            [selectedCell cellDidSelectWithModel:self.viewModel.currentArticle];
        }
    }
    if (indexPath.section == 3) {
        PGArticleBanner *articleBanner = self.viewModel.articlesArray[indexPath.item];
        [PGRouterManager routeToArticlePage:articleBanner.articleId link:articleBanner.link];
    }
}

#pragma mark - <PGTabBarControllerDelegate>

- (NSString *)tabBarTitle
{
    return @"文章";
}

- (NSString *)tabBarImage
{
    return @"pg_tab_explore";
}

- (NSString *)tabBarHighlightImage
{
    return @"pg_tab_explore_highlight";
}

- (void)tabBarDidClicked
{
    // NOTE: these codes in viewDidLoad && viewWillLoad will not work since self.navigationController is nil for the first time
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.parentViewController.navigationItem setLeftBarButtonItem:nil];
}

//#pragma mark - <PGArticleBannerCellDelegate>
//
//- (void)collectArticle:(PGArticleBanner *)article
//{
//    PGWeakSelf(self);
//    __weak PGArticleBanner *weakArticle = article;
//    [self.viewModel collectArticle:article.articleId completion:^(BOOL success) {
//        if (success) {
//            weakArticle.isCollected = YES;
//            [weakself showToast:@"收藏成功"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_UPDATE_ME object:nil];
//        }
//    }];
//}
//
//- (void)disCollectArticle:(PGArticleBanner *)article
//{
//    PGWeakSelf(self);
//    __weak PGArticleBanner *weakArticle = article;
//    [self.viewModel disCollectArticle:article.articleId completion:^(BOOL success) {
//        if (success) {
//            weakArticle.isCollected = NO;
//            [weakself showToast:@"取消成功"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_UPDATE_ME object:nil];
//        }
//    }];
//}

#pragma mark - <Check System Notification>

- (void)checkSystemNotification
{
    // NOTE: [[UIApplication sharedApplication] isRegisteredForRemoteNotifications] doesn't work http://stackoverflow.com/questions/29787736/isregisteredforremotenotifications-returns-true-even-though-i-disabled-it-comple
    UIUserNotificationSettings *notificationSettings = [UIApplication sharedApplication].currentUserNotificationSettings;
    if (notificationSettings.types == UIUserNotificationTypeNone) {
        NSArray *notificationExpireDate = [PGGlobal.cache objectForKey:@"system_notification_expire_date" fromTable:@"General"];
        if (!notificationExpireDate) {
            NSTimeInterval expireTime = [[NSDate date] timeIntervalSince1970]+5*24*60*60;
            [PGGlobal.cache putObject:@[@(expireTime)] forKey:@"system_notification_expire_date" intoTable:@"General"];
            
            PGWeakSelf(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself showSystemNotificationPopup];
            });
        } else {
            NSTimeInterval expireTime = [notificationExpireDate.firstObject doubleValue];
            NSDate *expireDate = [NSDate dateWithTimeIntervalSince1970:expireTime];
            if ([[NSDate date] compare:expireDate] == NSOrderedDescending) {
                NSTimeInterval expireTime = [[NSDate date] timeIntervalSince1970]+5*24*60*60;
                [PGGlobal.cache putObject:@[@(expireTime)] forKey:@"system_notification_expire_date" intoTable:@"General"];
                
                PGWeakSelf(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself showSystemNotificationPopup];
                });
            }
        }
    }
}

#pragma mark - <PGNavigationViewDelegate>

- (void)searchButtonClicked
{
    PGSearchRecommendsViewController *searchRecommendsVC = [[PGSearchRecommendsViewController alloc] init];
    PGBaseNavigationController *naviController = [[PGBaseNavigationController alloc] initWithRootViewController:searchRecommendsVC];
    PGGlobal.tempNavigationController = naviController;
    [self presentViewController:naviController animated:NO completion:nil];
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)exploreCollectionView {
    if(_exploreCollectionView == nil) {
        _exploreCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 64, UISCREEN_WIDTH, UISCREEN_HEIGHT-50-64) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _exploreCollectionView.dataSource = self;
        _exploreCollectionView.delegate = self;
        
        [_exploreCollectionView registerClass:[PGCollectionsCell class] forCellWithReuseIdentifier:HotArticlesCell];
        [_exploreCollectionView registerClass:[PGExploreTodayArticleCell class] forCellWithReuseIdentifier:TodayArticleCell];
        [_exploreCollectionView registerClass:[PGCollectionsCell class] forCellWithReuseIdentifier:TagsCell];
        [_exploreCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleCell];
        [_exploreCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HistoryArticlesHeaderView];
        
        PGWeakSelf(self);
        [_exploreCollectionView enablePullToRefreshWithTopInset:0.f completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.viewModel clearPagination];
                [weakself.viewModel requestData];
            });
        }];
        [_exploreCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestArticles];
        }];
    }
    return _exploreCollectionView;
}

- (NSAttributedString *)hotArticlesLabelText
{
    if (!_hotArticlesLabelText) {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:@"热门推文 · PENGUIN HOT"];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, 7)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, 7)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeLight range:NSMakeRange(7, 11)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(7, 11)];
        
        _hotArticlesLabelText = [[NSAttributedString alloc] initWithAttributedString:attrS];
    }
    return _hotArticlesLabelText;
}

- (NSAttributedString *)historyArticlesLabelText
{
    if (!_historyArticlesLabelText) {
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:@"往期推文 · PENGUIN REVIEW"];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeBold range:NSMakeRange(0, 7)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, 7)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontExtraLargeLight range:NSMakeRange(7, 14)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorLightText range:NSMakeRange(7, 14)];
        
        _historyArticlesLabelText = [[NSAttributedString alloc] initWithAttributedString:attrS];
    }
    return _historyArticlesLabelText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
