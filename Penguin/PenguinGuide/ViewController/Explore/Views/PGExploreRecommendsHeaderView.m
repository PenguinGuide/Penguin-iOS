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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(verticalLine.right+5, 11, 100, 16)];
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
        _bannersView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-185) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeDefault];
        _bannersView.delegate = self;
    }
    return _bannersView;
}

- (UIView *)scenarioView {
	if(_scenarioView == nil) {
		_scenarioView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannersView.bottom, UISCREEN_WIDTH, 185)];
        _scenarioView.backgroundColor = Theme.colorBackground;
        
        NSArray *icons = @[@"pg_home_category_wiki", @"pg_home_category_test", @"pg_home_category_store", @"pg_home_category_city_guide", @"pg_home_category_video", @"discover_6_icon", @"discover_7_icon", @"discover_8_icon"];
        NSArray *titles = @[@"新手入门", @"成长进阶", @"高端大人", @"御宅", @"办公室", @"爬梯", @"器具", @"伟哥推荐"];
        
        NSMutableArray *buttonsArray = [NSMutableArray new];
        
        CGFloat delta = (UISCREEN_WIDTH-25*2-60*4)/3;
        CGFloat leftX = 25.f;
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
                leftX = 25.f;
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
