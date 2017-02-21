//
//  PGArticleNoCommentsFooterView.m
//  Penguin
//
//  Created by Kobe Dai on 21/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGArticleNoCommentsFooterView.h"

@interface PGArticleNoCommentsFooterView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation PGArticleNoCommentsFooterView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    [self addSubview:self.imageView];
    [self addSubview:self.label];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.pg_width-132)/2, 50, 132, 90)];
        _imageView.image = [UIImage imageNamed:@"pg_article_no_comments_footer"];
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.pg_bottom+50, self.pg_width, 16)];
        _label.text = @"还没有评论，还来吐槽！";
        _label.font = Theme.fontMediumBold;
        _label.textColor = Theme.colorText;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
