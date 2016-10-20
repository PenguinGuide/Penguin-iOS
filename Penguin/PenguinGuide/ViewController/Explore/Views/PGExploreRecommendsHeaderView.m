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

@interface PGExploreRecommendsHeaderView () <PGPagedScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong, readwrite) PGPagedScrollView *bannersView;
@property (nonatomic, strong) UIView *scenarioView;

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
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(13, 11, 3, 16)];
    verticalLine.backgroundColor = Theme.colorExtraHighlight;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(verticalLine.pg_right+5, 11, 100, 16)];
    label.font = Theme.fontMediumBold;
    label.textColor = Theme.colorText;
    label.text = @"场景";
    [self.scenarioView addSubview:verticalLine];
    [self.scenarioView addSubview:label];
}

- (void)reloadBannersWithData:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    [self.bannersView reloadData];
}

+ (CGSize)headerViewSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*160/320+185);
}

#pragma mark - <PGPagedScrollViewDelegate>

- (NSArray *)imagesForScrollView
{
    NSMutableArray *banners = [NSMutableArray new];
    for (PGImageBanner *banner in self.dataArray) {
        if (banner.image) {
            [banners addObject:banner.image];
        }
    }
    return [NSArray arrayWithArray:banners];
}

- (void)imageViewDidSelect:(NSInteger)index
{
    PGImageBanner *banner = self.dataArray[index];
    [[PGRouter sharedInstance] openURL:banner.link];
}

- (void)scenarioButtonDidClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scenarioDidSelect:)]) {
        [self.delegate scenarioDidSelect:nil];
    }
}

#pragma mark - <Setters && Getters>

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
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
        
        NSArray *icons = @[@"pg_explore_scenario_beginner", @"pg_explore_scenario_growing", @"pg_explore_scenario_master", @"pg_explore_scenario_home", @"pg_explore_scenario_office", @"pg_explore_scenario_party", @"pg_explore_scenario_tool", @"pg_explore_scenario_ceo"];
        NSArray *titles = @[@"新手入门", @"成长进阶", @"高端大人", @"御宅", @"办公室", @"派对", @"器具", @"CEO推荐"];
        
        NSMutableArray *buttonsArray = [NSMutableArray new];
        
        CGFloat delta = (UISCREEN_WIDTH-15*2-60*4)/3;
        CGFloat leftX = 15.f;
        CGFloat topY = 25.f;
        for (int i = 0; i < 8; i++) {
            UIButton *scenarioButton = [[UIButton alloc] initWithFrame:CGRectMake(leftX, topY, 60, 80)];
            scenarioButton.tag = i;
            
            [scenarioButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
            [scenarioButton setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
            [scenarioButton addTarget:self action:@selector(scenarioButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80-28, 60, 16)];
            buttonLabel.font = Theme.fontExtraSmallBold;
            buttonLabel.textColor = Theme.colorText;
            buttonLabel.textAlignment = NSTextAlignmentCenter;
            buttonLabel.text = titles[i];
            [scenarioButton addSubview:buttonLabel];
            
            [buttonsArray addObject:scenarioButton];
            
            if (i == 3) {
                leftX = 15.f;
                topY = 25.f+80.f;
            } else {
                leftX = leftX+delta+60;
            }
            
            [_scenarioView addSubview:scenarioButton];
        }
        
        self.buttonsArray = [NSArray arrayWithArray:buttonsArray];
	}
	return _scenarioView;
}

@end
