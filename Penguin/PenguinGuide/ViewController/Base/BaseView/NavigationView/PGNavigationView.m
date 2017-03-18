//
//  PGNavigationView.m
//  Penguin
//
//  Created by Jing Dai on 30/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGNavigationView.h"

@implementation PGNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-46)/2.f, 20+(44-21)/2.f, 46, 21)];
        iconImageView.image = [UIImage imageNamed:@"pg_home_logo"];
        [self addSubview:iconImageView];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 64-1/[UIScreen mainScreen].scale, UISCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
        horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
        [self addSubview:horizontalLine];
    }
    return self;
}

// NOTE: this pattern is great!!!
+ (PGNavigationView *)defaultNavigationView
{
    PGNavigationView *naviView = [[PGNavigationView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 64)];
    
    return naviView;
}

+ (PGNavigationView *)defaultNavigationViewWithSearchButton
{
    PGNavigationView *naviView = [[PGNavigationView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 64)];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-24-50, 31, 50, 50)];
    searchButton.eventName = search_button_clicked;
    [searchButton setImage:[UIImage imageNamed:@"pg_home_search_button"] forState:UIControlStateNormal];
    [searchButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [searchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [searchButton addTarget:naviView action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [naviView addSubview:searchButton];
    
    return naviView;
}

- (void)searchButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchButtonClicked)]) {
        [self.delegate searchButtonClicked];
    }
}

@end
