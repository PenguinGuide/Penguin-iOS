//
//  PGScenarioSegmentController.h
//  Penguin
//
//  Created by Jing Dai on 05/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "ARSegmentPageController.h"

@protocol PGScenarioSegmentControllerDelegate <NSObject>

- (void)backButtonClicked;
- (void)updateStatusBar:(BOOL)isLightContent;

@end

@interface PGScenarioSegmentController : ARSegmentPageController

@property (nonatomic, weak) id<PGScenarioSegmentControllerDelegate> delegate;

- (id)initWithScenarioId:(NSString *)scenarioId naviTitle:(NSString *)naviTitle image:(NSString *)image;

@end
