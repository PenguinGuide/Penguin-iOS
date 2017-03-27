//
//  PGArticleCommentCell.m
//  Penguin
//
//  Created by Jing Dai on 21/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleCommentCell.h"
#import "PGArticleCommentLikeButton.h"

@interface PGArticleCommentCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *avatarMaskImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) PGArticleCommentLikeButton *likeButton;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation PGArticleCommentCell

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
    NSAttributedString *commentsStr = [[NSAttributedString alloc] initWithString:comment.content attributes:@{NSFontAttributeName:Theme.fontSmall,
                                                                                                              NSForegroundColorAttributeName:Theme.colorText,
                                                                                                              NSParagraphStyleAttributeName:paragraphStyle}];
    self.commentLabel.attributedText = commentsStr;
    
    CGSize textSize = [comment.content boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-30*2, 1000)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:Theme.fontSmall, NSParagraphStyleAttributeName:paragraphStyle}
                                                    context:nil].size;
    self.commentLabel.pg_height = textSize.height+5;
}

- (void)selectLabel
{
    [self.commentLabel setBackgroundColor:Theme.colorLightBackground];
}

- (void)unselectLabel
{
    [self.commentLabel setBackgroundColor:[UIColor whiteColor]];
}

+ (CGSize)cellSize:(PGComment *)comment
{
    // NOTE: 内存优化，将这份布局信息作为一个属性保存到对应的Model中: https://gold.xitu.io/post/58667d86128fe10057eae0d2
    if (CGSizeEqualToSize(comment.commentSize, CGSizeZero)) {
        if (comment.content && comment.content.length > 0) {
            CGFloat height = 42+15;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineSpacing = 5.f;
            CGSize textSize = [comment.content boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-30*2, 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:Theme.fontSmall, NSParagraphStyleAttributeName:paragraphStyle}
                                                            context:nil].size;
            height = height + textSize.height+5;
            
            comment.commentSize = CGSizeMake(UISCREEN_WIDTH, height);
            
            return comment.commentSize;
        }
    } else {
        return comment.commentSize;
    }

    return CGSizeZero;
}

- (void)moreButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentMoreButtonClicked:)]) {
        [self.delegate commentMoreButtonClicked:self];
    }
}

- (void)likeButtonClicked
{
    if (self.likeButton.tag == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(commentLikeButtonClicked:)]) {
            [self.delegate commentLikeButtonClicked:self];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(commentDislikeButtonClicked:)]) {
            [self.delegate commentDislikeButtonClicked:self];
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
        _avatarImageView.backgroundColor = Theme.colorBackground;
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

@end
