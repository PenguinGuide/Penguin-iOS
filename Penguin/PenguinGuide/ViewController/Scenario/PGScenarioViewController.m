//
//  PGScenarioViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define FeedsViewTag 999
#define GoodsViewTag 1999

#define FeedsCell @"FeedsCell"
#define GoodsCell @"GoodsCell"

#import "PGScenarioViewController.h"
#import "UIViewController+PGPagedController.h"
#import "PGScenarioFeedsViewController.h"
#import "PGScenarioGoodsViewController.h"
#import "PGScenarioViewModel.h"

#import "PGCityGuideSegmentIndicator.h"

#import "PGScenarioDelegate.h"

@interface PGScenarioViewController () <PGScenarioDelegate>

@property (nonatomic, strong) PGScenarioViewModel *viewModel;

@property (nonatomic, strong) NSString *scenarioId;

@property (nonatomic, strong) PGScenarioFeedsViewController *feedsVC;
@property (nonatomic, strong) PGScenarioGoodsViewController *goodsVC;

@property (nonatomic, strong) PGPagedController *pagedController;

@property (nonatomic, assign) BOOL darkStatusBar;

@end

@implementation PGScenarioViewController

- (id)initWithScenarioId:(NSString *)scenarioId
{
    if (self = [super init]) {
        self.scenarioId = scenarioId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.viewModel = [[PGScenarioViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"scenario" block:^(id changedObject) {
        PGScenario *scenario = changedObject;
        if (scenario && [scenario isKindOfClass:[PGScenario class]]) {
            [UIView setAnimationsEnabled:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
            
            [weakself setNavigationTitle:weakself.viewModel.scenario.title];
            
            weakself.feedsVC = [[PGScenarioFeedsViewController alloc] initWithScenarioId:weakself.viewModel.scenario.scenarioId];
            weakself.goodsVC = [[PGScenarioGoodsViewController alloc] initWithScenarioId:weakself.viewModel.scenario.scenarioId];
            
            weakself.feedsVC.delegate = weakself;
            weakself.goodsVC.delegate = weakself;
            
            weakself.pagedController = [[PGPagedController alloc] initWithViewControllers:@[weakself.feedsVC, weakself.goodsVC]
                                                                                   titles:@[weakself.isFromStorePage?@"教 你 买":@"边 读 边 选", @"商 品"]
                                                                            segmentHeight:60.f];
            weakself.pagedController.disableScrolling = YES;
            weakself.pagedController.view.frame = CGRectMake(0, 64, self.view.pg_width, UISCREEN_HEIGHT-64);
            
            [weakself addPagedController:weakself.pagedController config:^(PGSegmentedControlConfig *config) {
                config.SelectedViewClass = [PGCityGuideSegmentIndicator class];
                config.equalWidth = YES;
            }];
        }
        [weakself dismissLoading];
    }];
    [self observeError:self.viewModel];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [self unobserve];
}

- (void)reloadView
{
    if (!self.viewModel.scenario) {
        [self showLoading];
        [self.viewModel requestScenario:self.scenarioId];
    }
}

- (void)initAnalyticsKeys
{
    self.pageName = scenario_view;
    self.pageId = self.scenarioId;
}

#pragma mark - <PGScenarioSegmentControllerDelegate>

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateStatusBar:(BOOL)isLightContent
{
    if (isLightContent) {
        if (self.darkStatusBar) {
            self.darkStatusBar = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            self.darkStatusBar = NO;
        }
    } else {
        if (!self.darkStatusBar) {
            self.darkStatusBar = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            self.darkStatusBar = YES;
        }
    }
}

#pragma mark - <PGScenarioDelegate>

- (void)showPageLoading
{
    [self showLoading];
}

- (void)dismissPageLoading
{
    [self dismissLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
