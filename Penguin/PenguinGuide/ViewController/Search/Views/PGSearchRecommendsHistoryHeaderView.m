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
    UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, UISCREEN_WIDTH-40, 1/[UIScreen mainScreen].scale)];
    horizontalView.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    [self addSubview:horizontalView];
    
    UIView *verticalView = [[UIView alloc] initWithFrame:CGRectMake(20, horizontalView.bottom+10, 3, 20)];
    verticalView.backgroundColor = Theme.colorExtraHighlight;
    [self addSubview:verticalView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(verticalView.right+5, horizontalView.bottom+10, 100, 20)];
    label.text = @"历史记录";
    label.textColor = Theme.colorText;
    label.font = Theme.fontMediumBold;
    [self addSubview:label];
}

@end
