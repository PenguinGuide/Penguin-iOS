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
    }
    return self;
}

// NOTE: this pattern is great!!!
+ (PGNavigationView *)defaultNavigationView
{
    PGNavigationView *naviView = [[PGNavigationView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 64)];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 64-1/[UIScreen mainScreen].scale, UISCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    [naviView addSubview:horizontalLine];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-46)/2.f, 20+(44-21)/2.f, 46, 21)];
    iconImageView.image = [UIImage imageNamed:@"pg_home_logo"];
    [naviView addSubview:iconImageView];
    
    return naviView;
}

+ (PGNavigationView *)naviViewWithSearchButton
{
    PGNavigationView *naviView = [[PGNavigationView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 64)];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 64-1/[UIScreen mainScreen].scale, UISCREEN_WIDTH, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    [naviView addSubview:horizontalLine];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-46)/2.f, 20+(44-21)/2.f, 46, 21)];
    iconImageView.image = [UIImage imageNamed:@"pg_home_logo"];
    [naviView addSubview:iconImageView];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-24-50, 31, 50, 50)];
    searchButton.eventName = search_button_clicked;
    [searchButton setImage:[UIImage imageNamed:@"pg_home_search_button"] forState:UIControlStateNormal];
    [searchButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [searchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [searchButton addTarget:naviView action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [naviView addSubview:searchButton];
    
    return naviView;
}

+ (PGNavigationView *)naviViewWithShareButton
{
    PGNavigationView *naviView = [[PGNavigationView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 64)];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 64-1/[UIScreen mainScreen].scale, UISCREEN_WIDTH, SINGLE_LINE_HEIGHT)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    [naviView addSubview:horizontalLine];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"pg_article_back_button"] forState:UIControlStateNormal];
    [backButton addTarget:naviView action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-20-50, 31, 50, 50)];
    [shareButton setImage:[UIImage imageNamed:@"pg_article_share"] forState:UIControlStateNormal];
    [shareButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [shareButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [shareButton addTarget:naviView action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [naviView addSubview:shareButton];
    
    return naviView;
}

+ (PGNavigationView *)naviViewWithBackButton:(NSString *)naviTitle
{
    PGNavigationView *naviView = [[PGNavigationView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 64)];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button"] forState:UIControlStateNormal];
    [backButton addTarget:naviView action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, [UIScreen mainScreen].bounds.size.width-140, 44)];
    naviTitleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.textColor = Theme.colorText;
    naviTitleLabel.text = naviTitle;
    [naviView addSubview:naviTitleLabel];
    
    return naviView;
}

- (void)searchButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchButtonClicked)]) {
        [self.delegate searchButtonClicked];
    }
}

- (void)backButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(naviBackButtonClicked)]) {
        [self.delegate naviBackButtonClicked];
    }
}

@end
