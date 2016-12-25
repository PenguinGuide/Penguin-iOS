//
//  PGScenarioSegmentController.m
//  Penguin
//
//  Created by Jing Dai on 05/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioSegmentController.h"
#import "PGScenarioFeedsViewController.h"
#import "PGScenarioGoodsViewController.h"

#import "PGScenarioSegmentHeaderView.h"

void *CustomHeaderInsetObserver = &CustomHeaderInsetObserver;

@interface PGScenarioSegmentController ()

@property (nonatomic, strong) NSString *scenarioId;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *naviTitle;

@property (nonatomic, strong) PGScenarioSegmentHeaderView *header;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation PGScenarioSegmentController

- (id)initWithScenarioId:(NSString *)scenarioId naviTitle:(NSString *)naviTitle image:(NSString *)image
{
    PGScenarioFeedsViewController *feedsVC = [[PGScenarioFeedsViewController alloc] initWithScenarioId:scenarioId];
    PGScenarioGoodsViewController *goodsVC = [[PGScenarioGoodsViewController alloc] initWithScenarioId:scenarioId];
    if (self = [super initWithControllers:feedsVC, goodsVC, nil]) {
        self.scenarioId = scenarioId;
        self.image = image;
        self.naviTitle = naviTitle;
        self.segmentMiniTopInset = 64;
        self.headerHeight = UISCREEN_WIDTH*9/16;
        self.segmentHeight = 50.f;
    }
    return self;
}

- (UIView *)customHeaderView
{
    if (self.header == nil) {
        self.header = [[PGScenarioSegmentHeaderView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*9/16)];
        self.header.backgroundColor = [UIColor lightGrayColor];
        [self.header setNaviTitle:self.naviTitle];
        
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*9/16)];
        self.headerImageView.clipsToBounds = YES;
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.headerImageView setWithImageURL:self.image placeholder:nil completion:nil];
        [self.header addSubview:self.headerImageView];
        
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 35, 50, 50)];
        [self.backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button_light"] forState:UIControlStateNormal];
        [self.backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [self.backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.header addSubview:self.backButton];
    }
    return self.header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addObserver:self forKeyPath:@"segmentTopInset" options:NSKeyValueObservingOptionNew context:CustomHeaderInsetObserver];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if (context == CustomHeaderInsetObserver) {
        CGFloat inset = [change[NSKeyValueChangeNewKey] floatValue];
        if (inset <= 64) {
            [self.backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button"] forState:UIControlStateNormal];
        } else {
            [self.backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button_light"] forState:UIControlStateNormal];
        }
        [self.header updateHeadPhotoWithTopInset:inset];
        
        CGFloat ratio = (inset - 64)/self.header.pg_height;
        if (ratio <= 0 ) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateStatusBar:)]) {
                [self.delegate updateStatusBar:NO];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateStatusBar:)]) {
                [self.delegate updateStatusBar:YES];
            }
        }
        if (inset > UISCREEN_WIDTH*9/16) {
            self.headerImageView.frame = CGRectMake(0, 0, self.header.pg_width, inset);
        }
        
        [self.header bringSubviewToFront:self.backButton];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"segmentTopInset"];
}

- (void)backButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
