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
#import "PGArticleCommentReplyCell.h"
#import "PGCommentInputAccessoryView.h"

#import "PGMessageViewModel.h"

@interface PGMessageContentViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGCommentInputAccessoryViewDelegate>

@property (nonatomic, assign) PGMessageContentType type;
@property (nonatomic, strong) PGBaseCollectionView *messagesCollectionView;
@property (nonatomic, strong) PGCommentInputAccessoryView *commentInputAccessoryView;
@property (nonatomic, strong) PGMessageViewModel *viewModel;
@property (nonatomic, strong) PGMessage *selectedMessage;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (self.type == PGMessageContentTypeSystem) {
        [self setNavigationTitle:@"系统消息"];
    } else if (self.type == PGMessageContentTypeReply) {
        [self setNavigationTitle:@"收到的回复"];
    } else if (self.type == PGMessageContentTypeLikes) {
        [self setNavigationTitle:@"收到的赞"];
    }
    
    [self.view addSubview:self.messagesCollectionView];
    [self.view addSubview:self.commentInputAccessoryView];
    
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
        } else if (self.type == PGMessageContentTypeLikes) {
            [self.viewModel requestLikesMessages];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unobserve];
}

#pragma mark - <UICollectionView>

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
    if (self.type == PGMessageContentTypeReply) {
        PGArticleCommentReplyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MessageCell forIndexPath:indexPath];
        
        PGMessage *message = self.viewModel.messages[indexPath.item];
        [cell setCellWithMessage:message.content];
        
        return cell;
    } else {
        PGMessageContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MessageCell forIndexPath:indexPath];
        
        PGMessage *message = self.viewModel.messages[indexPath.item];
        if (self.type == PGMessageContentTypeSystem) {
            [cell setCellWithMessage:message type:@"system"];
        } else if (self.type == PGMessageContentTypeLikes) {
            [cell setCellWithMessage:message type:@"likes"];
        }
        
        return cell;
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == PGMessageContentTypeReply) {
        PGMessage *message = self.viewModel.messages[indexPath.item];
        return [PGArticleCommentReplyCell messageCellSize:message.content];
    } else {
        return CGSizeMake(UISCREEN_WIDTH, 50);
    }
    return CGSizeMake(UISCREEN_WIDTH, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.type == PGMessageContentTypeReply) {
        return 15.f;
    } else {
        return 0.f;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.type == PGMessageContentTypeReply) {
        if (self.viewModel.messages.count > 0) {
            return UIEdgeInsetsMake(20, 0, 0, 0);
        }
    }
    return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == PGMessageContentTypeReply) {
        PGWeakSelf(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            PGArticleCommentReplyCell *replyCell = (PGArticleCommentReplyCell *)cell;
            [replyCell unselectLabel];
            
            if (indexPath.item < weakself.viewModel.messages.count) {
                weakself.selectedMessage = self.viewModel.messages[indexPath.item];
                weakself.commentInputAccessoryView.commentTextView.text = @"";
                weakself.commentInputAccessoryView.commentTextView.placeholder = [NSString stringWithFormat:@"回复%@", weakself.selectedMessage.content.nickname];
                
                [weakself.commentInputAccessoryView.commentTextView becomeFirstResponder];
            }
        });
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == PGMessageContentTypeReply) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        PGArticleCommentReplyCell *replyCell = (PGArticleCommentReplyCell *)cell;
        [replyCell selectLabel];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == PGMessageContentTypeReply) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            PGArticleCommentReplyCell *replyCell = (PGArticleCommentReplyCell *)cell;
            [replyCell unselectLabel];
        });
    }
}

#pragma mark - <PGCommentInputAccessoryViewDelegate>

- (void)sendComment:(NSString *)comment
{
    if (comment.length > 0) {
        PGWeakSelf(self);
        [self showLoading];
        if (self.selectedMessage) {
            [self.viewModel sendReplyComment:comment commentId:self.selectedMessage.content.replyId completion:^(BOOL success) {
                if (success) {
                    weakself.selectedMessage = nil;
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
    self.selectedMessage = nil;
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
            weakself.commentInputAccessoryView.frame = CGRectMake(weakself.commentInputAccessoryView.pg_x, endFrame.origin.y-60, weakself.commentInputAccessoryView.pg_width, weakself.commentInputAccessoryView.pg_height);
        } else {
            // move down
            weakself.commentInputAccessoryView.frame = CGRectMake(weakself.commentInputAccessoryView.pg_x, endFrame.origin.y, weakself.commentInputAccessoryView.pg_width, weakself.commentInputAccessoryView.pg_height);
        }
    }];
}

#pragma mark - <Setters && Getters>

- (PGBaseCollectionView *)messagesCollectionView
{
    if (!_messagesCollectionView) {
        _messagesCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _messagesCollectionView.backgroundColor = [UIColor whiteColor];
        _messagesCollectionView.dataSource = self;
        _messagesCollectionView.delegate = self;
        
        if (self.type == PGMessageContentTypeReply) {
            [_messagesCollectionView registerClass:[PGArticleCommentReplyCell class] forCellWithReuseIdentifier:MessageCell];
        } else {
            [_messagesCollectionView registerClass:[PGMessageContentCell class] forCellWithReuseIdentifier:MessageCell];
        }
    }
    return _messagesCollectionView;
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
