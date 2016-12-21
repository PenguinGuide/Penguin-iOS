//
//  PGSearchRecommendsHistoryHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchRecommendsHistoryHeaderView.h"

@implementation PGSearchRecommendsHistoryHeaderView

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
    UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, UISCREEN_WIDTH-40, 1/[UIScreen mainScreen].scale)];
    horizontalView.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    [self addSubview:horizontalView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, horizontalView.pg_bottom+10, 100, 30)];
    label.text = @"历史记录";
    label.textColor = Theme.colorText;
    label.font = Theme.fontExtraLargeBold;
    [self addSubview:label];
}

@end
