//
//  PGArticleCommentsFooterView.m
//  Penguin
//
//  Created by Jing Dai on 11/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleCommentsFooterView.h"
#import "PGDashedLineView.h"

@interface PGArticleCommentsFooterView ()

@end

@implementation PGArticleCommentsFooterView

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
    PGDashedLineView *dashedLine = [[PGDashedLineView alloc] initWithFrame:CGRectMake(30, 20, self.pg_width-60, 2)];
    dashedLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:dashedLine];
    [self addSubview:self.allCommentsButton];
}

- (UIButton *)allCommentsButton
{
    if (!_allCommentsButton) {
        _allCommentsButton = [[UIButton alloc] initWithFrame:CGRectMake(84, 45, UISCREEN_WIDTH-84*2, 36)];
        _allCommentsButton.clipsToBounds = YES;
        _allCommentsButton.layer.cornerRadius = 18.f;
        _allCommentsButton.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _allCommentsButton.layer.borderColor = Theme.colorText.CGColor;
        [_allCommentsButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [_allCommentsButton.titleLabel setFont:Theme.fontMedium];
        [_allCommentsButton setTitle:@"查看所有评论" forState:UIControlStateNormal];
    }
    return _allCommentsButton;
}

@end
