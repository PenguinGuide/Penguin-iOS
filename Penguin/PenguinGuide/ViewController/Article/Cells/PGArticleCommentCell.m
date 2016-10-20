//
//  PGArticleCommentCell.m
//  Penguin
//
//  Created by Jing Dai on 21/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleCommentCell.h"

@interface PGArticleCommentCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *avatarMaskImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *likeButton;
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
    
    [self.contentView addSubview:self.commentLabel];
}

- (void)setCellWithComment:(PGComment *)comment
{
    [self.avatarImageView setWithImageURL:comment.user.avatar placeholder:nil completion:nil];
    self.nameLabel.text = comment.user.nickname;
    self.timeLabel.text = comment.time;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 5.f;
    NSAttributedString *commentsStr = [[NSAttributedString alloc] initWithString:comment.content attributes:@{NSFontAttributeName:Theme.fontSmall,
                                                                                                              NSForegroundColorAttributeName:Theme.colorText,
                                                                                                              NSParagraphStyleAttributeName:paragraphStyle}];
    self.commentLabel.attributedText = commentsStr;
    
    CGSize textSize = [comment.content boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-26*2, 1000)
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
    if (comment.content && comment.content.length > 0) {
        CGFloat height = 42+15;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 5.f;
        CGSize textSize = [comment.content boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-26*2, 1000)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:Theme.fontSmall, NSParagraphStyleAttributeName:paragraphStyle}
                                                        context:nil].size;
        height = height + textSize.height+5;
        
        return CGSizeMake(UISCREEN_WIDTH, height);
    }
    return CGSizeZero;
}

- (void)moreButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentMoreButtonClicked:)]) {
        [self.delegate commentMoreButtonClicked:self];
    }
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

- (UIButton *)likeButton
{
    if (!_likeButton) {
        
    }
    return _likeButton;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.pg_width-30-20, 10, 20, 20)];
        [_moreButton setImage:[UIImage imageNamed:@"pg_article_comment_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, self.avatarImageView.pg_bottom+15, self.pg_width-52, 0)];
        _commentLabel.numberOfLines = 0;
        _commentLabel.font = Theme.fontSmall;
        _commentLabel.textColor = Theme.colorText;
        _commentLabel.userInteractionEnabled = YES;
    }
    return _commentLabel;
}

@end
