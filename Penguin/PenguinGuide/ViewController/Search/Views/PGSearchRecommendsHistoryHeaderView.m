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
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.pg_width-20-100, horizontalView.pg_bottom+10, 100, 30)];
    deleteButton.eventName = search_history_delete_button_clicked;
    deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [deleteButton setImage:[UIImage imageNamed:@"pg_search_history_delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
}

- (void)deleteButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(historyDeleteButtonClicked)]) {
        [self.delegate historyDeleteButtonClicked];
    }
}

@end
