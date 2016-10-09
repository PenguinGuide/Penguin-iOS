//
//  PGArticleCommentReplyCell.m
//  Penguin
//
//  Created by Jing Dai on 21/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleCommentReplyCell.h"

@interface PGArticleCommentReplyCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *avatarMaskImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *replyLabel;

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
    [self.contentView addSubview:self.replyLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentLabel];
}

- (void)setCellWithComment:(PGComment *)comment
{
    [self.avatarImageView setWithImageURL:comment.user.avatar placeholder:nil completion:nil];
    self.nameLabel.text = comment.user.nickname;
    self.timeLabel.text = comment.time;
    self.replyLabel.text = [NSString stringWithFormat:@"回复%@:", comment.replyTo];
    
    CGSize nameSize = [comment.user.nickname sizeWithAttributes:@{NSFontAttributeName:Theme.fontSmall}];
    self.nameLabel.pg_width = nameSize.width;
    self.replyLabel.frame = CGRectMake(self.nameLabel.pg_right+5, self.replyLabel.pg_top, self.pg_width-self.replyLabel.pg_left-10, self.replyLabel.pg_height);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 5.f;
    NSAttributedString *commentsStr = [[NSAttributedString alloc] initWithString:comment.reply attributes:@{NSFontAttributeName:Theme.fontSmall,
                                                                                                            NSForegroundColorAttributeName:Theme.colorText,
                                                                                                            NSParagraphStyleAttributeName:paragraphStyle}];
    self.commentLabel.attributedText = commentsStr;
    
    CGSize textSize = [comment.reply boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-69-25, 1000)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:Theme.fontSmall, NSParagraphStyleAttributeName:paragraphStyle}
                                                  context:nil].size;
    self.commentLabel.pg_height = textSize.height+5;
}

+ (CGSize)cellSize:(PGComment *)comment
{
    if (comment.reply && comment.reply.length > 0) {
        CGFloat height = 42+15;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 5.f;
        CGSize textSize = [comment.reply boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-69-25, 1000)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:Theme.fontSmall, NSParagraphStyleAttributeName:paragraphStyle}
                                                      context:nil].size;
        height = height + textSize.height+5;
        
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

#pragma mark - <Setters && Getters>

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(62, 0, 30, 30)];
        _avatarImageView.backgroundColor = Theme.colorText;
    }
    return _avatarImageView;
}

- (UIImageView *)avatarMaskImageView
{
    if (!_avatarMaskImageView) {
        _avatarMaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(62, 0, 30, 30)];
        _avatarMaskImageView.image = [[UIImage imageNamed:@"pg_avatar_white_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    }
    return _avatarMaskImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.avatarImageView.pg_right+12, 1, 50, 14)];
        _nameLabel.font = Theme.fontSmall;
        _nameLabel.textColor = Theme.colorText;
    }
    return _nameLabel;
}

- (UILabel *)replyLabel
{
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.pg_right+5, 1, 50, 14)];
        _replyLabel.font = Theme.fontSmall;
        _replyLabel.textColor = Theme.colorExtraHighlight;
    }
    return _replyLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.avatarImageView.pg_right+12, self.nameLabel.pg_bottom+2, 100, 12)];
        _timeLabel.font = Theme.fontExtraSmall;
        _timeLabel.textColor = Theme.colorLightText;
    }
    return _timeLabel;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, self.avatarImageView.pg_bottom+15, self.pg_width-69-25, 0)];
        _commentLabel.numberOfLines = 0;
        _commentLabel.font = Theme.fontSmall;
        _commentLabel.textColor = Theme.colorText;
        _commentLabel.userInteractionEnabled = YES;
    }
    return _commentLabel;
}

@end
