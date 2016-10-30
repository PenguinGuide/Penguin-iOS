//
//  PGCommentsViewController.m
//  Penguin
//
//  Created by Jing Dai on 11/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ArticleCommentCell @"ArticleCommentCell"
#define ArticleCommentReplyCell @"ArticleCommentReplyCell"

#import "PGCommentsViewController.h"
//#import "PGCommentsViewModel.h"
#import "PGArticleCommentCell.h"
#import "PGArticleCommentReplyCell.h"
#import "PGCommentInputAccessoryView.h"

@interface PGCommentsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGArticleCommentCellDelegate, PGArticleCommentReplyCellDelegate, PGCommentInputAccessoryViewDelegate>

@property (nonatomic, strong) PGBaseCollectionView *commentsCollectionView;
@property (nonatomic, strong) PGCommentInputAccessoryView *commentInputAccessoryView;

@property (nonatomic, strong) PGCommentsViewModel *viewModel;

@property (nonatomic, strong) PGComment *selectedComment;

@end

@implementation PGCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setNavigationTitle:@"所有评论"];
    
    [self.view addSubview:self.commentsCollectionView];
    [self.view addSubview:self.commentInputAccessoryView];
    
    self.viewModel = [[PGCommentsViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"commentsArray" block:^(id changedObject) {
        NSArray *commentsArray = changedObject;
        if (commentsArray && [commentsArray isKindOfClass:[NSArray class]]) {
            [weakself.commentsCollectionView reloadData];
        }
        [weakself dismissLoading];
        [weakself.commentsCollectionView endBottomRefreshing];
    }];
    [self observe:self.viewModel keyPath:@"error" block:^(id changedObject) {
        NSError *error = changedObject;
        if (error && [error isKindOfClass:[NSError class]]) {
            [weakself showErrorMessage:error];
            [weakself dismissLoading];
            [weakself.commentsCollectionView endBottomRefreshing];
        }
    }];
    [self observeCollectionView:self.commentsCollectionView endOfFeeds:self.viewModel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.viewModel.commentsArray) {
        [self showLoading];
        [self.viewModel requestComments:self.articleId];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unobserve];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.commentsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGComment *comment = self.viewModel.commentsArray[indexPath.item];
    if (!comment.replyComment) {
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

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGComment *comment = self.viewModel.commentsArray[indexPath.item];
    if (!comment.replyComment) {
        return [PGArticleCommentCell cellSize:comment];
    } else {
        return [PGArticleCommentReplyCell cellSize:comment];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.viewModel.endFlag) {
        return [PGBaseCollectionViewFooterView footerViewSize];
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.viewModel.commentsArray.count > 0) {
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
        
        return footerView;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if ([cell isKindOfClass:[PGArticleCommentCell class]]) {
            PGArticleCommentCell *commentCell = (PGArticleCommentCell *)cell;
            [commentCell unselectLabel];
            
            if (indexPath.item < weakself.viewModel.commentsArray.count) {
                weakself.selectedComment = weakself.viewModel.commentsArray[indexPath.item];
                weakself.commentInputAccessoryView.commentTextView.text = @"";
                weakself.commentInputAccessoryView.commentTextView.placeholder = [NSString stringWithFormat:@"回复%@", weakself.selectedComment.user.nickname];
                
                [weakself.commentInputAccessoryView.commentTextView becomeFirstResponder];
            }
        } else if ([cell isKindOfClass:[PGArticleCommentReplyCell class]]) {
            PGArticleCommentReplyCell *replyCell = (PGArticleCommentReplyCell *)cell;
            [replyCell unselectLabel];
            
            if (indexPath.item < weakself.viewModel.commentsArray.count) {
                weakself.selectedComment = self.viewModel.commentsArray[indexPath.item];
                weakself.commentInputAccessoryView.commentTextView.text = @"";
                weakself.commentInputAccessoryView.commentTextView.placeholder = [NSString stringWithFormat:@"回复%@", weakself.selectedComment.user.nickname];
                
                [weakself.commentInputAccessoryView.commentTextView becomeFirstResponder];
            }
        }
    });
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[PGArticleCommentCell class]]) {
        PGArticleCommentCell *commentCell = (PGArticleCommentCell *)cell;
        [commentCell selectLabel];
    } else if ([cell isKindOfClass:[PGArticleCommentReplyCell class]]) {
        PGArticleCommentReplyCell *replyCell = (PGArticleCommentReplyCell *)cell;
        [replyCell selectLabel];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if ([cell isKindOfClass:[PGArticleCommentCell class]]) {
            PGArticleCommentCell *commentCell = (PGArticleCommentCell *)cell;
            [commentCell unselectLabel];
        } else if ([cell isKindOfClass:[PGArticleCommentReplyCell class]]) {
            PGArticleCommentReplyCell *replyCell = (PGArticleCommentReplyCell *)cell;
            [replyCell unselectLabel];
        }
    });
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
    NSIndexPath *indexPath = [self.commentsCollectionView indexPathForCell:cell];
    if (indexPath.item < self.viewModel.commentsArray.count) {
        PGComment *comment = self.viewModel.commentsArray[indexPath.item];
        if ([comment.user.userId isEqualToString:PGGlobal.userId]) {
            [alertController addActions:@[reportAction, deleteAction]];
        } else {
            [alertController addActions:@[reportAction]];
        }
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)commentLikeButtonClicked:(PGArticleCommentCell *)cell
{
    __block PGArticleCommentCell *weakCell = cell;
    
    NSIndexPath *indexPath = [self.commentsCollectionView indexPathForCell:cell];
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
    
    NSIndexPath *indexPath = [self.commentsCollectionView indexPathForCell:cell];
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
    NSIndexPath *indexPath = [self.commentsCollectionView indexPathForCell:cell];
    if (indexPath.item < self.viewModel.commentsArray.count) {
        PGComment *comment = self.viewModel.commentsArray[indexPath.item];
        if ([comment.user.userId isEqualToString:PGGlobal.userId]) {
            [alertController addActions:@[reportAction, deleteAction]];
        } else {
            [alertController addActions:@[reportAction]];
        }
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)commentReplyLikeButtonClicked:(PGArticleCommentReplyCell *)cell
{
    __block PGArticleCommentReplyCell *weakCell = cell;
    
    NSIndexPath *indexPath = [self.commentsCollectionView indexPathForCell:cell];
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
    
    NSIndexPath *indexPath = [self.commentsCollectionView indexPathForCell:cell];
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
                    weakself.selectedComment = nil;
                    [weakself.commentInputAccessoryView.commentTextView resignFirstResponder];
                    [weakself showToast:@"评论成功"];
                }
                [weakself dismissLoading];
            }];
        } else {
            [self.viewModel sendReplyComment:comment commentId:self.selectedComment.commentId completion:^(BOOL success) {
                if (success) {
                    weakself.selectedComment = nil;
                    [weakself.commentInputAccessoryView.commentTextView resignFirstResponder];
                    [weakself showToast:@"回复成功"];
                } else {
                    [weakself showToast:@"回复失败"];
                }
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
    self.selectedComment = nil;
    [self.commentInputAccessoryView.commentTextView resignFirstResponder];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    __block CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    __block CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    PGWeakSelf(self);
    [UIView animateWithDuration:animationDuration animations:^{
        if (beginFrame.origin.y >= endFrame.origin.y) {
            // move up
            weakself.commentInputAccessoryView.frame = CGRectMake(weakself.commentInputAccessoryView.pg_x, endFrame.origin.y-44, weakself.commentInputAccessoryView.pg_width, weakself.commentInputAccessoryView.pg_height);
        } else {
            // move down
            weakself.commentInputAccessoryView.frame = CGRectMake(weakself.commentInputAccessoryView.pg_x, endFrame.origin.y, weakself.commentInputAccessoryView.pg_width, weakself.commentInputAccessoryView.pg_height);
        }
    }];
}

#pragma mark - <Setters && Getters>

- (PGBaseCollectionView *)commentsCollectionView
{
    if (!_commentsCollectionView) {
        _commentsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _commentsCollectionView.dataSource = self;
        _commentsCollectionView.delegate = self;
        
        [_commentsCollectionView registerClass:[PGArticleCommentCell class] forCellWithReuseIdentifier:ArticleCommentCell];
        [_commentsCollectionView registerClass:[PGArticleCommentReplyCell class] forCellWithReuseIdentifier:ArticleCommentReplyCell];
        
        PGWeakSelf(self);
        [_commentsCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel loadNextPage];
        }];
    }
    return _commentsCollectionView;
}

- (PGCommentInputAccessoryView *)commentInputAccessoryView
{
    if (!_commentInputAccessoryView) {
        _commentInputAccessoryView = [[PGCommentInputAccessoryView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT, UISCREEN_WIDTH, 44)];
        _commentInputAccessoryView.delegate = self;
    }
    return _commentInputAccessoryView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
