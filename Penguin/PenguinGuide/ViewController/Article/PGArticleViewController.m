//
//  PGArticleViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/15/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ArticleParagraphInfoCell @"ArticleParagraphInfoCell"
#define ArticleParagraphTextCell @"ArticleParagraphTextCell"
#define ArticleParagraphImageCell @"ArticleParagraphImageCell"
#define ArticleParagraphGIFImageCell @"ArticleParagraphGIFImageCell"
#define ArticleParagraphCatalogImageCell @"PGArticleParagraphCatalogImageCell"
#define ArticleParagraphVideoCell @"ArticleParagraphVideoCell"
#define ArticleParagraphSingleGoodCell @"ArticleParagraphSingleGoodCell"
#define ArticleParagraphGoodsCollectionCell @"ArticleParagraphGoodsCollectionCell"
#define ArticleParagraphNewlineCell @"ArticleParagraphNewlineCell"
#define ArticleParagraphFooterCell @"ArticleParagraphFooterCell"
#define ArticleRelatedArticlesCell @"ArticleRelatedArticlesCell"
#define ArticleCommentCell @"ArticleCommentCell"
#define ArticleCommentReplyCell @"ArticleCommentReplyCell"
#define ArticleCommentsFooterView @"ArticleCommentsFooterView"

#import "PGArticleViewController.h"
#import "UIScrollView+PGScrollView.h"
#import "PGAlertController.h"
#import "PGVideoPlayerViewController.h"
#import "PGCommentsViewController.h"
#import "PGGoodViewController.h"
#import "PGShareViewController.h"
#import "PGCommentReportViewController.h"

#import "AFNetworkReachabilityManager.h"

// views
#import "PGArticleParagraphInfoCell.h"
#import "PGArticleParagraphTextCell.h"
#import "PGArticleParagraphImageCell.h"
#import "PGArticleParagraphGIFImageCell.h"
#import "PGArticleParagraphCatalogImageCell.h"
#import "PGArticleParagraphVideoCell.h"
#import "PGArticleParagraphSingleGoodCell.h"
#import "PGArticleParagraphGoodsCollectionCell.h"
#import "PGArticleParagraphNewlineCell.h"
#import "PGArticleParagraphFooterCell.h"
#import "PGArticleRelatedArticlesCell.h"
#import "PGArticleCommentCell.h"
#import "PGArticleCommentReplyCell.h"
#import "PGCommentInputAccessoryView.h"
#import "PGArticleCommentsFooterView.h"
#import "PGArticleParagraphTextLabel.h"

// view models
#import "PGArticleViewModel.h"

// models
#import "PGArticle.h"
#import "PGStringParser.h"

@interface PGArticleViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, PGArticleCommentCellDelegate, PGArticleCommentReplyCellDelegate, PGCommentInputAccessoryViewDelegate, PGArticleParagraphInfoCellDelegate>

@property (nonatomic, strong, readwrite) PGBaseCollectionView *articleCollectionView;

@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) PGCommentInputAccessoryView *commentInputAccessoryView;

@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) PGArticleViewModel *viewModel;

@property (nonatomic, strong) PGComment *selectedComment;

@property (nonatomic, copy) void(^animationCompletion)();
@property (nonatomic, assign) BOOL animated;

@property (nonatomic, assign) BOOL statusbarIsWhiteBackground;
@property (nonatomic, assign) BOOL shouldShowCommentInput;

@end

@implementation PGArticleViewController

- (id)initWithArticleId:(NSString *)articleId animated:(BOOL)animated
{
    if (self = [super init]) {
        self.articleId = articleId;
        self.animated = animated;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.pageView = @"文章页面";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.articleCollectionView];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.commentInputAccessoryView];
    
    if (self.animated) {
        self.articleCollectionView.alpha = 0.f;
    }
    
    self.viewModel = [[PGArticleViewModel alloc] initWithAPIClient:self.apiClient];
    self.viewModel.articleId = self.articleId;
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*9/16)];
    self.headerImageView.backgroundColor = Theme.colorText;
    self.headerImageView.clipsToBounds = YES;
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"article" block:^(id changedObject) {
        PGArticle *article = changedObject;
        if (article && [article isKindOfClass:[PGArticle class]]) {
            [weakself.headerImageView setWithImageURL:weakself.viewModel.article.image placeholder:nil completion:nil];
            [weakself.articleCollectionView setHeaderView:weakself.headerImageView naviTitle:weakself.viewModel.article.title rightNaviButton:nil];
            
            if (article.isLiked) {
                [weakself.likeButton setImage:[UIImage imageNamed:@"pg_article_liked"] forState:UIControlStateNormal];
                [weakself.likeButton setTag:1];
            } else {
                [weakself.likeButton setImage:[UIImage imageNamed:@"pg_article_like"] forState:UIControlStateNormal];
                [weakself.likeButton setTag:0];
            }
            if (article.isCollected) {
                [weakself.collectButton setImage:[UIImage imageNamed:@"pg_article_collected"] forState:UIControlStateNormal];
                [weakself.collectButton setTag:1];
            } else {
                [weakself.collectButton setImage:[UIImage imageNamed:@"pg_article_collect"] forState:UIControlStateNormal];
                [weakself.collectButton setTag:0];
            }
            
            if (article.body && article.body.length > 0) {
                PGStringParser *htmlParser = [PGStringParser htmlParserWithString:article.body];
                weakself.viewModel.paragraphsArray = [htmlParser articleParsedStorages];
                [weakself.viewModel requestGoods:^{
                    [weakself.viewModel requestComments];
                }];
            }
        }
    }];
    [self observe:self.viewModel keyPath:@"commentsArray" block:^(id changedObject) {
        if (weakself.viewModel.article) {
            [weakself.articleCollectionView reloadData];
            if (weakself.animated) {
                weakself.articleCollectionView.frame = CGRectMake(0, UISCREEN_HEIGHT-300, weakself.articleCollectionView.pg_width, weakself.articleCollectionView.pg_height);
                weakself.articleCollectionView.alpha = 0.f;
                [UIView animateWithDuration:0.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     weakself.articleCollectionView.frame = CGRectMake(0, 0, weakself.articleCollectionView.pg_width, weakself.articleCollectionView.pg_height);
                                     weakself.articleCollectionView.alpha = 0.4f;
                                 } completion:^(BOOL finished) {
                                     weakself.articleCollectionView.alpha = 1.f;
                                     if (weakself.animationCompletion) {
                                         weakself.animationCompletion();
                                     }
                                     
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         if ([PGGlobal.cache objectForKey:weakself.articleId fromTable:@"ArticlePosition"]) {
                                             NSString *contentOffsetStr = [[PGGlobal.cache objectForKey:weakself.articleId fromTable:@"ArticlePosition"] firstObject];
                                             if (contentOffsetStr && contentOffsetStr.length > 0) {
                                                 CGPoint contentOffset = CGPointFromString(contentOffsetStr);
                                                 [weakself.articleCollectionView setContentOffset:contentOffset animated:NO];
                                             }
                                         }
                                     });
                                 }];
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([PGGlobal.cache objectForKey:weakself.articleId fromTable:@"ArticlePosition"]) {
                        NSString *contentOffsetStr = [[PGGlobal.cache objectForKey:weakself.articleId fromTable:@"ArticlePosition"] firstObject];
                        if (contentOffsetStr && contentOffsetStr.length > 0) {
                            CGPoint contentOffset = CGPointFromString(contentOffsetStr);
                            [weakself.articleCollectionView setContentOffset:contentOffset animated:NO];
                        }
                    }
                });
            }
        }
        [weakself dismissLoading];
    }];
    [self observe:self.viewModel keyPath:@"commentError" block:^(id changedObject) {
        if (weakself.viewModel.article) {
            [weakself.articleCollectionView reloadData];
            if (weakself.animated) {
                weakself.articleCollectionView.frame = CGRectMake(0, UISCREEN_HEIGHT-300, weakself.articleCollectionView.pg_width, weakself.articleCollectionView.pg_height);
                weakself.articleCollectionView.alpha = 0.f;
                [UIView animateWithDuration:0.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     weakself.articleCollectionView.frame = CGRectMake(0, 0, weakself.articleCollectionView.pg_width, weakself.articleCollectionView.pg_height);
                                     weakself.articleCollectionView.alpha = 0.4f;
                                 } completion:^(BOOL finished) {
                                     weakself.articleCollectionView.alpha = 1.f;
                                     if (weakself.animationCompletion) {
                                         weakself.animationCompletion();
                                     }
                                 }];
            }
        }
        [weakself dismissLoading];
    }];
    [self observe:self.viewModel keyPath:@"likeSuccess" block:^(id changedObject) {
        BOOL likeSuccess = [changedObject boolValue];
        if (likeSuccess) {
            [weakself showToast:@"喜欢"];
            weakself.likeButton.tag = 1;
            [weakself.likeButton setImage:[UIImage imageNamed:@"pg_article_liked"] forState:UIControlStateNormal];
        }
        [weakself dismissLoading];
    }];
    [self observe:self.viewModel keyPath:@"dislikeSuccess" block:^(id changedObject) {
        BOOL dislikeSuccess = [changedObject boolValue];
        if (dislikeSuccess) {
            [weakself showToast:@"不再喜欢"];
            weakself.likeButton.tag = 0;
            [weakself.likeButton setImage:[UIImage imageNamed:@"pg_article_like"] forState:UIControlStateNormal];
        }
        [weakself dismissLoading];
    }];
    [self observe:self.viewModel keyPath:@"collectSuccess" block:^(id changedObject) {
        BOOL collectSuccess = [changedObject boolValue];
        if (collectSuccess) {
            [weakself showToast:@"收藏成功"];
            weakself.collectButton.tag = 1;
            [weakself.collectButton setImage:[UIImage imageNamed:@"pg_article_collected"] forState:UIControlStateNormal];
        }
        [weakself dismissLoading];
    }];
    [self observe:self.viewModel keyPath:@"discollectSuccess" block:^(id changedObject) {
        BOOL discollectSuccess = [changedObject boolValue];
        if (discollectSuccess) {
            [weakself showToast:@"取消收藏"];
            weakself.collectButton.tag = 0;
            [weakself.collectButton setImage:[UIImage imageNamed:@"pg_article_collect"] forState:UIControlStateNormal];
        }
        [weakself dismissLoading];
    }];
    [self observe:self.viewModel keyPath:@"error" block:^(id changedObject) {
        NSError *error = changedObject;
        if (error && [error isKindOfClass:[NSError class]]) {
            [weakself showErrorMessage:error];
            [weakself dismissLoading];
            [weakself.articleCollectionView endBottomRefreshing];
        }
    }];
}

- (void)animateCollectionView:(void (^)())completion
{
    if (completion) {
        self.animationCompletion = [completion copy];
    } else {
        self.animationCompletion = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (self.viewModel.article == nil) {
        [self.viewModel requestData];
    }
    
    if (self.statusbarIsWhiteBackground) {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor whiteColor];
        }
    } else {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.viewModel.article == nil) {
        [self showLoading];
    }
    
    [self.commentInputAccessoryView setUserInteractionEnabled:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.commentInputAccessoryView.commentTextView.text = @"";
    if (UISCREEN_WIDTH < UISCREEN_HEIGHT) {
        self.commentInputAccessoryView.frame = CGRectMake(0, UISCREEN_HEIGHT, UISCREEN_WIDTH, 60);
    } else {
        self.commentInputAccessoryView.frame = CGRectMake(0, UISCREEN_WIDTH, UISCREEN_HEIGHT, 60);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.commentInputAccessoryView.commentTextView resignFirstResponder];
    [self.commentInputAccessoryView setUserInteractionEnabled:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.articleId && self.articleId.length > 0) {
        CGPoint contentOffset = self.articleCollectionView.contentOffset;
        [PGGlobal.cache putObject:@[NSStringFromCGPoint(contentOffset)] forKey:self.articleId intoTable:@"ArticlePosition"];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unobserve];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.statusbarIsWhiteBackground) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.viewModel.paragraphsArray.count > 0 ? 1 + self.viewModel.paragraphsArray.count + 1 : 0;
    } else if (section == 1) {
        return self.viewModel.article.relatedArticlesArray.count > 0 ? 1 : 0;
    } else if (section == 2) {
        return self.viewModel.commentsArray.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            PGArticleParagraphInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphInfoCell forIndexPath:indexPath];
            cell.delegate = self;
            
            [cell setCellWithArticle:self.viewModel.article];
            
            return cell;
        } else if (indexPath.item == self.viewModel.paragraphsArray.count+1) {
            PGArticleParagraphFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphFooterCell forIndexPath:indexPath];
            
            return cell;
        } else {
            id storage = self.viewModel.paragraphsArray[indexPath.item-1];
            if ([storage isKindOfClass:[PGParserTextStorage class]]) {
                PGArticleParagraphTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphTextCell forIndexPath:indexPath];
                
                PGParserTextStorage *textStorage = (PGParserTextStorage *)storage;
                [cell setCellWithStr:textStorage.text];
                
                return cell;
            } else if ([storage isKindOfClass:[PGParserImageStorage class]]) {
                PGParserImageStorage *imageStorage = (PGParserImageStorage *)storage;
                if (imageStorage.isGIF) {
                    PGArticleParagraphGIFImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphGIFImageCell forIndexPath:indexPath];
                    [cell setCellWithImage:imageStorage.image];
                    
                    return cell;
                } else {
                    PGArticleParagraphImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphImageCell forIndexPath:indexPath];
                    [cell setCellWithImage:imageStorage.image];
                    
                    return cell;
                }
            } else if ([storage isKindOfClass:[PGParserCatalogImageStorage class]]) {
                PGParserCatalogImageStorage *imageStorage = (PGParserCatalogImageStorage *)storage;
                PGArticleParagraphCatalogImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphCatalogImageCell forIndexPath:indexPath];
                [cell setCellWithImage:imageStorage.image];
                
                return cell;
            } else if ([storage isKindOfClass:[PGParserVideoStorage class]]) {
                PGParserVideoStorage *videoStorage = (PGParserVideoStorage *)storage;
                PGArticleParagraphVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphVideoCell forIndexPath:indexPath];
                [cell setCellWithImage:videoStorage.image];
                
                return cell;
            } else if ([storage isKindOfClass:[PGParserSingleGoodStorage class]]) {
                PGParserSingleGoodStorage *singleGoodStorage = (PGParserSingleGoodStorage *)storage;
                
                PGArticleParagraphSingleGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphSingleGoodCell forIndexPath:indexPath];
                
                [cell setCellWithGood:singleGoodStorage.good];
                
                return cell;
            } else if ([storage isKindOfClass:[PGParserGoodsCollectionStorage class]]) {
                PGParserGoodsCollectionStorage *goodsCollectionStorage = (PGParserGoodsCollectionStorage *)storage;
                
                PGArticleParagraphGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphGoodsCollectionCell forIndexPath:indexPath];
                
                [cell reloadCellWithGoodsArray:goodsCollectionStorage.goodsArray];
                
                return cell;
            } else if ([storage isKindOfClass:[PGParserNewlineStorage class]]) {
                PGArticleParagraphNewlineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphNewlineCell forIndexPath:indexPath];
                
                return cell;
            }
        }
    } else if (indexPath.section == 1) {
        PGArticleRelatedArticlesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleRelatedArticlesCell forIndexPath:indexPath];
        [cell setCellWithDataArray:self.viewModel.article.relatedArticlesArray];
        
        return cell;
    } else if (indexPath.section == 2) {
        PGComment *comment = self.viewModel.commentsArray[indexPath.item];
        if (comment.replyComment || comment.replyDeleted) {
            PGArticleCommentReplyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCommentReplyCell forIndexPath:indexPath];
            cell.delegate = self;
            
            [cell setCellWithComment:comment];
            
            return cell;
        } else {
            PGArticleCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCommentCell forIndexPath:indexPath];
            cell.delegate = self;
            
            [cell setCellWithComment:comment];
            
            return cell;
        }
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && kind == UICollectionElementKindSectionFooter && self.viewModel.commentsArray.count > 0) {
        PGArticleCommentsFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ArticleCommentsFooterView forIndexPath:indexPath];
        [footerView.allCommentsButton addTarget:self action:@selector(allCommentsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        return footerView;
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(UISCREEN_WIDTH*9/16, 0, 0, 0);
    } else if (section == 1) {
        return UIEdgeInsetsMake(20, 0, 0, 0);
    } else if (section == 2) {
        if (self.viewModel.commentsArray.count > 0) {
            return UIEdgeInsetsMake(20, 0, 0, 0);
        }
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
        return 15.f;
    }
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            return [PGArticleParagraphInfoCell cellSize:self.viewModel.article];
        } else if (indexPath.item == self.viewModel.paragraphsArray.count+1) {
            return [PGArticleParagraphFooterCell cellSize];
        } else {
            id storage = self.viewModel.paragraphsArray[indexPath.item-1];
            if ([storage isKindOfClass:[PGParserTextStorage class]]) {
                PGParserTextStorage *textStorage = (PGParserTextStorage *)storage;
                
                return [self textSize:textStorage.text];
            } else if ([storage isKindOfClass:[PGParserImageStorage class]]) {
                PGParserImageStorage *imageStorage = (PGParserImageStorage *)storage;
                CGFloat width = UISCREEN_WIDTH;
                CGFloat height = 0.f;
                if (imageStorage.ratio > 0.f) {
                    height = 20+width*(1/imageStorage.ratio)+20;
                    // NOTE: app will be stucked if ratio == 0.f
                    return CGSizeMake(width, height);
                }
            } else if ([storage isKindOfClass:[PGParserCatalogImageStorage class]]) {
                PGParserCatalogImageStorage *imageStorage = (PGParserCatalogImageStorage *)storage;
                CGFloat width = UISCREEN_WIDTH-60;
                CGFloat height = 0.f;
                if (imageStorage.ratio > 0.f) {
                    height = 20+width*(1/imageStorage.ratio)+20;
                    return CGSizeMake(width, height);
                }
            } else if ([storage isKindOfClass:[PGParserVideoStorage class]]) {
                PGParserVideoStorage *videoStorage = (PGParserVideoStorage *)storage;
                CGFloat width = UISCREEN_WIDTH-30;
                CGFloat height = 0.f;
                if (videoStorage.ratio > 0.f) {
                    height = 20+width*(1/videoStorage.ratio)+20;
                    return CGSizeMake(width, height);
                }
            } else if ([storage isKindOfClass:[PGParserSingleGoodStorage class]]) {
                return CGSizeMake(UISCREEN_WIDTH-60, UISCREEN_WIDTH+30);
            } else if ([storage isKindOfClass:[PGParserGoodsCollectionStorage class]]) {
                return CGSizeMake(UISCREEN_WIDTH-60, 270.f);
            } else if ([storage isKindOfClass:[PGParserNewlineStorage class]]) {
                return CGSizeMake(UISCREEN_WIDTH, 3.f);
            }
        }
    } else if (indexPath.section == 1) {
        return [PGArticleRelatedArticlesCell cellSize];
    } else if (indexPath.section == 2) {
        PGComment *comment = self.viewModel.commentsArray[indexPath.item];
        if (comment.replyComment || comment.replyDeleted) {
            return [PGArticleCommentReplyCell cellSize:comment];
        } else {
            return [PGArticleCommentCell cellSize:comment];
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 2 && self.viewModel.commentsArray.count > 0) {
        return CGSizeMake(UISCREEN_WIDTH, 90);
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // FIXME: crash when selected if indexPath.item == 0
        if (indexPath.item > 0 && indexPath.item < self.viewModel.paragraphsArray.count+1) {
            id storage = self.viewModel.paragraphsArray[indexPath.item-1];
            if ([storage isKindOfClass:[PGParserVideoStorage class]]) {
                PGParserVideoStorage *videoStorage = (PGParserVideoStorage *)storage;
                if (videoStorage.link && videoStorage.link.length > 0) {
                    PGWeakSelf(self);
                    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
                    switch (status) {
                        case AFNetworkReachabilityStatusReachableViaWiFi:
                        {
                            PGVideoPlayerViewController *playerViewController = [[PGVideoPlayerViewController alloc] initWithVideoURL:videoStorage.link];
                            [self.navigationController pushViewController:playerViewController animated:YES];
                            break;
                        }
                            
                        case AFNetworkReachabilityStatusReachableViaWWAN:
                        {
                            PGAlertAction *cancelAction = [PGAlertAction actionWithTitle:@"取消" style:nil handler:nil];
                            PGAlertAction *doneAction = [PGAlertAction actionWithTitle:@"继续观看" style:^(PGAlertActionStyle *style) {
                                style.type = PGAlertActionTypeDestructive;
                            } handler:^{
                                PGVideoPlayerViewController *playerViewController = [[PGVideoPlayerViewController alloc] initWithVideoURL:videoStorage.link];
                                [weakself.navigationController pushViewController:playerViewController animated:YES];
                            }];
                            [self showAlert:@"已切换到3G/4G网络" message:@"继续播放将产生流量费用" actions:@[cancelAction, doneAction] style:^(PGAlertStyle *style) {
                                style.alertType = PGAlertTypeAlert;
                            }];
                            break;
                        }
                        case AFNetworkReachabilityStatusUnknown:
                            break;
                        case AFNetworkReachabilityStatusNotReachable:
                            break;
                        default:
                            break;
                    }
                }
            } else if ([storage isKindOfClass:[PGParserSingleGoodStorage class]]) {
                PGParserSingleGoodStorage *singleGoodStorage = (PGParserSingleGoodStorage *)storage;
                if (singleGoodStorage.goodId && singleGoodStorage.goodId.length > 0) {
                    PGGoodViewController *goodVC = [[PGGoodViewController alloc] initWithGoodId:singleGoodStorage.goodId];
                    [self.navigationController pushViewController:goodVC animated:YES];
                }
            }
        }
    } else if (indexPath.section == 2) {
        // NOTE: how to highlight UICollectionViewCell, write a sample code to show called sequence of UICollectionView delegate methods.
        
        // (when the touch begins)
        // 1. -collectionView:shouldHighlightItemAtIndexPath:
        // 2. -collectionView:didHighlightItemAtIndexPath:
        //
        // (when the touch lifts)
        // 3. -collectionView:shouldSelectItemAtIndexPath: or -collectionView:shouldDeselectItemAtIndexPath:
        // 4. -collectionView:didSelectItemAtIndexPath: or -collectionView:didDeselectItemAtIndexPath:
        // 5. -collectionView:didUnhighlightItemAtIndexPath:
        if (PGGlobal.userId && PGGlobal.userId.length > 0) {
            PGWeakSelf(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (indexPath.section == 2) {
                    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
                    if ([cell isKindOfClass:[PGArticleCommentCell class]]) {
                        PGArticleCommentCell *commentCell = (PGArticleCommentCell *)cell;
                        [commentCell unselectLabel];
                        
                        if (indexPath.item < weakself.viewModel.commentsArray.count) {
                            weakself.selectedComment = weakself.viewModel.commentsArray[indexPath.item];
                            weakself.commentInputAccessoryView.commentTextView.text = @"";
                            weakself.commentInputAccessoryView.commentTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复%@", weakself.selectedComment.user.nickname] attributes:@{NSFontAttributeName:Theme.fontMedium, NSForegroundColorAttributeName:[UIColor colorWithHexString:@"AFAFAF"]}];
                            
                            [weakself.commentInputAccessoryView.commentTextView becomeFirstResponder];
                        }
                    } else if ([cell isKindOfClass:[PGArticleCommentReplyCell class]]) {
                        PGArticleCommentReplyCell *replyCell = (PGArticleCommentReplyCell *)cell;
                        [replyCell unselectLabel];
                        
                        if (indexPath.item < weakself.viewModel.commentsArray.count) {
                            weakself.selectedComment = weakself.viewModel.commentsArray[indexPath.item];
                            weakself.commentInputAccessoryView.commentTextView.text = @"";
                            weakself.commentInputAccessoryView.commentTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复%@", weakself.selectedComment.user.nickname] attributes:@{NSFontAttributeName:Theme.fontMedium, NSForegroundColorAttributeName:[UIColor colorWithHexString:@"AFAFAF"]}];
                            
                            [weakself.commentInputAccessoryView.commentTextView becomeFirstResponder];
                        }
                    }
                }
            });
        } else {
            [PGRouterManager routeToLoginPage];
        }
    }
}

// NOTE: how to highlight UICollectionViewCell
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if ([cell isKindOfClass:[PGArticleCommentCell class]]) {
            PGArticleCommentCell *commentCell = (PGArticleCommentCell *)cell;
            [commentCell selectLabel];
        } else if ([cell isKindOfClass:[PGArticleCommentReplyCell class]]) {
            PGArticleCommentReplyCell *replyCell = (PGArticleCommentReplyCell *)cell;
            [replyCell selectLabel];
        }
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (indexPath.section == 2) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            if ([cell isKindOfClass:[PGArticleCommentCell class]]) {
                PGArticleCommentCell *commentCell = (PGArticleCommentCell *)cell;
                [commentCell unselectLabel];
            } else if ([cell isKindOfClass:[PGArticleCommentReplyCell class]]) {
                PGArticleCommentReplyCell *replyCell = (PGArticleCommentReplyCell *)cell;
                [replyCell unselectLabel];
            }
        }
    });
}

#pragma mark - <PGArticleParagraphInfoCellDelegate>

- (void)tagDidSelect:(PGTag *)tag
{
    [[PGRouter sharedInstance] openURL:tag.link];
}

#pragma mark - <PGArticleCommentCellDelegate>

- (void)commentMoreButtonClicked:(PGArticleCommentCell *)cell
{
    PGWeakSelf(self);
    PGAlertAction *reportAction = [PGAlertAction actionWithTitle:@"举报"
                                                           style:^(PGAlertActionStyle *style) {
                                                               
                                                           } handler:^{
                                                               NSIndexPath *indexPath = [weakself.articleCollectionView indexPathForCell:cell];
                                                               PGComment *comment = weakself.viewModel.commentsArray[indexPath.item];

                                                               PGCommentReportViewController *reportVC = [[PGCommentReportViewController alloc] initWithCommentId:comment.commentId];
                                                               [weakself.navigationController pushViewController:reportVC animated:YES];
                                                           }];
    PGAlertController *alertController = [PGAlertController alertControllerWithTitle:nil message:nil style:^(PGAlertStyle *style) {
        style.alertType = PGAlertTypeActionSheet;
    }];
    
    [alertController addActions:@[reportAction]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)commentLikeButtonClicked:(PGArticleCommentCell *)cell
{
    __block PGArticleCommentCell *weakCell = cell;
    
    NSIndexPath *indexPath = [self.articleCollectionView indexPathForCell:cell];
    if (indexPath.item < self.viewModel.commentsArray.count) {
        __block PGComment *comment = self.viewModel.commentsArray[indexPath.item];
        [self.viewModel likeComment:comment.commentId completion:^(BOOL success) {
            if (success) {
                comment.likesCount++;
                comment.liked = YES;
                [weakCell animateLikeButton:comment.likesCount];
            }
        }];
    }
}

- (void)commentDislikeButtonClicked:(PGArticleCommentCell *)cell
{
    __block PGArticleCommentCell *weakCell = cell;
    
    NSIndexPath *indexPath = [self.articleCollectionView indexPathForCell:cell];
    if (indexPath.item < self.viewModel.commentsArray.count) {
        PGComment *comment = self.viewModel.commentsArray[indexPath.item];
        [self.viewModel dislikeComment:comment.commentId completion:^(BOOL success) {
            if (success) {
                comment.likesCount--;
                comment.liked = NO;
                [weakCell animateDislikeButton:comment.likesCount];
            }
        }];
    }
}

#pragma mark - <PGArticleCommentReplyCellDelegate>

- (void)commentReplyMoreButtonClicked:(PGArticleCommentReplyCell *)cell
{
    PGWeakSelf(self);
    PGAlertAction *reportAction = [PGAlertAction actionWithTitle:@"举报"
                                                           style:^(PGAlertActionStyle *style) {
                                                               
                                                           } handler:^{
                                                               NSIndexPath *indexPath = [weakself.articleCollectionView indexPathForCell:cell];
                                                               PGComment *comment = weakself.viewModel.commentsArray[indexPath.item];
                                                               
                                                               PGCommentReportViewController *reportVC = [[PGCommentReportViewController alloc] initWithCommentId:comment.commentId];
                                                               [weakself.navigationController pushViewController:reportVC animated:YES];
                                                           }];
    PGAlertController *alertController = [PGAlertController alertControllerWithTitle:nil message:nil style:^(PGAlertStyle *style) {
        style.alertType = PGAlertTypeActionSheet;
    }];
    
    [alertController addActions:@[reportAction]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)commentReplyLikeButtonClicked:(PGArticleCommentReplyCell *)cell
{
    __block PGArticleCommentReplyCell *weakCell = cell;
    
    NSIndexPath *indexPath = [self.articleCollectionView indexPathForCell:cell];
    if (indexPath.item < self.viewModel.commentsArray.count) {
        __block PGComment *comment = self.viewModel.commentsArray[indexPath.item];
        [self.viewModel likeComment:comment.commentId completion:^(BOOL success) {
            if (success) {
                comment.likesCount++;
                [weakCell animateLikeButton:comment.likesCount];
            }
        }];
    }
}

- (void)commentReplyDislikeButtonClicked:(PGArticleCommentReplyCell *)cell
{
    __block PGArticleCommentReplyCell *weakCell = cell;
    
    NSIndexPath *indexPath = [self.articleCollectionView indexPathForCell:cell];
    if (indexPath.item < self.viewModel.commentsArray.count) {
        PGComment *comment = self.viewModel.commentsArray[indexPath.item];
        [self.viewModel dislikeComment:comment.commentId completion:^(BOOL success) {
            if (success) {
                comment.likesCount--;
                [weakCell animateDislikeButton:comment.likesCount];
            }
        }];
    }
}

#pragma mark - <PGCommentInputAccessoryViewDelegate>

- (void)sendComment:(NSString *)comment
{
    if (comment.length > 0) {
        PGWeakSelf(self);
        [self showLoading];
        if (!self.selectedComment) {
            [self.viewModel sendComment:comment completion:^(BOOL success) {
                if (success) {
                    [weakself.commentInputAccessoryView.commentTextView resignFirstResponder];
                    [weakself showToast:@"评论成功"];
                }
                weakself.selectedComment = nil;
                [weakself dismissLoading];
            }];
        } else {
            [self.viewModel sendReplyComment:comment commentId:self.selectedComment.commentId completion:^(BOOL success) {
                if (success) {
                    [weakself.commentInputAccessoryView.commentTextView resignFirstResponder];
                    [weakself showToast:@"回复成功"];
                } else {
                    [weakself showToast:@"回复失败"];
                }
                weakself.selectedComment = nil;
                [weakself dismissLoading];
            }];
        }
    } else {
        [self showToast:@"回复内容不能为空"];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView scrollViewShouldUpdateHeaderView];
    
    if (scrollView.contentOffset.y >= UISCREEN_WIDTH*9/16) {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor whiteColor];
        }
        if (!self.statusbarIsWhiteBackground) {
            self.statusbarIsWhiteBackground = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            self.statusbarIsWhiteBackground = YES;
        }
    } else {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor clearColor];
        }
        if (self.statusbarIsWhiteBackground) {
            self.statusbarIsWhiteBackground = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            self.statusbarIsWhiteBackground = NO;
        }
    }
    
    self.selectedComment = nil;
    [self.commentInputAccessoryView.commentTextView resignFirstResponder];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.shouldShowCommentInput) {
        [self.commentInputAccessoryView.commentTextView setText:nil];
        [self.commentInputAccessoryView.commentTextView becomeFirstResponder];
    }
    self.shouldShowCommentInput = NO;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    PGWeakSelf(self);
    [UIView animateWithDuration:animationDuration animations:^{
        if (beginFrame.origin.y >= endFrame.origin.y) {
            // move up
            weakself.commentInputAccessoryView.frame = CGRectMake(weakself.commentInputAccessoryView.pg_x, endFrame.origin.y-60, weakself.commentInputAccessoryView.pg_width, weakself.commentInputAccessoryView.pg_height);
        } else {
            // move down
            weakself.commentInputAccessoryView.frame = CGRectMake(weakself.commentInputAccessoryView.pg_x, endFrame.origin.y, weakself.commentInputAccessoryView.pg_width, weakself.commentInputAccessoryView.pg_height);
        }
    }];
}

#pragma mark - <Load Comments>

- (void)loadComments
{
    if (self.viewModel.commentsArray.count == 0) {
        [self.viewModel requestComments];
    } else {
        [self.articleCollectionView endBottomRefreshing];
    }
}

#pragma mark - <Button Events>

- (void)backButtonClicked
{
    [super backButtonClicked];
    
    if (self.animationCompletion) {
        self.animationCompletion();
    }
}

- (void)likeButtonClicked
{
    if (PGGlobal.userId && PGGlobal.userId.length > 0) {
        if (self.likeButton.tag == 0) {
//            [self showLoading];
            [self.viewModel likeArticle];
        } else {
//            [self showLoading];
            [self.viewModel dislikeArticle];
        }
    } else {
        [PGRouterManager routeToLoginPage];
    }
}

- (void)collectButtonClicked
{
    if (PGGlobal.userId && PGGlobal.userId.length > 0) {
        if (self.collectButton.tag == 0) {
//            [self showLoading];
            [self.viewModel collectArticle];
        } else {
//            [self showLoading];
            [self.viewModel discollectArticle];
        }
    } else {
        [PGRouterManager routeToLoginPage];
    }
}

- (void)shareButtonClicked
{
    PGShareAttribute *attribute = [[PGShareAttribute alloc] init];
    attribute.url = self.viewModel.article.shareUrl;
    attribute.text = @"测试分享";
    attribute.title = self.viewModel.article.title;
    attribute.image = self.viewModel.article.image;
    attribute.thumbnailImage = self.viewModel.article.image;
    attribute.shareViewImage = self.headerImageView.image;
    
    NSArray *dates = [self.viewModel.article.date componentsSeparatedByString:@"/"];
    if (dates.count == 3) {
        attribute.year = dates[0];
        attribute.day = dates[2];
        
        NSString *month = dates[1];
        if ([month isEqualToString:@"1"]) {
            attribute.month = @"JAN.";
        } else if ([month isEqualToString:@"2"]) {
            attribute.month = @"FEB.";
        } else if ([month isEqualToString:@"3"]) {
            attribute.month = @"MAR.";
        } else if ([month isEqualToString:@"4"]) {
            attribute.month = @"APR.";
        } else if ([month isEqualToString:@"5"]) {
            attribute.month = @"MAY.";
        } else if ([month isEqualToString:@"6"]) {
            attribute.month = @"JUN.";
        } else if ([month isEqualToString:@"7"]) {
            attribute.month = @"JUL.";
        } else if ([month isEqualToString:@"8"]) {
            attribute.month = @"AUG.";
        } else if ([month isEqualToString:@"9"]) {
            attribute.month = @"SEP.";
        } else if ([month isEqualToString:@"10"]) {
            attribute.month = @"OCT.";
        } else if ([month isEqualToString:@"11"]) {
            attribute.month = @"NOV.";
        } else if ([month isEqualToString:@"12"]) {
            attribute.month = @"DEC.";
        }
    }
    
    PGShareViewController *shareVC = [[PGShareViewController alloc] initWithShareAttribute:attribute];
    
    [self presentViewController:shareVC animated:YES completion:nil];
}

- (void)commentButtonClicked
{
    if (PGGlobal.userId && PGGlobal.userId.length > 0) {
        self.shouldShowCommentInput = YES;
        
        if (self.articleCollectionView.contentOffset.y+self.articleCollectionView.pg_height+1 >= self.articleCollectionView.contentSize.height) {
            [self.commentInputAccessoryView.commentTextView becomeFirstResponder];
            self.shouldShowCommentInput = NO;
        } else {
            if (self.viewModel.commentsArray.count > 0) {
                [self.articleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.commentsArray.count-1 inSection:2] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
            } else if (self.viewModel.article.relatedArticlesArray.count > 0) {
                [self.articleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
            } else if (self.viewModel.paragraphsArray.count > 0) {
                [self.articleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.paragraphsArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
            }
        }
    } else {
        [PGRouterManager routeToLoginPage];
    }
}

- (void)allCommentsButtonClicked
{
    PGCommentsViewController *commentsVC = [[PGCommentsViewController alloc] init];
    commentsVC.articleId = self.articleId;
    [self.navigationController pushViewController:commentsVC animated:YES];
}

#pragma mark - <Calculate Text Cell Size>

- (CGSize)textSize:(NSAttributedString *)attrS
{
    @autoreleasepool {
        // NOTE: calculate NSAttributedString size http://stackoverflow.com/questions/13621084/boundingrectwithsize-for-nsattributedstring-returning-wrong-size, https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/TextLayout/Tasks/StringHeight.html
        // NOTE: counting NSAttributedString number of lines https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/TextLayout/Tasks/CountLines.html
        if (attrS) {
            CGSize textSize = [PGArticleParagraphTextLabel sizeWithWidth:UISCREEN_WIDTH attriStr:attrS];
            
            return CGSizeMake(UISCREEN_WIDTH, ceil(textSize.height+15));
        }
        return CGSizeZero;
    }
}

#pragma mark - <Setters && Getters>

- (PGBaseCollectionView *)articleCollectionView
{
    if (!_articleCollectionView) {
        _articleCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-50) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _articleCollectionView.dataSource = self;
        _articleCollectionView.delegate = self;
        _articleCollectionView.contentSize = CGSizeMake(UISCREEN_WIDTH, UISCREEN_HEIGHT+300);
        _articleCollectionView.backgroundColor = [UIColor clearColor];
        
        [_articleCollectionView registerClass:[PGArticleParagraphInfoCell class] forCellWithReuseIdentifier:ArticleParagraphInfoCell];
        [_articleCollectionView registerClass:[PGArticleParagraphTextCell class] forCellWithReuseIdentifier:ArticleParagraphTextCell];
        [_articleCollectionView registerClass:[PGArticleParagraphImageCell class] forCellWithReuseIdentifier:ArticleParagraphImageCell];
        [_articleCollectionView registerClass:[PGArticleParagraphGIFImageCell class] forCellWithReuseIdentifier:ArticleParagraphGIFImageCell];
        [_articleCollectionView registerClass:[PGArticleParagraphCatalogImageCell class] forCellWithReuseIdentifier:ArticleParagraphCatalogImageCell];
        [_articleCollectionView registerClass:[PGArticleParagraphVideoCell class] forCellWithReuseIdentifier:ArticleParagraphVideoCell];
        [_articleCollectionView registerClass:[PGArticleParagraphSingleGoodCell class] forCellWithReuseIdentifier:ArticleParagraphSingleGoodCell];
        [_articleCollectionView registerClass:[PGArticleParagraphGoodsCollectionCell class] forCellWithReuseIdentifier:ArticleParagraphGoodsCollectionCell];
        [_articleCollectionView registerClass:[PGArticleParagraphNewlineCell class] forCellWithReuseIdentifier:ArticleParagraphNewlineCell];
        [_articleCollectionView registerClass:[PGArticleParagraphFooterCell class] forCellWithReuseIdentifier:ArticleParagraphFooterCell];
        
        [_articleCollectionView registerClass:[PGArticleRelatedArticlesCell class] forCellWithReuseIdentifier:ArticleRelatedArticlesCell];
        
        [_articleCollectionView registerClass:[PGArticleCommentCell class] forCellWithReuseIdentifier:ArticleCommentCell];
        [_articleCollectionView registerClass:[PGArticleCommentReplyCell class] forCellWithReuseIdentifier:ArticleCommentReplyCell];
        [_articleCollectionView registerClass:[PGArticleCommentsFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ArticleCommentsFooterView];
    }
    return _articleCollectionView;
}

- (UIView *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT-50, UISCREEN_WIDTH, 50)];
        _toolbar.backgroundColor = [UIColor whiteColor];
        
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 50)];
        [self.backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:self.backButton];
        
        self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-50, 0, 50, 50)];
        [self.likeButton setImage:[UIImage imageNamed:@"pg_article_like"] forState:UIControlStateNormal];
        [self.likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.likeButton setTag:0];
        [_toolbar addSubview:self.likeButton];
        
        self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(self.likeButton.pg_left-50, 0, 50, 50)];
        [self.commentButton setImage:[UIImage imageNamed:@"pg_article_comment"] forState:UIControlStateNormal];
        [self.commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:self.commentButton];
        
        self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.commentButton.pg_left-50, 0, 50, 50)];
        [self.collectButton setImage:[UIImage imageNamed:@"pg_article_collect"] forState:UIControlStateNormal];
        [self.collectButton addTarget:self action:@selector(collectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.collectButton setTag:0];
        [_toolbar addSubview:self.collectButton];
        
        self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(self.collectButton.pg_left-50, 0, 50, 50)];
        [self.shareButton setImage:[UIImage imageNamed:@"pg_article_share"] forState:UIControlStateNormal];
        [self.shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:self.shareButton];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
        horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
        [_toolbar addSubview:horizontalLine];
    }
    return _toolbar;
}

- (PGCommentInputAccessoryView *)commentInputAccessoryView
{
    if (!_commentInputAccessoryView) {
        _commentInputAccessoryView = [[PGCommentInputAccessoryView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT, UISCREEN_WIDTH, 60)];
        _commentInputAccessoryView.delegate = self;
    }
    return _commentInputAccessoryView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
