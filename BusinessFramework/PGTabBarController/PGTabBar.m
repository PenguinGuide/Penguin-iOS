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

@end

@implementation PGTabBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)setTabs:(NSArray *)tabs
{
    if (![tabs isEqual:_tabs]) {
        _tabs = tabs;
        
        for (PGTab *tab in tabs) {
            [tab removeFromSuperview];
        }
        
        [self setNeedsLayout];
    }
}

// 该函数只会进行位置，视图大小的数字计算，并不会引起屏幕的绘制
- (void)layoutSubviews
{
    float tabWidth = CGRectGetWidth(self.frame) / _tabs.count;
    
    for (int i = 0; i < _tabs.count; i++) {
        PGTab *tab = _tabs[i];
        tab.frame = CGRectMake(i*tabWidth, 0, tabWidth, CGRectGetHeight(self.frame));
        [tab addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tab];
    }
}

- (void)tabClicked:(id)sender
{
    
}

@end
