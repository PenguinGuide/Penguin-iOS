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
#define ArticleParagraphFooterCell @"ArticleParagraphFooterCell"
#define ArticleRelatedArticlesCell @"ArticleRelatedArticlesCell"
#define ArticleCommentCell @"ArticleCommentCell"
#define ArticleCommentReplyCell @"ArticleCommentReplyCell"

#import "PGArticleViewController.h"
#import "UIScrollView+PGScrollView.h"
#import "PGAlertController.h"
#import "PGVideoPlayerViewController.h"

// views
#import "PGArticleParagraphInfoCell.h"
#import "PGArticleParagraphTextCell.h"
#import "PGArticleParagraphImageCell.h"
#import "PGArticleParagraphGIFImageCell.h"
#import "PGArticleParagraphCatalogImageCell.h"
#import "PGArticleParagraphVideoCell.h"
#import "PGArticleParagraphFooterCell.h"
#import "PGArticleRelatedArticlesCell.h"
#import "PGArticleCommentCell.h"
#import "PGArticleCommentReplyCell.h"
#import "PGCommentInputAccessoryView.h"

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

@property (nonatomic, copy) void(^animationCompletion)();
@property (nonatomic, assign) BOOL animated;

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
    [self.view addSubview:self.commentInputAccessoryView];
    [self.view addSubview:self.toolbar];
    
    if (self.animated) {
        self.articleCollectionView.alpha = 0.f;
    }
    
    self.viewModel = [[PGArticleViewModel alloc] initWithAPIClient:self.apiClient];
    self.viewModel.articleId = self.articleId;
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*9/16)];
    self.headerImageView.backgroundColor = Theme.colorText;
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"article" block:^(id changedObject) {
        PGArticle *article = changedObject;
        if (article && [article isKindOfClass:[PGArticle class]]) {
            [weakself.headerImageView setWithImageURL:weakself.viewModel.article.image placeholder:nil completion:nil];
            [weakself.articleCollectionView setHeaderView:weakself.headerImageView naviTitle:weakself.viewModel.article.title rightNaviButton:nil];
            
            if (article.body && article.body.length > 0) {
                PGStringParser *htmlParser = [PGStringParser htmlParserWithString:article.body];
                weakself.viewModel.paragraphsArray = [htmlParser articleParsedStorages];
                
                [weakself.articleCollectionView reloadData];
                
                weakself.articleCollectionView.frame = CGRectMake(0, UISCREEN_HEIGHT-300, weakself.articleCollectionView.pg_width, self.articleCollectionView.pg_height);
                weakself.articleCollectionView.alpha = 0.f;
                [UIView animateWithDuration:0.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseOut
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
            [weakself dismissLoading];
        }
    }];
    [self observe:self.viewModel keyPath:@"commentsArray" block:^(id changedObject) {
        NSArray *comments = changedObject;
        if (comments && [comments isKindOfClass:[NSArray class]]) {
            [weakself.articleCollectionView reloadData];
            [weakself.articleCollectionView endBottomRefreshing];
        }
    }];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)animateCollectionView:(void (^)())completion
{
    self.animationCompletion = completion;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.viewModel.article == nil) {
        [self showLoading];
        [self.viewModel requestData];
    }
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unobserve];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
            }
        }
    } else if (indexPath.section == 1) {
        PGArticleRelatedArticlesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleRelatedArticlesCell forIndexPath:indexPath];
        [cell setCellWithDataArray:self.viewModel.article.relatedArticlesArray];
        
        return cell;
    } else if (indexPath.section == 2) {
        PGComment *comment = self.viewModel.commentsArray[indexPath.item];
        if (comment.comment.length > 0) {
            PGArticleCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCommentCell forIndexPath:indexPath];
            cell.delegate = self;
            
            [cell setCellWithComment:comment];
            
            return cell;
        } else {
            PGArticleCommentReplyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCommentReplyCell forIndexPath:indexPath];
            cell.delegate = self;
            
            [cell setCellWithComment:comment];
            
            return cell;
        }
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
                CGSize textSize = [textStorage.text boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-60, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                return CGSizeMake(UISCREEN_WIDTH, textSize.height);
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
            }
        }
    } else if (indexPath.section == 1) {
        return [PGArticleRelatedArticlesCell cellSize];
    } else if (indexPath.section == 2) {
        PGComment *comment = self.viewModel.commentsArray[indexPath.item];
        if (comment.comment.length > 0) {
            return [PGArticleCommentCell cellSize:comment];
        } else {
            return [PGArticleCommentReplyCell cellSize:comment];
        }
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        id storage = self.viewModel.paragraphsArray[indexPath.item-1];
        if ([storage isKindOfClass:[PGParserVideoStorage class]]) {
            PGVideoPlayerViewController *playerViewController = [[PGVideoPlayerViewController alloc] init];
            [self.navigationController pushViewController:playerViewController animated:YES];
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
    PGWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (indexPath.section == 2) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            if ([cell isKindOfClass:[PGArticleCommentCell class]]) {
                PGArticleCommentCell *commentCell = (PGArticleCommentCell *)cell;
                [commentCell unselectLabel];
                
                if (indexPath.item < weakself.viewModel.commentsArray.count) {
                    PGComment *selectedComment = weakself.viewModel.commentsArray[indexPath.item];
                    weakself.commentInputAccessoryView.commentTextView.text = @"";
                    weakself.commentInputAccessoryView.commentTextView.placeholder = [NSString stringWithFormat:@"回复%@", selectedComment.user.nickname];
                    
                    [weakself.commentInputAccessoryView.commentTextView becomeFirstResponder];
                }
            } else if ([cell isKindOfClass:[PGArticleCommentReplyCell class]]) {
                PGArticleCommentReplyCell *replyCell = (PGArticleCommentReplyCell *)cell;
                [replyCell unselectLabel];
                
                if (indexPath.item < weakself.viewModel.commentsArray.count) {
                    PGComment *selectedComment = self.viewModel.commentsArray[indexPath.item];
                    weakself.commentInputAccessoryView.commentTextView.text = @"";
                    weakself.commentInputAccessoryView.commentTextView.placeholder = [NSString stringWithFormat:@"回复%@", selectedComment.user.nickname];
                    
                    [weakself.commentInputAccessoryView.commentTextView becomeFirstResponder];
                }
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
    PGAlertAction *reportAction = [PGAlertAction actionWithTitle:@"举报"
                                                           style:^(PGAlertActionStyle *style) {
                                                               
                                                           } handler:^{
                                                               
                                                           }];
    PGAlertAction *deleteAction = [PGAlertAction actionWithTitle:@"删除"
                                                           style:^(PGAlertActionStyle *style) {
                                                               style.type = PGAlertActionTypeDestructive;
                                                           } handler:^{
                                                               
                                                           }];
    PGAlertController *alertController = [PGAlertController alertControllerWithTitle:nil message:nil style:^(PGAlertStyle *style) {
        style.alertType = PGAlertTypeActionSheet;
    }];
    [alertController addActions:@[reportAction, deleteAction]];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - <PGArticleCommentReplyCellDelegate>

#pragma mark - <PGCommentInputAccessoryViewDelegate>

- (void)sendComment:(NSString *)comment
{
    if (comment.length > 0) {
        [self.commentInputAccessoryView.commentTextView resignFirstResponder];
        [self showToast:@"发送成功" position:PGToastPositionTop];
    } else {
        [self showToast:@"回复内容不能为空" position:PGToastPositionTop];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView scrollViewShouldUpdateHeaderView];
    
    [self.commentInputAccessoryView.commentTextView resignFirstResponder];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    PGWeakSelf(self);
    [UIView animateWithDuration:animationDuration animations:^{
        weakself.commentInputAccessoryView.frame = CGRectMake(weakself.commentInputAccessoryView.pg_x, endFrame.origin.y-44, weakself.commentInputAccessoryView.pg_width, weakself.commentInputAccessoryView.pg_height);
        [weakself.commentInputAccessoryView.commentTextView becomeFirstResponder];
    }];
}

#pragma mark - <Load Comments>

- (void)loadComments
{
    [self.viewModel requestComments];
}

#pragma mark - <Button Events>

- (void)backButtonClicked
{
    [super backButtonClicked];
    
    if (self.animationCompletion) {
        self.animationCompletion();
    }
}

#pragma mark - <Setters && Getters>

- (PGBaseCollectionView *)articleCollectionView
{
    if (!_articleCollectionView) {
        _articleCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-44) collectionViewLayout:[UICollectionViewFlowLayout new]];
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
        [_articleCollectionView registerClass:[PGArticleParagraphFooterCell class] forCellWithReuseIdentifier:ArticleParagraphFooterCell];
        
        [_articleCollectionView registerClass:[PGArticleRelatedArticlesCell class] forCellWithReuseIdentifier:ArticleRelatedArticlesCell];
        
        [_articleCollectionView registerClass:[PGArticleCommentCell class] forCellWithReuseIdentifier:ArticleCommentCell];
        [_articleCollectionView registerClass:[PGArticleCommentReplyCell class] forCellWithReuseIdentifier:ArticleCommentReplyCell];
        
        PGWeakSelf(self);
        [_articleCollectionView enableInfiniteScrolling:^{
            [weakself loadComments];
        }];
    }
    return _articleCollectionView;
}

- (UIView *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT-44, UISCREEN_WIDTH, 44)];
        _toolbar.backgroundColor = [UIColor whiteColor];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
        horizontalLine.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
        [_toolbar addSubview:horizontalLine];
        
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.backButton setImage:[UIImage imageNamed:@"pg_login_back"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:self.backButton];
        
        self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-44, 0, 44, 44)];
        [self.likeButton setImage:[UIImage imageNamed:@"pg_article_like"] forState:UIControlStateNormal];
        [_toolbar addSubview:self.likeButton];
        
        self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(self.likeButton.pg_left-44, 0, 44, 44)];
        [self.commentButton setImage:[UIImage imageNamed:@"pg_article_comment"] forState:UIControlStateNormal];
        [_toolbar addSubview:self.commentButton];
        
        self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.commentButton.pg_left-44, 0, 44, 44)];
        [self.collectButton setImage:[UIImage imageNamed:@"pg_article_collect"] forState:UIControlStateNormal];
        [_toolbar addSubview:self.collectButton];
        
        self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(self.collectButton.pg_left-44, 0, 44, 44)];
        [self.shareButton setImage:[UIImage imageNamed:@"pg_article_share"] forState:UIControlStateNormal];
        [_toolbar addSubview:self.shareButton];
    }
    return _toolbar;
}

- (PGCommentInputAccessoryView *)commentInputAccessoryView
{
    if (!_commentInputAccessoryView) {
        _commentInputAccessoryView = [[PGCommentInputAccessoryView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT-44, UISCREEN_WIDTH, 44)];
        _commentInputAccessoryView.delegate = self;
    }
    return _commentInputAccessoryView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
