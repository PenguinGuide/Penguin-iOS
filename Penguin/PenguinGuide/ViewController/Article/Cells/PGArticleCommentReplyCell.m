//
//  PGArticleCommentReplyCell.m
//  Penguin
//
//  Created by Jing Dai on 21/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleCommentReplyCell.h"
#import "PGArticleCommentLikeButton.h"

@interface PGArticleCommentReplyCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *avatarMaskImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) PGArticleCommentLikeButton *likeButton;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UIImageView *replyLabelMaskView;

@end

@implementation PGArticleCommentReplyCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.avatarMaskImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.moreButton];
    [self.contentView addSubview:self.likeButton];
    
    [self.contentView addSubview:self.commentLabel];
    
    [self.contentView addSubview:self.replyLabel];
    [self.contentView addSubview:self.replyLabelMaskView];
}

- (void)setCellWithComment:(PGComment *)comment
{
    [self.avatarImageView setWithImageURL:comment.user.avatar placeholder:nil completion:nil];
    self.nameLabel.text = comment.user.nickname;
    self.timeLabel.text = comment.time;
    
    CGSize nameSize = [comment.user.nickname sizeWithAttributes:@{NSFontAttributeName:Theme.fontMediumBold}];
    self.nameLabel.pg_width = nameSize.width;
    
    // NOTE: set UIButton with image && title http://www.tuicool.com/articles/bIvyYvQ
    if (comment.likesCount > 0) {
        NSString *likesStr = [NSString stringWithFormat:@"%ld", (long)comment.likesCount];
        [self.likeButton setTitle:likesStr forState:UIControlStateNormal];
        CGSize likesSize = [likesStr sizeWithAttributes:@{NSFontAttributeName:Theme.fontSmallBold}];
        self.likeButton.frame = CGRectMake(self.moreButton.pg_left-(33+likesSize.width+15), 0, 33+likesSize.width+15, 40);
    } else {
        [self.likeButton setTitle:nil forState:UIControlStateNormal];
        self.likeButton.frame = CGRectMake(self.moreButton.pg_left-46, 0, 46, 40);
    }
    if (comment.liked) {
        self.likeButton.selected = YES;
        self.likeButton.tag = 1;
    } else {
        self.likeButton.selected = NO;
        self.likeButton.tag = 0;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 5.f;
    
    NSString *commentContent = @"";
    if (comment.replyDeleted) {
        commentContent = [NSString stringWithFormat:@"回复: %@", comment.content];
    } else {
        commentContent = [NSString stringWithFormat:@"回复%@: %@", comment.replyComment.user.nickname, comment.content];
    }
    NSMutableAttributedString *commentsStr = [[NSMutableAttributedString alloc] initWithString:commentContent];
    
    if (comment.replyDeleted) {
        [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, 4)];
        [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(4, comment.content.length)];
        [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(0, 4)];
        [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmall range:NSMakeRange(4, comment.content.length)];
        [commentsStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentContent.length)];
    } else {
        [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, 4+comment.replyComment.user.nickname.length)];
        [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(4+comment.replyComment.user.nickname.length, comment.content.length)];
        [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(0, 4+comment.replyComment.user.nickname.length)];
        [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmall range:NSMakeRange(4+comment.replyComment.user.nickname.length, comment.content.length)];
        [commentsStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentContent.length)];
    }
    self.commentLabel.attributedText = commentsStr;
    
    CGSize textSize = [commentContent boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-69-25, 1000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:Theme.fontSmall, NSParagraphStyleAttributeName:paragraphStyle}
                                                   context:nil].size;
    self.commentLabel.pg_height = textSize.height+5;
    
    self.replyLabel.frame = CGRectMake(30, self.commentLabel.pg_bottom+10, self.replyLabel.pg_width, self.replyLabel.pg_height);
    self.replyLabelMaskView.frame = CGRectMake(30, self.commentLabel.pg_bottom+10, self.replyLabel.pg_width, self.replyLabel.pg_height);
    
    NSString *replyContent = @"";
    if (comment.replyDeleted) {
        replyContent = @"    原评论已删除";
    } else {
        replyContent = [NSString stringWithFormat:@"    %@: %@", comment.replyComment.user.nickname, comment.replyComment.content];
    }
    NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:replyContent];
    if (comment.replyDeleted) {
        [attrS addAttribute:NSFontAttributeName value:Theme.fontSmall range:NSMakeRange(0, replyContent.length)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, replyContent.length)];
    } else {
        [attrS addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(0, 4+comment.replyComment.user.nickname.length+1)];
        [attrS addAttribute:NSFontAttributeName value:Theme.fontSmall range:NSMakeRange(4+comment.replyComment.user.nickname.length+1, comment.replyComment.content.length)];
        [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, replyContent.length)];
    }
    self.replyLabel.attributedText = attrS;
}

- (void)setCellWithMessage:(PGMessageContent *)message
{
    [self.avatarImageView setWithImageURL:message.avatar placeholder:nil completion:nil];
    self.nameLabel.text = message.nickname;
    self.timeLabel.text = @"刚刚";
    
    CGSize nameSize = [message.nickname sizeWithAttributes:@{NSFontAttributeName:Theme.fontMediumBold}];
    self.nameLabel.pg_width = nameSize.width;
    
    self.likeButton.hidden = YES;
    self.moreButton.hidden = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 5.f;
    
    NSString *nickname = @"你";
    NSString *commentContent = [NSString stringWithFormat:@"回复%@: %@", nickname, message.replyContent];
    NSMutableAttributedString *commentsStr = [[NSMutableAttributedString alloc] initWithString:commentContent];
    [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, 4+nickname.length)];
    [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(4+nickname.length, message.replyContent.length)];
    [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(0, 4+nickname.length)];
    [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmall range:NSMakeRange(4+nickname.length, message.replyContent.length)];
    [commentsStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentContent.length)];
    self.commentLabel.attributedText = commentsStr;
    
    CGSize textSize = [commentContent boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-69-25, 1000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:Theme.fontSmall, NSParagraphStyleAttributeName:paragraphStyle}
                                                   context:nil].size;
    self.commentLabel.pg_height = textSize.height+5;
    
    self.replyLabel.frame = CGRectMake(30, self.commentLabel.pg_bottom+10, self.replyLabel.pg_width, self.replyLabel.pg_height);
    self.replyLabelMaskView.frame = CGRectMake(30, self.commentLabel.pg_bottom+10, self.replyLabel.pg_width, self.replyLabel.pg_height);
    
    NSString *myNickname = @"我";
    NSString *replyContent = [NSString stringWithFormat:@"    %@: %@", myNickname, message.content];
    
    NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:replyContent];
    [attrS addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(0, 4+myNickname.length+1)];
    [attrS addAttribute:NSFontAttributeName value:Theme.fontSmall range:NSMakeRange(4+myNickname.length+1, message.content.length)];
    [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, replyContent.length)];
    
    self.replyLabel.attributedText = attrS;
}

+ (CGSize)cellSize:(PGComment *)comment
{
    if (CGSizeEqualToSize(comment.commentSize, CGSizeZero)) {
        if (comment.content && comment.content.length > 0) {
            CGFloat height = 42+15;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineSpacing = 5.f;
            
            NSString *commentContent = @"";
            if (comment.replyDeleted) {
                commentContent = [NSString stringWithFormat:@"回复: %@", comment.content];
            } else {
                commentContent = [NSString stringWithFormat:@"回复%@: %@", comment.replyComment.user.nickname, comment.content];
            }
            NSMutableAttributedString *commentsStr = [[NSMutableAttributedString alloc] initWithString:commentContent];
            
            if (comment.replyDeleted) {
                [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, 4)];
                [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(4, comment.content.length)];
                [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(0, 4)];
                [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmall range:NSMakeRange(4, comment.content.length)];
                [commentsStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentContent.length)];
            } else {
                [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, 4+comment.replyComment.user.nickname.length)];
                [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(4+comment.replyComment.user.nickname.length, comment.content.length)];
                [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(0, 4+comment.replyComment.user.nickname.length)];
                [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmall range:NSMakeRange(4+comment.replyComment.user.nickname.length, comment.content.length)];
                [commentsStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentContent.length)];
            }
            
            CGSize textSize = [commentsStr boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-69-25, 1000)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                        context:nil].size;
            
            height = height + textSize.height+5+10+40;
            
            comment.commentSize = CGSizeMake(UISCREEN_WIDTH, height);
            
            return comment.commentSize;
        }
    } else {
        return comment.commentSize;
    }

    return CGSizeZero;
}

+ (CGSize)messageCellSize:(PGMessageContent *)message
{
    if (message.replyContent && message.replyContent.length > 0) {
        CGFloat height = 42+15;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 5.f;
        NSString *nickname = @"你";
        NSString *commentContent = [NSString stringWithFormat:@"回复%@: %@", nickname, message.replyContent];
        NSMutableAttributedString *commentsStr = [[NSMutableAttributedString alloc] initWithString:commentContent];
        [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorHighlight range:NSMakeRange(0, 4+nickname.length)];
        [commentsStr addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(4+nickname.length, message.replyContent.length)];
        [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmallBold range:NSMakeRange(0, 4+nickname.length)];
        [commentsStr addAttribute:NSFontAttributeName value:Theme.fontSmall range:NSMakeRange(4+nickname.length, message.replyContent.length)];
        [commentsStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentContent.length)];
        CGSize textSize = [commentsStr boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-69-25, 1000)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil].size;
        
        height = height + textSize.height+5+10+40;
        
        return CGSizeMake(UISCREEN_WIDTH, height);
    }
    return CGSizeZero;
}

- (void)selectLabel
{
    [self.commentLabel setBackgroundColor:Theme.colorLightBackground];
}

- (void)unselectLabel
{
    [self.commentLabel setBackgroundColor:[UIColor whiteColor]];
}

- (void)moreButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentReplyMoreButtonClicked:)]) {
        [self.delegate commentReplyMoreButtonClicked:self];
    }
}

- (void)likeButtonClicked
{
    if (self.likeButton.tag == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(commentReplyLikeButtonClicked:)]) {
            [self.delegate commentReplyLikeButtonClicked:self];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(commentReplyDislikeButtonClicked:)]) {
            [self.delegate commentReplyDislikeButtonClicked:self];
        }
    }
}

- (void)animateLikeButton:(NSInteger)count
{
    NSString *likesStr = [NSString stringWithFormat:@"%ld", (long)count];
    [self.likeButton setTitle:likesStr forState:UIControlStateNormal];
    CGSize likesSize = [likesStr sizeWithAttributes:@{NSFontAttributeName:Theme.fontSmallBold}];
    self.likeButton.frame = CGRectMake(self.moreButton.pg_left-(33+likesSize.width+15), 0, 33+likesSize.width+15, 40);
    self.likeButton.selected = YES;
    self.likeButton.tag = 1;
}

- (void)animateDislikeButton:(NSInteger)count
{
    if (count == 0) {
        [self.likeButton setTitle:nil forState:UIControlStateNormal];
        self.likeButton.frame = CGRectMake(self.moreButton.pg_left-46, 0, 46, 40);
    } else {
        NSString *likesStr = [NSString stringWithFormat:@"%ld", (long)count];
        [self.likeButton setTitle:likesStr forState:UIControlStateNormal];
        CGSize likesSize = [likesStr sizeWithAttributes:@{NSFontAttributeName:Theme.fontSmallBold}];
        self.likeButton.frame = CGRectMake(self.moreButton.pg_left-(33+likesSize.width+15), 0, 33+likesSize.width+15, 40);
    }
    self.likeButton.selected = NO;
    self.likeButton.tag = 0;
}

#pragma mark - <Setters && Getters>

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 42, 42)];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.backgroundColor = Theme.colorText;
    }
    return _avatarImageView;
}

- (UIImageView *)avatarMaskImageView
{
    if (!_avatarMaskImageView) {
        _avatarMaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 42, 42)];
        _avatarMaskImageView.image = [[UIImage imageNamed:@"pg_avatar_white_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    }
    return _avatarMaskImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.avatarImageView.pg_right+12, 4, 150, 16)];
        _nameLabel.font = Theme.fontMediumBold;
        _nameLabel.textColor = Theme.colorText;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.avatarImageView.pg_right+12, self.nameLabel.pg_bottom+3, 100, 14)];
        _timeLabel.font = Theme.fontSmallBold;
        _timeLabel.textColor = Theme.colorLightText;
    }
    return _timeLabel;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.pg_width-49, 0, 49, 40)];
        [_moreButton setImage:[UIImage imageNamed:@"pg_article_comment_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _moreButton;
}

- (UIButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = [[PGArticleCommentLikeButton alloc] initWithFrame:CGRectMake(self.moreButton.pg_left-56, 0, 56, 40)];
        [_likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.avatarImageView.pg_bottom+15, self.pg_width-60, 0)];
        _commentLabel.numberOfLines = 0;
        _commentLabel.font = Theme.fontSmall;
        _commentLabel.textColor = Theme.colorText;
        _commentLabel.userInteractionEnabled = YES;
    }
    return _commentLabel;
}

- (UILabel *)replyLabel
{
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.commentLabel.pg_bottom+10, UISCREEN_WIDTH-30*2, 40)];
        _replyLabel.font = Theme.fontSmall;
        _replyLabel.backgroundColor = Theme.colorBackground;
        _replyLabel.textColor = Theme.colorText;
    }
    return _replyLabel;
}

- (UIImageView *)replyLabelMaskView
{
    if (!_replyLabelMaskView) {
        _replyLabelMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.commentLabel.pg_bottom+10, UISCREEN_WIDTH-30*2, 40)];
        _replyLabelMaskView.image = [[UIImage imageNamed:@"pg_bg_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    }
    return _replyLabelMaskView;
}

@end
