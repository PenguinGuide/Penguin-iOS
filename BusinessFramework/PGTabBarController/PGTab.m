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

- (void)drawRect:(CGRect)rect
{
    [self.tabLabel removeFromSuperview];
    [self.tabImageView removeFromSuperview];
    
    if (!self.selected) {
        self.tabLabel.font = [UIFont systemFontOfSize:10.f weight:UIFontWeightLight];
        self.tabLabel.text = self.tabTitle;
        self.tabLabel.textColor = [UIColor blackColor];
        UIImage *tabImage = [UIImage imageNamed:self.tabImage];
        self.tabImageView.image = tabImage;
        self.tabImageView.frame = CGRectMake(CGRectGetWidth(self.frame)/2-tabImage.size.width/2, self.tabLabel.frame.origin.y-8-tabImage.size.height, tabImage.size.width, tabImage.size.height);
    } else {
        self.tabLabel.font = [UIFont boldSystemFontOfSize:10.f];
        self.tabLabel.text = self.tabTitle;
        self.tabLabel.textColor = [UIColor colorWithRed:239.f/256.f green:103.f/256.f blue:51.f/256.f alpha:1.f];
        UIImage *tabHighlightImage = [UIImage imageNamed:self.tabHighlightImage];
        self.tabImageView.image = tabHighlightImage;
        self.tabImageView.frame = CGRectMake(CGRectGetWidth(self.frame)/2-tabHighlightImage.size.width/2, self.tabLabel.frame.origin.y-8-tabHighlightImage.size.height, tabHighlightImage.size.width, tabHighlightImage.size.height);
    }
    
    [self addSubview:self.tabLabel];
    [self addSubview:self.tabImageView];
}

- (UILabel *)tabLabel
{
    if (!_tabLabel) {
        int width = (int)(CGRectGetWidth(self.frame));
        if (width % 2 != 0) {
            width = width-1;
        }
        _tabLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-width/2.f, CGRectGetHeight(self.frame)-14, width, 10)];
        _tabLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tabLabel;
}

- (UIImageView *)tabImageView
{
    if (!_tabImageView) {
        _tabImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-20)];
        _tabImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tabImageView.clipsToBounds = NO;
    }
    return _tabImageView;
}

@end
