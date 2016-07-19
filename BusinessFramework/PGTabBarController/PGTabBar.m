//
//  PGTabBar.m
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTabBar.h"
#import "PGTab.h"

@interface PGTabBar ()

@property (nonatomic, strong, readwrite) NSArray *tabs;
@property (nonatomic) NSInteger selectedIndex;

@end

@implementation PGTabBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        self.userInteractionEnabled = YES;
        self.selectedIndex = 0;
    }
    
    return self;
}

- (void)setTabs:(NSArray *)tabs
{
    if (![tabs isEqual:_tabs]) {
        for (PGTab *tab in _tabs) {
            [tab removeFromSuperview];
        }
        
        _tabs = tabs;
        [self setNeedsLayout];
    }
}

// 该函数只会进行位置，视图大小的数字计算，并不会引起屏幕的绘制
- (void)layoutSubviews
{
    float tabWidth = CGRectGetWidth(self.frame) / _tabs.count;
    
    for (int i = 0; i < _tabs.count; i++) {
        PGTab *tab = _tabs[i];
        if (i == self.selectedIndex) {
            tab.selected = YES;
        } else {
            tab.selected = NO;
        }
        tab.frame = CGRectMake(i*tabWidth, 0, tabWidth, CGRectGetHeight(self.frame));
        [tab addTarget:self action:@selector(tabDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tab];
    }
}

- (void)tabDidSelected:(PGTab *)tab
{
    self.selectedIndex = [self.tabs indexOfObject:tab];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarDidSelect:)]) {
        [self.delegate tabBarDidSelect:self.selectedIndex];
    }
}

@end
