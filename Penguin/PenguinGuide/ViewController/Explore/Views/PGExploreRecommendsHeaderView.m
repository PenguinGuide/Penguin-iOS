//
//  PGExploreRecommendsHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static NSString *const ScenarioCell = @"ScenarioCell";

#import "PGExploreRecommendsHeaderView.h"
#import "PGHomeChannelCell.h"
#import "PGImageBanner.h"
#import "PGCategoryIcon.h"

@interface PGExploreRecommendsHeaderView () <PGPagedScrollViewDelegate>

@property (nonatomic, strong) NSArray *recommendsArray;
@property (nonatomic, strong) NSArray *scenariosArray;
@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong, readwrite) PGPagedScrollView *bannersView;
@property (nonatomic, strong) UIView *scenarioView;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UILabel *scenarioLabel;

@end

@implementation PGExploreRecommendsHeaderView

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
    [self addSubview:self.bannersView];
    [self addSubview:self.scenarioView];
}

- (void)reloadBannersWithRecommendsArray:(NSArray *)recommendsArray scenariosArray:(NSArray *)scenariosArray
{
    self.recommendsArray = recommendsArray;
    self.scenariosArray = scenariosArray;
    [self.bannersView reloadData];
    
    NSMutableArray *buttonsArray = [NSMutableArray new];
    
    for (UIView *subview in self.scenarioView.subviews) {
        [subview removeFromSuperview];
    }
    
    if (scenariosArray.count > 0) {
        self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(13, 11, 3, 16)];
        self.verticalLine.backgroundColor = Theme.colorExtraHighlight;
        self.scenarioLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.verticalLine.pg_right+5, 11, 100, 16)];
        self.scenarioLabel.font = Theme.fontMediumBold;
        self.scenarioLabel.textColor = Theme.colorText;
        self.scenarioLabel.text = @"场景";
        [self.scenarioView addSubview:self.verticalLine];
        [self.scenarioView addSubview:self.scenarioLabel];
    }
    
    CGFloat delta = (UISCREEN_WIDTH-15*2-60*4)/3;
    CGFloat leftX = 15.f;
    CGFloat topY = 25.f;
    for (int i = 0; i < MIN(8, self.scenariosArray.count); i++) {
        PGCategoryIcon *icon = self.scenariosArray[i];
        UIButton *scenarioButton = [[UIButton alloc] initWithFrame:CGRectMake(leftX, topY, 60, 80)];
        scenarioButton.tag = i;
        
        [scenarioButton addTarget:self action:@selector(scenarioButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
        [iconImageView setWithImageURL:icon.image placeholder:nil completion:nil];
        [scenarioButton addSubview:iconImageView];
        
        UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80-28, 60, 16)];
        buttonLabel.font = Theme.fontExtraSmallBold;
        buttonLabel.textColor = Theme.colorText;
        buttonLabel.textAlignment = NSTextAlignmentCenter;
        buttonLabel.text = icon.title;
        [scenarioButton addSubview:buttonLabel];
        
        [buttonsArray addObject:scenarioButton];
        
        if (i == 3) {
            leftX = 15.f;
            topY = 25.f+80.f;
        } else {
            leftX = leftX+delta+60;
        }
        
        [self.scenarioView addSubview:scenarioButton];
    }
    
    self.buttonsArray = [NSArray arrayWithArray:buttonsArray];
}

+ (CGSize)headerViewSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*160/320+185);
}

#pragma mark - <PGPagedScrollViewDelegate>

- (NSArray *)imagesForScrollView
{
    NSMutableArray *banners = [NSMutableArray new];
    for (PGImageBanner *banner in self.recommendsArray) {
        if (banner.image) {
            [banners addObject:banner.image];
        }
    }
    return [NSArray arrayWithArray:banners];
}

- (void)imageViewDidSelect:(NSInteger)index
{
    PGImageBanner *banner = self.recommendsArray[index];
    [[PGRouter sharedInstance] openURL:banner.link];
}

- (void)scenarioButtonDidClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scenarioDidSelect:)]) {
        UIButton *button = (UIButton *)sender;
        PGCategoryIcon *scenario = self.scenariosArray[button.tag];
        [self.delegate scenarioDidSelect:scenario];
    }
}

#pragma mark - <Setters && Getters>

- (NSArray *)recommendsArray
{
    if (!_recommendsArray) {
        _recommendsArray = [NSArray new];
    }
    return _recommendsArray;
}

- (NSArray *)scenariosArray
{
    if (!_scenariosArray) {
        _scenariosArray = [NSArray new];
    }
    return _scenariosArray;
}

- (PGPagedScrollView *)bannersView
{
    if (!_bannersView) {
        _bannersView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height-185) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeDefault];
        _bannersView.delegate = self;
    }
    return _bannersView;
}

- (UIView *)scenarioView {
	if(_scenarioView == nil) {
		_scenarioView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannersView.pg_bottom, UISCREEN_WIDTH, 185)];
        _scenarioView.backgroundColor = Theme.colorBackground;
	}
	return _scenarioView;
}

@end
