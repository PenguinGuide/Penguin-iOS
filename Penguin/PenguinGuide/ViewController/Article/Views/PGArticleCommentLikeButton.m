//
//  PGArticleCommentLikeButton.m
//  Penguin
//
//  Created by Jing Dai on 24/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleCommentLikeButton.h"

@implementation PGArticleCommentLikeButton

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
    [self setImage:[UIImage imageNamed:@"pg_article_comment_like"] forState:UIControlStateNormal];
    [self setTitleColor:Theme.colorLightText forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"pg_article_comment_liked"] forState:UIControlStateSelected];
    [self setTitleColor:Theme.colorRed forState:UIControlStateSelected];
    [self.titleLabel setFont:Theme.fontSmallBold];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(15, (contentRect.size.height-22)/2, 16, 22);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(33, 0, contentRect.size.width-33, contentRect.size.height);
}

@end