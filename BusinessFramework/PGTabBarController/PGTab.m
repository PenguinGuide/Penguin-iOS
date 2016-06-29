//
//  PGTab.m
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTab.h"

@interface PGTab ()

@property (nonatomic, strong) UILabel *tabLabel;
@property (nonatomic, strong) UIImageView *tabImageView;

@end

@implementation PGTab

#pragma mark - <Setters && Getters>

- (UILabel *)tabLabel
{
    if (!_tabLabel) {
        _tabLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, CGRectGetWidth(self.frame), 14)];
        _tabLabel.font = [UIFont systemFontOfSize:14.f];
        _tabLabel.textColor = [UIColor blackColor];
    }
}

- (UIImageView *)tabImageView
{
    if (!_tabImageView) {
        _tabImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-20)];
        _tabImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tabImageView.clipsToBounds = NO;
    }
}

- (void)drawRect:(CGRect)rect
{
    [self.tabLabel removeFromSuperview];
    [self.tabImageView removeFromSuperview];
    
    [self addSubview:self.tabLabel];
    [self addSubview:self.tabImageView];
    
    if (!self.selected) {
        self.tabLabel.text = self.tabTitle;
        self.tabImageView.image = self.tabImage;
    }
}

@end
