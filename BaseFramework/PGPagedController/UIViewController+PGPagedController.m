//
//  UIViewController+PGPagedController.m
//  Penguin
//
//  Created by Jing Dai on 04/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "UIViewController+PGPagedController.h"
#import "PGSegmentedControl.h"
#import <objc/runtime.h>

static char SegmentedControl;
static char PagedController;

@interface UIViewController (PGPagedController)

@property (nonatomic, strong) PGPagedController *pagedController;
@property (nonatomic, strong) PGSegmentedControl *segmentedControl;

@end

@implementation UIViewController (PGPagedController)

- (void)addPagedController:(PGPagedController *)pagedController config:(void (^)(PGSegmentedControlConfig *config))configBlock
{
    [self.segmentedControl removeFromSuperview];
    for (UIViewController *vc in self.childViewControllers) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
        [vc didMoveToParentViewController:nil];
    }
    
    self.segmentedControl = [[PGSegmentedControl alloc] initWithSegmentTitles:pagedController.titles];
    self.pagedController = pagedController;
    self.pagedController.segmentedControl = self.segmentedControl;
    
    PGSegmentedControlConfig *config = [[PGSegmentedControlConfig alloc] init];
    configBlock(config);
    
    // why use UIControl: http://www.tuicool.com/articles/B73AFj
    self.segmentedControl.segmentTitles = self.pagedController.titles;
    self.segmentedControl.pagedController = self.pagedController;
    self.segmentedControl.config = config;
    
    self.segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width, pagedController.segmentHeight);
    [self.pagedController.view addSubview:self.segmentedControl];
    
    [self.view addSubview:self.pagedController.view];
    [self addChildViewController:self.pagedController];
    [self.pagedController didMoveToParentViewController:self];
}

- (void)setPagedController:(PGPagedController *)pagedController
{
    objc_setAssociatedObject(self, &PagedController, pagedController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PGPagedController *)pagedController
{
    return objc_getAssociatedObject(self, &PagedController);
}

- (void)setSegmentedControl:(PGSegmentedControl *)segmentedControl
{
    objc_setAssociatedObject(self, &SegmentedControl, segmentedControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PGSegmentedControl *)segmentedControl
{
    return objc_getAssociatedObject(self, &SegmentedControl);
}

@end
